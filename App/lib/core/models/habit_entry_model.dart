/// Wire shape of Core's HabitEntryDto (Core/Source/Models/Dtos/HabitEntryDto.cs) — used for sync only.
class HabitEntryModel {
  final int id;
  final int habitId;
  final String date;
  final String status;
  final DateTime updatedAt;
  final bool isDeleted;

  const HabitEntryModel({
    required this.id,
    required this.habitId,
    required this.date,
    required this.status,
    required this.updatedAt,
    required this.isDeleted,
  });

  factory HabitEntryModel.fromJson(Map<String, dynamic> json) => HabitEntryModel(
    id: json['id'] as int,
    habitId: json['habitId'] as int,
    date: json['date'] as String,
    status: json['status'] as String,
    updatedAt: DateTime.parse(json['updatedAt'] as String).toUtc(),
    isDeleted: json['isDeleted'] as bool? ?? false,
  );
}

class HabitEntryStatus {
  HabitEntryStatus._();
  static const done = 'Done';
  static const notDone = 'NotDone';
  static const none = 'None';
}
