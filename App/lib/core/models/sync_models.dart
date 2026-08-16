import 'category_model.dart';
import 'habit_entry_model.dart';
import 'habit_model.dart';

String _iso(DateTime dt) => dt.toUtc().toIso8601String();

/// Mirrors Core's CategorySyncItemDto (Core/Source/Models/Dtos/Sync/SyncRequestDto.cs).
class CategorySyncItem {
  final int? id;
  final String? clientTempId;
  final String name;
  final String icon;
  final String color;
  final DateTime updatedAt;
  final bool isDeleted;

  const CategorySyncItem({
    this.id,
    this.clientTempId,
    required this.name,
    required this.icon,
    required this.color,
    required this.updatedAt,
    required this.isDeleted,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'clientTempId': clientTempId,
    'name': name,
    'icon': icon,
    'color': color,
    'updatedAt': _iso(updatedAt),
    'isDeleted': isDeleted,
  };
}

/// Mirrors Core's HabitSyncItemDto.
class HabitSyncItem {
  final int? id;
  final String? clientTempId;
  final String name;
  final int? categoryId;
  final String? categoryClientTempId;
  final int frequencyType;
  final int? intervalDays;
  final int? dayOfMonth;
  final int? dayOfWeek;
  final DateTime startDate;
  final DateTime updatedAt;
  final bool isDeleted;

  const HabitSyncItem({
    this.id,
    this.clientTempId,
    required this.name,
    this.categoryId,
    this.categoryClientTempId,
    required this.frequencyType,
    this.intervalDays,
    this.dayOfMonth,
    this.dayOfWeek,
    required this.startDate,
    required this.updatedAt,
    required this.isDeleted,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'clientTempId': clientTempId,
    'name': name,
    'categoryId': categoryId,
    'categoryClientTempId': categoryClientTempId,
    'frequencyType': frequencyType,
    'intervalDays': intervalDays,
    'dayOfMonth': dayOfMonth,
    'dayOfWeek': dayOfWeek,
    'startDate': startDate.toIso8601String().split('T').first,
    'updatedAt': _iso(updatedAt),
    'isDeleted': isDeleted,
  };
}

/// Mirrors Core's HabitEntrySyncItemDto.
class HabitEntrySyncItem {
  final int? id;
  final String? clientTempId;
  final int? habitId;
  final String? habitClientTempId;
  final String date;
  final String status;
  final DateTime updatedAt;
  final bool isDeleted;

  const HabitEntrySyncItem({
    this.id,
    this.clientTempId,
    this.habitId,
    this.habitClientTempId,
    required this.date,
    required this.status,
    required this.updatedAt,
    required this.isDeleted,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'clientTempId': clientTempId,
    'habitId': habitId,
    'habitClientTempId': habitClientTempId,
    'date': date,
    'status': status,
    'updatedAt': _iso(updatedAt),
    'isDeleted': isDeleted,
  };
}

class SyncRequest {
  final DateTime? lastSyncedAt;
  final List<CategorySyncItem> categories;
  final List<HabitSyncItem> habits;
  final List<HabitEntrySyncItem> habitEntries;

  const SyncRequest({
    required this.lastSyncedAt,
    required this.categories,
    required this.habits,
    required this.habitEntries,
  });

  Map<String, dynamic> toJson() => {
    'lastSyncedAt': lastSyncedAt == null ? null : _iso(lastSyncedAt!),
    'categories': categories.map((c) => c.toJson()).toList(),
    'habits': habits.map((h) => h.toJson()).toList(),
    'habitEntries': habitEntries.map((e) => e.toJson()).toList(),
  };
}

class IdMapping {
  final String clientTempId;
  final int serverId;

  const IdMapping({required this.clientTempId, required this.serverId});

  factory IdMapping.fromJson(Map<String, dynamic> json) =>
      IdMapping(clientTempId: json['clientTempId'] as String, serverId: json['serverId'] as int);
}

class SyncResponse {
  final DateTime syncedAt;
  final List<CategoryModel> categories;
  final List<HabitModel> habits;
  final List<HabitEntryModel> habitEntries;
  final List<IdMapping> categoryIdMappings;
  final List<IdMapping> habitIdMappings;
  final List<IdMapping> habitEntryIdMappings;

  const SyncResponse({
    required this.syncedAt,
    required this.categories,
    required this.habits,
    required this.habitEntries,
    required this.categoryIdMappings,
    required this.habitIdMappings,
    required this.habitEntryIdMappings,
  });

  factory SyncResponse.fromJson(Map<String, dynamic> json) => SyncResponse(
    syncedAt: DateTime.parse(json['syncedAt'] as String).toUtc(),
    categories: (json['categories'] as List).map((e) => CategoryModel.fromJson(e as Map<String, dynamic>)).toList(),
    habits: (json['habits'] as List).map((e) => HabitModel.fromJson(e as Map<String, dynamic>)).toList(),
    habitEntries: (json['habitEntries'] as List)
        .map((e) => HabitEntryModel.fromJson(e as Map<String, dynamic>))
        .toList(),
    categoryIdMappings: (json['categoryIdMappings'] as List)
        .map((e) => IdMapping.fromJson(e as Map<String, dynamic>))
        .toList(),
    habitIdMappings: (json['habitIdMappings'] as List).map((e) => IdMapping.fromJson(e as Map<String, dynamic>)).toList(),
    habitEntryIdMappings: (json['habitEntryIdMappings'] as List)
        .map((e) => IdMapping.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}
