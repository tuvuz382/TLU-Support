import '../../../data_generator/domain/entities/tai_lieu_entity.dart';
import '../repositories/documents_repository.dart';

/// Use case to watch all documents (realtime stream)
class WatchAllDocumentsUseCase {
  final DocumentsRepository _repository;

  WatchAllDocumentsUseCase(this._repository);

  /// Execute the use case
  /// Returns a stream that emits documents list whenever there's a change
  Stream<List<TaiLieuEntity>> call() {
    return _repository.watchAllDocuments();
  }
}
