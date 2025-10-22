import '../entities/document_entity.dart';
import '../repositories/document_repository.dart';

class GetDocumentDetailUsecase {
  final DocumentRepository _repository;

  GetDocumentDetailUsecase(this._repository);

  Future<DocumentEntity?> call(String documentId) async {
    return await _repository.getDocumentById(documentId);
  }
}
