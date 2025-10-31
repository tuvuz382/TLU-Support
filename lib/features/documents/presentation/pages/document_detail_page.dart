import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '/core/presentation/theme/app_colors.dart';
import '../../../data_generator/domain/entities/tai_lieu_entity.dart';
import '../../data/datasources/firebase_documents_datasource.dart';
import '../../data/repositories/documents_repository_impl.dart';
import '../../domain/repositories/documents_repository.dart';
import '../../domain/usecases/toggle_favorite_usecase.dart';

class DocumentDetailPage extends StatefulWidget {
  final TaiLieuEntity document;

  const DocumentDetailPage({super.key, required this.document});

  @override
  State<DocumentDetailPage> createState() => _DocumentDetailPageState();
}

class _DocumentDetailPageState extends State<DocumentDetailPage> {
  late TaiLieuEntity _document;
  late DocumentsRepository _repository;
  late ToggleFavoriteUseCase _toggleFavoriteUseCase;
  bool _isTogglingFavorite = false;

  @override
  void initState() {
    super.initState();
    _document = widget.document;
    _repository = DocumentsRepositoryImpl(FirebaseDocumentsDataSource());
    _toggleFavoriteUseCase = ToggleFavoriteUseCase(_repository);
  }

  Future<void> _handleToggleFavorite() async {
    if (_isTogglingFavorite) return;

    setState(() {
      _isTogglingFavorite = true;
    });

    try {
      // Optimistic update: Cập nhật UI trước
      final newFavoriteStatus = !_document.yeuThich;
      setState(() {
        _document = TaiLieuEntity(
          maTL: _document.maTL,
          tenTL: _document.tenTL,
          maMon: _document.maMon,
          duongDan: _document.duongDan,
          moTa: _document.moTa,
          yeuThich: newFavoriteStatus,
        );
      });

      // Gọi UseCase để cập nhật Firestore
      await _toggleFavoriteUseCase.call(_document.maTL, newFavoriteStatus);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              newFavoriteStatus
                  ? 'Đã thêm vào yêu thích'
                  : 'Đã xóa khỏi yêu thích',
            ),
            backgroundColor: AppColors.success,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      // Revert lại trạng thái cũ nếu lỗi
      setState(() {
        _document = widget.document;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi: ${e.toString()}'),
            backgroundColor: AppColors.error,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isTogglingFavorite = false;
        });
      }
    }
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
          _document.tenTL.length > 30
              ? '${_document.tenTL.substring(0, 30)}...'
              : _document.tenTL,
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thông tin môn học và người tạo
              _buildInfoSection(),

              const SizedBox(height: 20),

              // Action buttons (Download, Bookmark, Share)
              _buildActionButtons(context),

              const SizedBox(height: 24),

              // Document preview image
              _buildDocumentPreview(),

              const SizedBox(height: 16),

              // Document title
              Text(
                _document.tenTL,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 16),

              // Date and Views
              _buildMetaInfo(),

              const SizedBox(height: 24),

              // Description section
              _buildDescriptionSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Môn học
          Row(
            children: [
              Icon(Icons.book_outlined, size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
              const Text(
                'Môn học: ',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              Expanded(
                child: Text(
                  _getSubjectName(_document.maMon),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Người tạo
          Row(
            children: [
              Icon(Icons.person_outline, size: 20, color: Colors.grey[700]),
              const SizedBox(width: 8),
              const Text(
                'Người tạo: ',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const Text(
                'Nguyễn Văn A',
                style: TextStyle(fontSize: 15, color: Colors.black87),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        // Download button
        Expanded(
          flex: 2,
          child: ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Đang tải tài liệu: ${_document.tenTL}'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            icon: const Icon(Icons.download, size: 20),
            label: const Text(
              'Download',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 2,
            ),
          ),
        ),

        const SizedBox(width: 12),

        // Favorite button
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
            onPressed: _isTogglingFavorite ? null : _handleToggleFavorite,
            icon: _isTogglingFavorite
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                    ),
                  )
                : Icon(
                    _document.yeuThich ? Icons.favorite : Icons.favorite_border,
                    color: _document.yeuThich ? Colors.red : Colors.grey,
                  ),
          ),
        ),

        const SizedBox(width: 12),

        // Share button
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Chia sẻ tài liệu'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
            icon: Icon(Icons.share_outlined, color: Colors.grey[700]),
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentPreview() {
    // Tạo màu dựa trên môn học
    Color backgroundColor;
    switch (_document.maMon) {
      case 'MH001':
        backgroundColor = const Color(0xFFFF9800);
        break;
      case 'MH002':
        backgroundColor = const Color(0xFF2196F3);
        break;
      case 'MH003':
        backgroundColor = const Color(0xFFE0E0E0);
        break;
      case 'MH004':
        backgroundColor = const Color(0xFF4CAF50);
        break;
      case 'MH005':
        backgroundColor = const Color(0xFFD32F2F);
        break;
      default:
        backgroundColor = const Color(0xFF9C27B0);
    }

    return Container(
      width: double.infinity,
      height: 400,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Header banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: backgroundColor == const Color(0xFFE0E0E0)
                  ? Colors.grey[400]
                  : Colors.black.withValues(alpha: 0.2),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: const Text(
              'BỘ GIÁO DỤC VÀ ĐÀO TẠO',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),

          const Spacer(),

          // Document title on preview
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              _document.tenTL.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: backgroundColor == const Color(0xFFE0E0E0)
                    ? Colors.grey[800]
                    : Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                height: 1.3,
                shadows: backgroundColor != const Color(0xFFE0E0E0)
                    ? [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 4,
                        ),
                      ]
                    : null,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Subject info
          Text(
            _getSubjectName(_document.maMon),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: backgroundColor == const Color(0xFFE0E0E0)
                  ? Colors.grey[700]
                  : Colors.white.withValues(alpha: 0.9),
              fontSize: 14,
              fontStyle: FontStyle.italic,
            ),
          ),

          const Spacer(),

          // Publisher info
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: backgroundColor == const Color(0xFFE0E0E0)
                  ? Colors.grey[400]
                  : Colors.black.withValues(alpha: 0.2),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Column(
              children: [
                Icon(Icons.account_balance, color: Colors.white, size: 32),
                const SizedBox(height: 8),
                const Text(
                  'NHÀ XUẤT BẢN CHÍNH TRỊ QUỐC GIA',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetaInfo() {
    return Row(
      children: [
        Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          _formatDate(DateTime.now()),
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        const SizedBox(width: 24),
        Icon(Icons.remove_red_eye_outlined, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          '1130', // Có thể thêm views vào entity sau
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Mô tả',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Text(
            _document.moTa,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[800],
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }

  String _getSubjectName(String maMon) {
    switch (maMon) {
      case 'MH001':
        return 'Lập trình hướng đối tượng';
      case 'MH002':
        return 'Cơ sở dữ liệu';
      case 'MH003':
        return 'Mạng máy tính';
      case 'MH004':
        return 'Phân tích thiết kế hệ thống';
      case 'MH005':
        return 'Phát triển ứng dụng di động';
      default:
        return maMon;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
