import 'package:equatable/equatable.dart';

class TaiLieuEntity extends Equatable {
  final String maTL;
  final String tenTL;
  final String maMon;
  final String duongDan;
  final String moTa;
  final bool yeuThich;

  const TaiLieuEntity({
    required this.maTL,
    required this.tenTL,
    required this.maMon,
    required this.duongDan,
    required this.moTa,
    required this.yeuThich,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'maTL': maTL,
      'tenTL': tenTL,
      'maMon': maMon,
      'duongDan': duongDan,
      'moTa': moTa,
      'yeuThich': yeuThich,
    };
  }

  factory TaiLieuEntity.fromFirestore(Map<String, dynamic> data) {
    return TaiLieuEntity(
      maTL: data['maTL'] ?? '',
      tenTL: data['tenTL'] ?? '',
      maMon: data['maMon'] ?? '',
      duongDan: data['duongDan'] ?? '',
      moTa: data['moTa'] ?? '',
      yeuThich: data['yeuThich'] ?? false,
    );
  }

  @override
  List<Object?> get props => [
        maTL,
        tenTL,
        maMon,
        duongDan,
        moTa,
        yeuThich,
      ];
}




