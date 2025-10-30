import '../../../data_generator/domain/entities/tai_lieu_entity.dart';
import '../repositories/documents_repository.dart';

/// Use case to search documents by query
class SearchDocumentsUseCase {
  final DocumentsRepository _repository;

  SearchDocumentsUseCase(this._repository);

  /// Execute the use case
  /// [query] - The search query string
  /// [documents] - List of documents to search in (optional, if not provided will use repository)
  Future<List<TaiLieuEntity>> call(
    String query, {
    List<TaiLieuEntity>? documents,
  }) async {
    // Normalize query (trim, validate)
    final normalizedQuery = query.trim();

    if (normalizedQuery.isEmpty) {
      return documents ?? [];
    }

    // If documents provided, search in them directly
    if (documents != null) {
      return documents
          .where(
            (doc) =>
                doc.tenTL.toLowerCase().contains(
                  normalizedQuery.toLowerCase(),
                ) ||
                doc.maMon.toLowerCase().contains(
                  normalizedQuery.toLowerCase(),
                ) ||
                doc.moTa.toLowerCase().contains(normalizedQuery.toLowerCase()),
          )
          .toList();
    }

    // Otherwise call repository
    return await _repository.searchDocuments(normalizedQuery);
  }
}
