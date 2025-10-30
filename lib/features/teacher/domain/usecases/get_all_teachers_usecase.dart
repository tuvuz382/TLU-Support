import '../../../data_generator/domain/entities/giang_vien_entity.dart';
import '../repositories/teacher_repository.dart';

class GetAllTeachersUseCase {
  final TeacherRepository repository;
  GetAllTeachersUseCase(this.repository);

  Future<List<GiangVienEntity>> call() => repository.getAllTeachers();
}
