/// Entity chứa kết quả tính GPA
class GPAResultEntity {
  final double gpaHe10; // GPA theo thang điểm 10
  final double gpaHe4; // GPA theo thang điểm 4
  final int tongTinChi; // Tổng số tín chỉ
  final int soMonHoc; // Số môn học

  const GPAResultEntity({
    required this.gpaHe10,
    required this.gpaHe4,
    required this.tongTinChi,
    required this.soMonHoc,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GPAResultEntity &&
        other.gpaHe10 == gpaHe10 &&
        other.gpaHe4 == gpaHe4 &&
        other.tongTinChi == tongTinChi &&
        other.soMonHoc == soMonHoc;
  }

  @override
  int get hashCode {
    return gpaHe10.hashCode ^
        gpaHe4.hashCode ^
        tongTinChi.hashCode ^
        soMonHoc.hashCode;
  }

  @override
  String toString() {
    return 'GPAResultEntity(gpaHe10: $gpaHe10, gpaHe4: $gpaHe4, tongTinChi: $tongTinChi, soMonHoc: $soMonHoc)';
  }
}
