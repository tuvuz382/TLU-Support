import '../repositories/documents_repository.dart';

/// Use case to toggle favorite status of a document
class ToggleFavoriteUseCase {
  final DocumentsRepository _repository;

  ToggleFavoriteUseCase(this._repository);

  /// Execute the use case
  /// [documentId] - The document ID (maTL)
  /// [isFavorite] - The new favorite status
  Future<void> call(String documentId, bool isFavorite) async {
    // Validate input
    if (documentId.isEmpty) {
      throw Exception('Document ID không được để trống');
    }

    // Call repository
    await _repository.toggleFavorite(documentId, isFavorite);
  }
}
