import 'package:equatable/equatable.dart';

class DanhGiaEntity extends Equatable {
  final String maDanhGia;
  final String maMon;
  final String maSV;
  final String noiDung;
  final double diemDanhGia;
  final DateTime ngayDanhGia;

  const DanhGiaEntity({
    required this.maDanhGia,
    required this.maMon,
    required this.maSV,
    required this.noiDung,
    required this.diemDanhGia,
    required this.ngayDanhGia,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'maDanhGia': maDanhGia,
      'maMon': maMon,
      'maSV': maSV,
      'noiDung': noiDung,
      'diemDanhGia': diemDanhGia,
      'ngayDanhGia': ngayDanhGia.toIso8601String(),
    };
  }

  factory DanhGiaEntity.fromFirestore(Map<String, dynamic> data) {
    return DanhGiaEntity(
      maDanhGia: data['maDanhGia'] ?? '',
      maMon: data['maMon'] ?? '',
      maSV: data['maSV'] ?? '',
      noiDung: data['noiDung'] ?? '',
      diemDanhGia: (data['diemDanhGia'] ?? 0.0).toDouble(),
      ngayDanhGia: DateTime.parse(data['ngayDanhGia'] ?? DateTime.now().toIso8601String()),
    );
  }

  @override
  List<Object?> get props => [
        maDanhGia,
        maMon,
        maSV,
        noiDung,
        diemDanhGia,
        ngayDanhGia,
      ];
}
