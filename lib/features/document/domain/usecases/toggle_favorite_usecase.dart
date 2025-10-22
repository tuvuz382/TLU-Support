import '../repositories/document_repository.dart';

class ToggleFavoriteUsecase {
  final DocumentRepository _repository;

  ToggleFavoriteUsecase(this._repository);

  Future<void> call(String documentId) async {
    await _repository.toggleFavorite(documentId);
  }
}
