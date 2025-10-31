import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '/core/presentation/theme/app_colors.dart';
import '../../../data_generator/domain/entities/mon_hoc_entity.dart';
import '../../../data_generator/domain/entities/giang_vien_entity.dart';
import '../../../documents/data/datasources/firebase_documents_datasource.dart';
import '../../../data_generator/domain/entities/tai_lieu_entity.dart';
import '../../../teacher/data/datasources/firebase_teacher_datasource.dart';
import '../../../teacher/data/repositories/teacher_repository_impl.dart';
import '../../../teacher/domain/usecases/get_teacher_detail_usecase.dart';

class SubjectDetailPage extends StatelessWidget {
  final MonHocEntity subject;
  const SubjectDetailPage({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: Text(
          subject.tenMon,
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.black),
            onPressed: () => context.go('/notifications'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${subject.tenMon} (${subject.maMon})',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _InfoChip(
                        icon: Icons.credit_card,
                        label: '${subject.soTinChi} tín chỉ',
                      ),
                      const SizedBox(width: 12),
                      _InfoChip(
                        icon: Icons.school,
                        label: subject.chuyenNganh,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            // Mục tiêu môn học
            _SectionCard(
              title: 'Mục tiêu môn học',
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Text(
                  subject.moTa.isEmpty
                      ? 'Nội dung sẽ được cập nhật.'
                      : subject.moTa,
                  style: const TextStyle(fontSize: 14, height: 1.6),
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Tài liệu tham khảo
            _SectionCard(
              title: 'Tài liệu tham khảo',
              child: _SubjectDocuments(maMon: subject.maMon),
            ),
            const SizedBox(height: 20),
            
            // Giảng viên giảng dạy
            _SectionCard(
              title: 'Giảng viên giảng dạy',
              child: _SubjectTeachers(maGV: subject.maGV),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SubjectDocuments extends StatelessWidget {
  final String maMon;
  const _SubjectDocuments({required this.maMon});

  @override
  Widget build(BuildContext context) {
    final ds = FirebaseDocumentsDataSource();
    return FutureBuilder<List<TaiLieuEntity>>(
      future: ds.getAllDocuments(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (!snapshot.hasData || snapshot.hasError) {
          return const Padding(
            padding: EdgeInsets.all(8),
            child: Text('Không thể tải tài liệu.'),
          );
        }
        final docs = snapshot.data!
            .where((e) => e.maMon == maMon)
            .toList();
        if (docs.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(8),
            child: Text('Không có tài liệu.', style: TextStyle(color: Colors.grey)),
          );
        }
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: docs.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final d = docs[index];
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          d.tenTL,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        if (d.moTa.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            d.moTa,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right, color: Colors.grey),
                    onPressed: () {
                      context.push('/document-detail', extra: d);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _SubjectTeachers extends StatelessWidget {
  final String maGV;
  const _SubjectTeachers({required this.maGV});

  @override
  Widget build(BuildContext context) {
    if (maGV.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(8),
        child: Text('Chưa có thông tin giảng viên.', style: TextStyle(color: Colors.grey)),
      );
    }

    final ds = FirebaseTeacherDataSource();
    final repo = TeacherRepositoryImpl(ds);
    final useCase = GetTeacherDetailUseCase(repo);

    return FutureBuilder<GiangVienEntity?>(
      future: useCase(maGV),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return const Padding(
            padding: EdgeInsets.all(8),
            child: Text('Không tìm thấy giảng viên.', style: TextStyle(color: Colors.grey)),
          );
        }
        final teacher = snapshot.data!;
        return _TeacherCard(teacher: teacher);
      },
    );
  }
}

class _TeacherCard extends StatelessWidget {
  final GiangVienEntity teacher;
  const _TeacherCard({required this.teacher});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                teacher.hoTen.isNotEmpty ? teacher.hoTen[0].toUpperCase() : 'G',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        teacher.hocVi,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  teacher.hoTen,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right, color: Colors.grey),
            onPressed: () {
              context.push('/teacher-detail', extra: teacher);
            },
          ),
        ],
      ),
    );
  }
}


