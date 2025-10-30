import '../repositories/gpa_repository.dart';
import '../../../data_generator/domain/entities/mon_hoc_entity.dart';

class GetAllSubjectsUseCase {
  final GPARepository repository;
  GetAllSubjectsUseCase(this.repository);
  Future<List<MonHocEntity>> call() => repository.getAllSubjects();
}
