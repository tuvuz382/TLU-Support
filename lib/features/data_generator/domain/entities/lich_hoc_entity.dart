import 'package:equatable/equatable.dart';

class LichHocEntity extends Equatable {
  final String maLich;
  final String maMon;
  final DateTime ngayHoc;
  final String tietHoc;
  final String phongHoc;
  final String lop; // Thêm lớp học theo UML

  const LichHocEntity({
    required this.maLich,
    required this.maMon,
    required this.ngayHoc,
    required this.tietHoc,
    required this.phongHoc,
    required this.lop,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'maLich': maLich,
      'maMon': maMon,
      'ngayHoc': ngayHoc.toIso8601String(),
      'tietHoc': tietHoc,
      'phongHoc': phongHoc,
      'lop': lop,
    };
  }

  factory LichHocEntity.fromFirestore(Map<String, dynamic> data) {
    return LichHocEntity(
      maLich: data['maLich'] ?? '',
      maMon: data['maMon'] ?? '',
      ngayHoc: DateTime.parse(data['ngayHoc'] ?? DateTime.now().toIso8601String()),
      tietHoc: data['tietHoc'] ?? '',
      phongHoc: data['phongHoc'] ?? '',
      lop: data['lop'] ?? '',
    );
  }

  @override
  List<Object?> get props => [
        maLich,
        maMon,
        ngayHoc,
        tietHoc,
        phongHoc,
        lop,
      ];
}




