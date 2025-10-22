import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/document_provider.dart';
import '../../../../core/presentation/theme/app_colors.dart';

class DocumentTabsWidget extends StatelessWidget {
  const DocumentTabsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DocumentProvider>(
      builder: (context, provider, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              // Tabs
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => provider.setShowingFavorites(false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: !provider.isShowingFavorites 
                                  ? AppColors.primary 
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                        ),
                        child: Text(
                          'Tất cả',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: !provider.isShowingFavorites 
                                ? AppColors.primary 
                                : AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => provider.setShowingFavorites(true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: provider.isShowingFavorites 
                                  ? AppColors.primary 
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                        ),
                        child: Text(
                          'Yêu thích',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: provider.isShowingFavorites 
                                ? AppColors.primary 
                                : AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              // Document Count
              Text(
                provider.isShowingFavorites 
                    ? '${provider.favoriteDocuments.length} tài liệu'
                    : '${provider.documents.length} tài liệu',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}