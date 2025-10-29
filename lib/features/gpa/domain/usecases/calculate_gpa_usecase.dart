import '../../../data_generator/domain/entities/bang_diem_entity.dart';
import '../../../data_generator/domain/entities/mon_hoc_entity.dart';
import '../entities/gpa_result_entity.dart';
import 'calculate_grade_4_point_scale_usecase.dart';

/// Use case để tính GPA từ danh sách điểm
class CalculateGPAUseCase {
  final CalculateGrade4PointScaleUseCase _grade4PointScaleUseCase;

  CalculateGPAUseCase({
    CalculateGrade4PointScaleUseCase? grade4PointScaleUseCase,
  }) : _grade4PointScaleUseCase = grade4PointScaleUseCase ?? CalculateGrade4PointScaleUseCase();

  /// Execute the use case
  /// 
  /// [grades] Danh sách bảng điểm
  /// [subjects] Danh sách môn học
  /// 
  /// Returns GPAResultEntity chứa kết quả tính GPA
  GPAResultEntity call({
    required List<BangDiemEntity> grades,
    required List<MonHocEntity> subjects,
  }) {
    if (grades.isEmpty) {
      return const GPAResultEntity(
        gpaHe10: 0.0,
        gpaHe4: 0.0,
        tongTinChi: 0,
        soMonHoc: 0,
      );
    }

    double totalWeightedScore10 = 0.0;
    double totalWeightedScore4 = 0.0;
    int totalCredits = 0;
    int subjectCount = 0;

    for (final grade in grades) {
      // Tìm thông tin môn học
      final subject = subjects.firstWhere(
        (s) => s.maMon == grade.maMon,
        orElse: () => MonHocEntity(
          maMon: grade.maMon,
          maGV: '',
          tenMon: 'Không xác định',
          soTinChi: 3, // Mặc định 3 tín chỉ
          moTa: '',
        ),
      );

      final credits = subject.soTinChi;
      final score10 = grade.diem;
      final score4 = _grade4PointScaleUseCase(score10);

      // Chỉ tính những môn có điểm >= 4.0 (điều kiện đậu)
      if (score10 >= 4.0) {
        totalWeightedScore10 += score10 * credits;
        totalWeightedScore4 += score4 * credits;
        totalCredits += credits;
        subjectCount++;
      }
    }

    if (totalCredits == 0) {
      return const GPAResultEntity(
        gpaHe10: 0.0,
        gpaHe4: 0.0,
        tongTinChi: 0,
        soMonHoc: 0,
      );
    }

    final gpaHe10 = totalWeightedScore10 / totalCredits;
    final gpaHe4 = totalWeightedScore4 / totalCredits;

    return GPAResultEntity(
      gpaHe10: gpaHe10,
      gpaHe4: gpaHe4,
      tongTinChi: totalCredits,
      soMonHoc: subjectCount,
    );
  }
}
