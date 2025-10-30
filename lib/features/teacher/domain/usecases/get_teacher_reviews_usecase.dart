import '../../../data_generator/domain/entities/danh_gia_entity.dart';
import '../repositories/teacher_repository.dart';

class GetTeacherReviewsUseCase {
  final TeacherRepository repository;
  GetTeacherReviewsUseCase(this.repository);

  Future<List<DanhGiaEntity>> call(String maGV) => repository.getReviewsByTeacher(maGV);
}
