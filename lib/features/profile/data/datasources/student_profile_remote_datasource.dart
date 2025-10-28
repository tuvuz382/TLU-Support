import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Remote DataSource cho Student Profile sử dụng Firebase Firestore
/// Chịu trách nhiệm trực tiếp giao tiếp với Firebase
class StudentProfileRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final String _collectionName = 'sinhVien';

  StudentProfileRemoteDataSource({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  CollectionReference get _collection => _firestore.collection(_collectionName);

  /// Lấy thông tin sinh viên theo email của user hiện tại
  Future<Map<String, dynamic>?> getCurrentStudentData() async {
    final user = _auth.currentUser;
    if (user?.email == null) return null;

    final snapshot = await _collection
        .where('email', isEqualTo: user!.email)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;

    return snapshot.docs.first.data() as Map<String, dynamic>;
  }

  /// Tạo mới document sinh viên
  Future<String> createStudent(Map<String, dynamic> studentData) async {
    final docRef = await _collection.add(studentData);
    return docRef.id;
  }

  /// Cập nhật thông tin sinh viên theo email
  Future<void> updateStudentByEmail(
    String email,
    Map<String, dynamic> studentData,
  ) async {
    final snapshot = await _collection
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final docId = snapshot.docs.first.id;
      await _collection.doc(docId).update(studentData);
    } else {
      throw Exception('Không tìm thấy sinh viên với email: $email');
    }
  }

  /// Cập nhật một field cụ thể theo email
  Future<void> updateStudentField(
    String email,
    String fieldName,
    dynamic value,
  ) async {
    final snapshot = await _collection
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final docId = snapshot.docs.first.id;
      await _collection.doc(docId).update({fieldName: value});
    } else {
      throw Exception('Không tìm thấy sinh viên với email: $email');
    }
  }

  /// Kiểm tra sự tồn tại của sinh viên theo email
  Future<bool> studentExists(String email) async {
    final snapshot = await _collection
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    return snapshot.docs.isNotEmpty;
  }

  /// Xóa sinh viên theo email
  Future<void> deleteStudentByEmail(String email) async {
    final snapshot = await _collection
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final docId = snapshot.docs.first.id;
      await _collection.doc(docId).delete();
    }
  }

  /// Stream để theo dõi thay đổi sinh viên theo email
  Stream<Map<String, dynamic>?> watchStudentByEmail(String email) {
    return _collection
        .where('email', isEqualTo: email)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) return null;
      return snapshot.docs.first.data() as Map<String, dynamic>;
    });
  }

  /// Lấy email của user hiện tại
  String? getCurrentUserEmail() {
    return _auth.currentUser?.email;
  }

  /// Sinh mã sinh viên tự động
  String generateStudentId() {
    final now = DateTime.now();
    final year = now.year.toString().substring(2);
    final random = now.millisecondsSinceEpoch.toString().substring(8);
    return 'SV$year$random';
  }

  /// Lấy tất cả sinh viên từ Firestore (dữ liệu từ DataGeneratorService)
  Future<List<Map<String, dynamic>>> getAllStudents() async {
    final snapshot = await _collection.get();
    return snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  /// Lấy sinh viên theo mã sinh viên
  Future<Map<String, dynamic>?> getStudentByMaSV(String maSV) async {
    final snapshot = await _collection
        .where('maSV', isEqualTo: maSV)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;
    return snapshot.docs.first.data() as Map<String, dynamic>;
  }

  /// Tạo profile mới từ sinh viên có sẵn, link với email hiện tại
  Future<void> linkExistingStudentToCurrentUser(Map<String, dynamic> studentData) async {
    final currentEmail = getCurrentUserEmail();
    if (currentEmail == null) {
      throw Exception('Người dùng chưa đăng nhập');
    }

    // Tạo bản sao của dữ liệu sinh viên và thay email
    final newStudentData = Map<String, dynamic>.from(studentData);
    newStudentData['email'] = currentEmail;

    // Xóa profile cũ nếu có
    await deleteStudentByEmail(currentEmail);
    
    // Tạo profile mới
    await createStudent(newStudentData);
  }

  /// Kiểm tra có dữ liệu sinh viên nào trong hệ thống không
  Future<bool> hasAnyStudentData() async {
    final snapshot = await _collection.limit(1).get();
    return snapshot.docs.isNotEmpty;
  }
}
