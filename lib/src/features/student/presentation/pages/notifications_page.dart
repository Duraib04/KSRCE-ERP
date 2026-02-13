import 'package:flutter/material.dart';

class StudentNotificationsPage extends StatefulWidget {
  final String userId;

  const StudentNotificationsPage({Key? key, required this.userId})
      : super(key: key);

  @override
  State<StudentNotificationsPage> createState() =>
      _StudentNotificationsPageState();
}

class _StudentNotificationsPageState extends State<StudentNotificationsPage> {
  late List<NotificationItem> notifications;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  void _loadNotifications() {
    notifications = [
      NotificationItem(
        id: 'N001',
        title: 'Semester Exam Schedule Released',
        message: 'Check the portal for your semester exam schedule',
        category: 'Academic',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isRead: false,
      ),
      NotificationItem(
        id: 'N002',
        title: 'Assignment Submission Deadline',
        message: 'CS201 assignment due on 30th Jan 2024',
        category: 'Academic',
        timestamp: DateTime.now().subtract(const Duration(hours: 6)),
        isRead: false,
      ),
      NotificationItem(
        id: 'N003',
        title: 'Fee Payment Reminder',
        message: 'Semester fee pending. Pay before 25th Jan',
        category: 'Finance',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        isRead: true,
      ),
      NotificationItem(
        id: 'N004',
        title: 'Grades Published',
        message: 'Midterm grades for all subjects are now available',
        category: 'Academic',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        isRead: true,
      ),
      NotificationItem(
        id: 'N005',
        title: 'Events: Technical Seminar',
        message: 'Join us for a technical seminar on AI & ML',
        category: 'Events',
        timestamp: DateTime.now().subtract(const Duration(days: 3)),
        isRead: true,
      ),
    ];
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Academic':
        return Colors.blue;
      case 'Finance':
        return Colors.orange;
      case 'Events':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            onPressed: () {
              setState(() {
                for (var notif in notifications) {
                  notif.isRead = true;
                }
              });
            },
            tooltip: 'Mark all as read',
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return _buildNotificationCard(notifications[index]);
        },
      ),
    );
  }

  Widget _buildNotificationCard(NotificationItem notification) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: notification.isRead ? Colors.white : Colors.blue.shade50,
      child: InkWell(
        onTap: () {
          setState(() {
            notification.isRead = true;
          });
          _showNotificationDetails(notification);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: _getCategoryColor(notification.category)
                          .withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Icon(
                        _getCategoryIcon(notification.category),
                        color: _getCategoryColor(notification.category),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                notification.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            if (!notification.isRead)
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          notification.message,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Chip(
                              label: Text(notification.category),
                              backgroundColor:
                                  _getCategoryColor(notification.category)
                                       .withValues(alpha: 0.15),
                              labelStyle: TextStyle(
                                fontSize: 11,
                                color:
                                    _getCategoryColor(notification.category),
                              ),
                            ),
                            Text(
                              _formatTime(notification.timestamp),
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Academic':
        return Icons.school;
      case 'Finance':
        return Icons.attach_money;
      case 'Events':
        return Icons.event;
      default:
        return Icons.notifications;
    }
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  void _showNotificationDetails(NotificationItem notification) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              notification.message,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  label: Text(notification.category),
                  backgroundColor:
                       _getCategoryColor(notification.category).withValues(alpha: 0.15),
                ),
                Text(
                  _formatTime(notification.timestamp),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final String category;
  final DateTime timestamp;
  bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.category,
    required this.timestamp,
    required this.isRead,
  });
}
