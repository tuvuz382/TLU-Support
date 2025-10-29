import 'package:equatable/equatable.dart';

class MonHocEntity extends Equatable {
  final String maMon;
  final String maGV; // Thêm mã giảng viên theo UML
  final String tenMon;
  final int soTinChi;
  final String moTa;

  const MonHocEntity({
    required this.maMon,
    required this.maGV,
    required this.tenMon,
    required this.soTinChi,
    required this.moTa,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'maMon': maMon,
      'maGV': maGV,
      'tenMon': tenMon,
      'soTinChi': soTinChi,
      'moTa': moTa,
    };
  }

  factory MonHocEntity.fromFirestore(Map<String, dynamic> data) {
    return MonHocEntity(
      maMon: data['maMon'] ?? '',
      maGV: data['maGV'] ?? '',
      tenMon: data['tenMon'] ?? '',
      soTinChi: data['soTinChi'] ?? 0,
      moTa: data['moTa'] ?? '',
    );
  }

  @override
  List<Object?> get props => [
        maMon,
        maGV,
        tenMon,
        soTinChi,
        moTa,
      ];
}

