import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Remote DataSource cho Scholarship sử dụng Firebase Firestore
/// Chịu trách nhiệm trực tiếp giao tiếp với Firebase
class ScholarshipRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final String _scholarshipCollectionName = 'hocBong';
  final String _registrationCollectionName = 'dangKyHocBong';

  ScholarshipRemoteDataSource({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  CollectionReference get _scholarshipCollection =>
      _firestore.collection(_scholarshipCollectionName);

  CollectionReference get _registrationCollection =>
      _firestore.collection(_registrationCollectionName);

  /// Lấy tất cả học bổng từ Firestore
  Future<List<Map<String, dynamic>>> getAllScholarships() async {
    final snapshot = await _scholarshipCollection.get();
    return snapshot.docs
        .map((doc) => {
              ...doc.data() as Map<String, dynamic>,
              'id': doc.id,
            })
        .toList();
  }

  /// Lấy học bổng theo mã học bổng
  Future<Map<String, dynamic>?> getScholarshipByMaHB(String maHB) async {
    final snapshot = await _scholarshipCollection
        .where('maHB', isEqualTo: maHB)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;

    return {
      ...snapshot.docs.first.data() as Map<String, dynamic>,
      'id': snapshot.docs.first.id,
    };
  }

  /// Stream để theo dõi thay đổi danh sách học bổng real-time
  Stream<List<Map<String, dynamic>>> watchScholarships() {
    return _scholarshipCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => {
                ...doc.data() as Map<String, dynamic>,
                'id': doc.id,
              })
          .toList();
    });
  }

  /// Lấy email của user hiện tại
  String? getCurrentUserEmail() {
    return _auth.currentUser?.email;
  }

  /// Tạo đăng ký học bổng mới
  Future<String> createRegistration(Map<String, dynamic> registrationData) async {
    final docRef = await _registrationCollection.add(registrationData);
    return docRef.id;
  }

  /// Lấy tất cả đăng ký học bổng của sinh viên hiện tại
  Future<List<Map<String, dynamic>>> getRegistrationsByEmail(
      String email) async {
    final snapshot = await _registrationCollection
        .where('email', isEqualTo: email)
        .get();

    return snapshot.docs
        .map((doc) => {
              ...doc.data() as Map<String, dynamic>,
              'id': doc.id,
            })
        .toList();
  }

  /// Stream để theo dõi đăng ký học bổng của sinh viên hiện tại
  Stream<List<Map<String, dynamic>>> watchRegistrationsByEmail(String email) {
    return _registrationCollection
        .where('email', isEqualTo: email)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => {
                ...doc.data() as Map<String, dynamic>,
                'id': doc.id,
              })
          .toList();
    });
  }

  /// Kiểm tra sinh viên đã đăng ký học bổng này chưa
  Future<bool> hasRegisteredScholarship(String email, String maHB) async {
    final snapshot = await _registrationCollection
        .where('email', isEqualTo: email)
        .where('maHB', isEqualTo: maHB)
        .limit(1)
        .get();

    return snapshot.docs.isNotEmpty;
  }

  /// Lấy thông tin đăng ký theo ID
  Future<Map<String, dynamic>?> getRegistrationById(String id) async {
    final doc = await _registrationCollection.doc(id).get();
    if (!doc.exists) return null;

    return {
      ...doc.data() as Map<String, dynamic>,
      'id': doc.id,
    };
  }

  /// Xóa đăng ký học bổng
  Future<void> deleteRegistration(String id) async {
    await _registrationCollection.doc(id).delete();
  }

  /// Lấy danh sách học bổng đang mở đăng ký
  /// Note: Firestore lưu dates as ISO strings, nên filter trong memory
  Future<List<Map<String, dynamic>>> getOpenScholarships() async {
    final snapshot = await _scholarshipCollection.get();
    final now = DateTime.now();

    return snapshot.docs
        .map((doc) => {
              ...doc.data() as Map<String, dynamic>,
              'id': doc.id,
            })
        .where((item) {
          try {
            final batDau = DateTime.parse(item['thoiHanDangKyBatDau'] ?? '');
            final ketThuc = DateTime.parse(item['thoiHanDangKyKetThuc'] ?? '');
            return now.isAfter(batDau) && now.isBefore(ketThuc);
          } catch (e) {
            return false;
          }
        })
        .toList();
  }

  /// Lấy danh sách học bổng đã hết hạn
  /// Note: Firestore lưu dates as ISO strings, nên filter trong memory
  Future<List<Map<String, dynamic>>> getExpiredScholarships() async {
    final snapshot = await _scholarshipCollection.get();
    final now = DateTime.now();

    return snapshot.docs
        .map((doc) => {
              ...doc.data() as Map<String, dynamic>,
              'id': doc.id,
            })
        .where((item) {
          try {
            final ketThuc = DateTime.parse(item['thoiHanDangKyKetThuc'] ?? '');
            return now.isAfter(ketThuc);
          } catch (e) {
            return false;
          }
        })
        .toList();
  }
}

