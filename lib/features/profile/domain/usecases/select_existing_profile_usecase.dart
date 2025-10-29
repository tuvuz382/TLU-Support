import '../repositories/student_profile_repository.dart';

/// Use case to select existing profile
class SelectExistingProfileUseCase {
  final StudentProfileRepository _repository;

  SelectExistingProfileUseCase(this._repository);

  /// Execute the use case
  /// [maSV] - Student ID to select
  Future<void> call(String maSV) async {
    // Validate input
    if (maSV.trim().isEmpty) {
      throw Exception('Mã sinh viên không được để trống');
    }
    
    if (maSV.trim().length < 3) {
      throw Exception('Mã sinh viên phải có ít nhất 3 ký tự');
    }

    // Check if student exists
    final existingProfile = await _repository.getStudentById(maSV);
    if (existingProfile == null) {
      throw Exception('Không tìm thấy sinh viên với mã: $maSV');
    }

    // Call repository
    await _repository.selectExistingProfile(maSV);
  }
}
