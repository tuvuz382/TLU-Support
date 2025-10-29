import '../entities/scholarship_entity.dart';
import '../repositories/scholarship_repository.dart';

/// Use case để lấy học bổng theo mã học bổng
class GetScholarshipByIdUseCase {
  final ScholarshipRepository _repository;

  GetScholarshipByIdUseCase(this._repository);

  /// Execute the use case
  Future<ScholarshipEntity?> call(String maHB) async {
    return await _repository.getScholarshipById(maHB);
  }
}

