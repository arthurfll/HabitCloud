import 'dart:async';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';

import '../db/app_database.dart';
import '../models/category_model.dart';
import '../models/habit_entry_model.dart';
import '../models/habit_model.dart';
import '../models/sync_models.dart';
import '../network/api_client.dart';
import '../network/sync_hub_client.dart';
import 'retry.dart';

String _catTempId(int localId) => 'local-cat-$localId';
String _habitTempId(int localId) => 'local-habit-$localId';
String _entryTempId(int localId) => 'local-entry-$localId';

enum InitialSyncStatus { idle, syncing, success, failed }

/// Drives both sync paths described in the app's design: the one-shot SignalR bootstrap right
/// after first login, and the incremental two-way REST sync (Core/Source/Controllers/Api/SyncController.cs)
/// used by the ~2am background backup job. Both are wrapped in [withColdStartRetry] because the
/// background job can wake from a cold start before the device's network is fully up.
class SyncService {
  final AppDatabase _db;
  final ApiClient _api;
  final SyncHubClient _hub;

  /// Lets the UI show progress/failure for the interactive initial-sync path instead of it running
  /// as an invisible, unawaited future — a silent multi-minute retry loop is indistinguishable from
  /// "the app is broken" to whoever is staring at an empty screen.
  final ValueNotifier<InitialSyncStatus> initialSyncStatus = ValueNotifier(InitialSyncStatus.idle);

  /// The last exception seen while retrying the initial sync, so the failure banner can show
  /// *why* instead of just "it failed" — needed because "no data" can mean anything from a
  /// timeout to a 401 to a JSON shape mismatch, each with a completely different fix.
  final ValueNotifier<Object?> initialSyncError = ValueNotifier(null);

  /// Bumped after every successful [runBackupSync], so screens that load local data via a
  /// one-shot Future (rather than a Drift stream that updates itself) know when to refetch.
  final ValueNotifier<int> syncVersion = ValueNotifier(0);

  bool _isSyncing = false;
  bool _rerunRequested = false;
  Timer? _debounceTimer;

  SyncService(this._db, {ApiClient? api, SyncHubClient? hub}) : _api = api ?? ApiClient.instance, _hub = hub ?? SyncHubClient();

  /// Entry point for every automatic sync trigger (app open, app resume, periodic timer, and
  /// every local write via [requestSync]): coalesces concurrent callers into a single
  /// [runBackupSync] instead of racing, and silently re-runs itself if a write came in while a
  /// sync was already in flight, so nothing gets dropped.
  Future<void> syncNow() async {
    if (_isSyncing) {
      _rerunRequested = true;
      return;
    }
    _isSyncing = true;
    try {
      final ok = await runBackupSync();
      if (ok) syncVersion.value++;
    } catch (_) {
      // Silent by design — a background sync failing (e.g. offline, or the ~30s cold-start
      // window on Core's Azure Container Apps hosting still not being enough) isn't something
      // the user needs to see; the next trigger (edit, resume, or the periodic timer) retries it.
    } finally {
      _isSyncing = false;
      if (_rerunRequested) {
        _rerunRequested = false;
        unawaited(syncNow());
      }
    }
  }

  /// Called after every local write (habit/category/entry create-update-delete-toggle) so changes
  /// reach the cloud without the user having to do anything. Debounced so a burst of edits — e.g.
  /// quickly toggling several habits — collapses into one sync call instead of one per edit.
  void requestSync() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 800), syncNow);
  }

  Future<bool> runInitialSyncIfNeeded({void Function(int attempt, Object error)? onRetry}) async {
    final state = await _db.ensureSyncState();
    if (state.hasCompletedInitialSync) {
      initialSyncStatus.value = InitialSyncStatus.success;
      return true;
    }

    initialSyncStatus.value = InitialSyncStatus.syncing;
    initialSyncError.value = null;

    // Unlike the ~2am background job (which nobody is watching, so it's fine to hammer quietly for
    // ~10 minutes before giving up until the next scheduled run), this path runs in front of a user
    // who just logged in — fail fast-ish and let them retry on demand instead of staring at a blank
    // screen for a long, silent stretch. Still needs a handful of attempts with real spacing though:
    // Core runs on Azure Container Apps, which scales to zero, so the very first request after a
    // period of inactivity can hit a cold container and fail (or hang past the negotiate timeout)
    // while it spins back up — the 2nd/3rd attempt is what actually gets through.
    final result = await withColdStartRetry(() async {
      final categories = await _hub.fetchAllCategories();
      final habits = await _hub.fetchAllHabits();
      return (categories, habits);
    }, maxAttempts: 3, delay: const Duration(seconds: 10), onAttemptFailed: (attempt, error) {
      debugPrint('[SyncService] initial sync attempt $attempt failed: $error');
      initialSyncError.value = error;
      onRetry?.call(attempt, error);
    });

    if (result == null) {
      initialSyncStatus.value = InitialSyncStatus.failed;
      return false;
    }
    final (categories, habits) = result;

    await _db.transaction(() async {
      for (final c in categories) {
        await _upsertCategoryFromServer(c);
      }
      for (final h in habits) {
        await _upsertHabitFromServer(h);
      }
      // Deliberately leaves lastSyncedAt untouched (still null on a fresh install): this
      // bootstrap only pulled categories/habits, never habit entries. If it stamped lastSyncedAt
      // as "now" here, the very next runBackupSync would send that recent cutoff to Core and
      // only get back entries changed after it — silently skipping every entry that already
      // existed before install (per SyncService.cs on Core: a null LastSyncedAt is what makes it
      // return everything). Leaving it null makes the next runBackupSync — which every automatic
      // trigger fires right after this completes — do a true full pull that includes entries.
      // runBackupSync sets the real lastSyncedAt itself once that full sync succeeds.
      await (_db.update(_db.syncStateTable)..where((t) => t.id.equals(0))).write(
        const SyncStateTableCompanion(hasCompletedInitialSync: Value(true)),
      );
    });

    initialSyncStatus.value = InitialSyncStatus.success;
    return true;
  }

  /// Uploads everything changed locally since the last sync and applies whatever Core says is
  /// newer, per the last-write-wins protocol implemented by SyncService.cs on the backend.
  Future<bool> runBackupSync({void Function(int attempt, Object error)? onRetry}) async {
    final state = await _db.ensureSyncState();
    var since = state.lastSyncedAt;
    if (since != null) {
      // Self-heals installs caught by a since-fixed bug where lastSyncedAt got stamped right
      // after the initial bootstrap pulled categories/habits but before habit entries were ever
      // pulled — that cutoff then permanently excluded every entry that existed before it. If
      // there's a lastSyncedAt but zero local entries, treat it as never having synced entries
      // and force one full pull; for an account that's genuinely empty this just costs one no-op
      // request.
      final hasLocalEntry = await (_db.select(_db.habitEntriesTable)..limit(1)).getSingleOrNull();
      if (hasLocalEntry == null) since = null;
    }
    final request = await _buildRequest(since);

    final response = await withColdStartRetry(() => _api.sync(request), onAttemptFailed: onRetry);
    if (response == null) return false;

    await _db.transaction(() async {
      for (final mapping in response.categoryIdMappings) {
        final localId = _localIdFromTempId(mapping.clientTempId, 'local-cat-');
        if (localId == null) continue;
        await (_db.update(_db.categoriesTable)..where((t) => t.id.equals(localId))).write(
          CategoriesTableCompanion(serverId: Value(mapping.serverId)),
        );
      }
      for (final mapping in response.habitIdMappings) {
        final localId = _localIdFromTempId(mapping.clientTempId, 'local-habit-');
        if (localId == null) continue;
        await (_db.update(_db.habitsTable)..where((t) => t.id.equals(localId))).write(
          HabitsTableCompanion(serverId: Value(mapping.serverId)),
        );
      }
      for (final mapping in response.habitEntryIdMappings) {
        final localId = _localIdFromTempId(mapping.clientTempId, 'local-entry-');
        if (localId == null) continue;
        await (_db.update(_db.habitEntriesTable)..where((t) => t.id.equals(localId))).write(
          HabitEntriesTableCompanion(serverId: Value(mapping.serverId)),
        );
      }

      for (final c in response.categories) {
        await _upsertCategoryFromServer(c);
      }
      for (final h in response.habits) {
        await _upsertHabitFromServer(h);
      }
      for (final e in response.habitEntries) {
        await _upsertEntryFromServer(e);
      }

      await (_db.update(_db.syncStateTable)..where((t) => t.id.equals(0))).write(
        SyncStateTableCompanion(lastSyncedAt: Value(response.syncedAt)),
      );
    });

    return true;
  }

  int? _localIdFromTempId(String clientTempId, String prefix) {
    if (!clientTempId.startsWith(prefix)) return null;
    return int.tryParse(clientTempId.substring(prefix.length));
  }

  Future<void> _upsertCategoryFromServer(CategoryModel c) async {
    final existing = await (_db.select(_db.categoriesTable)..where((t) => t.serverId.equals(c.id))).getSingleOrNull();
    final companion = CategoriesTableCompanion(
      serverId: Value(c.id),
      name: Value(c.name),
      icon: Value(c.icon),
      color: Value(c.color),
      updatedAt: Value(c.updatedAt),
      isDeleted: Value(c.isDeleted),
    );

    if (existing != null) {
      await (_db.update(_db.categoriesTable)..where((t) => t.id.equals(existing.id))).write(companion);
    } else {
      await _db.into(_db.categoriesTable).insert(companion, mode: InsertMode.insertOrReplace);
    }
  }

  Future<void> _upsertHabitFromServer(HabitModel h) async {
    final localCategory = await (_db.select(
      _db.categoriesTable,
    )..where((t) => t.serverId.equals(h.categoryId))).getSingleOrNull();
    if (localCategory == null) return; // category will arrive in the same or a later sync batch

    final existing = await (_db.select(_db.habitsTable)..where((t) => t.serverId.equals(h.id))).getSingleOrNull();
    final companion = HabitsTableCompanion(
      serverId: Value(h.id),
      name: Value(h.name),
      categoryId: Value(localCategory.id),
      frequencyType: Value(h.frequencyType),
      intervalDays: Value(h.intervalDays),
      dayOfMonth: Value(h.dayOfMonth),
      dayOfWeek: Value(h.dayOfWeek),
      startDate: Value(h.startDate),
      updatedAt: Value(h.updatedAt),
      isDeleted: Value(h.isDeleted),
    );

    if (existing != null) {
      await (_db.update(_db.habitsTable)..where((t) => t.id.equals(existing.id))).write(companion);
    } else {
      await _db.into(_db.habitsTable).insert(companion, mode: InsertMode.insertOrReplace);
    }
  }

  Future<void> _upsertEntryFromServer(HabitEntryModel e) async {
    final localHabit = await (_db.select(
      _db.habitsTable,
    )..where((t) => t.serverId.equals(e.habitId))).getSingleOrNull();
    if (localHabit == null) return;

    final existing = await (_db.select(_db.habitEntriesTable)..where((t) => t.serverId.equals(e.id))).getSingleOrNull();
    final companion = HabitEntriesTableCompanion(
      serverId: Value(e.id),
      habitId: Value(localHabit.id),
      date: Value(DateTime.parse(e.date)),
      status: Value(e.status),
      updatedAt: Value(e.updatedAt),
      isDeleted: Value(e.isDeleted),
    );

    if (existing != null) {
      await (_db.update(_db.habitEntriesTable)..where((t) => t.id.equals(existing.id))).write(companion);
    } else {
      await _db.into(_db.habitEntriesTable).insert(companion, mode: InsertMode.insertOrReplace);
    }
  }

  Future<SyncRequest> _buildRequest(DateTime? since) async {
    final cutoff = since ?? DateTime.fromMillisecondsSinceEpoch(0);

    final dirtyCategories = await (_db.select(
      _db.categoriesTable,
    )..where((t) => t.updatedAt.isBiggerThanValue(cutoff))).get();
    final dirtyHabits = await (_db.select(
      _db.habitsTable,
    )..where((t) => t.updatedAt.isBiggerThanValue(cutoff))).get();
    final dirtyEntries = await (_db.select(
      _db.habitEntriesTable,
    )..where((t) => t.updatedAt.isBiggerThanValue(cutoff))).get();

    final allCategories = {for (final c in await _db.select(_db.categoriesTable).get()) c.id: c};
    final allHabits = {for (final h in await _db.select(_db.habitsTable).get()) h.id: h};

    return SyncRequest(
      lastSyncedAt: since,
      categories: dirtyCategories
          .map(
            (c) => CategorySyncItem(
              id: c.serverId,
              clientTempId: c.serverId == null ? _catTempId(c.id) : null,
              name: c.name,
              icon: c.icon,
              color: c.color,
              updatedAt: c.updatedAt,
              isDeleted: c.isDeleted,
            ),
          )
          .toList(),
      habits: dirtyHabits.map((h) {
        final category = allCategories[h.categoryId];
        return HabitSyncItem(
          id: h.serverId,
          clientTempId: h.serverId == null ? _habitTempId(h.id) : null,
          name: h.name,
          categoryId: category?.serverId,
          categoryClientTempId: category?.serverId == null ? _catTempId(h.categoryId) : null,
          frequencyType: h.frequencyType,
          intervalDays: h.intervalDays,
          dayOfMonth: h.dayOfMonth,
          dayOfWeek: h.dayOfWeek,
          startDate: h.startDate,
          updatedAt: h.updatedAt,
          isDeleted: h.isDeleted,
        );
      }).toList(),
      habitEntries: dirtyEntries.map((e) {
        final habit = allHabits[e.habitId];
        return HabitEntrySyncItem(
          id: e.serverId,
          clientTempId: e.serverId == null ? _entryTempId(e.id) : null,
          habitId: habit?.serverId,
          habitClientTempId: habit?.serverId == null ? _habitTempId(e.habitId) : null,
          date: e.date.toIso8601String().split('T').first,
          status: e.status,
          updatedAt: e.updatedAt,
          isDeleted: e.isDeleted,
        );
      }).toList(),
    );
  }
}
