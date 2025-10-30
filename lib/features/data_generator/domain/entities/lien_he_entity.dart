import 'package:equatable/equatable.dart';

class LienHeEntity extends Equatable {
  final String maLienHe;
  final String noiDung;
  final DateTime ngayGui;
  final String trangThaiPhanHoi;
  final String maSV;

  const LienHeEntity({
    required this.maLienHe,
    required this.noiDung,
    required this.ngayGui,
    required this.trangThaiPhanHoi,
    required this.maSV,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'maLienHe': maLienHe,
      'noiDung': noiDung,
      'ngayGui': ngayGui.toIso8601String(),
      'trangThaiPhanHoi': trangThaiPhanHoi,
      'maSV': maSV,
    };
  }

  factory LienHeEntity.fromFirestore(Map<String, dynamic> data) {
    return LienHeEntity(
      maLienHe: data['maLienHe'] ?? '',
      noiDung: data['noiDung'] ?? '',
      ngayGui: DateTime.parse(
        data['ngayGui'] ?? DateTime.now().toIso8601String(),
      ),
      trangThaiPhanHoi: data['trangThaiPhanHoi'] ?? '',
      maSV: data['maSV'] ?? '',
    );
  }

  @override
  List<Object?> get props => [maLienHe, noiDung, ngayGui, trangThaiPhanHoi, maSV];
}
