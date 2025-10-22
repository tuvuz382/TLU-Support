import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/document_provider.dart';
import '../../../../core/presentation/theme/app_colors.dart';

class CategoryFilterWidget extends StatelessWidget {
  final String title;
  final String type;

  const CategoryFilterWidget({
    super.key,
    required this.title,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<DocumentProvider>(
      builder: (context, provider, child) {
        final categories = provider.categories
            .where((cat) => cat.type == type)
            .toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            
            const SizedBox(height: 12),
            
            ...categories.map((category) {
              return CheckboxListTile(
                title: Text(
                  category.name,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.textPrimary,
                  ),
                ),
                value: category.isSelected,
                onChanged: (value) {
                  provider.toggleCategory(category.id);
                },
                activeColor: AppColors.primary,
                contentPadding: EdgeInsets.zero,
              );
            }).toList(),
          ],
        );
      },
    );
  }
}