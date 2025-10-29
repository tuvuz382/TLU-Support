import '../../../data_generator/domain/entities/tai_lieu_entity.dart';
import '../repositories/documents_repository.dart';

/// Use case to get all documents from Firestore
class GetAllDocumentsUseCase {
  final DocumentsRepository _repository;

  GetAllDocumentsUseCase(this._repository);

  /// Execute the use case
  Future<List<TaiLieuEntity>> call() async {
    return await _repository.getAllDocuments();
  }
}
