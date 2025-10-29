import '../../../data_generator/domain/entities/lich_hoc_entity.dart';
import '../../../data_generator/domain/entities/mon_hoc_entity.dart';

abstract class ScheduleRepository {
  /// Lấy tất cả lịch học
  Future<List<LichHocEntity>> getAllSchedules();
  
  /// Lấy lịch học theo ngày cụ thể
  Future<List<LichHocEntity>> getSchedulesByDate(DateTime date);
  
  /// Lấy lịch học hôm nay
  Future<List<LichHocEntity>> getTodaySchedules();
  
  /// Lấy lịch học trong khoảng thời gian
  Future<List<LichHocEntity>> getSchedulesInRange(DateTime startDate, DateTime endDate);
  
  /// Lấy thông tin môn học theo mã môn
  Future<MonHocEntity?> getSubjectByCode(String maMon);
  
  /// Lấy tất cả môn học
  Future<List<MonHocEntity>> getAllSubjects();
  
  /// Stream lịch học realtime
  Stream<List<LichHocEntity>> watchAllSchedules();
  
  // Thêm method lọc theo lớp và ngành học
  /// Lấy lịch học theo lớp
  Future<List<LichHocEntity>> getSchedulesByClass(String lop);
  
  /// Lấy lịch học theo ngành học
  Future<List<LichHocEntity>> getSchedulesByMajor(String nganhHoc);
  
  /// Lấy lịch học hôm nay theo lớp
  Future<List<LichHocEntity>> getTodaySchedulesByClass(String lop);
}
