import '../../../data_generator/domain/entities/lich_hoc_entity.dart';
import '../../../data_generator/domain/entities/mon_hoc_entity.dart';
import '../../domain/repositories/schedule_repository.dart';
import '../datasources/firebase_schedule_datasource.dart';

/// Implementation của ScheduleRepository
class ScheduleRepositoryImpl implements ScheduleRepository {
  final FirebaseScheduleDataSource _dataSource;

  ScheduleRepositoryImpl(this._dataSource);

  @override
  Future<List<LichHocEntity>> getAllSchedules() async {
    return await _dataSource.getAllSchedules();
  }

  @override
  Future<List<LichHocEntity>> getSchedulesByDate(DateTime date) async {
    return await _dataSource.getSchedulesByDate(date);
  }

  @override
  Future<List<LichHocEntity>> getTodaySchedules() async {
    final today = DateTime.now();
    return await _dataSource.getSchedulesByDate(today);
  }

  @override
  Future<List<LichHocEntity>> getSchedulesInRange(DateTime startDate, DateTime endDate) async {
    return await _dataSource.getSchedulesInRange(startDate, endDate);
  }

  @override
  Future<MonHocEntity?> getSubjectByCode(String maMon) async {
    return await _dataSource.getSubjectByCode(maMon);
  }

  @override
  Future<List<MonHocEntity>> getAllSubjects() async {
    return await _dataSource.getAllSubjects();
  }

  @override
  Stream<List<LichHocEntity>> watchAllSchedules() {
    return _dataSource.watchAllSchedules();
  }

  @override
  Future<List<LichHocEntity>> getSchedulesByClass(String lop) async {
    return await _dataSource.getSchedulesByClass(lop);
  }

  @override
  Future<List<LichHocEntity>> getSchedulesByMajor(String nganhHoc) async {
    return await _dataSource.getSchedulesByMajor(nganhHoc);
  }

  @override
  Future<List<LichHocEntity>> getTodaySchedulesByClass(String lop) async {
    return await _dataSource.getTodaySchedulesByClass(lop);
  }
}
