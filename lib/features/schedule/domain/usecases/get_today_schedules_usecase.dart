import '../../domain/repositories/schedule_repository.dart';
import '../../../data_generator/domain/entities/lich_hoc_entity.dart';

class GetTodaySchedulesUseCase {
  final ScheduleRepository repository;
  GetTodaySchedulesUseCase(this.repository);
  Future<List<LichHocEntity>> call() => repository.getTodaySchedules();
}
