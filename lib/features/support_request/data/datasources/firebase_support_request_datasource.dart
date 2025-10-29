import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../data_generator/domain/entities/lien_he_entity.dart';

/// Firebase DataSource for Support Request operations
class FirebaseSupportRequestDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'lienHe';

  CollectionReference get _collection => _firestore.collection(_collectionName);

  /// Submit a new support request
  Future<void> submitRequest(LienHeEntity request) async {
    try {
      await _collection.add(request.toFirestore());
    } catch (e) {
      throw Exception('Lỗi khi gửi yêu cầu hỗ trợ: $e');
    }
  }

  /// Get all pending requests (trangThaiPhanHoi == "Chưa phản hồi" or "Đang xử lý")
  Future<List<LienHeEntity>> getPendingRequests() async {
    try {
      // Fetch all và filter ở client để tránh cần composite index
      final snapshot = await _collection.get();

      return snapshot.docs
          .map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return LienHeEntity.fromFirestore(data);
          })
          .where(
            (entity) =>
                entity.trangThaiPhanHoi == 'Chưa phản hồi' ||
                entity.trangThaiPhanHoi == 'Đang xử lý',
          )
          .toList()
        ..sort((a, b) => b.ngayGui.compareTo(a.ngayGui));
    } catch (e) {
      throw Exception('Lỗi khi lấy danh sách yêu cầu chờ xác nhận: $e');
    }
  }

  /// Get all processed requests (trangThaiPhanHoi == "Đã phản hồi")
  Future<List<LienHeEntity>> getProcessedRequests() async {
    try {
      final snapshot = await _collection.get();

      return snapshot.docs
          .map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return LienHeEntity.fromFirestore(data);
          })
          .where((entity) => entity.trangThaiPhanHoi == 'Đã phản hồi')
          .toList()
        ..sort((a, b) => b.ngayGui.compareTo(a.ngayGui));
    } catch (e) {
      throw Exception('Lỗi khi lấy danh sách yêu cầu đã xử lý: $e');
    }
  }

  /// Get request detail by maLienHe
  Future<LienHeEntity?> getRequestDetail(String maLienHe) async {
    try {
      final snapshot = await _collection
          .where('maLienHe', isEqualTo: maLienHe)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return null;

      final data = snapshot.docs.first.data() as Map<String, dynamic>;
      return LienHeEntity.fromFirestore(data);
    } catch (e) {
      throw Exception('Lỗi khi lấy chi tiết yêu cầu: $e');
    }
  }

  /// Watch all requests (Stream for realtime updates)
  Stream<List<LienHeEntity>> watchAllRequests() {
    try {
      return _collection
          .orderBy('ngayGui', descending: true)
          .snapshots()
          .map(
            (snapshot) => snapshot.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return LienHeEntity.fromFirestore(data);
            }).toList(),
          );
    } catch (e) {
      throw Exception('Lỗi khi theo dõi yêu cầu: $e');
    }
  }
}
