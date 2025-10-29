import '../../../data_generator/domain/entities/sinh_vien_entity.dart';
import '../repositories/student_profile_repository.dart';

/// Use case to update student profile
class UpdateStudentProfileUseCase {
  final StudentProfileRepository _repository;

  UpdateStudentProfileUseCase(this._repository);

  /// Execute the use case
  /// [student] - Student entity to update
  Future<void> call(SinhVienEntity student) async {
    // Validate input
    if (student.hoTen.trim().isEmpty) {
      throw Exception('Họ tên không được để trống');
    }
    
    if (student.maSV.trim().isEmpty) {
      throw Exception('Mã sinh viên không được để trống');
    }
    
    if (student.lop.trim().isEmpty) {
      throw Exception('Lớp không được để trống');
    }
    
    if (student.nganhHoc.trim().isEmpty) {
      throw Exception('Ngành học không được để trống');
    }
    
    if (student.diemGPA < 0 || student.diemGPA > 4.0) {
      throw Exception('Điểm GPA phải từ 0.0 đến 4.0');
    }
    
    if (student.ngaySinh.isAfter(DateTime.now())) {
      throw Exception('Ngày sinh không thể là ngày tương lai');
    }

    // Call repository
    await _repository.updateStudentProfile(student);
  }
}
