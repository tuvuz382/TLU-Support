import 'gpa_result_entity.dart';

/// Entity chứa thông tin tổng hợp GPA theo năm học và học kỳ
class GPASummaryEntity {
  final String namHoc; // Năm học (VD: "2023-2024")
  final String hocKy; // Học kỳ (VD: "HK1", "HK2")
  final GPAResultEntity gpaResult; // Kết quả GPA

  const GPASummaryEntity({
    required this.namHoc,
    required this.hocKy,
    required this.gpaResult,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GPASummaryEntity &&
        other.namHoc == namHoc &&
        other.hocKy == hocKy &&
        other.gpaResult == gpaResult;
  }

  @override
  int get hashCode {
    return namHoc.hashCode ^ hocKy.hashCode ^ gpaResult.hashCode;
  }

  @override
  String toString() {
    return 'GPASummaryEntity(namHoc: $namHoc, hocKy: $hocKy, gpaResult: $gpaResult)';
  }
}
