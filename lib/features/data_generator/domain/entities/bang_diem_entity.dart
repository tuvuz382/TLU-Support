import 'package:equatable/equatable.dart';

class BangDiemEntity extends Equatable {
  final String maBD;
  final String maSV;
  final String maMon;
  final String hocky;
  final int namHoc;
  final double diem; // Điểm hệ 10
  final double diemHe4; // Điểm hệ 4
  final String diemChu; // Điểm chữ (A, B, C, D, F)

  const BangDiemEntity({
    required this.maBD,
    required this.maSV,
    required this.maMon,
    required this.hocky,
    required this.namHoc,
    required this.diem,
    required this.diemHe4,
    required this.diemChu,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'maBD': maBD,
      'maSV': maSV,
      'maMon': maMon,
      'hocky': hocky,
      'namHoc': namHoc,
      'diem': diem,
      'diemHe4': diemHe4,
      'diemChu': diemChu,
    };
  }

  factory BangDiemEntity.fromFirestore(Map<String, dynamic> data) {
    final diem = (data['diem'] ?? 0.0).toDouble();
    
    // Nếu diemHe4 hoặc diemChu không có trong database, tự động tính từ diem
    double diemHe4;
    String diemChu;
    
    if (data['diemHe4'] != null && data['diemChu'] != null) {
      // Nếu đã có trong database, dùng giá trị đó
      diemHe4 = (data['diemHe4']).toDouble();
      diemChu = data['diemChu'] as String;
    } else {
      // Nếu chưa có, tự động tính từ điểm hệ 10
      diemHe4 = _convertTo4PointScale(diem);
      diemChu = _convertToLetterGrade(diem);
    }
    
    return BangDiemEntity(
      maBD: data['maBD'] ?? '',
      maSV: data['maSV'] ?? '',
      maMon: data['maMon'] ?? '',
      hocky: data['hocky'] ?? '',
      namHoc: data['namHoc'] ?? 0,
      diem: diem,
      diemHe4: diemHe4,
      diemChu: diemChu,
    );
  }

  /// Chuyển đổi điểm hệ 10 sang điểm hệ 4
  static double _convertTo4PointScale(double diemHe10) {
    if (diemHe10 >= 8.5) return 4.0;
    if (diemHe10 >= 7.0) return 3.0;
    if (diemHe10 >= 5.5) return 2.0;
    if (diemHe10 >= 4.0) return 1.0;
    return 0.0;
  }

  /// Chuyển đổi điểm hệ 10 sang điểm chữ
  static String _convertToLetterGrade(double diemHe10) {
    if (diemHe10 >= 8.5) return 'A';
    if (diemHe10 >= 7.0) return 'B';
    if (diemHe10 >= 5.5) return 'C';
    if (diemHe10 >= 4.0) return 'D';
    return 'F';
  }

  @override
  List<Object?> get props => [
        maBD,
        maSV,
        maMon,
        hocky,
        namHoc,
        diem,
        diemHe4,
        diemChu,
      ];
}
