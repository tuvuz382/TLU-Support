import 'package:equatable/equatable.dart';

class TaiLieuEntity extends Equatable {
  final String maTL;
  final String tenTL;
  final String monHoc;
  final String duongDan;
  final String moTa;
  final bool yeuThich;

  const TaiLieuEntity({
    required this.maTL,
    required this.tenTL,
    required this.monHoc,
    required this.duongDan,
    required this.moTa,
    required this.yeuThich,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'maTL': maTL,
      'tenTL': tenTL,
      'monHoc': monHoc,
      'duongDan': duongDan,
      'moTa': moTa,
      'yeuThich': yeuThich,
    };
  }

  factory TaiLieuEntity.fromFirestore(Map<String, dynamic> data) {
    return TaiLieuEntity(
      maTL: data['maTL'] ?? '',
      tenTL: data['tenTL'] ?? '',
      monHoc: data['monHoc'] ?? '',
      duongDan: data['duongDan'] ?? '',
      moTa: data['moTa'] ?? '',
      yeuThich: data['yeuThich'] ?? false,
    );
  }

  @override
  List<Object?> get props => [
        maTL,
        tenTL,
        monHoc,
        duongDan,
        moTa,
        yeuThich,
      ];
}




