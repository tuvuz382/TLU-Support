import '../../../data_generator/domain/entities/tai_lieu_entity.dart';

/// Use case to filter documents by various criteria
class FilterDocumentsUseCase {
  /// Execute the use case
  /// [documents] - List of documents to filter
  /// [subject] - Subject filter (optional)
  /// [favoriteStatus] - Favorite status filter (optional)
  /// [sortBy] - Sort criteria (optional)
  List<TaiLieuEntity> call({
    required List<TaiLieuEntity> documents,
    String? subject,
    bool? favoriteStatus,
    String? sortBy,
  }) {
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
