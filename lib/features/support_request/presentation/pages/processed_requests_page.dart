import 'package:flutter/material.dart';
import '/core/presentation/theme/app_colors.dart';
import '../../../data_generator/domain/entities/lien_he_entity.dart';
import '../../data/datasources/firebase_support_request_datasource.dart';
import '../../data/repositories/support_request_repository_impl.dart';
import '../../domain/repositories/support_request_repository.dart';
import '../../domain/usecases/get_processed_requests_usecase.dart';
import '../widgets/support_request_card.dart';

class ProcessedRequestsPage extends StatefulWidget {
  const ProcessedRequestsPage({super.key});

  @override
  State<ProcessedRequestsPage> createState() => _ProcessedRequestsPageState();
}

class _ProcessedRequestsPageState extends State<ProcessedRequestsPage> {
  late SupportRequestRepository _repository;
  late GetProcessedRequestsUseCase _getProcessedRequestsUseCase;
  List<LienHeEntity> _processedRequests = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _repository = SupportRequestRepositoryImpl(
      FirebaseSupportRequestDataSource(),
    );
    _getProcessedRequestsUseCase = GetProcessedRequestsUseCase(_repository);
    _loadProcessedRequests();
  }

  Future<void> _loadProcessedRequests() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final requests = await _getProcessedRequestsUseCase.call();
      setState(() {
        _processedRequests = requests;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Đã xảy ra lỗi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                _errorMessage ?? 'Không thể tải dữ liệu',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadProcessedRequests,
              icon: const Icon(Icons.refresh),
              label: const Text('Thử lại'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (_processedRequests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'Chưa có yêu cầu đã xử lý',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Các yêu cầu đã được xử lý sẽ hiển thị ở đây',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadProcessedRequests,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _processedRequests.length,
        itemBuilder: (context, index) {
          return SupportRequestCard(request: _processedRequests[index]);
        },
      ),
    );
  }
}
