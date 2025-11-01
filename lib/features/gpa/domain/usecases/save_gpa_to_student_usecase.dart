import '../../../profile/data/datasources/student_profile_remote_datasource.dart';

/// Use case để lưu GPA tổng hợp vào collection sinhVien
class SaveGPAToStudentUseCase {
  final StudentProfileRemoteDataSource _dataSource;

  SaveGPAToStudentUseCase(this._dataSource);

  /// Lưu GPA He 4 vào diemGPA của sinh viên
  /// 
  /// [maSV] Mã sinh viên
  /// [gpaHe4] Điểm GPA thang 4
  /// 
  /// Returns void
  Future<void> call(String maSV, double gpaHe4) async {
    try {
      // Kiểm tra sinh viên tồn tại
      final studentData = await _dataSource.getStudentByMaSV(maSV);
      
      if (studentData == null) {
        throw Exception('Không tìm thấy sinh viên với mã: $maSV');
      }

      // Update diemGPA field theo maSV thông qua DataSource
      await _dataSource.updateStudentFieldByMaSV(maSV, 'diemGPA', gpaHe4);
    } catch (e) {
      throw Exception('Lỗi khi lưu GPA vào sinh viên: $e');
    }
  }
}

