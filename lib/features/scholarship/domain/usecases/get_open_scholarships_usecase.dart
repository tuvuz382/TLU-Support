import '../entities/scholarship_entity.dart';
import '../repositories/scholarship_repository.dart';

/// Use case để lấy danh sách học bổng đang mở đăng ký
class GetOpenScholarshipsUseCase {
  final ScholarshipRepository _repository;

  GetOpenScholarshipsUseCase(this._repository);

  /// Execute the use case
  Future<List<ScholarshipEntity>> call() async {
    return await _repository.getOpenScholarships();
  }
}

