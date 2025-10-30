import '../../../data_generator/domain/entities/giang_vien_entity.dart';
import '../repositories/teacher_repository.dart';

class GetTeacherDetailUseCase {
  final TeacherRepository repository;
  GetTeacherDetailUseCase(this.repository);

  Future<GiangVienEntity?> call(String maGV) => repository.getTeacherById(maGV);
}
