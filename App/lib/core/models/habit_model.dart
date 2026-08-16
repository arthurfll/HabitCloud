/// Wire shape of Core's HabitDto (Core/Source/Models/Dtos/HabitDto.cs).
class HabitModel {
  final int id;
  final String name;
  final int categoryId;
  final String categoryName;
  final String categoryIcon;
  final String categoryColor;
  final int frequencyType;
  final int? intervalDays;
  final int? dayOfMonth;
  final int? dayOfWeek;
  final DateTime startDate;
  final String frequencyLabel;
  final DateTime updatedAt;
  final bool isDeleted;

  const HabitModel({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.categoryName,
    required this.categoryIcon,
    required this.categoryColor,
    required this.frequencyType,
    this.intervalDays,
    this.dayOfMonth,
    this.dayOfWeek,
    required this.startDate,
    required this.frequencyLabel,
    required this.updatedAt,
    required this.isDeleted,
  });

  factory HabitModel.fromJson(Map<String, dynamic> json) => HabitModel(
    id: json['id'] as int,
    name: json['name'] as String,
    categoryId: json['categoryId'] as int,
    categoryName: json['categoryName'] as String? ?? '',
    categoryIcon: json['categoryIcon'] as String? ?? '',
    categoryColor: json['categoryColor'] as String? ?? '',
    frequencyType: json['frequencyType'] as int,
    intervalDays: json['intervalDays'] as int?,
    dayOfMonth: json['dayOfMonth'] as int?,
    dayOfWeek: json['dayOfWeek'] as int?,
    startDate: DateTime.parse(json['startDate'] as String),
    frequencyLabel: json['frequencyLabel'] as String? ?? '',
    updatedAt: DateTime.parse(json['updatedAt'] as String).toUtc(),
    isDeleted: json['isDeleted'] as bool? ?? false,
  );
}

class HabitFrequencyType {
  HabitFrequencyType._();
  static const everyNDays = 1;
  static const dayOfMonth = 2;
  static const dayOfWeek = 3;
}
