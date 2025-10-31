import '../../../data_generator/domain/entities/giang_vien_entity.dart';
import '../repositories/teacher_repository.dart';

class SearchTeachersUseCase {
  final TeacherRepository repository;
  SearchTeachersUseCase(this.repository);

  Future<List<GiangVienEntity>> call(String query) => repository.searchTeachers(query);
}

