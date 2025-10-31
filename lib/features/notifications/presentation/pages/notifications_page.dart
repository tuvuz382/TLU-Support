import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/notification_item.dart';
import '../../domain/usecases/get_notifications_usecase.dart';
import '../../data/repositories/notification_repository_impl.dart';
import '/core/presentation/theme/app_colors.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  late final GetNotificationsUseCase _getNotificationsUseCase;
  bool _loading = true;
  List<NotificationItem> _notifications = [];

  @override
  void initState() {
    super.initState();
    _getNotificationsUseCase = GetNotificationsUseCase(NotificationRepositoryImpl());
    _fetch();
  }

  Future<void> _fetch() async {
    setState(() => _loading = true);
    try {
      final data = await _getNotificationsUseCase();
      setState(() {
        _notifications = data;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F2F8),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
        ),
        title: const Text('Thông báo'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _fetch,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _notifications.isEmpty
                    ? _buildEmptyView()
                    : ListView.separated(
                        itemCount: _notifications.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final notification = _notifications[index];
                          return _buildNotificationCard(context, notification);
                        },
                      ),
              ),
            ),
    );
  }

  Widget _buildNotificationCard(BuildContext context, NotificationItem notification) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.all(16),
        leading: const CircleAvatar(
          backgroundColor: AppColors.primary,
          child: Icon(Icons.notifications, color: Colors.white),
        ),
        title: Text(
          notification.title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(notification.time, style: const TextStyle(fontSize: 12)),
            if (notification.attachment != null)
              Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: Row(
                  children: [
                    const Icon(Icons.attach_file, size: 14, color: AppColors.primary),
                    Text('${notification.attachment!.fileName} (${notification.attachment!.fileSize})',
                        style: const TextStyle(fontSize: 12, color: AppColors.primary)),
                  ],
                ),
              ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          context.push('/notification-detail', extra: notification);
        },
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.notifications_none, size: 64, color: AppColors.primary),
          SizedBox(height: 16),
          Text(
            'Bạn chưa có thông báo nào',
            style: TextStyle(fontSize: 16, color: AppColors.textPrimary, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
