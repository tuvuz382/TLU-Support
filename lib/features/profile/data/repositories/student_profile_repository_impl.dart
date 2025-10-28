import '../../domain/repositories/student_profile_repository.dart';
import '../../../data_generator/domain/entities/sinh_vien_entity.dart';
import '../datasources/student_profile_remote_datasource.dart';

/// Implementation của StudentProfileRepository
/// Kết nối Domain layer với Data layer thông qua DataSource
class StudentProfileRepositoryImpl implements StudentProfileRepository {
  final StudentProfileRemoteDataSource _remoteDataSource;

  StudentProfileRepositoryImpl({
    required StudentProfileRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<SinhVienEntity?> getCurrentStudentProfile() async {
    try {
      final data = await _remoteDataSource.getCurrentStudentData();
      if (data == null) return null;

      return SinhVienEntity.fromFirestore(data);
    } catch (e) {
      throw Exception('Lỗi khi lấy thông tin sinh viên: $e');
    }
  }

  @override
  Future<void> updateStudentProfile(SinhVienEntity student) async {
    try {
      final email = _remoteDataSource.getCurrentUserEmail();
      if (email == null) {
        throw Exception('Người dùng chưa đăng nhập');
      }

      final exists = await _remoteDataSource.studentExists(email);
      
      if (exists) {
        // Cập nhật nếu đã tồn tại
        await _remoteDataSource.updateStudentByEmail(
          email,
          student.toFirestore(),
        );
      } else {
        // Tạo mới nếu chưa tồn tại
        await _remoteDataSource.createStudent(student.toFirestore());
      }
    } catch (e) {
      throw Exception('Lỗi khi cập nhật thông tin sinh viên: $e');
    }
  }

  @override
  Future<void> createBasicStudentProfile({
    required String email,
    required String hoTen,
    String? maSV,
    String? lop,
    String? nganhHoc,
  }) async {
    try {
      final basicStudent = SinhVienEntity(
        maSV: maSV ?? _remoteDataSource.generateStudentId(),
        hoTen: hoTen,
        email: email,
        matKhau: '', // Firebase Auth quản lý password
        ngaySinh: DateTime.now().subtract(const Duration(days: 365 * 20)),
        lop: lop ?? '',
        nganhHoc: nganhHoc ?? '',
        diemGPA: 0.0,
        hocBongDangKy: [],
        anhDaiDien: null,
      );

      await _remoteDataSource.createStudent(basicStudent.toFirestore());
    } catch (e) {
      throw Exception('Lỗi khi tạo profile sinh viên: $e');
    }
  }

  @override
  Future<void> updateProfileImage(String imageUrl) async {
    try {
      final email = _remoteDataSource.getCurrentUserEmail();
      if (email == null) {
        throw Exception('Người dùng chưa đăng nhập');
      }

      await _remoteDataSource.updateStudentField(
        email,
        'anhDaiDien',
        imageUrl,
      );
    } catch (e) {
      throw Exception('Lỗi khi cập nhật ảnh đại diện: $e');
    }
  }

  @override
  Future<bool> hasStudentProfile() async {
    try {
      final email = _remoteDataSource.getCurrentUserEmail();
      if (email == null) return false;

      return await _remoteDataSource.studentExists(email);
    } catch (e) {
      return false; // Graceful failure
    }
  }

  @override
  Stream<SinhVienEntity?> watchStudentProfile() {
    final email = _remoteDataSource.getCurrentUserEmail();
    if (email == null) {
      return Stream.value(null);
    }

    return _remoteDataSource.watchStudentByEmail(email).map((data) {
      if (data == null) return null;
      return SinhVienEntity.fromFirestore(data);
    });
  }

  @override
  Future<void> deleteStudentProfile() async {
    try {
      final email = _remoteDataSource.getCurrentUserEmail();
      if (email == null) {
        throw Exception('Người dùng chưa đăng nhập');
      }

      await _remoteDataSource.deleteStudentByEmail(email);
    } catch (e) {
      throw Exception('Lỗi khi xóa profile sinh viên: $e');
    }
  }

  @override
  Future<List<SinhVienEntity>> getAllSampleStudents() async {
    try {
      final studentsData = await _remoteDataSource.getAllStudents();
      return studentsData
          .map((data) => SinhVienEntity.fromFirestore(data))
          .toList();
    } catch (e) {
      throw Exception('Lỗi khi lấy danh sách sinh viên: $e');
    }
  }

  @override
  Future<SinhVienEntity?> getStudentById(String maSV) async {
    try {
      final data = await _remoteDataSource.getStudentByMaSV(maSV);
      if (data == null) return null;

      return SinhVienEntity.fromFirestore(data);
    } catch (e) {
      throw Exception('Lỗi khi lấy thông tin sinh viên: $e');
    }
  }

  @override
  Future<void> selectExistingProfile(String maSV) async {
    try {
      final studentData = await _remoteDataSource.getStudentByMaSV(maSV);
      if (studentData == null) {
        throw Exception('Không tìm thấy sinh viên với mã: $maSV');
      }

      await _remoteDataSource.linkExistingStudentToCurrentUser(studentData);
    } catch (e) {
      throw Exception('Lỗi khi chọn profile sinh viên: $e');
    }
  }

  @override
  Future<bool> hasSampleData() async {
    try {
      return await _remoteDataSource.hasAnyStudentData();
    } catch (e) {
      return false; // Graceful failure
    }
  }
}
