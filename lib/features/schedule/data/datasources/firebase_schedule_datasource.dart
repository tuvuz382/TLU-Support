import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../data_generator/domain/entities/lich_hoc_entity.dart';
import '../../../data_generator/domain/entities/mon_hoc_entity.dart';

/// Firebase DataSource cho Schedule operations
class FirebaseScheduleDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Lấy tất cả lịch học từ Firestore
  Future<List<LichHocEntity>> getAllSchedules() async {
    try {
      final snapshot = await _firestore.collection('lichHoc').get();
      return snapshot.docs
          .map((doc) => LichHocEntity.fromFirestore(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Lỗi khi lấy danh sách lịch học: $e');
    }
  }

  /// Lấy lịch học theo ngày cụ thể
  Future<List<LichHocEntity>> getSchedulesByDate(DateTime date) async {
    try {
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);
      
      // Query đơn giản: lấy tất cả lịch học, sau đó filter theo ngày
      final snapshot = await _firestore.collection('lichHoc').get();
      
      final allSchedules = snapshot.docs
          .map((doc) => LichHocEntity.fromFirestore(doc.data()))
          .toList();
      
      // Filter theo ngày trong code
      return allSchedules.where((schedule) {
        final scheduleDate = schedule.ngayHoc;
        return scheduleDate.isAfter(startOfDay.subtract(const Duration(seconds: 1))) &&
               scheduleDate.isBefore(endOfDay.add(const Duration(seconds: 1)));
      }).toList();
    } catch (e) {
      throw Exception('Lỗi khi lấy lịch học theo ngày: $e');
    }
  }

  /// Lấy lịch học trong khoảng thời gian
  Future<List<LichHocEntity>> getSchedulesInRange(DateTime startDate, DateTime endDate) async {
    try {
      // Query đơn giản: lấy tất cả lịch học, sau đó filter theo khoảng thời gian
      final snapshot = await _firestore.collection('lichHoc').get();
      
      final allSchedules = snapshot.docs
          .map((doc) => LichHocEntity.fromFirestore(doc.data()))
          .toList();
      
      // Filter theo khoảng thời gian trong code
      return allSchedules.where((schedule) {
        final scheduleDate = schedule.ngayHoc;
        return scheduleDate.isAfter(startDate.subtract(const Duration(seconds: 1))) &&
               scheduleDate.isBefore(endDate.add(const Duration(seconds: 1)));
      }).toList();
    } catch (e) {
      throw Exception('Lỗi khi lấy lịch học trong khoảng thời gian: $e');
    }
  }

  /// Lấy thông tin môn học theo mã môn
  Future<MonHocEntity?> getSubjectByCode(String maMon) async {
    try {
      final snapshot = await _firestore
          .collection('monHoc')
          .where('maMon', isEqualTo: maMon)
          .limit(1)
          .get();
      
      if (snapshot.docs.isNotEmpty) {
        return MonHocEntity.fromFirestore(snapshot.docs.first.data());
      }
      return null;
    } catch (e) {
      throw Exception('Lỗi khi lấy thông tin môn học: $e');
    }
  }

  /// Lấy tất cả môn học
  Future<List<MonHocEntity>> getAllSubjects() async {
    try {
      final snapshot = await _firestore.collection('monHoc').get();
      return snapshot.docs
          .map((doc) => MonHocEntity.fromFirestore(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Lỗi khi lấy danh sách môn học: $e');
    }
  }

  /// Stream lịch học realtime
  Stream<List<LichHocEntity>> watchAllSchedules() {
    try {
      return _firestore.collection('lichHoc').snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => LichHocEntity.fromFirestore(doc.data()))
            .toList(),
      );
    } catch (e) {
      throw Exception('Lỗi khi theo dõi lịch học: $e');
    }
  }

  /// Lấy lịch học theo lớp
  Future<List<LichHocEntity>> getSchedulesByClass(String lop) async {
    try {
      final snapshot = await _firestore
          .collection('lichHoc')
          .where('lop', isEqualTo: lop)
          .get();
      
      return snapshot.docs
          .map((doc) => LichHocEntity.fromFirestore(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Lỗi khi lấy lịch học theo lớp: $e');
    }
  }

  /// Lấy lịch học theo ngành học
  Future<List<LichHocEntity>> getSchedulesByMajor(String nganhHoc) async {
    try {
      final snapshot = await _firestore
          .collection('lichHoc')
          .where('nganhHoc', isEqualTo: nganhHoc)
          .get();
      
      return snapshot.docs
          .map((doc) => LichHocEntity.fromFirestore(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Lỗi khi lấy lịch học theo ngành học: $e');
    }
  }

  /// Lấy lịch học hôm nay theo lớp
  Future<List<LichHocEntity>> getTodaySchedulesByClass(String lop) async {
    try {
      final today = DateTime.now();
      final startOfDay = DateTime(today.year, today.month, today.day);
      final endOfDay = DateTime(today.year, today.month, today.day, 23, 59, 59);
      
      // Query đơn giản hơn: lấy tất cả lịch học của lớp, sau đó filter theo ngày
      final snapshot = await _firestore
          .collection('lichHoc')
          .where('lop', isEqualTo: lop)
          .get();
      
      final allSchedules = snapshot.docs
          .map((doc) => LichHocEntity.fromFirestore(doc.data()))
          .toList();
      
      // Filter theo ngày trong code thay vì trong query
      return allSchedules.where((schedule) {
        final scheduleDate = schedule.ngayHoc;
        return scheduleDate.isAfter(startOfDay.subtract(const Duration(seconds: 1))) &&
               scheduleDate.isBefore(endOfDay.add(const Duration(seconds: 1)));
      }).toList();
    } catch (e) {
      throw Exception('Lỗi khi lấy lịch học hôm nay theo lớp: $e');
    }
  }
}
