/// Wire shape of Core's CategoryDto (Core/Source/Models/Dtos/CategoryDto.cs).
class CategoryModel {
  final int id;
  final String name;
  final String icon;
  final String color;
  final DateTime updatedAt;
  final bool isDeleted;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.updatedAt,
    required this.isDeleted,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    id: json['id'] as int,
    name: json['name'] as String,
    icon: json['icon'] as String,
    color: json['color'] as String,
    updatedAt: DateTime.parse(json['updatedAt'] as String).toUtc(),
    isDeleted: json['isDeleted'] as bool? ?? false,
  );
}
