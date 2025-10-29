import '../../../data_generator/domain/entities/lien_he_entity.dart';
import '../repositories/support_request_repository.dart';

/// Use case to get all pending support requests
class GetPendingRequestsUseCase {
  final SupportRequestRepository _repository;

  GetPendingRequestsUseCase(this._repository);

  /// Execute the use case
  /// Returns list of requests with status "Chưa phản hồi" or "Đang xử lý"
  Future<List<LienHeEntity>> call() async {
    return await _repository.getPendingRequests();
  }
}
