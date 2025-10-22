import '../../domain/entities/category_entity.dart';

class CategoryModel {
  final String id;
  final String name;
  final String type;
  final bool isSelected;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.type,
    required this.isSelected,
  });

  factory CategoryModel.fromEntity(CategoryEntity entity) {
    return CategoryModel(
      id: entity.id,
      name: entity.name,
      type: entity.type,
      isSelected: entity.isSelected,
    );
  }

  CategoryEntity toEntity() {
    return CategoryEntity(
      id: id,
      name: name,
      type: type,
      isSelected: isSelected,
    );
  }
}
