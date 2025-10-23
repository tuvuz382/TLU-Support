import 'package:equatable/equatable.dart';

class SinhVienEntity extends Equatable {
  final String maSV;
  final String hoTen;
  final String email;
  final String matKhau;
  final DateTime ngaySinh;
  final String lop;
  final String nganhHoc;
  final double diemGPA;
  final List<String> hocBongDangKy;
  final String? anhDaiDien;

  const SinhVienEntity({
    required this.maSV,
    required this.hoTen,
    required this.email,
    required this.matKhau,
    required this.ngaySinh,
    required this.lop,
    required this.nganhHoc,
    required this.diemGPA,
    required this.hocBongDangKy,
    this.anhDaiDien,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'maSV': maSV,
      'hoTen': hoTen,
      'email': email,
      'matKhau': matKhau,
      'ngaySinh': ngaySinh.toIso8601String(),
      'lop': lop,
      'nganhHoc': nganhHoc,
      'diemGPA': diemGPA,
      'hocBongDangKy': hocBongDangKy,
      'anhDaiDien': anhDaiDien,
    };
  }

  factory SinhVienEntity.fromFirestore(Map<String, dynamic> data) {
    return SinhVienEntity(
      maSV: data['maSV'] ?? '',
      hoTen: data['hoTen'] ?? '',
      email: data['email'] ?? '',
      matKhau: data['matKhau'] ?? '',
      ngaySinh: DateTime.parse(data['ngaySinh'] ?? DateTime.now().toIso8601String()),
      lop: data['lop'] ?? '',
      nganhHoc: data['nganhHoc'] ?? '',
      diemGPA: (data['diemGPA'] ?? 0.0).toDouble(),
      hocBongDangKy: List<String>.from(data['hocBongDangKy'] ?? []),
      anhDaiDien: data['anhDaiDien'],
    );
  }

  @override
  List<Object?> get props => [
        maSV,
        hoTen,
        email,
        matKhau,
        ngaySinh,
        lop,
        nganhHoc,
        diemGPA,
        hocBongDangKy,
        anhDaiDien,
      ];
}
