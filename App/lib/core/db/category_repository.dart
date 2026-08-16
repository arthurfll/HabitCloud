import 'package:drift/drift.dart';

import 'app_database.dart';

class CategoryRepository {
  final AppDatabase _db;
  final void Function()? _onDirty;

  CategoryRepository(this._db, {void Function()? onDirty}) : _onDirty = onDirty;

  void _markDirty() => _onDirty?.call();

  Stream<List<CategoriesTableData>> watchAll() {
    return (_db.select(_db.categoriesTable)
          ..where((t) => t.isDeleted.equals(false))
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .watch();
  }

  Future<List<CategoriesTableData>> getAll() {
    return (_db.select(_db.categoriesTable)..where((t) => t.isDeleted.equals(false))).get();
  }

  Future<CategoriesTableData?> getById(int id) {
    return (_db.select(_db.categoriesTable)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<int> create({required String name, required String icon, required String color}) async {
    final id = await _db
        .into(_db.categoriesTable)
        .insert(
          CategoriesTableCompanion.insert(name: name, icon: icon, color: color, updatedAt: DateTime.now().toUtc()),
        );
    _markDirty();
    return id;
  }

  Future<void> update(int id, {required String name, required String icon, required String color}) async {
    await (_db.update(_db.categoriesTable)..where((t) => t.id.equals(id))).write(
      CategoriesTableCompanion(
        name: Value(name),
        icon: Value(icon),
        color: Value(color),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
    _markDirty();
  }

  Future<void> delete(int id) async {
    await (_db.update(_db.categoriesTable)..where((t) => t.id.equals(id))).write(
      CategoriesTableCompanion(isDeleted: const Value(true), updatedAt: Value(DateTime.now().toUtc())),
    );
    _markDirty();
  }
}
