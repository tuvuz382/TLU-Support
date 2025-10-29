import '../../../data_generator/domain/entities/lien_he_entity.dart';
import '../repositories/support_request_repository.dart';

/// Use case to submit a new support request
class SubmitSupportRequestUseCase {
  final SupportRequestRepository _repository;

  SubmitSupportRequestUseCase(this._repository);

  /// Execute the use case
  /// [maSV] - Student ID
  /// [tenSV] - Student name
  /// [lop] - Class
  /// [loaiYeuCau] - Request type
  /// [noiDungChiTiet] - Detailed content
  Future<void> call({
    required String maSV,
    required String tenSV,
    required String lop,
    required String loaiYeuCau,
    required String noiDungChiTiet,
  }) async {
    // Validate input
    if (maSV.trim().isEmpty) {
      throw Exception('Mã sinh viên không được để trống');
    }
    if (tenSV.trim().isEmpty) {
      throw Exception('Tên sinh viên không được để trống');
    }
    if (lop.trim().isEmpty) {
      throw Exception('Lớp không được để trống');
    }
    if (loaiYeuCau.trim().isEmpty) {
      throw Exception('Loại yêu cầu không được để trống');
    }
    if (noiDungChiTiet.trim().isEmpty) {
      throw Exception('Nội dung không được để trống');
    }

    // Format noiDung
    final noiDung = _buildNoiDung(
      maSV: maSV.trim(),
      tenSV: tenSV.trim(),
      lop: lop.trim(),
      loaiYeuCau: loaiYeuCau.trim(),
      noiDungChiTiet: noiDungChiTiet.trim(),
    );

    // Generate maLienHe
    final maLienHe = _generateMaLienHe();

    // Create entity
    final request = LienHeEntity(
      maLienHe: maLienHe,
      noiDung: noiDung,
      ngayGui: DateTime.now(),
      trangThaiPhanHoi: 'Chưa phản hồi',
    );

    // Submit to repository
    await _repository.submitSupportRequest(request);
  }

  /// Build noiDung string from individual fields
  String _buildNoiDung({
    required String maSV,
    required String tenSV,
    required String lop,
    required String loaiYeuCau,
    required String noiDungChiTiet,
  }) {
    return '''Mã sinh viên: $maSV
Tên: $tenSV
Lớp: $lop
Loại yêu cầu: $loaiYeuCau
Nội dung: $noiDungChiTiet''';
  }

  /// Generate unique maLienHe from timestamp
  String _generateMaLienHe() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'LH${timestamp.toString().substring(timestamp.toString().length - 6)}';
  }
}
