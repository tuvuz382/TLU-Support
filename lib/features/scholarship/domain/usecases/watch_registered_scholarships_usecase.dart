import '../entities/scholarship_entity.dart';
import '../repositories/scholarship_repository.dart';

/// Use case để theo dõi danh sách học bổng đã đăng ký real-time
class WatchRegisteredScholarshipsUseCase {
  final ScholarshipRepository _repository;

  WatchRegisteredScholarshipsUseCase(this._repository);

  /// Execute the use case
  Stream<List<ScholarshipRegistrationEntity>> call() {
    return _repository.watchRegisteredScholarships();
  }
}

