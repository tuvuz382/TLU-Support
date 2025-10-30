import 'package:equatable/equatable.dart';

class GhiChuEntity extends Equatable {
  final String maGhiChu;
  final String noiDung;
  final DateTime ngayTao;
  final String tieuDe;

  const GhiChuEntity({
    required this.maGhiChu,
    required this.noiDung,
    required this.ngayTao,
    required this.tieuDe,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'maGhiChu': maGhiChu,
      'noiDung': noiDung,
      'ngayTao': ngayTao.toIso8601String(),
      'tieuDe': tieuDe,
    };
  }

  factory GhiChuEntity.fromFirestore(Map<String, dynamic> data) {
    return GhiChuEntity(
      maGhiChu: data['maGhiChu'] ?? '',
      noiDung: data['noiDung'] ?? '',
      ngayTao: DateTime.parse(data['ngayTao'] ?? DateTime.now().toIso8601String()),
      tieuDe: data['tieuDe'] ?? '',
    );
  }

  @override
  List<Object?> get props => [
        maGhiChu,
        noiDung,
        ngayTao,
        tieuDe,
      ];
}

