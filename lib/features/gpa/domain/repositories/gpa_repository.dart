import '../../../data_generator/domain/entities/bang_diem_entity.dart';
import '../../../data_generator/domain/entities/mon_hoc_entity.dart';

abstract class GPARepository {
  /// Lấy tất cả bảng điểm của một sinh viên
  Future<List<BangDiemEntity>> getGradesByStudent(String maSV);

  /// Lấy bảng điểm theo năm học và học kỳ
  Future<List<BangDiemEntity>> getGradesBySemester(
    String maSV,
    int namHoc,
    String hocky,
  );

  /// Lấy bảng điểm theo năm học
  Future<List<BangDiemEntity>> getGradesByYear(
    String maSV,
    int namHoc,
  );

  /// Lấy thông tin môn học theo mã môn
  Future<MonHocEntity?> getSubjectByCode(String maMon);

  /// Lấy tất cả môn học
  Future<List<MonHocEntity>> getAllSubjects();
}

