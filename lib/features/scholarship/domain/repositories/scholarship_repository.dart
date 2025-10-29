import '../entities/scholarship_entity.dart';

/// Repository interface cho quản lý học bổng
/// Tuân thủ Dependency Inversion Principle - Domain layer không phụ thuộc vào Data layer
abstract class ScholarshipRepository {
  /// Lấy tất cả học bổng có sẵn
  /// Returns danh sách học bổng, có thể lọc theo trạng thái
  Future<List<ScholarshipEntity>> getAllScholarships();

  /// Lấy học bổng theo mã học bổng
  /// Returns null nếu không tìm thấy
  Future<ScholarshipEntity?> getScholarshipById(String maHB);

  /// Stream để theo dõi thay đổi danh sách học bổng real-time
  Stream<List<ScholarshipEntity>> watchScholarships();

  /// Đăng ký học bổng cho sinh viên hiện tại
  /// Tự động lấy email từ current user
  /// Returns ID của đăng ký
  Future<String> registerScholarship(String maHB);

  /// Lấy tất cả đăng ký học bổng của sinh viên hiện tại
  Future<List<ScholarshipRegistrationEntity>>
      getRegisteredScholarships();

  /// Stream để theo dõi thay đổi đăng ký học bổng real-time
  Stream<List<ScholarshipRegistrationEntity>>
      watchRegisteredScholarships();

  /// Kiểm tra sinh viên đã đăng ký học bổng này chưa
  Future<bool> hasRegisteredScholarship(String maHB);

  /// Lấy thông tin đăng ký cụ thể
  Future<ScholarshipRegistrationEntity?> getRegistrationById(String id);

  /// Hủy đăng ký học bổng (nếu đang pending)
  Future<void> cancelRegistration(String registrationId);

  /// Lấy danh sách học bổng đang mở đăng ký
  Future<List<ScholarshipEntity>> getOpenScholarships();

  /// Lấy danh sách học bổng đã hết hạn
  Future<List<ScholarshipEntity>> getExpiredScholarships();
}

