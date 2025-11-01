import '../../domain/repositories/teacher_repository.dart';
import '../../../data_generator/domain/entities/giang_vien_entity.dart';
import '../../../data_generator/domain/entities/danh_gia_entity.dart';
import '../datasources/firebase_teacher_datasource.dart';

class TeacherRepositoryImpl implements TeacherRepository {
  final FirebaseTeacherDataSource _dataSource;

  TeacherRepositoryImpl(this._dataSource);

  @override
  Future<List<GiangVienEntity>> getAllTeachers() async {
    return await _dataSource.getAllTeachers();
  }

  @override
  Future<GiangVienEntity?> getTeacherById(String maGV) async {
    return await _dataSource.getTeacherById(maGV);
  }

  @override
  Future<List<GiangVienEntity>> searchTeachers(String query) async {
    return await _dataSource.searchTeachers(query);
  }

  @override
  Future<List<DanhGiaEntity>> getReviewsByTeacher(String maGV) {
    return _dataSource.getReviewsByTeacher(maGV);
  }

  @override
  Future<void> addReview(DanhGiaEntity review) {
    return _dataSource.addReview(review);
  }

  @override
  Future<bool> hasReviewedTeacher(String maGV, String maSV) {
    return _dataSource.hasReviewedTeacher(maGV, maSV);
  }
}

