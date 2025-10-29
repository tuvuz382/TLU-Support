import '../repositories/scholarship_repository.dart';

/// Use case để đăng ký học bổng
class RegisterScholarshipUseCase {
  final ScholarshipRepository _repository;

  RegisterScholarshipUseCase(this._repository);

  /// Execute the use case
  /// Returns registration ID
  Future<String> call(String maHB) async {
    // Business logic: Kiểm tra đã đăng ký chưa
    final hasRegistered = await _repository.hasRegisteredScholarship(maHB);
    if (hasRegistered) {
      throw Exception('Bạn đã đăng ký học bổng này rồi');
    }

    // Business logic: Kiểm tra học bổng có đang mở đăng ký không
    final scholarship = await _repository.getScholarshipById(maHB);
    if (scholarship == null) {
      throw Exception('Không tìm thấy học bổng');
    }

    if (scholarship.isExpired) {
      throw Exception('Học bổng đã hết hạn đăng ký');
    }

    if (!scholarship.isOpenForRegistration) {
      throw Exception('Học bổng chưa mở đăng ký');
    }

    return await _repository.registerScholarship(maHB);
  }
}

