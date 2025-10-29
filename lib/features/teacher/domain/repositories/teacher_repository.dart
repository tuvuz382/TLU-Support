import '../../../data_generator/domain/entities/giang_vien_entity.dart';

abstract class TeacherRepository {
  Future<List<GiangVienEntity>> getAllTeachers();
  Future<GiangVienEntity?> getTeacherById(String maGV);
  Future<List<GiangVienEntity>> searchTeachers(String query);
}

