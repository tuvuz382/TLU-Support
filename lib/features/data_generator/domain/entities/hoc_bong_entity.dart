import 'package:equatable/equatable.dart';

class HocBongEntity extends Equatable {
  final String maHB;
  final String tenHB;
  final String moTa;
  final double giaTri;
  final DateTime thoiHanDangKy;
  final String trangThaiDangKy;

  const HocBongEntity({
    required this.maHB,
    required this.tenHB,
    required this.moTa,
    required this.giaTri,
    required this.thoiHanDangKy,
    required this.trangThaiDangKy,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'maHB': maHB,
      'tenHB': tenHB,
      'moTa': moTa,
      'giaTri': giaTri,
      'thoiHanDangKy': thoiHanDangKy.toIso8601String(),
      'trangThaiDangKy': trangThaiDangKy,
    };
  }

  factory HocBongEntity.fromFirestore(Map<String, dynamic> data) {
    return HocBongEntity(
      maHB: data['maHB'] ?? '',
      tenHB: data['tenHB'] ?? '',
      moTa: data['moTa'] ?? '',
      giaTri: (data['giaTri'] ?? 0.0).toDouble(),
      thoiHanDangKy: DateTime.parse(data['thoiHanDangKy'] ?? DateTime.now().toIso8601String()),
      trangThaiDangKy: data['trangThaiDangKy'] ?? '',
    );
  }

  @override
  List<Object?> get props => [
        maHB,
        tenHB,
        moTa,
        giaTri,
        thoiHanDangKy,
        trangThaiDangKy,
      ];
}
