import 'package:equatable/equatable.dart';

class GhiChuEntity extends Equatable {
  final String maGhiChu;
  final String noiDung;
  final DateTime ngayTao;
  final String monHoc;

  const GhiChuEntity({
    required this.maGhiChu,
    required this.noiDung,
    required this.ngayTao,
    required this.monHoc,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'maGhiChu': maGhiChu,
      'noiDung': noiDung,
      'ngayTao': ngayTao.toIso8601String(),
      'monHoc': monHoc,
    };
  }

  factory GhiChuEntity.fromFirestore(Map<String, dynamic> data) {
    return GhiChuEntity(
      maGhiChu: data['maGhiChu'] ?? '',
      noiDung: data['noiDung'] ?? '',
      ngayTao: DateTime.parse(data['ngayTao'] ?? DateTime.now().toIso8601String()),
      monHoc: data['monHoc'] ?? '',
    );
  }

  @override
  List<Object?> get props => [
        maGhiChu,
        noiDung,
        ngayTao,
        monHoc,
      ];
}
