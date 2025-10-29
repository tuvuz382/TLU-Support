import '../../../data_generator/domain/entities/tai_lieu_entity.dart';
import '../repositories/documents_repository.dart';

/// Use case to search documents by query
class SearchDocumentsUseCase {
  final DocumentsRepository _repository;

  SearchDocumentsUseCase(this._repository);

  /// Execute the use case
  /// [query] - The search query string
  Future<List<TaiLieuEntity>> call(String query) async {
    // Normalize query (trim, validate)
    final normalizedQuery = query.trim();

    if (normalizedQuery.isEmpty) {
      return [];
    }

    // Call repository
    return await _repository.searchDocuments(normalizedQuery);
  }
}
