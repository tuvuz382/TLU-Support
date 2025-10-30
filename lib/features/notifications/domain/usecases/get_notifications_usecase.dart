import '../entities/notification_item.dart';

class GetNotificationsUseCase {
  List<NotificationItem> call() {
    return const [
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
        attachment: AttachmentItem(fileName: 'HBBGDOT.pdf', fileSize: '3KB'),
      ),
      NotificationItem(
        id: '3',
        title: 'Về việc đăng ký thực hiện học phần tốt nghiệp cho K64',
        time: '7:50AM 20/8/2025',
        description: 'Thông báo về việc đăng ký thực hiện học phần tốt nghiệp dành cho sinh viên khóa 64.',
        attachment: null,
      ),
    ];
  }
}
