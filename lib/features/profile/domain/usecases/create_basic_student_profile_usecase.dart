import '../repositories/student_profile_repository.dart';

/// Use case to create basic student profile
class CreateBasicStudentProfileUseCase {
  final StudentProfileRepository _repository;

  CreateBasicStudentProfileUseCase(this._repository);

  /// Execute the use case
  /// [email] - Student email
  /// [hoTen] - Student full name
  /// [maSV] - Student ID (optional)
  /// [lop] - Class (optional)
  /// [nganhHoc] - Major (optional)
  Future<void> call({
    required String email,
    required String hoTen,
    String? maSV,
    String? lop,
    String? nganhHoc,
  }) async {
    // Validate input
    if (email.trim().isEmpty) {
      throw Exception('Email không được để trống');
    }
    
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      throw Exception('Email không đúng định dạng');
    }
    
    if (hoTen.trim().isEmpty) {
      throw Exception('Họ tên không được để trống');
    }
    
    if (hoTen.trim().length < 2) {
      throw Exception('Họ tên phải có ít nhất 2 ký tự');
    }

    // Call repository
    await _repository.createBasicStudentProfile(
      email: email,
      hoTen: hoTen,
      maSV: maSV,
      lop: lop,
      nganhHoc: nganhHoc,
    );
  }
}
