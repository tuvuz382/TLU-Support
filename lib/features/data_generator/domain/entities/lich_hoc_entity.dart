import 'package:equatable/equatable.dart';

class LichHocEntity extends Equatable {
  final String maLich;
  final String maMon;
  final DateTime ngayHoc;
  final String tietHoc;
  final String phongHoc;
  final String giangVienPhuTrach;
  final String lop; // Thêm lớp học theo UML
  final String nganhHoc; // Thêm ngành học theo UML

  const LichHocEntity({
    required this.maLich,
    required this.maMon,
    required this.ngayHoc,
    required this.tietHoc,
    required this.phongHoc,
    required this.giangVienPhuTrach,
    required this.lop,
    required this.nganhHoc,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'maLich': maLich,
      'maMon': maMon,
      'ngayHoc': ngayHoc.toIso8601String(),
      'tietHoc': tietHoc,
      'phongHoc': phongHoc,
      'giangVienPhuTrach': giangVienPhuTrach,
      'lop': lop,
      'nganhHoc': nganhHoc,
    };
  }

  factory LichHocEntity.fromFirestore(Map<String, dynamic> data) {
    return LichHocEntity(
      maLich: data['maLich'] ?? '',
      maMon: data['maMon'] ?? '',
      ngayHoc: DateTime.parse(data['ngayHoc'] ?? DateTime.now().toIso8601String()),
      tietHoc: data['tietHoc'] ?? '',
      phongHoc: data['phongHoc'] ?? '',
      giangVienPhuTrach: data['giangVienPhuTrach'] ?? '',
      lop: data['lop'] ?? '',
      nganhHoc: data['nganhHoc'] ?? '',
    );
  }

  @override
  List<Object?> get props => [
        maLich,
        maMon,
        ngayHoc,
        tietHoc,
        phongHoc,
        giangVienPhuTrach,
        lop,
        nganhHoc,
      ];
}




