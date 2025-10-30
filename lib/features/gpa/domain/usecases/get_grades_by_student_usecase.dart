import '../repositories/gpa_repository.dart';
import '../../../data_generator/domain/entities/bang_diem_entity.dart';

class GetGradesByStudentUseCase {
  final GPARepository repository;
  GetGradesByStudentUseCase(this.repository);
  Future<List<BangDiemEntity>> call(String maSV) => repository.getGradesByStudent(maSV);
}
