import '../../../data_generator/domain/entities/tai_lieu_entity.dart';
import '../repositories/documents_repository.dart';

/// Use case to get favorite documents
class GetFavoriteDocumentsUseCase {
  final DocumentsRepository _repository;

  GetFavoriteDocumentsUseCase(this._repository);

  /// Execute the use case
  Future<List<TaiLieuEntity>> call() async {
    return await _repository.getFavoriteDocuments();
  }
}
