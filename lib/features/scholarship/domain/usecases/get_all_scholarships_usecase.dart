import '../entities/scholarship_entity.dart';
import '../repositories/scholarship_repository.dart';

/// Use case để lấy tất cả học bổng
class GetAllScholarshipsUseCase {
  final ScholarshipRepository _repository;

  GetAllScholarshipsUseCase(this._repository);

  /// Execute the use case
  Future<List<ScholarshipEntity>> call() async {
    return await _repository.getAllScholarships();
  }
}

