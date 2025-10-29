import 'package:equatable/equatable.dart';

class BangDiemEntity extends Equatable {
  final String maBD;
  final String maSV;
  final String maMon;
  final String hocky;
  final int namHoc;
  final double diem;

  const BangDiemEntity({
    required this.maBD,
    required this.maSV,
    required this.maMon,
    required this.hocky,
    required this.namHoc,
    required this.diem,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'maBD': maBD,
      'maSV': maSV,
      'maMon': maMon,
      'hocky': hocky,
      'namHoc': namHoc,
      'diem': diem,
    };
  }

  factory BangDiemEntity.fromFirestore(Map<String, dynamic> data) {
    return BangDiemEntity(
      maBD: data['maBD'] ?? '',
      maSV: data['maSV'] ?? '',
      maMon: data['maMon'] ?? '',
      hocky: data['hocky'] ?? '',
      namHoc: data['namHoc'] ?? 0,
      diem: (data['diem'] ?? 0.0).toDouble(),
    );
  }

  @override
  List<Object?> get props => [
        maBD,
        maSV,
        maMon,
        hocky,
        namHoc,
        diem,
      ];
}
