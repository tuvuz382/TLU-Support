import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../data_generator/domain/entities/giang_vien_entity.dart';

class FirebaseTeacherDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<GiangVienEntity>> getAllTeachers() async {
    try {
      final snapshot = await _firestore
          .collection('giangVien')
          .orderBy('hoTen')
          .get();

      return snapshot.docs
          .map((doc) => GiangVienEntity.fromFirestore(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Lỗi khi lấy danh sách giảng viên: $e');
    }
  }

  Future<GiangVienEntity?> getTeacherById(String maGV) async {
    try {
      final snapshot = await _firestore
          .collection('giangVien')
          .where('maGV', isEqualTo: maGV)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        return null;
      }

      return GiangVienEntity.fromFirestore(snapshot.docs.first.data());
    } catch (e) {
      throw Exception('Lỗi khi lấy thông tin giảng viên: $e');
    }
  }

  Future<List<GiangVienEntity>> searchTeachers(String query) async {
    try {
      final snapshot = await _firestore
          .collection('giangVien')
          .get();

      final allTeachers = snapshot.docs
          .map((doc) => GiangVienEntity.fromFirestore(doc.data()))
          .toList();

      final lowerQuery = query.toLowerCase();
      return allTeachers.where((teacher) {
        return teacher.hoTen.toLowerCase().contains(lowerQuery) ||
            teacher.chuyenNganh.toLowerCase().contains(lowerQuery) ||
            teacher.maGV.toLowerCase().contains(lowerQuery) ||
            teacher.hocVi.toLowerCase().contains(lowerQuery);
      }).toList();
    } catch (e) {
      throw Exception('Lỗi khi tìm kiếm giảng viên: $e');
    }
  }
}

