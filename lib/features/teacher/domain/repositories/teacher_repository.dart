import '../../../data_generator/domain/entities/giang_vien_entity.dart';
import '../../../data_generator/domain/entities/danh_gia_entity.dart';

abstract class TeacherRepository {
  Future<List<GiangVienEntity>> getAllTeachers();
  Future<GiangVienEntity?> getTeacherById(String maGV);
  Future<List<GiangVienEntity>> searchTeachers(String query);
  Future<List<DanhGiaEntity>> getReviewsByTeacher(String maGV);
  Future<void> addReview(DanhGiaEntity review);
}

