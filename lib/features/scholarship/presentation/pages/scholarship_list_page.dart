import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/presentation/theme/app_colors.dart';
import '../../../../core/routing/app_routes.dart';

class ScholarshipListPage extends StatefulWidget {
  const ScholarshipListPage({super.key});

  @override
  State<ScholarshipListPage> createState() => _ScholarshipListPageState();
}

class _ScholarshipListPageState extends State<ScholarshipListPage> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.go(AppRoutes.home),
        ),
        title: const Text(
          'Học bổng',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Tab Navigation
          Container(
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedTab = 0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: _selectedTab == 0 ? AppColors.primary : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                      child: Text(
                        'Danh sách',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _selectedTab == 0 ? AppColors.primary : Colors.grey,
                          fontWeight: _selectedTab == 0 ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedTab = 1),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: _selectedTab == 1 ? AppColors.primary : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                      child: Text(
                        'Đã đăng ký',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _selectedTab == 1 ? AppColors.primary : Colors.grey,
                          fontWeight: _selectedTab == 1 ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Content
          Expanded(
            child: _selectedTab == 0 ? _buildScholarshipList() : _buildRegisteredList(),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildScholarshipList() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildScholarshipCard(
          'Học bổng khuyến học "Lê Văn Kiếm và gia đình"',
          'Hạn đăng ký: 23/09/2025-30/09/2025',
        ),
        const SizedBox(height: 16),
        _buildScholarshipCard(
          'Học bổng khuyến học "Lê Văn Kiếm và gia đình"',
          'Hạn đăng ký: 23/09/2025-30/09/2025',
        ),
        const SizedBox(height: 16),
        _buildScholarshipCard(
          'Học bổng khuyến học "Lê Văn Kiếm và gia đình"',
          'Hạn đăng ký: 23/09/2025-30/09/2025',
        ),
      ],
    );
  }

  Widget _buildRegisteredList() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildRegisteredCard(
          'Học bổng khuyến học "Lê Văn Kiếm và gia đình"',
          'Thời gian gửi: 8:15AM 23/09/2025',
          'Trạng thái: Đang chờ duyệt',
        ),
        const SizedBox(height: 16),
        _buildRegisteredCard(
          'Học bổng khuyến khích học tập theo Quy định của Bộ GD&ĐT',
          'Thời gian gửi: 7:55AM 22/09/2025',
          'Trạng thái: Đã duyệt',
        ),
      ],
    );
  }

  Widget _buildScholarshipCard(String title, String deadline) {
    return GestureDetector(
      onTap: () => context.go(AppRoutes.scholarshipDetail),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              height: 1,
              color: Colors.white.withOpacity(0.3),
            ),
            const SizedBox(height: 8),
            Text(
              deadline,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegisteredCard(String title, String submissionTime, String status) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(12),
      ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              height: 1,
              color: Colors.white.withOpacity(0.3),
            ),
            const SizedBox(height: 8),
            Text(
              submissionTime,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              status,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ],
        ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      height: 60,
      decoration: const BoxDecoration(
        color: AppColors.primary,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, true),
          _buildNavItem(Icons.grid_view, false),
          _buildNavItem(Icons.description, false),
          _buildNavItem(Icons.person, false),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, bool isSelected) {
    return Icon(
      icon,
      color: Colors.white,
      size: 24,
    );
  }
}
