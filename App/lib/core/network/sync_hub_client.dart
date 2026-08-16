import 'dart:async';

import 'package:signalr_netcore/signalr_client.dart';

import '../auth/auth_service.dart';
import '../config/env.dart';
import '../models/category_model.dart';
import '../models/habit_model.dart';

/// Used right after the very first login to pull every category/habit the user owns over the same
/// real-time channel the web/mobile clients use for live updates, per Core's CategoryHub/HabitHub
/// `RequestFullSync` method (Core/Source/Hubs/CategoryHub.cs, HabitHub.cs).
class SyncHubClient {
  Future<List<CategoryModel>> fetchAllCategories() async {
    final connection = _buildConnection(Env.categoryHubUrl);
    try {
      await connection.start();
      final completer = Completer<List<CategoryModel>>();
      connection.on('FullSyncCategories', (arguments) {
        final list = (arguments?.first as List).cast<Map<String, dynamic>>();
        if (!completer.isCompleted) completer.complete(list.map(CategoryModel.fromJson).toList());
      });
      await connection.invoke('RequestFullSync');
      return await completer.future.timeout(const Duration(seconds: 30));
    } finally {
      await connection.stop();
    }
  }

  Future<List<HabitModel>> fetchAllHabits() async {
    final connection = _buildConnection(Env.habitHubUrl);
    try {
      await connection.start();
      final completer = Completer<List<HabitModel>>();
      connection.on('FullSyncHabits', (arguments) {
        final list = (arguments?.first as List).cast<Map<String, dynamic>>();
        if (!completer.isCompleted) completer.complete(list.map(HabitModel.fromJson).toList());
      });
      await connection.invoke('RequestFullSync');
      return await completer.future.timeout(const Duration(seconds: 30));
    } finally {
      await connection.stop();
    }
  }

  HubConnection _buildConnection(String url) {
    return HubConnectionBuilder()
        .withUrl(
          url,
          options: HttpConnectionOptions(
            accessTokenFactory: () async => await AuthService.instance.currentAccessToken() ?? '',
          ),
        )
        .build();
  }
}
