import '../../../data_generator/domain/entities/bang_diem_entity.dart';
import '../../../data_generator/domain/entities/mon_hoc_entity.dart';
import '../entities/gpa_summary_entity.dart';
import 'calculate_gpa_usecase.dart';

/// Use case để tính tổng hợp GPA theo năm học và học kỳ
class CalculateGPASummaryUseCase {
  final CalculateGPAUseCase _calculateGPAUseCase;

  CalculateGPASummaryUseCase({
    required CalculateGPAUseCase calculateGPAUseCase,
  }) : _calculateGPAUseCase = calculateGPAUseCase;

  /// Execute the use case
  /// 
  /// [allGrades] Tất cả bảng điểm
  /// [subjects] Danh sách môn học
  /// 
  /// Returns List<GPASummaryEntity> chứa tổng hợp GPA theo năm học, học kỳ, cả năm và toàn khóa
  List<GPASummaryEntity> call({
    required List<BangDiemEntity> allGrades,
    required List<MonHocEntity> subjects,
  }) {
    if (allGrades.isEmpty) {
      return [];
    }

    // Nhóm điểm theo năm học và học kỳ
    final Map<String, Map<String, List<BangDiemEntity>>> groupedGrades = {};

    for (final grade in allGrades) {
      final namHoc = '${grade.namHoc}-${grade.namHoc + 1}';
      final hocKy = grade.hocky;

      groupedGrades.putIfAbsent(namHoc, () => {});
      groupedGrades[namHoc]!.putIfAbsent(hocKy, () => []);
      groupedGrades[namHoc]![hocKy]!.add(grade);
    }

    final List<GPASummaryEntity> summary = [];

    // Tính GPA cho từng học kỳ
    groupedGrades.forEach((namHoc, hocKyMap) {
      hocKyMap.forEach((hocKy, grades) {
        final gpaResult = _calculateGPAUseCase(
          grades: grades,
          subjects: subjects,
        );

        summary.add(GPASummaryEntity(
          namHoc: namHoc,
          hocKy: hocKy,
          gpaResult: gpaResult,
        ));
      });
    });

    // Tính GPA cho cả năm (tổng hợp tất cả học kỳ trong năm)
    groupedGrades.forEach((namHoc, hocKyMap) {
      final allGradesInYear = <BangDiemEntity>[];
      for (final grades in hocKyMap.values) {
        allGradesInYear.addAll(grades);
      }

      if (allGradesInYear.isNotEmpty) {
        final gpaResult = _calculateGPAUseCase(
          grades: allGradesInYear,
          subjects: subjects,
        );

        summary.add(GPASummaryEntity(
          namHoc: namHoc,
          hocKy: 'Cả năm',
          gpaResult: gpaResult,
        ));
      }
    });

    // Tính GPA cho toàn khóa (tổng hợp tất cả điểm)
    final gpaResult = _calculateGPAUseCase(
      grades: allGrades,
      subjects: subjects,
    );

    summary.add(GPASummaryEntity(
      namHoc: 'Toàn khóa',
      hocKy: 'Toàn khóa',
      gpaResult: gpaResult,
    ));

    // Sắp xếp theo thứ tự: học kỳ -> cả năm -> toàn khóa
    summary.sort((a, b) {
      // Toàn khóa luôn ở cuối
      if (a.namHoc == 'Toàn khóa' && b.namHoc != 'Toàn khóa') return 1;
      if (a.namHoc != 'Toàn khóa' && b.namHoc == 'Toàn khóa') return -1;
      
      // Cả năm luôn sau học kỳ trong cùng năm
      if (a.namHoc == b.namHoc) {
        if (a.hocKy == 'Cả năm' && b.hocKy != 'Cả năm') return 1;
        if (a.hocKy != 'Cả năm' && b.hocKy == 'Cả năm') return -1;
        return a.hocKy.compareTo(b.hocKy);
      }
      
      return a.namHoc.compareTo(b.namHoc);
    });

    return summary;
  }
}
