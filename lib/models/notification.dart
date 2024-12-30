class HikingNotification {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  bool isRead;

  HikingNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    this.isRead = false,
  });
}