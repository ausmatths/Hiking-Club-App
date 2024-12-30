import 'package:flutter/material.dart';
import '../models/notification.dart';

class NotificationScreen extends StatelessWidget {
  final List<HikingNotification> notifications;
  final Function(String) onNotificationRead;

  const NotificationScreen({
    Key? key,
    required this.notifications,
    required this.onNotificationRead,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: notifications.isEmpty
          ? const Center(
        child: Text('No notifications'),
      )
          : ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return ListTile(
            title: Text(notification.title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(notification.message),
                Text(
                  '${notification.timestamp.day}/${notification.timestamp.month}/${notification.timestamp.year}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            tileColor: notification.isRead ? null : Colors.blue[50],
            onTap: () {
              onNotificationRead(notification.id);
            },
          );
        },
      ),
    );
  }
}