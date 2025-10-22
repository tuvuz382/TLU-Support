import '../entities/document_entity.dart';
import '../repositories/document_repository.dart';

class SearchDocumentsUsecase {
  final DocumentRepository _repository;

  SearchDocumentsUsecase(this._repository);

  Future<List<DocumentEntity>> call(String keyword) async {
    return await _repository.searchDocuments(keyword);
  }
}
