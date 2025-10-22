import '../entities/category_entity.dart';
import '../repositories/document_repository.dart';

class GetCategoriesUsecase {
  final DocumentRepository _repository;

  GetCategoriesUsecase(this._repository);

  Future<List<CategoryEntity>> call() async {
    return await _repository.getCategories();
  }
}
