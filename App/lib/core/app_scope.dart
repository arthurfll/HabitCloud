import 'package:flutter/widgets.dart';

import 'db/app_database.dart';
import 'db/category_repository.dart';
import 'db/habit_repository.dart';
import 'sync/sync_service.dart';

/// Lightweight service locator: one shared database/repository/sync-service instance for the
/// whole widget tree, reachable via `AppScope.of(context)` without pulling in a DI package.
class AppScope extends InheritedWidget {
  final AppDatabase db;
  final CategoryRepository categoryRepository;
  final HabitRepository habitRepository;
  final SyncService syncService;

  AppScope._({super.key, required this.db, required super.child})
    : categoryRepository = CategoryRepository(db),
      habitRepository = HabitRepository(db),
      syncService = SyncService(db);

  factory AppScope({Key? key, required Widget child, AppDatabase? database}) {
    return AppScope._(key: key, db: database ?? AppDatabase(), child: child);
  }

  static AppScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'No AppScope found in context');
    return scope!;
  }

  @override
  bool updateShouldNotify(AppScope oldWidget) => false;
}
