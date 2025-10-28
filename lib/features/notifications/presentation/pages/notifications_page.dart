import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F2F8), // Màu nền tím xám nhạt
      body: Column(
        children: [
          // Header với thanh tiêu đề
          Container(
            color: Colors.grey[200],
            child: Column(
              children: [
                // Thanh tiêu đề trên cùng
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: const Text(
                    'Thông báo - chi tiết',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ),
                // Header chính
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      // Nút back
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () => context.go('/'),
                      ),
                      const Expanded(
                        child: Text(
                          'Thông báo',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      // Icon search
                      IconButton(
                        icon: const Icon(Icons.search, color: Colors.black),
                        onPressed: () {},
                      ),
                      // Icon notifications
                      IconButton(
                        icon: const Icon(Icons.notifications, color: Colors.black),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Nội dung danh sách thông báo
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final notification = _notifications[index];
                return _buildNotificationCard(context, notification);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(BuildContext context, NotificationItem notification) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            // Điều hướng đến trang chi tiết thông báo
            context.push('/notification-detail', extra: notification);
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E3A8A), // Màu xanh đậm
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 8),
                // Đường gạch ngăn cách
                Container(
                  height: 1,
                  color: Colors.white.withValues(alpha: 0.3),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                ),
                Text(
                  'Thời gian: ${notification.time}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Dữ liệu mẫu cho thông báo
  static final List<NotificationItem> _notifications = [
    NotificationItem(
      id: '1',
      title: 'Thông báo về việc nộp học phí II Năm học 2025-2026',
      time: '3:30PM 3/9/2025',
      description: 'Thông báo chi tiết về việc nộp học phí học kỳ II năm học 2025-2026. Sinh viên vui lòng thực hiện đúng thời gian quy định.',
      attachment: null,
    ),
    NotificationItem(
      id: '2',
      title: 'Danh sách sinh viên nhận học bổng khuyến khích học tập',
      time: '8:10AM 30/8/2025',
      description: 'Danh sách sinh viên nhận học bổng khuyến khích học tập theo quy định của Bộ Giáo Dục và Đào Tạo.',
      attachment: AttachmentItem(
        fileName: 'HBBGDOT.pdf',
        fileSize: '3KB',
      ),
    ),
    NotificationItem(
      id: '3',
      title: 'Về việc đăng ký thực hiện học phần tốt nghiệp cho K64',
      time: '7:50AM 20/8/2025',
      description: 'Thông báo về việc đăng ký thực hiện học phần tốt nghiệp dành cho sinh viên khóa 64.',
      attachment: null,
    ),
    NotificationItem(
      id: '4',
      title: 'Về việc đăng ký thực hiện học phần tốt nghiệp cho K64',
      time: '7:50AM 20/8/2025',
      description: 'Thông báo về việc đăng ký thực hiện học phần tốt nghiệp dành cho sinh viên khóa 64.',
      attachment: null,
    ),
  ];
}

// Model cho thông báo
class NotificationItem {
  final String id;
  final String title;
  final String time;
  final String description;
  final AttachmentItem? attachment;

  NotificationItem({
    required this.id,
    required this.title,
    required this.time,
    required this.description,
    this.attachment,
  });
}

// Model cho file đính kèm
class AttachmentItem {
  final String fileName;
  final String fileSize;

  AttachmentItem({
    required this.fileName,
    required this.fileSize,
  });
}
