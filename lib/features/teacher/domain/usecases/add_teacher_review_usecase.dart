import '../../../data_generator/domain/entities/danh_gia_entity.dart';
import '../repositories/teacher_repository.dart';

class AddTeacherReviewUseCase {
  final TeacherRepository repository;
  AddTeacherReviewUseCase(this.repository);

  Future<void> call(DanhGiaEntity review) => repository.addReview(review);
}

