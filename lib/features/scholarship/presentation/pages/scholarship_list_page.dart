import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/presentation/theme/app_colors.dart';
import '../../../../core/routing/app_routes.dart';
import '../../data/repositories/scholarship_repository_impl.dart';
import '../../data/datasources/scholarship_remote_datasource.dart';
import '../../domain/usecases/get_all_scholarships_usecase.dart';
import '../../domain/usecases/get_registered_scholarships_usecase.dart';
import '../../domain/usecases/watch_scholarships_usecase.dart';
import '../../domain/usecases/watch_registered_scholarships_usecase.dart';
import '../../domain/entities/scholarship_entity.dart';

class ScholarshipListPage extends StatefulWidget {
  const ScholarshipListPage({super.key});

  @override
  State<ScholarshipListPage> createState() => _ScholarshipListPageState();
}

class _ScholarshipListPageState extends State<ScholarshipListPage> {
  int _selectedTab = 0;

  late final GetAllScholarshipsUseCase _getAllScholarshipsUseCase;
  late final GetRegisteredScholarshipsUseCase
      _getRegisteredScholarshipsUseCase;
  late final WatchScholarshipsUseCase _watchScholarshipsUseCase;
  late final WatchRegisteredScholarshipsUseCase
      _watchRegisteredScholarshipsUseCase;

  List<ScholarshipEntity> _scholarships = [];
  List<ScholarshipRegistrationEntity> _registeredScholarships = [];
  bool _isLoading = true;
  StreamSubscription? _scholarshipsSubscription;
  StreamSubscription? _registrationsSubscription;

  @override
  void initState() {
    super.initState();
    // Dependency Injection setup
    final dataSource = ScholarshipRemoteDataSource();
    final repository =
        ScholarshipRepositoryImpl(remoteDataSource: dataSource);
    _getAllScholarshipsUseCase = GetAllScholarshipsUseCase(repository);
    _getRegisteredScholarshipsUseCase =
        GetRegisteredScholarshipsUseCase(repository);
    _watchScholarshipsUseCase = WatchScholarshipsUseCase(repository);
    _watchRegisteredScholarshipsUseCase =
        WatchRegisteredScholarshipsUseCase(repository);

    _loadData();
    _setupStreams();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final scholarships = await _getAllScholarshipsUseCase();
      final registrations = await _getRegisteredScholarshipsUseCase();

      if (mounted) {
        setState(() {
          _scholarships = scholarships;
          _registeredScholarships = registrations;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi khi tải danh sách học bổng: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _setupStreams() {
    _scholarshipsSubscription =
        _watchScholarshipsUseCase().listen((scholarships) {
      if (mounted) {
        setState(() {
          _scholarships = scholarships;
        });
      }
    });

    _registrationsSubscription =
        _watchRegisteredScholarshipsUseCase().listen((registrations) {
      if (mounted) {
        setState(() {
          _registeredScholarships = registrations;
        });
      }
    });
  }

  @override
  void dispose() {
    _scholarshipsSubscription?.cancel();
    _registrationsSubscription?.cancel();
    super.dispose();
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
          onPressed: () => context.go(AppRoutes.home),
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
      body: Column(
        children: [
          // Tab Navigation
          Container(
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedTab = 0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: _selectedTab == 0
                                ? AppColors.primary
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                      child: Text(
                        'Danh sách',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _selectedTab == 0
                              ? AppColors.primary
                              : Colors.grey,
                          fontWeight: _selectedTab == 0
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedTab = 1),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: _selectedTab == 1
                                ? AppColors.primary
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                      child: Text(
                        'Đã đăng ký',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _selectedTab == 1
                              ? AppColors.primary
                              : Colors.grey,
                          fontWeight: _selectedTab == 1
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Content
          Expanded(
            child: _selectedTab == 0
                ? _buildScholarshipList()
                : _buildRegisteredList(),
          ),
        ],
      ),
    );
  }

  Widget _buildScholarshipList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_scholarships.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.school_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Chưa có học bổng nào',
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ..._scholarships.map((scholarship) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildScholarshipCard(scholarship),
              )),
        ],
      ),
    );
  }

  Widget _buildRegisteredList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_registeredScholarships.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.description_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Chưa có học bổng nào được đăng ký',
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ..._registeredScholarships.map((registration) {
            // Tìm thông tin học bổng tương ứng
            final scholarship = _scholarships.firstWhere(
              (s) => s.maHB == registration.maHB,
              orElse: () => ScholarshipEntity(
                maHB: registration.maHB,
                tenHB: 'Học bổng ${registration.maHB}',
                moTa: '',
                giaTri: 0,
                thoiHanDangKyBatDau: DateTime.now(),
                thoiHanDangKyKetThuc: DateTime.now(),
              ),
            );
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildRegisteredCard(registration, scholarship),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildScholarshipCard(ScholarshipEntity scholarship) {
    final deadlineText = 'Hạn đăng ký: '
        '${_formatDate(scholarship.thoiHanDangKyBatDau)} - '
        '${_formatDate(scholarship.thoiHanDangKyKetThuc)}';

    return GestureDetector(
      onTap: () => context.go(
        AppRoutes.scholarshipDetail,
        extra: {'scholarshipId': scholarship.maHB},
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: scholarship.isOpenForRegistration
              ? AppColors.primary
              : Colors.grey,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              scholarship.tenHB,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              height: 1,
              color: Colors.white.withOpacity(0.3),
            ),
            const SizedBox(height: 8),
            Text(
              deadlineText,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
            if (scholarship.giaTri > 0) ...[
              const SizedBox(height: 4),
              Text(
                'Giá trị: ${scholarship.giaTri.toStringAsFixed(0)} VNĐ',
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRegisteredCard(
    ScholarshipRegistrationEntity registration,
    ScholarshipEntity scholarship,
  ) {
    final submissionTime = 'Thời gian gửi: ${_formatDateTime(registration.thoiGianDangKy)}';
    final statusText = _getStatusText(registration.trangThai);
    final statusColor = _getStatusColor(registration.trangThai);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            scholarship.tenHB,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            height: 1,
            color: Colors.white.withOpacity(0.3),
          ),
          const SizedBox(height: 8),
          Text(
            submissionTime,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                'Trạng thái: ',
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  statusText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatDateTime(DateTime date) {
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour < 12 ? 'AM' : 'PM';
    final hour12 = date.hour > 12 ? date.hour - 12 : (date.hour == 0 ? 12 : date.hour);
    return '$hour12:$minute $period ${_formatDate(date)}';
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Đang chờ duyệt';
      case 'approved':
        return 'Đã duyệt';
      case 'rejected':
        return 'Từ chối';
      default:
        return status;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
