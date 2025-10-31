import '../../../data_generator/domain/entities/tai_lieu_entity.dart';
import '../repositories/documents_repository.dart';

/// Use case to filter documents by various criteria
/// Follows Clean Architecture: gets data from Repository
class FilterDocumentsUseCase {
  final DocumentsRepository _repository;

  FilterDocumentsUseCase(this._repository);

  /// Execute the use case
  /// [searchQuery] - Optional search query to filter documents first
  /// [subject] - Subject filter (optional)
  /// [favoriteStatus] - Favorite status filter (optional)
  /// [sortBy] - Sort criteria (optional)
  Future<List<TaiLieuEntity>> call({
    String? searchQuery,
    String? subject,
    bool? favoriteStatus,
    String? sortBy,
  }) async {
    // Get documents from repository (following Clean Architecture)
    List<TaiLieuEntity> documents;

    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      // If search query provided, search first
      documents = await _repository.searchDocuments(searchQuery.trim());
    } else {
      // Otherwise get all documents
      documents = await _repository.getAllDocuments();
    }

    // Start filtering from the documents obtained from repository
    List<TaiLieuEntity> filteredDocuments = List.from(documents);

    // Filter by subject
    if (subject != null && subject.isNotEmpty) {
      filteredDocuments = filteredDocuments
          .where((doc) => doc.maMon == subject)
          .toList();
    }

    // Filter by favorite status
    if (favoriteStatus != null) {
      filteredDocuments = filteredDocuments
          .where((doc) => doc.yeuThich == favoriteStatus)
          .toList();
    }

    // Sort documents
    _sortDocuments(filteredDocuments, sortBy);

    return filteredDocuments;
  }

  void _sortDocuments(List<TaiLieuEntity> documents, String? sortBy) {
    switch (sortBy) {
      case 'name_asc':
        documents.sort((a, b) => a.tenTL.compareTo(b.tenTL));
        break;
      case 'name_desc':
        documents.sort((a, b) => b.tenTL.compareTo(a.tenTL));
        break;
      case 'subject_asc':
        documents.sort((a, b) => a.maMon.compareTo(b.maMon));
        break;
      case 'subject_desc':
        documents.sort((a, b) => b.maMon.compareTo(a.maMon));
        break;
      // Default: no sorting
    }
  }
}
