import '../repositories/teacher_repository.dart';
import '../../../data_generator/domain/entities/giang_vien_entity.dart';

class GetAllTeachersUseCase {
  final TeacherRepository repository;
  GetAllTeachersUseCase(this.repository);
  Future<List<GiangVienEntity>> call() => repository.getAllTeachers();
}
