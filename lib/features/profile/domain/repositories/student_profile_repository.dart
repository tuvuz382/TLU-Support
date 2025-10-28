import '../../../data_generator/domain/entities/sinh_vien_entity.dart';

/// Repository interface cho quản lý thông tin profile sinh viên
/// Tuân thủ Dependency Inversion Principle - Domain layer không phụ thuộc vào Data layer
abstract class StudentProfileRepository {
  /// Lấy thông tin sinh viên hiện tại
  /// Returns null nếu chưa có profile hoặc chưa đăng nhập
  Future<SinhVienEntity?> getCurrentStudentProfile();

  /// Cập nhật thông tin sinh viên
  /// Tự động tạo mới nếu chưa tồn tại
  Future<void> updateStudentProfile(SinhVienEntity student);

  /// Tạo profile sinh viên mới với thông tin cơ bản
  /// Sử dụng khi user đăng ký lần đầu
  Future<void> createBasicStudentProfile({
    required String email,
    required String hoTen,
    String? maSV,
    String? lop,
    String? nganhHoc,
  });

  /// Cập nhật ảnh đại diện
  /// Chỉ update field anhDaiDien
  Future<void> updateProfileImage(String imageUrl);

  /// Kiểm tra xem sinh viên đã có profile chưa
  /// Returns false nếu chưa đăng nhập hoặc có lỗi
  Future<bool> hasStudentProfile();

  /// Stream để theo dõi thay đổi profile real-time
  /// Returns Stream<null> nếu chưa đăng nhập
  Stream<SinhVienEntity?> watchStudentProfile();

  /// Xóa profile sinh viên (cho trường hợp cần thiết)
  Future<void> deleteStudentProfile();

  /// Lấy tất cả sinh viên mẫu từ hệ thống (từ DataGeneratorService)
  /// Dùng để user có thể chọn profile có sẵn
  Future<List<SinhVienEntity>> getAllSampleStudents();

  /// Lấy sinh viên theo mã sinh viên
  Future<SinhVienEntity?> getStudentById(String maSV);

  /// Chọn profile sinh viên từ danh sách có sẵn
  /// Link email hiện tại với profile sinh viên đã chọn
  Future<void> selectExistingProfile(String maSV);

  /// Kiểm tra xem có sinh viên nào trong hệ thống không
  Future<bool> hasSampleData();
}
