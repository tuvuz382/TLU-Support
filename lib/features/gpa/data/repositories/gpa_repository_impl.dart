import '../../domain/repositories/gpa_repository.dart';
import '../datasources/firebase_gpa_datasource.dart';
import '../../../data_generator/domain/entities/bang_diem_entity.dart';
import '../../../data_generator/domain/entities/mon_hoc_entity.dart';

class GPARepositoryImpl implements GPARepository {
  final FirebaseGPADataSource _dataSource;

  GPARepositoryImpl(this._dataSource);

  @override
  Future<List<BangDiemEntity>> getGradesByStudent(String maSV) async {
    return await _dataSource.getGradesByStudent(maSV);
  }

  @override
  Future<List<BangDiemEntity>> getGradesBySemester(
    String maSV,
    int namHoc,
    String hocky,
  ) async {
    return await _dataSource.getGradesBySemester(maSV, namHoc, hocky);
  }

  @override
  Future<List<BangDiemEntity>> getGradesByYear(
    String maSV,
    int namHoc,
  ) async {
    return await _dataSource.getGradesByYear(maSV, namHoc);
  }

  @override
  Future<MonHocEntity?> getSubjectByCode(String maMon) async {
    return await _dataSource.getSubjectByCode(maMon);
  }

  @override
  Future<List<MonHocEntity>> getAllSubjects() async {
    return await _dataSource.getAllSubjects();
  }
}

