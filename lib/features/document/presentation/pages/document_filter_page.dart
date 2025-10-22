import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/category_filter_widget.dart';
import '../providers/document_provider.dart';
import '../../../../core/presentation/theme/app_colors.dart';

class DocumentFilterPage extends StatelessWidget {
  const DocumentFilterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Phân loại tài liệu',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'nhập từ khóa',
                hintStyle: TextStyle(
                  color: AppColors.textSecondary.withOpacity(0.7),
                ),
                prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
              ),
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textPrimary,
              ),
            ),
          ),

          // Categories
          Expanded(
            child: Consumer<DocumentProvider>(
              builder: (context, provider, child) {
                return ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    // Departments
                    const CategoryFilterWidget(
                      title: 'Khoa/Ngành Học',
                      type: 'department',
                    ),

                    const SizedBox(height: 24),

                    // Document Types
                    const CategoryFilterWidget(
                      title: 'Loại tài liệu',
                      type: 'document_type',
                    ),

                    const SizedBox(height: 24),

                    // Languages
                    const CategoryFilterWidget(
                      title: 'Ngôn ngữ tài liệu',
                      type: 'language',
                    ),

                    const SizedBox(height: 32),

                    // Apply Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          provider.applyFilters();
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Áp dụng bộ lọc',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
