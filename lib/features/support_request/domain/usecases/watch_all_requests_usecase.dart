import '../../../data_generator/domain/entities/lien_he_entity.dart';
import '../repositories/support_request_repository.dart';

/// Use case to watch all support requests (realtime stream)
class WatchAllRequestsUseCase {
  final SupportRequestRepository _repository;

  WatchAllRequestsUseCase(this._repository);

  /// Execute the use case
  /// Returns a stream that emits requests list whenever there's a change
  Stream<List<LienHeEntity>> call() {
    return _repository.watchAllRequests();
  }
}
