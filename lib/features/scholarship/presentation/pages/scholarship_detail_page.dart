import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/presentation/theme/app_colors.dart';
import '../../../../core/routing/app_routes.dart';
import '../../data/repositories/scholarship_repository_impl.dart';
import '../../data/datasources/scholarship_remote_datasource.dart';
import '../../domain/usecases/get_scholarship_by_id_usecase.dart';
import '../../domain/usecases/has_registered_scholarship_usecase.dart';
import '../../domain/entities/scholarship_entity.dart';

class ScholarshipDetailPage extends StatefulWidget {
  final String? scholarshipId;
  final String? scholarshipTitle; // For backwards compatibility

  const ScholarshipDetailPage({
    super.key,
    this.scholarshipId,
    this.scholarshipTitle,
  });

  @override
  State<ScholarshipDetailPage> createState() => _ScholarshipDetailPageState();
}

class _ScholarshipDetailPageState extends State<ScholarshipDetailPage> {
  late final GetScholarshipByIdUseCase _getScholarshipByIdUseCase;
  late final HasRegisteredScholarshipUseCase
      _hasRegisteredScholarshipUseCase;

  ScholarshipEntity? _scholarship;
  bool _isLoading = true;
  bool _hasRegistered = false;

  @override
  void initState() {
    super.initState();
    // Dependency Injection setup
    final dataSource = ScholarshipRemoteDataSource();
    final repository =
        ScholarshipRepositoryImpl(remoteDataSource: dataSource);
    _getScholarshipByIdUseCase = GetScholarshipByIdUseCase(repository);
    _hasRegisteredScholarshipUseCase =
        HasRegisteredScholarshipUseCase(repository);

    _loadScholarship();
  }

  Future<void> _loadScholarship() async {
    if (widget.scholarshipId == null && widget.scholarshipTitle == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      if (widget.scholarshipId != null) {
        final scholarship =
            await _getScholarshipByIdUseCase(widget.scholarshipId!);
        final hasRegistered = await _hasRegisteredScholarshipUseCase(
            widget.scholarshipId!);

        if (mounted) {
          setState(() {
            _scholarship = scholarship;
            _hasRegistered = hasRegistered;
            _isLoading = false;
          });
        }
      } else {
        // Fallback: create a dummy entity from title
        if (mounted) {
          setState(() {
            _scholarship = ScholarshipEntity(
              maHB: 'HB_TEMP',
              tenHB: widget.scholarshipTitle ?? 'Học bổng',
              moTa: '',
              giaTri: 0,
              thoiHanDangKyBatDau: DateTime.now(),
              thoiHanDangKyKetThuc: DateTime.now(),
            );
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi khi tải thông tin học bổng: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _navigateToRegistration(BuildContext context) {
    if (_scholarship == null) return;

    context.go(
      AppRoutes.scholarshipRegistration,
      extra: {'scholarshipId': _scholarship!.maHB},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.go(AppRoutes.scholarshipList),
        ),
        title: const Text(
          'Học bổng',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _scholarship == null
              ? const Center(child: Text('Không tìm thấy học bổng'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          _scholarship!.tenHB,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Time
                        Text(
                          'Thời gian đăng ký: '
                          '${_formatDate(_scholarship!.thoiHanDangKyBatDau)} - '
                          '${_formatDate(_scholarship!.thoiHanDangKyKetThuc)}',
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black87),
                        ),
                        if (_scholarship!.giaTri > 0) ...[
                          const SizedBox(height: 8),
                          Text(
                            'Giá trị: ${_scholarship!.giaTri.toStringAsFixed(0)} VNĐ',
                            style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                        const SizedBox(height: 20),
                        // Description
                        if (_scholarship!.moTa.isNotEmpty) ...[
                          Text(
                            _scholarship!.moTa,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                        // Attachment
                        if (_scholarship!.tepDinhKem != null &&
                            _scholarship!.tepDinhKem!.isNotEmpty) ...[
                          const Text(
                            'Chi tiết xem tại file dưới đây:',
                            style: TextStyle(fontSize: 14, color: Colors.black87),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.picture_as_pdf,
                                  color: Colors.red,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _scholarship!.tepDinhKem!.split('/').last,
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black87),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),
                        ],
                        // Register Button
                        if (!_hasRegistered && _scholarship!.isOpenForRegistration)
                          Center(
                            child: GestureDetector(
                              onTap: () => _navigateToRegistration(context),
                              child: Container(
                                width: double.infinity,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Center(
                                  child: Text(
                                    'Đăng ký',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        else if (_hasRegistered)
                          Center(
                            child: Container(
                              width: double.infinity,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Center(
                                child: Text(
                                  'Đã đăng ký',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          )
                        else if (_scholarship!.isExpired)
                          Center(
                            child: Container(
                              width: double.infinity,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Center(
                                child: Text(
                                  'Đã hết hạn đăng ký',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
