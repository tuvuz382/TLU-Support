import '../../domain/entities/notification_item.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_remote_datasource.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDatasource _remote;
  NotificationRepositoryImpl([NotificationRemoteDatasource? remote])
      : _remote = remote ?? NotificationRemoteDatasource();

  @override
  Future<List<NotificationItem>> getNotifications() async {
    return await _remote.fetchNotifications();
  }
}
