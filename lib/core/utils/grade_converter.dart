/// Utility class để chuyển đổi điểm hệ 10 sang hệ 4 và điểm chữ
class GradeConverter {
  /// Chuyển đổi điểm hệ 10 sang điểm hệ 4
  /// Quy tắc:
  /// - A (4.0): >= 8.5
  /// - B (3.0): >= 7.0 và < 8.5
  /// - C (2.0): >= 5.5 và < 7.0
  /// - D (1.0): >= 4.0 và < 5.5
  /// - F (0.0): < 4.0
  static double convertTo4PointScale(double diemHe10) {
    if (diemHe10 >= 8.5) return 4.0;
    if (diemHe10 >= 7.0) return 3.0;
    if (diemHe10 >= 5.5) return 2.0;
    if (diemHe10 >= 4.0) return 1.0;
    return 0.0;
  }

  /// Chuyển đổi điểm hệ 10 sang điểm chữ
  static String convertToLetterGrade(double diemHe10) {
    if (diemHe10 >= 8.5) return 'A';
    if (diemHe10 >= 7.0) return 'B';
    if (diemHe10 >= 5.5) return 'C';
    if (diemHe10 >= 4.0) return 'D';
    return 'F';
  }

  /// Tính điểm hệ 4 và điểm chữ từ điểm hệ 10
  /// Trả về Map với keys: 'diemHe4' và 'diemChu'
  static Map<String, dynamic> convertGrade(double diemHe10) {
    return {
      'diemHe4': convertTo4PointScale(diemHe10),
      'diemChu': convertToLetterGrade(diemHe10),
    };
  }
}

