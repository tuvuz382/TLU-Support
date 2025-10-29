import '../../../data_generator/domain/entities/lien_he_entity.dart';
import '../../domain/repositories/support_request_repository.dart';
import '../datasources/firebase_support_request_datasource.dart';

/// Implementation of SupportRequestRepository
class SupportRequestRepositoryImpl implements SupportRequestRepository {
  final FirebaseSupportRequestDataSource _dataSource;

  SupportRequestRepositoryImpl(this._dataSource);

  @override
  Future<void> submitSupportRequest(LienHeEntity request) async {
    return await _dataSource.submitRequest(request);
  }

  @override
  Future<List<LienHeEntity>> getPendingRequests() async {
    return await _dataSource.getPendingRequests();
  }

  @override
  Future<List<LienHeEntity>> getProcessedRequests() async {
    return await _dataSource.getProcessedRequests();
  }

  @override
  Future<LienHeEntity?> getRequestDetail(String maLienHe) async {
    return await _dataSource.getRequestDetail(maLienHe);
  }

  @override
  Stream<List<LienHeEntity>> watchAllRequests() {
    return _dataSource.watchAllRequests();
  }
}
