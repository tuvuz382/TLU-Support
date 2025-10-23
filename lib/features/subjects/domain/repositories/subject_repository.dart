import '../entities/subject_entity.dart';

abstract class SubjectRepository {
  /// Lấy tất cả môn học
  Future<List<SubjectEntity>> getAllSubjects();

  /// Lấy môn học theo ngành
  Future<List<SubjectEntity>> getSubjectsByMajor(String major);

  /// Lấy môn học theo ID
  Future<SubjectEntity?> getSubjectById(String id);

  /// Tìm kiếm môn học
  Future<List<SubjectEntity>> searchSubjects(String query);
}

