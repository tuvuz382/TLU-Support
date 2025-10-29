import '../../../data_generator/domain/entities/sinh_vien_entity.dart';
import '../repositories/student_profile_repository.dart';

/// Use case to get current student profile
class GetCurrentStudentProfileUseCase {
  final StudentProfileRepository _repository;

  GetCurrentStudentProfileUseCase(this._repository);

  /// Execute the use case
  Future<SinhVienEntity?> call() async {
    return await _repository.getCurrentStudentProfile();
  }
}
