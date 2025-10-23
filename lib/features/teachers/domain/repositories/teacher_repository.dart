import '../entities/teacher_entity.dart';

abstract class TeacherRepository {
  /// Lấy danh sách tất cả giảng viên
  Future<List<TeacherEntity>> getAllTeachers();

  /// Lấy thông tin chi tiết giảng viên theo ID
  Future<TeacherEntity?> getTeacherById(String id);

  /// Tìm kiếm giảng viên theo tên
  Future<List<TeacherEntity>> searchTeachers(String query);

  /// Lọc giảng viên theo khoa
  Future<List<TeacherEntity>> getTeachersByFaculty(String faculty);

  /// Lọc giảng viên theo bộ môn
  Future<List<TeacherEntity>> getTeachersByDepartment(String department);
}

