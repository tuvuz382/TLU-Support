import '../../../data_generator/domain/entities/tai_lieu_entity.dart';
import '../repositories/documents_repository.dart';

/// Use case to search documents by query
class SearchDocumentsUseCase {
  final DocumentsRepository _repository;

  SearchDocumentsUseCase(this._repository);

  /// Execute the use case
  /// [query] - The search query string
  /// Returns list of documents matching the query
  Future<List<TaiLieuEntity>> call(String query) async {
    // Normalize query (trim, validate)
    final normalizedQuery = query.trim();

    if (normalizedQuery.isEmpty) {
      return [];
    }

    // Get all documents from repository (following Clean Architecture)
    final allDocuments = await _repository.getAllDocuments();

    // Search in documents by matching query in title, subject code, or description
    return allDocuments
        .where(
          (doc) =>
              doc.tenTL.toLowerCase().contains(normalizedQuery.toLowerCase()) ||
              doc.maMon.toLowerCase().contains(normalizedQuery.toLowerCase()) ||
              doc.moTa.toLowerCase().contains(normalizedQuery.toLowerCase()),
        )
        .toList();
  }
}
