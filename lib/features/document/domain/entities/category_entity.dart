import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final String id;
  final String name;
  final String type; // 'department', 'document_type', 'language'
  final bool isSelected;

  const CategoryEntity({
    required this.id,
    required this.name,
    required this.type,
    required this.isSelected,
  });

  @override
  List<Object?> get props => [id, name, type, isSelected];

  CategoryEntity copyWith({
    String? id,
    String? name,
    String? type,
    bool? isSelected,
  }) {
    return CategoryEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
