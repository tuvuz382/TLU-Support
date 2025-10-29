import '../../../data_generator/domain/entities/lien_he_entity.dart';
import '../repositories/support_request_repository.dart';

/// Use case to get support request detail by maLienHe
class GetRequestDetailUseCase {
  final SupportRequestRepository _repository;

  GetRequestDetailUseCase(this._repository);

  /// Execute the use case
  /// [maLienHe] - The request ID (maLienHe)
  /// Returns the request entity or null if not found
  Future<LienHeEntity?> call(String maLienHe) async {
    // Validate input
    if (maLienHe.trim().isEmpty) {
      throw Exception('Mã liên hệ không được để trống');
    }

    // Call repository
    return await _repository.getRequestDetail(maLienHe.trim());
  }
}
