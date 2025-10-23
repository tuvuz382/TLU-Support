import 'package:equatable/equatable.dart';

class ThongBaoEntity extends Equatable {
  final String maTB;
  final String tieuDe;
  final String noiDung;
  final DateTime ngayDang;

  const ThongBaoEntity({
    required this.maTB,
    required this.tieuDe,
    required this.noiDung,
    required this.ngayDang,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'maTB': maTB,
      'tieuDe': tieuDe,
      'noiDung': noiDung,
      'ngayDang': ngayDang.toIso8601String(),
    };
  }

  factory ThongBaoEntity.fromFirestore(Map<String, dynamic> data) {
    return ThongBaoEntity(
      maTB: data['maTB'] ?? '',
      tieuDe: data['tieuDe'] ?? '',
      noiDung: data['noiDung'] ?? '',
      ngayDang: DateTime.parse(data['ngayDang'] ?? DateTime.now().toIso8601String()),
    );
  }

  @override
  List<Object?> get props => [
        maTB,
        tieuDe,
        noiDung,
        ngayDang,
      ];
}
