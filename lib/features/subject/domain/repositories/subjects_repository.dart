import '../../../data_generator/domain/entities/mon_hoc_entity.dart';

abstract class SubjectsRepository {
  Future<List<MonHocEntity>> getAllSubjects();
  Future<List<MonHocEntity>> getSubjectsByMajor(String major);
}


