import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../data_generator/domain/entities/bang_diem_entity.dart';
import '../../../data_generator/domain/entities/mon_hoc_entity.dart';

/// Firebase DataSource cho GPA operations
class FirebaseGPADataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Lấy tất cả bảng điểm của một sinh viên
  Future<List<BangDiemEntity>> getGradesByStudent(String maSV) async {
    try {
      final snapshot = await _firestore
          .collection('bangDiem')
          .where('maSV', isEqualTo: maSV)
          .get();
      return snapshot.docs
          .map((doc) => BangDiemEntity.fromFirestore(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Lỗi khi lấy bảng điểm: $e');
    }
  }

  /// Lấy bảng điểm theo năm học và học kỳ
  Future<List<BangDiemEntity>> getGradesBySemester(
    String maSV,
    int namHoc,
    String hocky,
  ) async {
    try {
      final snapshot = await _firestore
          .collection('bangDiem')
          .where('maSV', isEqualTo: maSV)
          .where('namHoc', isEqualTo: namHoc)
          .where('hocky', isEqualTo: hocky)
          .get();
      return snapshot.docs
          .map((doc) => BangDiemEntity.fromFirestore(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Lỗi khi lấy bảng điểm theo học kỳ: $e');
    }
  }

  /// Lấy bảng điểm theo năm học
  Future<List<BangDiemEntity>> getGradesByYear(
    String maSV,
    int namHoc,
  ) async {
    try {
      final snapshot = await _firestore
          .collection('bangDiem')
          .where('maSV', isEqualTo: maSV)
          .where('namHoc', isEqualTo: namHoc)
          .get();
      return snapshot.docs
          .map((doc) => BangDiemEntity.fromFirestore(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Lỗi khi lấy bảng điểm theo năm học: $e');
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
}

