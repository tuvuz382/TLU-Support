import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/subject_entity.dart';
import '../../domain/repositories/subject_repository.dart';

class FirebaseSubjectDatasource implements SubjectRepository {
  final FirebaseFirestore _firestore;
  final String _collectionName = 'subjects';

  FirebaseSubjectDatasource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<SubjectEntity>> getAllSubjects() async {
    try {
      final querySnapshot = await _firestore.collection(_collectionName).get();

      final subjects = querySnapshot.docs
          .map((doc) => SubjectEntity.fromJson(doc.data(), doc.id))
          .toList();

      subjects.sort((a, b) => a.code.compareTo(b.code));

      return subjects;
    } catch (e) {
      throw Exception('Không thể tải danh sách môn học: $e');
    }
  }

  @override
  Future<List<SubjectEntity>> getSubjectsByMajor(String major) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collectionName)
          .where('major', isEqualTo: major)
          .get();

      final subjects = querySnapshot.docs
          .map((doc) => SubjectEntity.fromJson(doc.data(), doc.id))
          .toList();

      subjects.sort((a, b) {
        final semesterCompare = a.semester.compareTo(b.semester);
        if (semesterCompare != 0) return semesterCompare;
        return a.code.compareTo(b.code);
      });

      return subjects;
    } catch (e) {
      throw Exception('Không thể tải danh sách môn học: $e');
    }
  }

  @override
  Future<SubjectEntity?> getSubjectById(String id) async {
    try {
      final docSnapshot =
          await _firestore.collection(_collectionName).doc(id).get();

      if (!docSnapshot.exists) {
        return null;
      }

      return SubjectEntity.fromJson(docSnapshot.data()!, docSnapshot.id);
    } catch (e) {
      throw Exception('Không thể tải thông tin môn học: $e');
    }
  }

  @override
  Future<List<SubjectEntity>> searchSubjects(String query) async {
    try {
      final querySnapshot = await _firestore.collection(_collectionName).get();

      final allSubjects = querySnapshot.docs
          .map((doc) => SubjectEntity.fromJson(doc.data(), doc.id))
          .toList();

      return allSubjects
          .where((subject) =>
              subject.name.toLowerCase().contains(query.toLowerCase()) ||
              subject.code.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } catch (e) {
      throw Exception('Không thể tìm kiếm môn học: $e');
    }
  }

  /// Thêm môn học mới
  Future<String> addSubject(Map<String, dynamic> subjectData) async {
    try {
      final docRef =
          await _firestore.collection(_collectionName).add(subjectData);
      return docRef.id;
    } catch (e) {
      throw Exception('Không thể thêm môn học: $e');
    }
  }

  /// Cập nhật môn học
  Future<void> updateSubject(
      String id, Map<String, dynamic> subjectData) async {
    try {
      await _firestore.collection(_collectionName).doc(id).update(subjectData);
    } catch (e) {
      throw Exception('Không thể cập nhật môn học: $e');
    }
  }

  /// Xóa môn học
  Future<void> deleteSubject(String id) async {
    try {
      await _firestore.collection(_collectionName).doc(id).delete();
    } catch (e) {
      throw Exception('Không thể xóa môn học: $e');
    }
  }
}

