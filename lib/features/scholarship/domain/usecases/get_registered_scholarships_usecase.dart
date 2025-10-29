import '../entities/scholarship_entity.dart';
import '../repositories/scholarship_repository.dart';

/// Use case để lấy danh sách học bổng đã đăng ký
class GetRegisteredScholarshipsUseCase {
  final ScholarshipRepository _repository;

  GetRegisteredScholarshipsUseCase(this._repository);

  /// Execute the use case
  Future<List<ScholarshipRegistrationEntity>> call() async {
    return await _repository.getRegisteredScholarships();
  }
}

