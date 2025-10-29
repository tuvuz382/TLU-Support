import '../repositories/student_profile_repository.dart';

/// Use case to check if student has profile
class HasStudentProfileUseCase {
  final StudentProfileRepository _repository;

  HasStudentProfileUseCase(this._repository);

  /// Execute the use case
  /// Returns true if student has profile, false otherwise
  Future<bool> call() async {
    return await _repository.hasStudentProfile();
  }
}
