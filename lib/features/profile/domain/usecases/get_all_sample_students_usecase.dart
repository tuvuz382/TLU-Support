import '../../../data_generator/domain/entities/sinh_vien_entity.dart';
import '../repositories/student_profile_repository.dart';

/// Use case to get all sample students
class GetAllSampleStudentsUseCase {
  final StudentProfileRepository _repository;

  GetAllSampleStudentsUseCase(this._repository);

  /// Execute the use case
  /// [limit] - Maximum number of students to return (default: 50)
  /// [nganhHoc] - Filter by major (optional)
  Future<List<SinhVienEntity>> call({
    int limit = 50,
    String? nganhHoc,
  }) async {
    // Get all students from repository
    final students = await _repository.getAllSampleStudents();
    
    // Apply filtering
    var filteredStudents = students;
    
    if (nganhHoc != null && nganhHoc.isNotEmpty) {
      filteredStudents = students.where(
        (student) => student.nganhHoc.toLowerCase().contains(
          nganhHoc.toLowerCase(),
        ),
      ).toList();
    }
    
    // Apply limit
    if (filteredStudents.length > limit) {
      filteredStudents = filteredStudents.take(limit).toList();
    }
    
    return filteredStudents;
  }
}
