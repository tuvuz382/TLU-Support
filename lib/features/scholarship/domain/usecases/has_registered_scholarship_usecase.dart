import '../repositories/scholarship_repository.dart';

/// Use case để kiểm tra sinh viên đã đăng ký học bổng chưa
class HasRegisteredScholarshipUseCase {
  final ScholarshipRepository _repository;

  HasRegisteredScholarshipUseCase(this._repository);

  /// Execute the use case
  Future<bool> call(String maHB) async {
    return await _repository.hasRegisteredScholarship(maHB);
  }
}

