import 'package:equatable/equatable.dart';

class GiangVienEntity extends Equatable {
  final String maGV;
  final String hoTen;
  final String email;
  final String chuyenNganh;
  final String hocVi;
  final String soDT;

  const GiangVienEntity({
    required this.maGV,
    required this.hoTen,
    required this.email,
    required this.chuyenNganh,
    required this.hocVi,
    required this.soDT,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'maGV': maGV,
      'hoTen': hoTen,
      'email': email,
      'chuyenNganh': chuyenNganh,
      'hocVi': hocVi,
      'soDT': soDT,
    };
  }

  factory GiangVienEntity.fromFirestore(Map<String, dynamic> data) {
    return GiangVienEntity(
      maGV: data['maGV'] ?? '',
      hoTen: data['hoTen'] ?? '',
      email: data['email'] ?? '',
      chuyenNganh: data['chuyenNganh'] ?? '',
      hocVi: data['hocVi'] ?? '',
      soDT: data['soDT'] ?? '',
    );
  }

  @override
  List<Object?> get props => [
        maGV,
        hoTen,
        email,
        chuyenNganh,
        hocVi,
        soDT,
      ];
}
