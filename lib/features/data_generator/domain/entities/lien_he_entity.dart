import 'package:equatable/equatable.dart';

class LienHeEntity extends Equatable {
  final String maLienHe;
  final String noiDung;
  final DateTime ngayGui;
  final String trangThaiPhanHoi;

  const LienHeEntity({
    required this.maLienHe,
    required this.noiDung,
    required this.ngayGui,
    required this.trangThaiPhanHoi,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'maLienHe': maLienHe,
      'noiDung': noiDung,
      'ngayGui': ngayGui.toIso8601String(),
      'trangThaiPhanHoi': trangThaiPhanHoi,
    };
  }

  factory LienHeEntity.fromFirestore(Map<String, dynamic> data) {
    return LienHeEntity(
      maLienHe: data['maLienHe'] ?? '',
      noiDung: data['noiDung'] ?? '',
      ngayGui: DateTime.parse(data['ngayGui'] ?? DateTime.now().toIso8601String()),
      trangThaiPhanHoi: data['trangThaiPhanHoi'] ?? '',
    );
  }

  @override
  List<Object?> get props => [
        maLienHe,
        noiDung,
        ngayGui,
        trangThaiPhanHoi,
      ];
}
