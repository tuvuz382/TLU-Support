import '../../domain/repositories/schedule_repository.dart';
import '../../../data_generator/domain/entities/lich_hoc_entity.dart';

class GetAllSchedulesUseCase {
  final ScheduleRepository repository;
  GetAllSchedulesUseCase(this.repository);
  Future<List<LichHocEntity>> call() => repository.getAllSchedules();
}
