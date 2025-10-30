import '../../../data_generator/domain/entities/mon_hoc_entity.dart';
import '../../domain/repositories/subjects_repository.dart';
import '../datasources/firebase_subjects_datasource.dart';

class SubjectsRepositoryImpl implements SubjectsRepository {
  final FirebaseSubjectsDataSource _dataSource;
  SubjectsRepositoryImpl(this._dataSource);

  @override
  Future<List<MonHocEntity>> getAllSubjects() {
    return _dataSource.getAllSubjects();
  }

  @override
  Future<List<MonHocEntity>> getSubjectsByMajor(String major) {
    return _dataSource.getSubjectsByMajor(major);
  }
}


