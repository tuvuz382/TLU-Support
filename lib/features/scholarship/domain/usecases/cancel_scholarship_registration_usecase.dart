import '../repositories/scholarship_repository.dart';

/// Use case để hủy đăng ký học bổng
class CancelScholarshipRegistrationUseCase {
  final ScholarshipRepository _repository;

  CancelScholarshipRegistrationUseCase(this._repository);

  /// Execute the use case
  /// Chỉ cho phép hủy nếu trạng thái là 'pending'
  Future<void> call(String registrationId) async {
    final registration =
        await _repository.getRegistrationById(registrationId);
    if (registration == null) {
      throw Exception('Không tìm thấy đăng ký');
    }

    if (registration.trangThai != 'pending') {
      throw Exception(
          'Chỉ có thể hủy đăng ký khi trạng thái là "Đang chờ duyệt"');
    }

    await _repository.cancelRegistration(registrationId);
  }
}

