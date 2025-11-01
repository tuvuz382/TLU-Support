import 'package:equatable/equatable.dart';

class DanhGiaEntity extends Equatable {
  final String maDanhGia;
  final String maGV;
  final String maSV;
  final String noiDung;
  final int danhGia;  // Điểm đánh giá từ 1-5 sao
  final DateTime ngayDanhGia;

  const DanhGiaEntity({
    required this.maDanhGia,
    required this.maGV,
    required this.maSV,
    required this.noiDung,
    required this.danhGia,
    required this.ngayDanhGia,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'maDanhGia': maDanhGia,
      'maGV': maGV,
      'maSV': maSV,
      'noiDung': noiDung,
      'danhGia': danhGia,
      'ngayDanhGia': ngayDanhGia.toIso8601String(),
    };
  }

  factory DanhGiaEntity.fromFirestore(Map<String, dynamic> data) {
    return DanhGiaEntity(
      maDanhGia: data['maDanhGia'] ?? '',
      maGV: data['maGV'] ?? '',
      maSV: data['maSV'] ?? '',
      noiDung: data['noiDung'] ?? '',
      danhGia: data['danhGia'] ?? 5,
      ngayDanhGia: DateTime.parse(data['ngayDanhGia'] ?? DateTime.now().toIso8601String()),
    );
  }

  @override
  List<Object?> get props => [
        maDanhGia,
        maGV,
        maSV,
        noiDung,
        danhGia,
        ngayDanhGia,
      ];
}

