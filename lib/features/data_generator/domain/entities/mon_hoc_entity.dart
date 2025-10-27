import 'package:equatable/equatable.dart';

class MonHocEntity extends Equatable {
  final String maMon;
  final String tenMon;
  final int soTinChi;
  final String moTa;
  final double danhGiaTB;

  const MonHocEntity({
    required this.maMon,
    required this.tenMon,
    required this.soTinChi,
    required this.moTa,
    required this.danhGiaTB,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'maMon': maMon,
      'tenMon': tenMon,
      'soTinChi': soTinChi,
      'moTa': moTa,
      'danhGiaTB': danhGiaTB,
    };
  }

  factory MonHocEntity.fromFirestore(Map<String, dynamic> data) {
    return MonHocEntity(
      maMon: data['maMon'] ?? '',
      tenMon: data['tenMon'] ?? '',
      soTinChi: data['soTinChi'] ?? 0,
      moTa: data['moTa'] ?? '',
      danhGiaTB: (data['danhGiaTB'] ?? 0.0).toDouble(),
    );
  }

  @override
  List<Object?> get props => [
        maMon,
        tenMon,
        soTinChi,
        moTa,
        danhGiaTB,
      ];
}

