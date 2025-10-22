import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/document_entity.dart';
import '../providers/document_provider.dart';
import '../../../../core/presentation/theme/app_colors.dart';

class DocumentDetailPage extends StatelessWidget {
  final DocumentEntity document;

  const DocumentDetailPage({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go('/'),
        ),
        title: Text(
          document.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              // TODO: Navigate to notifications
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Document Info
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Môn học: ${document.subject}',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Người tạo: ${document.author}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Đang tải xuống...'),
                          backgroundColor: AppColors.success,
                        ),
                      );
                    },
                    icon: const Icon(Icons.download),
                    label: const Text(
                      'Download',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Consumer<DocumentProvider>(
                  builder: (context, provider, child) {
                    return IconButton(
                      onPressed: () {
                        provider.toggleFavorite(document.id);
                      },
                      icon: Icon(
                        document.isFavorite
                            ? Icons.bookmark
                            : Icons.bookmark_border,
                        color: document.isFavorite
                            ? Colors.amber
                            : AppColors.textSecondary,
                        size: 32,
                      ),
                    );
                  },
                ),
                IconButton(
                  onPressed: () {
                    // TODO: Share functionality
                  },
                  icon: const Icon(
                    Icons.share,
                    color: AppColors.textSecondary,
                    size: 32,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Document Cover
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                width: double.infinity,
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.primary.withOpacity(0.1),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.picture_as_pdf,
                      size: 80,
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'GIÁO TRÌNH TƯ TƯỞNG HỒ CHÍ MINH',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Đối tượng sử dụng: Sinh viên',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      'Nhà xuất bản: Đại học Thủy Lợi',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Document Title
            Text(
              document.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 8),

            // Upload Date and View Count
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  '${document.uploadDate.day}/${document.uploadDate.month}/${document.uploadDate.year} ${document.viewCount}',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
