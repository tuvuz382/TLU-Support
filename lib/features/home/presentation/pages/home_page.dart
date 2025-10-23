import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/core/presentation/theme/app_colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: Column(
        children: [
          // Header với logo và hình ảnh
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.primary, AppColors.primaryDark],
              ),
            ),
            child: Stack(
              children: [
                // Hình ảnh nền
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          'https://images.unsplash.com/photo-1562774053-701939374585?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                // Overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.3),
                        Colors.black.withValues(alpha: 0.1),
                      ],
                    ),
                  ),
                ),
                // Logo và branding
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        // Logo TLU
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              '1959',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'TLU SUPPORT',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const Spacer(),
                        // Action icons
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.search, color: Colors.white),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const Icon(Icons.notifications, color: Colors.white),
                              onPressed: () => context.go('/notifications'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Grid chức năng
          Expanded(
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.count(
                  crossAxisCount: 3,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _buildGridItem(
                      context,
                      icon: Icons.school,
                      label: 'Tính GPA',
                      onTap: () {},
                    ),
                    _buildGridItem(
                      context,
                      icon: Icons.calendar_today,
                      label: 'Lịch học',
                      onTap: () => context.go('/schedule'),
                    ),
                    _buildGridItem(
                      context,
                      icon: Icons.description,
                      label: 'Tài liệu',
                      onTap: () {},
                    ),
                    _buildGridItem(
                      context,
                      icon: Icons.people,
                      label: 'Đội ngũ giảng viên',
                      onTap: () {},
                    ),
                    _buildGridItem(
                      context,
                      icon: Icons.school,
                      label: 'Chương trình đào tạo',
                      onTap: () {},
                    ),
                    _buildGridItem(
                      context,
                      icon: Icons.note,
                      label: 'Ghi chú',
                      onTap: () => context.go('/notes'),
                    ),
                    _buildGridItem(
                      context,
                      icon: Icons.card_giftcard,
                      label: 'Học bổng',
                      onTap: () {},
                    ),
                    _buildGridItem(
                      context,
                      icon: Icons.headset_mic,
                      label: 'Liên hệ/Hỗ trợ',
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.divider),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32,
              color: AppColors.primary,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
