import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../data_generator/domain/entities/tai_lieu_entity.dart';

/// Firebase DataSource for Documents operations
class FirebaseDocumentsDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'taiLieu';

  CollectionReference get _collection => _firestore.collection(_collectionName);

  /// Get all documents from Firestore
  Future<List<TaiLieuEntity>> getAllDocuments() async {
    try {
      final snapshot = await _collection.get();
      return snapshot.docs
          .map(
            (doc) =>
                TaiLieuEntity.fromFirestore(doc.data() as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      throw Exception('Lỗi khi lấy danh sách tài liệu: $e');
    }
  }

  /// Get favorite documents
  Future<List<TaiLieuEntity>> getFavoriteDocuments() async {
    try {
      final snapshot = await _collection
          .where('yeuThich', isEqualTo: true)
          .get();
      return snapshot.docs
          .map(
            (doc) =>
                TaiLieuEntity.fromFirestore(doc.data() as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      throw Exception('Lỗi khi lấy danh sách tài liệu yêu thích: $e');
    }
  }

  /// Toggle favorite status
  Future<void> toggleFavorite(String documentId, bool isFavorite) async {
    try {
      // Tìm document theo maTL
      final snapshot = await _collection
          .where('maTL', isEqualTo: documentId)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final docId = snapshot.docs.first.id;
        await _collection.doc(docId).update({'yeuThich': isFavorite});
      }
    } catch (e) {
      throw Exception('Lỗi khi cập nhật trạng thái yêu thích: $e');
    }
  }

  /// Search documents by title
  Future<List<TaiLieuEntity>> searchDocuments(String query) async {
    try {
      final snapshot = await _collection.get();
      final allDocs = snapshot.docs
          .map(
            (doc) =>
                TaiLieuEntity.fromFirestore(doc.data() as Map<String, dynamic>),
          )
          .toList();

      // Filter by title (case insensitive)
      return allDocs
          .where((doc) => doc.tenTL.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } catch (e) {
      throw Exception('Lỗi khi tìm kiếm tài liệu: $e');
    }
  }

  /// Watch all documents (Stream for realtime updates)
  Stream<List<TaiLieuEntity>> watchAllDocuments() {
    try {
      return _collection.snapshots().map(
        (snapshot) => snapshot.docs
            .map(
              (doc) => TaiLieuEntity.fromFirestore(
                doc.data() as Map<String, dynamic>,
              ),
            )
            .toList(),
      );
    } catch (e) {
      throw Exception('Lỗi khi theo dõi tài liệu: $e');
    }
  }
}
