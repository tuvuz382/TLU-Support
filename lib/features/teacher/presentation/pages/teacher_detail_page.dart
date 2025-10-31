import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '/core/presentation/theme/app_colors.dart';
import '../../../data_generator/domain/entities/giang_vien_entity.dart';
import '../../../data_generator/domain/entities/danh_gia_entity.dart';
import '../../data/datasources/firebase_teacher_datasource.dart';
import '../../data/repositories/teacher_repository_impl.dart';
import '../../domain/usecases/get_teacher_reviews_usecase.dart';
import '../../domain/usecases/add_teacher_review_usecase.dart';
import '../../../profile/domain/usecases/get_current_student_profile_usecase.dart';
import '../../../profile/data/repositories/student_profile_repository_impl.dart';
import '../../../profile/data/datasources/student_profile_remote_datasource.dart';

class TeacherDetailPage extends StatefulWidget {
  final GiangVienEntity teacher;

  const TeacherDetailPage({super.key, required this.teacher});

  @override
  State<TeacherDetailPage> createState() => _TeacherDetailPageState();
}

class _TeacherDetailPageState extends State<TeacherDetailPage> {
  final TextEditingController _reviewController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isSubmitting = false;
  String? _currentStudentMaSV;
  int _refreshKey = 0;

  late final GetTeacherReviewsUseCase _reviewsUC;
  late final AddTeacherReviewUseCase _addReviewUC;
  late final GetCurrentStudentProfileUseCase _getStudentUC;

  @override
  void initState() {
    super.initState();
    final ds = FirebaseTeacherDataSource();
    final repo = TeacherRepositoryImpl(ds);
    _reviewsUC = GetTeacherReviewsUseCase(repo);
    _addReviewUC = AddTeacherReviewUseCase(repo);

    final studentDS = StudentProfileRemoteDataSource();
    final studentRepo = StudentProfileRepositoryImpl(remoteDataSource: studentDS);
    _getStudentUC = GetCurrentStudentProfileUseCase(studentRepo);
    _loadCurrentStudent();
  }

  Future<void> _loadCurrentStudent() async {
    final student = await _getStudentUC();
    if (student != null) {
      setState(() {
        _currentStudentMaSV = student.maSV;
      });
    }
  }

  Future<void> _submitReview() async {
    if (_reviewController.text.trim().isEmpty || _currentStudentMaSV == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập đánh giá')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final review = DanhGiaEntity(
        maDanhGia: 'DG${DateTime.now().millisecondsSinceEpoch}',
        maGV: widget.teacher.maGV,
        maSV: _currentStudentMaSV!,
        noiDung: _reviewController.text.trim(),
        ngayDanhGia: DateTime.now(),
      );

      await _addReviewUC(review);
      _reviewController.clear();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đánh giá đã được gửi!')),
        );
        setState(() {
          _refreshKey++; // Refresh reviews section
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  void dispose() {
    _reviewController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: Text(
          widget.teacher.hoTen.length > 25
              ? '${widget.teacher.hoTen.substring(0, 25)}...'
              : widget.teacher.hoTen,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.black),
            onPressed: () => context.go('/notifications'),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar Section
                    _buildAvatarSection(),

                    const SizedBox(height: 24),

                    // Name and Degree
                    Center(
                      child: Column(
                        children: [
                          Text(
                            widget.teacher.hoTen,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              widget.teacher.hocVi,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Information Card
                    _buildInfoCard(),

                    const SizedBox(height: 24),

                    // Contact Section
                    _buildContactSection(),

                    const SizedBox(height: 24),

                    // Reviews Section
                    _TeacherReviewsSection(
                      maGV: widget.teacher.maGV,
                      reviewsUC: _reviewsUC,
                      refreshTrigger: _refreshKey,
                    ),

                    const SizedBox(height: 80), // Space for bottom chatbox
                  ],
                ),
              ),
            ),
          ),
          // Chatbox for review input
          _buildReviewInputBox(),
        ],
      ),
    );
  }

  Widget _buildAvatarSection() {
    return Center(
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.3),
            width: 3,
          ),
        ),
        child: Center(
          child: Text(
            widget.teacher.hoTen.isNotEmpty ? widget.teacher.hoTen[0].toUpperCase() : 'G',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Thông tin',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),

          // Mã giảng viên
          _buildInfoRow(
            icon: Icons.badge_outlined,
            label: 'Mã giảng viên',
            value: widget.teacher.maGV,
          ),

          const SizedBox(height: 12),

          // Chuyên ngành
          _buildInfoRow(
            icon: Icons.work_outline,
            label: 'Chuyên ngành',
            value: widget.teacher.chuyenNganh,
          ),

          const SizedBox(height: 12),

          // Học vị
          _buildInfoRow(
            icon: Icons.school,
            label: 'Học vị',
            value: widget.teacher.hocVi,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContactSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Liên hệ',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),

          // Email
          _buildContactItem(
            icon: Icons.email_outlined,
            label: 'Email',
            value: widget.teacher.email,
            onTap: () {},
          ),

          const SizedBox(height: 12),

          // Số điện thoại
          _buildContactItem(
            icon: Icons.phone_outlined,
            label: 'Số điện thoại',
            value: widget.teacher.soDT,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewInputBox() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _reviewController,
                maxLines: null,
                textInputAction: TextInputAction.newline,
                decoration: InputDecoration(
                  hintText: 'Nhập đánh giá của bạn...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(
                color: _isSubmitting 
                    ? Colors.grey 
                    : AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: _isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Icon(Icons.send, color: Colors.white),
                onPressed: _isSubmitting ? null : _submitReview,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TeacherReviewsSection extends StatefulWidget {
  final String maGV;
  final GetTeacherReviewsUseCase reviewsUC;
  final int refreshTrigger;
  const _TeacherReviewsSection({
    required this.maGV,
    required this.reviewsUC,
    required this.refreshTrigger,
  });

  @override
  State<_TeacherReviewsSection> createState() => _TeacherReviewsSectionState();
}

class _TeacherReviewsSectionState extends State<_TeacherReviewsSection> {
  late Future<List<DanhGiaEntity>> _reviewsFuture;

  @override
  void initState() {
    super.initState();
    _reviewsFuture = widget.reviewsUC(widget.maGV);
  }

  @override
  void didUpdateWidget(_TeacherReviewsSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.refreshTrigger != widget.refreshTrigger) {
      _reviewsFuture = widget.reviewsUC(widget.maGV);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DanhGiaEntity>>(
      future: _reviewsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text('Lỗi khi tải đánh giá: ${snapshot.error}',
                style: const TextStyle(color: Colors.red)),
          );
        }
        final reviews = snapshot.data ?? const <DanhGiaEntity>[];
        if (reviews.isEmpty) {
          return Container(
            margin: const EdgeInsets.only(top: 8),
            child: const Text('Chưa có đánh giá.'),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            const Text(
              'Đánh giá',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...reviews.map((r) => _ReviewTile(review: r)),
          ],
        );
      },
    );
  }
}

class _ReviewTile extends StatelessWidget {
  final DanhGiaEntity review;
  const _ReviewTile({required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.person_outline, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  review.noiDung,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 6),
                Text(
                  'Ngày: ${review.ngayDanhGia.day}/${review.ngayDanhGia.month}/${review.ngayDanhGia.year}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

