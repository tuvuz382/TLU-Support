/// Use case để tính điểm hệ 4 từ điểm hệ 10
/// 
/// Quy tắc chuyển đổi:
/// - A (4.0): >= 8.5
/// - B (3.0): >= 7.0 và < 8.5
/// - C (2.0): >= 5.5 và < 7.0
/// - D (1.0): >= 4.0 và < 5.5
/// - F (0.0): < 4.0
class CalculateGrade4PointScaleUseCase {
  /// Execute the use case
  /// 
  /// [diemHe10] Điểm hệ 10 cần chuyển đổi
  /// 
  /// Returns điểm hệ 4 (0.0 - 4.0)
  double call(double diemHe10) {
    if (diemHe10 >= 8.5) return 4.0;
    if (diemHe10 >= 7.0) return 3.0;
    if (diemHe10 >= 5.5) return 2.0;
    if (diemHe10 >= 4.0) return 1.0;
    return 0.0;
  }
}

