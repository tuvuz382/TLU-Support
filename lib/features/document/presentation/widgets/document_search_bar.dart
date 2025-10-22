import 'package:flutter/material.dart';
import '../../../../core/presentation/theme/app_colors.dart';

class DocumentSearchBar extends StatelessWidget {
  const DocumentSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Tìm kiếm tài liệu...',
                hintStyle: TextStyle(
                  color: AppColors.textSecondary.withOpacity(0.7),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: AppColors.textSecondary,
                ),
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
        ),
        
        const SizedBox(width: 12),
        
        // Filter Button
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/document-filter');
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.filter_list,
              color: AppColors.textSecondary,
              size: 24,
            ),
          ),
        ),
      ],
    );
  }
}