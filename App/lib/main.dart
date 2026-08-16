import 'package:flutter/material.dart';

import 'app.dart';
import 'core/auth/auth_service.dart';
import 'core/sync/background_sync_scheduler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthService.instance.configure();
  await BackgroundSyncScheduler.initialize();
  runApp(const HabitCloudApp());
}
