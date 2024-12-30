import 'package:flutter/material.dart';
import '../models/notification.dart';
import '../screens/notification_screen.dart';

class NotificationBell extends StatelessWidget {
  final List<HikingNotification> notifications;
  final Function(String) onNotificationRead;

  const NotificationBell({
    Key? key,
    required this.notifications,
    required this.onNotificationRead,
  }) : super(key: key);

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          icon: const Icon(Icons.notifications),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NotificationScreen(
                  notifications: notifications,
                  onNotificationRead: onNotificationRead,
                ),
              ),
            );
          },
        ),
        if (unreadCount > 0)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: const BoxConstraints(
                minWidth: 20,
                minHeight: 20,
              ),
              child: Text(
                unreadCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}