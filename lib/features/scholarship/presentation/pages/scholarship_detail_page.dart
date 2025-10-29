import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/presentation/theme/app_colors.dart';
import '../../../../core/routing/app_routes.dart';

class ScholarshipDetailPage extends StatelessWidget {
  final String scholarshipTitle;
  
  const ScholarshipDetailPage({
    super.key,
    this.scholarshipTitle = 'Học bổng khuyến khích học tập theo Quy định của Bộ GD&ĐT',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.go(AppRoutes.scholarshipList),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                scholarshipTitle,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              // Time
              const Text(
                'Thời gian: 3:30PM 3/9/2025',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              // Description
              const Text(
                '1. Học bổng loại Xuất sắc: Điểm trung bình chung học tập đạt loại xuất sắc và kết quả rèn luyện đạt loại xuất sắc.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                '2. Học bổng loại Giỏi: Điểm trung bình chung học tập đạt loại giỏi trở lên và kết quả rèn luyện đạt loại tốt trở lên.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                '3. Học bổng loại Khá: Điểm trung bình chung học tập đạt loại khá trở lên và kết quả rèn luyện đạt loại khá trở lên.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              // Attachment
              const Text(
                'Chi tiết xem tại file dưới đây:',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.picture_as_pdf,
                      color: Colors.red,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'HBBGDOT.pdf',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              // Register Button
              Center(
                child: GestureDetector(
                  onTap: () => _navigateToRegistration(context),
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        'Đăng ký',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
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

  void _navigateToRegistration(BuildContext context) {
    context.go(AppRoutes.scholarshipRegistration, extra: {
      'scholarshipTitle': scholarshipTitle,
    });
  }
}
