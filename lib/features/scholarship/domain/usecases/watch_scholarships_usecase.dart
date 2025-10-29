import '../entities/scholarship_entity.dart';
import '../repositories/scholarship_repository.dart';

/// Use case để theo dõi danh sách học bổng real-time
class WatchScholarshipsUseCase {
  final ScholarshipRepository _repository;

  WatchScholarshipsUseCase(this._repository);

  /// Execute the use case
  Stream<List<ScholarshipEntity>> call() {
    return _repository.watchScholarships();
  }
}

