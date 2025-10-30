import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/notification_item.dart';

class NotificationRemoteDatasource {
  final FirebaseFirestore _firestore;
  NotificationRemoteDatasource([FirebaseFirestore? firestore])
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<List<NotificationItem>> fetchNotifications() async {
    final snap = await _firestore.collection('thongBao').get();
    return snap.docs.map((doc) {
      final data = doc.data();
      return NotificationItem(
        id: doc.id,
        title: data['tieuDe'] ?? '',
        time: '', // Không dùng ngày đăng
        description: data['noiDung'] ?? '',
        attachment: null,
      );
    }).toList();
  }
}