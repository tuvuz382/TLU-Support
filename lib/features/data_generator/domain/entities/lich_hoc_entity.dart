import 'package:equatable/equatable.dart';

class LichHocEntity extends Equatable {
  final String maLich;
  final String maMon;
  final String ngayHoc;
  final String tietHoc;
  final String phongHoc;
  final String giangVienPhuTrach;

  const LichHocEntity({
    required this.maLich,
    required this.maMon,
    required this.ngayHoc,
    required this.tietHoc,
    required this.phongHoc,
    required this.giangVienPhuTrach,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'maLich': maLich,
      'maMon': maMon,
      'ngayHoc': ngayHoc,
      'tietHoc': tietHoc,
      'phongHoc': phongHoc,
      'giangVienPhuTrach': giangVienPhuTrach,
    };
  }

  factory LichHocEntity.fromFirestore(Map<String, dynamic> data) {
    return LichHocEntity(
      maLich: data['maLich'] ?? '',
      maMon: data['maMon'] ?? '',
      ngayHoc: data['ngayHoc'] ?? '',
      tietHoc: data['tietHoc'] ?? '',
      phongHoc: data['phongHoc'] ?? '',
      giangVienPhuTrach: data['giangVienPhuTrach'] ?? '',
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
      ];
}




