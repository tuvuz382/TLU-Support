import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '/core/presentation/theme/app_colors.dart';
import '../../../data_generator/domain/entities/tai_lieu_entity.dart';
import '../../data/datasources/firebase_documents_datasource.dart';
import '../../data/repositories/documents_repository_impl.dart';
import '../../domain/repositories/documents_repository.dart';

class DocumentsPage extends StatefulWidget {
  const DocumentsPage({super.key});

  @override
  State<DocumentsPage> createState() => _DocumentsPageState();
}

class _DocumentsPageState extends State<DocumentsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late DocumentsRepository _repository;

  List<TaiLieuEntity> _allDocuments = [];
  List<TaiLieuEntity> _favoriteDocuments = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _repository = DocumentsRepositoryImpl(FirebaseDocumentsDataSource());
    _loadDocuments();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadDocuments() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final documents = await _repository.getAllDocuments();
      setState(() {
        _allDocuments = documents;
        _favoriteDocuments = documents.where((doc) => doc.yeuThich).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleFavorite(String documentId, bool currentStatus) async {
    try {
      // Toggle trên UI trước để responsive
      setState(() {
        final index = _allDocuments.indexWhere((doc) => doc.maTL == documentId);
        if (index != -1) {
          _allDocuments[index] = TaiLieuEntity(
            maTL: _allDocuments[index].maTL,
            tenTL: _allDocuments[index].tenTL,
            monHoc: _allDocuments[index].monHoc,
            duongDan: _allDocuments[index].duongDan,
            moTa: _allDocuments[index].moTa,
            yeuThich: !currentStatus,
          );
          _favoriteDocuments = _allDocuments
              .where((doc) => doc.yeuThich)
              .toList();
        }
      });

      // Update Firestore
      await _repository.toggleFavorite(documentId, !currentStatus);
    } catch (e) {
      // Nếu lỗi, revert lại
      _loadDocuments();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
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
        title: const Text(
          'Tài liệu học tập',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? _buildErrorState()
          : _buildContent(),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        // Tab Bar
        Container(
          color: Colors.white,
          child: TabBar(
            controller: _tabController,
            labelColor: AppColors.primary,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppColors.primary,
            indicatorWeight: 3,
            labelStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            tabs: const [
              Tab(text: 'Tất cả'),
              Tab(text: 'Yêu thích'),
            ],
          ),
        ),

        // Document Count and Filter
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_allDocuments.length} tài liệu',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.search, color: Colors.grey),
                    onPressed: () {
                      // TODO: Implement search
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.filter_list,
                      color: AppColors.primary,
                    ),
                    onPressed: () {
                      // TODO: Implement filter
                    },
                  ),
                ],
              ),
            ],
          ),
        ),

        const Divider(height: 1),

        // Document List
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              // Tất cả
              _allDocuments.isEmpty
                  ? _buildEmptyState(
                      icon: Icons.description_outlined,
                      title: 'Chưa có tài liệu',
                      subtitle: 'Chưa có tài liệu nào trong hệ thống',
                    )
                  : _buildDocumentList(_allDocuments),
              // Yêu thích
              _favoriteDocuments.isEmpty
                  ? _buildEmptyState(
                      icon: Icons.favorite_border,
                      title: 'Chưa có tài liệu yêu thích',
                      subtitle: 'Nhấn vào biểu tượng trái tim để lưu tài liệu',
                    )
                  : _buildDocumentList(_favoriteDocuments),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentList(List<TaiLieuEntity> documents) {
    return RefreshIndicator(
      onRefresh: _loadDocuments,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: documents.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final document = documents[index];
          return _buildDocumentCard(document);
        },
      ),
    );
  }

  Widget _buildDocumentCard(TaiLieuEntity document) {
    return InkWell(
      onTap: () {
        // Navigate to document detail page
        context.push('/document-detail', extra: document);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            Container(
              width: 80,
              height: 110,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[200],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: _buildDocumentThumbnail(document),
              ),
            ),

            const SizedBox(width: 12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    document.tenTL,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 8),

                  // Subject
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      document.monHoc,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Description
                  Text(
                    document.moTa,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Favorite Button
            IconButton(
              icon: Icon(
                document.yeuThich ? Icons.favorite : Icons.favorite_border,
                color: document.yeuThich ? Colors.red : Colors.grey,
              ),
              onPressed: () =>
                  _toggleFavorite(document.maTL, document.yeuThich),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentThumbnail(TaiLieuEntity document) {
    // Tạo màu dựa trên môn học
    Color backgroundColor;
    switch (document.monHoc) {
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
      color: backgroundColor,
      child: Center(
        child: Icon(
          Icons.description,
          size: 40,
          color: Colors.white.withValues(alpha: 0.8),
        ),
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 80, color: Colors.grey[400]),
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
            onPressed: _loadDocuments,
            icon: const Icon(Icons.refresh),
            label: const Text('Thử lại'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
