import 'package:flutter/material.dart';
import '../../domain/entities/document_entity.dart';
import '../../../../core/presentation/theme/app_colors.dart';

class DocumentCardWidget extends StatelessWidget {
  final DocumentEntity document;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;

  const DocumentCardWidget({
    super.key,
    required this.document,
    required this.onTap,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Thumbnail
              Container(
                width: 60,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.primary.withOpacity(0.1),
                ),
                child: Icon(
                  Icons.picture_as_pdf,
                  color: AppColors.primary,
                  size: 30,
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      document.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 4),
                    
                    Text(
                      '${document.uploadDate.day}/${document.uploadDate.month}/${document.uploadDate.year} ${document.viewCount}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Favorite Button
              IconButton(
                onPressed: onFavoriteToggle,
                icon: Icon(
                  document.isFavorite ? Icons.bookmark : Icons.bookmark_border,
                  color: document.isFavorite ? Colors.amber : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}