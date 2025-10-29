import '../../../data_generator/domain/entities/tai_lieu_entity.dart';

/// Use case to get unique subjects from documents
class GetAvailableSubjectsUseCase {
  /// Execute the use case
  /// [documents] - List of documents to extract subjects from
  /// Returns sorted list of unique subjects
  List<String> call(List<TaiLieuEntity> documents) {
    return documents.map((doc) => doc.monHoc).toSet().toList()..sort();
  }
}
