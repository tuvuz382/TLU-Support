import '../../domain/repositories/schedule_repository.dart';
import '../../../data_generator/domain/entities/lich_hoc_entity.dart';

class GetSchedulesByClassUseCase {
  final ScheduleRepository repository;
  GetSchedulesByClassUseCase(this.repository);
  Future<List<LichHocEntity>> call(String classId) => repository.getSchedulesByClass(classId);
}
