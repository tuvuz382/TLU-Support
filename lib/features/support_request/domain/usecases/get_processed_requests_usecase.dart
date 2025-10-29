import '../../../data_generator/domain/entities/lien_he_entity.dart';
import '../repositories/support_request_repository.dart';

/// Use case to get all processed support requests
class GetProcessedRequestsUseCase {
  final SupportRequestRepository _repository;

  GetProcessedRequestsUseCase(this._repository);

  /// Execute the use case
  /// Returns list of requests with status "Đã phản hồi"
  Future<List<LienHeEntity>> call() async {
    return await _repository.getProcessedRequests();
  }
}
