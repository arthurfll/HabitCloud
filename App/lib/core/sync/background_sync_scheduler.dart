import 'package:workmanager/workmanager.dart';

import '../auth/auth_service.dart';
import '../db/app_database.dart';
import 'sync_service.dart';

const _backupTaskName = 'habitcloud-backup-sync';
const _backupHour = 2;

/// Android gives no guarantee of exact-time background execution without the
/// SCHEDULE_EXACT_ALARM permission (which Play Store scrutinizes for anything that isn't an
/// actual alarm-clock app), so this runs a WorkManager periodic task at its minimum interval
/// (15 min) and only actually syncs the first time it wakes up at/after 2am on a given day —
/// close enough to "backup at ~2am" without fighting Doze/battery restrictions.
class BackgroundSyncScheduler {
  static Future<void> initialize() async {
    await Workmanager().initialize(callbackDispatcher);
    await Workmanager().registerPeriodicTask(
      _backupTaskName,
      _backupTaskName,
      frequency: const Duration(minutes: 15),
      constraints: Constraints(networkType: NetworkType.connected),
      existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
    );
  }
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final now = DateTime.now();
    if (now.hour < _backupHour) return true;

    final db = AppDatabase();
    try {
      final state = await db.ensureSyncState();
      final lastSync = state.lastSyncedAt?.toLocal();
      final alreadySyncedToday =
          lastSync != null && lastSync.year == now.year && lastSync.month == now.month && lastSync.day == now.day;
      if (alreadySyncedToday) return true;

      await AuthService.instance.configure();
      if (!await AuthService.instance.isSignedIn()) return true;

      final syncService = SyncService(db);
      await syncService.runBackupSync();
      return true;
    } finally {
      await db.close();
    }
  });
}
