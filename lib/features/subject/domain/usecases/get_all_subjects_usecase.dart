import '../../../data_generator/domain/entities/mon_hoc_entity.dart';
import '../repositories/subjects_repository.dart';

class GetAllSubjectsUseCase {
  final SubjectsRepository repository;
  GetAllSubjectsUseCase(this.repository);

  Future<List<MonHocEntity>> call() => repository.getAllSubjects();
}
