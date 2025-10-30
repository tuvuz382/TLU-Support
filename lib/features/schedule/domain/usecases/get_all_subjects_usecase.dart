import '../../domain/repositories/schedule_repository.dart';
import '../../../data_generator/domain/entities/mon_hoc_entity.dart';

class GetAllSubjectsUseCase {
  final ScheduleRepository repository;
  GetAllSubjectsUseCase(this.repository);
  Future<List<MonHocEntity>> call() => repository.getAllSubjects();
}
