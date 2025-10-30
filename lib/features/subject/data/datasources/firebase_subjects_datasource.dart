import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../data_generator/domain/entities/mon_hoc_entity.dart';

class FirebaseSubjectsDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'monHoc';

  CollectionReference get _collection => _firestore.collection(_collectionName);

  Future<List<MonHocEntity>> getAllSubjects() async {
    try {
      final snapshot = await _collection.get();
      return snapshot.docs
          .map((doc) => MonHocEntity.fromFirestore(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Lỗi khi lấy danh sách môn học: $e');
    }
  }

  Future<List<MonHocEntity>> getSubjectsByMajor(String major) async {
    try {
      final snapshot = await _collection.where('chuyenNganh', isEqualTo: major).get();
      return snapshot.docs
          .map((doc) => MonHocEntity.fromFirestore(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Lỗi khi lọc môn học theo chuyên ngành: $e');
    }
  }
}


