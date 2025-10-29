import '../../../data_generator/domain/entities/sinh_vien_entity.dart';
import '../repositories/student_profile_repository.dart';

/// Use case to watch student profile changes
class WatchStudentProfileUseCase {
  final StudentProfileRepository _repository;

  WatchStudentProfileUseCase(this._repository);

  /// Execute the use case
  /// Returns stream of student profile changes
  Stream<SinhVienEntity?> call() {
    return _repository.watchStudentProfile();
  }
}
