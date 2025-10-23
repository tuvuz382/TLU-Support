import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/teacher_entity.dart';
import '../../domain/repositories/teacher_repository.dart';

class FirebaseTeacherDatasource implements TeacherRepository {
  final FirebaseFirestore _firestore;
  final String _collectionName = 'teachers';

  FirebaseTeacherDatasource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<TeacherEntity>> getAllTeachers() async {
    try {
      final querySnapshot = await _firestore
          .collection(_collectionName)
          .orderBy('name')
          .get();

      return querySnapshot.docs
          .map((doc) => TeacherEntity.fromJson(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Không thể tải danh sách giảng viên: $e');
    }
  }

  @override
  Future<TeacherEntity?> getTeacherById(String id) async {
    try {
      final docSnapshot =
          await _firestore.collection(_collectionName).doc(id).get();

      if (!docSnapshot.exists) {
        return null;
      }

      return TeacherEntity.fromJson(docSnapshot.data()!, docSnapshot.id);
    } catch (e) {
      throw Exception('Không thể tải thông tin giảng viên: $e');
    }
  }

  @override
  Future<List<TeacherEntity>> searchTeachers(String query) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collectionName)
          .orderBy('name')
          .get();

      final allTeachers = querySnapshot.docs
          .map((doc) => TeacherEntity.fromJson(doc.data(), doc.id))
          .toList();

      // Lọc theo tên (case-insensitive)
      return allTeachers
          .where((teacher) =>
              teacher.name.toLowerCase().contains(query.toLowerCase()) ||
              teacher.fullName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } catch (e) {
      throw Exception('Không thể tìm kiếm giảng viên: $e');
    }
  }

  @override
  Future<List<TeacherEntity>> getTeachersByFaculty(String faculty) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collectionName)
          .where('faculty', isEqualTo: faculty)
          .orderBy('name')
          .get();

      return querySnapshot.docs
          .map((doc) => TeacherEntity.fromJson(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Không thể tải danh sách giảng viên theo khoa: $e');
    }
  }

  @override
  Future<List<TeacherEntity>> getTeachersByDepartment(
      String department) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collectionName)
          .where('department', isEqualTo: department)
          .orderBy('name')
          .get();

      return querySnapshot.docs
          .map((doc) => TeacherEntity.fromJson(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Không thể tải danh sách giảng viên theo bộ môn: $e');
    }
  }

  /// Thêm giảng viên mới
  Future<String> addTeacher(Map<String, dynamic> teacherData) async {
    try {
      final docRef = await _firestore.collection(_collectionName).add(teacherData);
      return docRef.id;
    } catch (e) {
      throw Exception('Không thể thêm giảng viên: $e');
    }
  }

  /// Cập nhật thông tin giảng viên
  Future<void> updateTeacher(String id, Map<String, dynamic> teacherData) async {
    try {
      await _firestore.collection(_collectionName).doc(id).update(teacherData);
    } catch (e) {
      throw Exception('Không thể cập nhật giảng viên: $e');
    }
  }

  /// Xóa giảng viên
  Future<void> deleteTeacher(String id) async {
    try {
      await _firestore.collection(_collectionName).doc(id).delete();
    } catch (e) {
      throw Exception('Không thể xóa giảng viên: $e');
    }
  }
}

