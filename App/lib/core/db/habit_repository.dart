import 'package:drift/drift.dart';

import 'app_database.dart';
import 'habit_schedule.dart';

class HabitWithCategory {
  final HabitsTableData habit;
  final CategoriesTableData category;

  const HabitWithCategory(this.habit, this.category);
}

class HabitRepository {
  final AppDatabase _db;
  final void Function()? _onDirty;

  HabitRepository(this._db, {void Function()? onDirty}) : _onDirty = onDirty;

  void _markDirty() => _onDirty?.call();

  Stream<List<HabitWithCategory>> watchAll() {
    final query = _db.select(_db.habitsTable).join([
      innerJoin(_db.categoriesTable, _db.categoriesTable.id.equalsExp(_db.habitsTable.categoryId)),
    ])..where(_db.habitsTable.isDeleted.equals(false));

    return query.watch().map(
      (rows) => rows
          .map((row) => HabitWithCategory(row.readTable(_db.habitsTable), row.readTable(_db.categoriesTable)))
          .toList(),
    );
  }

  Future<List<HabitWithCategory>> getAll() async {
    final query = _db.select(_db.habitsTable).join([
      innerJoin(_db.categoriesTable, _db.categoriesTable.id.equalsExp(_db.habitsTable.categoryId)),
    ])..where(_db.habitsTable.isDeleted.equals(false));

    final rows = await query.get();
    return rows
        .map((row) => HabitWithCategory(row.readTable(_db.habitsTable), row.readTable(_db.categoriesTable)))
        .toList();
  }

  Stream<HabitWithCategory?> watchById(int id) {
    final query = _db.select(_db.habitsTable).join([
      innerJoin(_db.categoriesTable, _db.categoriesTable.id.equalsExp(_db.habitsTable.categoryId)),
    ])..where(_db.habitsTable.id.equals(id));

    return query.watchSingleOrNull().map(
      (row) => row == null ? null : HabitWithCategory(row.readTable(_db.habitsTable), row.readTable(_db.categoriesTable)),
    );
  }

  Future<List<HabitWithCategory>> getDueToday() async {
    final all = await getAll();
    final today = DateTime.now();
    return all.where((h) => isHabitDue(h.habit, today)).toList();
  }

  Future<HabitEntriesTableData?> getEntry(int habitId, DateTime date) {
    final d = DateTime(date.year, date.month, date.day);
    return (_db.select(_db.habitEntriesTable)..where(
          (t) => t.habitId.equals(habitId) & t.date.equals(d) & t.isDeleted.equals(false),
        ))
        .getSingleOrNull();
  }

  /// Unlike [getEntry], includes soft-deleted rows — [toggleEntry] needs to see a tombstoned row
  /// for the day to revive it instead of inserting a second row and hitting the unique
  /// constraint on (habitId, date).
  Future<HabitEntriesTableData?> _getRawEntry(int habitId, DateTime date) {
    final d = DateTime(date.year, date.month, date.day);
    return (_db.select(
      _db.habitEntriesTable,
    )..where((t) => t.habitId.equals(habitId) & t.date.equals(d))).getSingleOrNull();
  }

  Future<List<HabitEntriesTableData>> getEntriesInRange(int habitId, DateTime start, DateTime end) {
    return (_db.select(_db.habitEntriesTable)..where(
          (t) =>
              t.habitId.equals(habitId) &
              t.date.isBiggerOrEqualValue(start) &
              t.date.isSmallerOrEqualValue(end) &
              t.isDeleted.equals(false),
        ))
        .get();
  }

  Future<int> create({
    required String name,
    required int categoryId,
    required int frequencyType,
    int? intervalDays,
    int? dayOfMonth,
    int? dayOfWeek,
  }) async {
    final id = await _db
        .into(_db.habitsTable)
        .insert(
          HabitsTableCompanion.insert(
            name: name,
            categoryId: categoryId,
            frequencyType: frequencyType,
            intervalDays: Value(intervalDays),
            dayOfMonth: Value(dayOfMonth),
            dayOfWeek: Value(dayOfWeek),
            startDate: DateTime.now().toUtc(),
            updatedAt: DateTime.now().toUtc(),
          ),
        );
    _markDirty();
    return id;
  }

  Future<void> updateName(int id, String name) async {
    await (_db.update(_db.habitsTable)..where((t) => t.id.equals(id))).write(
      HabitsTableCompanion(name: Value(name), updatedAt: Value(DateTime.now().toUtc())),
    );
    _markDirty();
  }

  Future<void> delete(int id) async {
    await (_db.update(_db.habitsTable)..where((t) => t.id.equals(id))).write(
      HabitsTableCompanion(isDeleted: const Value(true), updatedAt: Value(DateTime.now().toUtc())),
    );
    _markDirty();
  }

  /// Cycles a day through None -> Done -> NotDone -> None, mirroring Core's
  /// HabitService.ToggleEntryAsync (Core/Source/Services/HabitService.cs), including reviving a
  /// soft-deleted (tombstoned) row instead of inserting a fresh one for the same (habitId, date).
  Future<void> toggleEntry(int habitId, DateTime date) async {
    final d = DateTime(date.year, date.month, date.day);
    final now = DateTime.now().toUtc();
    final existing = await _getRawEntry(habitId, d);

    if (existing == null) {
      await _db
          .into(_db.habitEntriesTable)
          .insert(
            HabitEntriesTableCompanion.insert(habitId: habitId, date: d, status: 'Done', updatedAt: now),
          );
      _markDirty();
      return;
    }

    if (existing.isDeleted) {
      await (_db.update(_db.habitEntriesTable)..where((t) => t.id.equals(existing.id))).write(
        HabitEntriesTableCompanion(status: const Value('Done'), isDeleted: const Value(false), updatedAt: Value(now)),
      );
    } else if (existing.status == 'Done') {
      await (_db.update(_db.habitEntriesTable)..where((t) => t.id.equals(existing.id))).write(
        HabitEntriesTableCompanion(status: const Value('NotDone'), updatedAt: Value(now)),
      );
    } else {
      await (_db.update(_db.habitEntriesTable)..where((t) => t.id.equals(existing.id))).write(
        HabitEntriesTableCompanion(isDeleted: const Value(true), updatedAt: Value(now)),
      );
    }
    _markDirty();
  }
}
