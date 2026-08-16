import 'package:drift/drift.dart';

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

/// Drives both sync paths described in the app's design: the one-shot SignalR bootstrap right
/// after first login, and the incremental two-way REST sync (Core/Source/Controllers/Api/SyncController.cs)
/// used by the ~2am background backup job. Both are wrapped in [withColdStartRetry] because the
/// background job can wake from a cold start before the device's network is fully up.
class SyncService {
  final AppDatabase _db;
  final ApiClient _api;
  final SyncHubClient _hub;

  SyncService(this._db, {ApiClient? api, SyncHubClient? hub}) : _api = api ?? ApiClient.instance, _hub = hub ?? SyncHubClient();

  Future<bool> runInitialSyncIfNeeded({void Function(int attempt, Object error)? onRetry}) async {
    final state = await _db.ensureSyncState();
    if (state.hasCompletedInitialSync) return true;

    final result = await withColdStartRetry(() async {
      final categories = await _hub.fetchAllCategories();
      final habits = await _hub.fetchAllHabits();
      return (categories, habits);
    }, onAttemptFailed: onRetry);

    if (result == null) return false;
    final (categories, habits) = result;

    await _db.transaction(() async {
      for (final c in categories) {
        await _upsertCategoryFromServer(c);
      }
      for (final h in habits) {
        await _upsertHabitFromServer(h);
      }
      await (_db.update(_db.syncStateTable)..where((t) => t.id.equals(0))).write(
        SyncStateTableCompanion(hasCompletedInitialSync: const Value(true), lastSyncedAt: Value(DateTime.now().toUtc())),
      );
    });

    return true;
  }

  /// Uploads everything changed locally since the last sync and applies whatever Core says is
  /// newer, per the last-write-wins protocol implemented by SyncService.cs on the backend.
  Future<bool> runBackupSync({void Function(int attempt, Object error)? onRetry}) async {
    final state = await _db.ensureSyncState();
    final request = await _buildRequest(state.lastSyncedAt);

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
