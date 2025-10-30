import 'package:equatable/equatable.dart';

/// Entity đại diện cho học bổng trong hệ thống
class ScholarshipEntity extends Equatable {
  final String maHB; // Mã học bổng
  final String tenHB; // Tên học bổng
  final String moTa; // Mô tả chi tiết
  final double giaTri; // Giá trị học bổng
  final DateTime thoiHanDangKyBatDau; // Thời gian bắt đầu đăng ký
  final DateTime thoiHanDangKyKetThuc; // Thời gian kết thúc đăng ký
  final String? tepDinhKem; // File đính kèm (URL hoặc path)
  final DateTime? ngayTao; // Ngày tạo học bổng

  const ScholarshipEntity({
    required this.maHB,
    required this.tenHB,
    required this.moTa,
    required this.giaTri,
    required this.thoiHanDangKyBatDau,
    required this.thoiHanDangKyKetThuc,
    this.tepDinhKem,
    this.ngayTao,
  });

  /// Chuyển đổi entity sang Firestore format
  Map<String, dynamic> toFirestore() {
    return {
      'maHB': maHB,
      'tenHB': tenHB,
      'moTa': moTa,
      'giaTri': giaTri,
      'thoiHanDangKyBatDau': thoiHanDangKyBatDau.toIso8601String(),
      'thoiHanDangKyKetThuc': thoiHanDangKyKetThuc.toIso8601String(),
      'tepDinhKem': tepDinhKem,
      'ngayTao': ngayTao?.toIso8601String(),
    };
  }

  /// Tạo entity từ Firestore data
  /// Hỗ trợ cả format cũ (thoiHanDangKy) và format mới (thoiHanDangKyBatDau, thoiHanDangKyKetThuc)
  factory ScholarshipEntity.fromFirestore(Map<String, dynamic> data) {
    DateTime thoiHanDangKyBatDau;
    DateTime thoiHanDangKyKetThuc;

    // Nếu có format mới (thoiHanDangKyBatDau và thoiHanDangKyKetThuc)
    if (data['thoiHanDangKyBatDau'] != null &&
        data['thoiHanDangKyKetThuc'] != null) {
      thoiHanDangKyBatDau = DateTime.parse(data['thoiHanDangKyBatDau']);
      thoiHanDangKyKetThuc = DateTime.parse(data['thoiHanDangKyKetThuc']);
    }
    // Nếu có format cũ (thoiHanDangKy) - tạo khoảng thời gian hợp lý
    else if (data['thoiHanDangKy'] != null) {
      final thoiHanDangKyCu = DateTime.parse(data['thoiHanDangKy']);
      final now = DateTime.now();
      
      // Nếu thời hạn cũ đã qua, tạo khoảng đăng ký mới từ hôm nay
      if (thoiHanDangKyCu.isBefore(now)) {
        thoiHanDangKyBatDau = now;
        thoiHanDangKyKetThuc = now.add(const Duration(days: 60)); // Mở đăng ký trong 60 ngày
      } else {
        // Nếu thời hạn cũ chưa đến, tạo khoảng 30 ngày trước đó
        final baseStart = thoiHanDangKyCu.subtract(const Duration(days: 30));
        thoiHanDangKyBatDau = baseStart.isBefore(now) ? now : baseStart;
        thoiHanDangKyKetThuc = thoiHanDangKyCu;
      }
    }
    // Fallback nếu không có dữ liệu nào
    else {
      final now = DateTime.now();
      thoiHanDangKyBatDau = now;
      thoiHanDangKyKetThuc = now.add(const Duration(days: 30));
    }

    return ScholarshipEntity(
      maHB: data['maHB'] ?? '',
      tenHB: data['tenHB'] ?? '',
      moTa: data['moTa'] ?? '',
      giaTri: (data['giaTri'] ?? 0.0).toDouble(),
      thoiHanDangKyBatDau: thoiHanDangKyBatDau,
      thoiHanDangKyKetThuc: thoiHanDangKyKetThuc,
      tepDinhKem: data['tepDinhKem'],
      ngayTao: data['ngayTao'] != null
          ? DateTime.parse(data['ngayTao'])
          : null,
    );
  }

  /// Kiểm tra học bổng có đang mở đăng ký không
  bool get isOpenForRegistration {
    final now = DateTime.now();
    final startsOk = now.isAfter(thoiHanDangKyBatDau) ||
        now.isAtSameMomentAs(thoiHanDangKyBatDau);
    final endsOk = now.isBefore(thoiHanDangKyKetThuc) ||
        now.isAtSameMomentAs(thoiHanDangKyKetThuc);
    return startsOk && endsOk;
  }

  /// Kiểm tra học bổng đã hết hạn đăng ký chưa
  bool get isExpired {
    return DateTime.now().isAfter(thoiHanDangKyKetThuc);
  }

  @override
  List<Object?> get props => [
        maHB,
        tenHB,
        moTa,
        giaTri,
        thoiHanDangKyBatDau,
        thoiHanDangKyKetThuc,
        tepDinhKem,
        ngayTao,
      ];
}

/// Entity đại diện cho đăng ký học bổng của sinh viên
class ScholarshipRegistrationEntity extends Equatable {
  final String id; // Document ID trong Firestore
  final String maHB; // Mã học bổng
  final String email; // Email sinh viên đăng ký
  final DateTime thoiGianDangKy; // Thời gian đăng ký
  final String trangThai; // Trạng thái: 'pending', 'approved', 'rejected'
  final String? ghiChu; // Ghi chú từ admin

  const ScholarshipRegistrationEntity({
    required this.id,
    required this.maHB,
    required this.email,
    required this.thoiGianDangKy,
    required this.trangThai,
    this.ghiChu,
  });

  /// Chuyển đổi entity sang Firestore format
  Map<String, dynamic> toFirestore() {
    return {
      'maHB': maHB,
      'email': email,
      'thoiGianDangKy': thoiGianDangKy.toIso8601String(),
      'trangThai': trangThai,
      'ghiChu': ghiChu,
    };
  }

  /// Tạo entity từ Firestore data
  factory ScholarshipRegistrationEntity.fromFirestore(
    String id,
    Map<String, dynamic> data,
  ) {
    return ScholarshipRegistrationEntity(
      id: id,
      maHB: data['maHB'] ?? '',
      email: data['email'] ?? '',
      thoiGianDangKy: DateTime.parse(
        data['thoiGianDangKy'] ?? DateTime.now().toIso8601String(),
      ),
      trangThai: data['trangThai'] ?? 'pending',
      ghiChu: data['ghiChu'],
    );
  }

  @override
  List<Object?> get props => [
        id,
        maHB,
        email,
        thoiGianDangKy,
        trangThai,
        ghiChu,
      ];
}

