import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

/// Local-first storage: every category/habit/entry lives here first, the Core API is only used
/// for the ~2am backup sync. `serverId` is null until a locally-created row has been accepted by
/// Core; `updatedAt`/`isDeleted` mirror Core's sync metadata (Category/Habito/HabitEntry.UpdatedAt
/// and IsDeleted in Core/Source/Models) so the same last-write-wins comparison works on both ends.
class CategoriesTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get serverId => integer().nullable()();
  TextColumn get name => text().withLength(min: 1, max: 50)();
  TextColumn get icon => text()();
  TextColumn get color => text()();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
}

class HabitsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get serverId => integer().nullable()();
  TextColumn get name => text().withLength(min: 1, max: 50)();
  IntColumn get categoryId => integer().references(CategoriesTable, #id)();

  /// Matches Core's HabitFrequencyType enum values (EveryNDays=1, DayOfMonth=2, DayOfWeek=3).
  IntColumn get frequencyType => integer()();
  IntColumn get intervalDays => integer().nullable()();
  IntColumn get dayOfMonth => integer().nullable()();

  /// .NET DayOfWeek encoding (Sunday=0..Saturday=6), matching Core's wire format.
  IntColumn get dayOfWeek => integer().nullable()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
}

class HabitEntriesTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get serverId => integer().nullable()();
  IntColumn get habitId => integer().references(HabitsTable, #id)();
  DateTimeColumn get date => dateTime()();

  /// "Done" or "NotDone", matching Core's HabitEntryStatus.ToString().
  TextColumn get status => text()();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  List<Set<Column>> get uniqueKeys => [
    {habitId, date},
  ];
}

class SyncStateTable extends Table {
  IntColumn get id => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastSyncedAt => dateTime().nullable()();
  TextColumn get cachedIconsJson => text().nullable()();
  TextColumn get cachedColorsJson => text().nullable()();
  BoolColumn get hasCompletedInitialSync => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [CategoriesTable, HabitsTable, HabitEntriesTable, SyncStateTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'habitcloud'));

  @override
  int get schemaVersion => 1;

  Future<SyncStateTableData> ensureSyncState() async {
    final existing = await (select(syncStateTable)..where((t) => t.id.equals(0))).getSingleOrNull();
    if (existing != null) return existing;

    await into(syncStateTable).insert(const SyncStateTableCompanion(id: Value(0)));
    return (select(syncStateTable)..where((t) => t.id.equals(0))).getSingle();
  }
}
