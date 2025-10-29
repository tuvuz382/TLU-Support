import '../../../data_generator/domain/entities/lien_he_entity.dart';

/// Abstract repository for Support Request operations
abstract class SupportRequestRepository {
  /// Submit a new support request
  Future<void> submitSupportRequest(LienHeEntity request);

  /// Get all pending requests (Chờ xác nhận)
  Future<List<LienHeEntity>> getPendingRequests();

  /// Get all processed requests (Đã duyệt or Từ chối)
  Future<List<LienHeEntity>> getProcessedRequests();

  /// Get request detail by maLienHe
  Future<LienHeEntity?> getRequestDetail(String maLienHe);

  /// Watch all requests (Stream for realtime updates)
  Stream<List<LienHeEntity>> watchAllRequests();
}
