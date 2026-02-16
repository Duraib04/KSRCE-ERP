import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/student_data_service.dart';
import '../../domain/student_models.dart' as models;

// Use StudentNotification instead of Notification to avoid conflict with Flutter's Notification
typedef StudentNotification = models.Notification;

class StudentNotificationsPage extends StatefulWidget {
  final String userId;

  const StudentNotificationsPage({super.key, required this.userId});

  @override
  State<StudentNotificationsPage> createState() => _StudentNotificationsPageState();
}

class _StudentNotificationsPageState extends State<StudentNotificationsPage> {
  List<StudentNotification>? _notifications;
  bool _isLoading = true;
  String _filter = 'all'; // all, announcement, exam, assignment, attendance, result, event, alert

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    try {
      final notifications = await StudentDataService.getNotifications(widget.userId);
      if (mounted) {
        setState(() {
          _notifications = notifications;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading notifications: $e')),
        );
      }
    }
  }

  List<StudentNotification> get _filteredNotifications {
    if (_notifications == null) return [];
    if (_filter == 'all') return _notifications!;
    
    models.NotificationType type;
    switch (_filter) {
      case 'announcement':
        type = models.NotificationType.general;
        break;
      case 'exam':
        type = models.NotificationType.exam;
        break;
      case 'assignment':
        type = models.NotificationType.assignment;
        break;
      case 'attendance':
        type = models.NotificationType.attendance;
        break;
      case 'result':
        type = models.NotificationType.event;
        break;
      case 'event':
        type = models.NotificationType.event;
        break;
      case 'alert':
        type = models.NotificationType.urgent;
        break;
      default:
        return _notifications!;
    }
    
    return _notifications!.where((n) => n?.type == type).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            initialValue: _filter,
            onSelected: (value) => setState(() => _filter = value),
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'all', child: Text('All')),
              const PopupMenuItem(value: 'announcement', child: Text('Announcements')),
              const PopupMenuItem(value: 'exam', child: Text('Exams')),
              const PopupMenuItem(value: 'assignment', child: Text('Assignments')),
              const PopupMenuItem(value: 'attendance', child: Text('Attendance')),
              const PopupMenuItem(value: 'result', child: Text('Results')),
              const PopupMenuItem(value: 'event', child: Text('Events')),
              const PopupMenuItem(value: 'alert', child: Text('Alerts')),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _notifications == null || _notifications!.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: _loadNotifications,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredNotifications.length,
                    itemBuilder: (context, index) {
                      final notification = _filteredNotifications[index];
                      return _buildNotificationCard(notification);
                    },
                  ),
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_none, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No Notifications',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(StudentNotification notification) {
    final isNew = !notification.isRead;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: isNew ? Colors.blue[50] : null,
      child: InkWell(
        onTap: () => _showNotificationDetails(notification),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _getTypeColor(notification.type).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  _getTypeIcon(notification.type),
                  color: _getTypeColor(notification.type),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: TextStyle(
                              fontWeight: isNew ? FontWeight.bold : FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        if (isNew)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      notification.message,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 12, color: Colors.grey[500]),
                        const SizedBox(width: 4),
                        Text(
                          _formatDateTime(notification.timestamp),
                          style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showNotificationDetails(StudentNotification notification) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _getTypeColor(notification.type).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getTypeIcon(notification.type),
                      color: _getTypeColor(notification.type),
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getTypeName(notification.type),
                          style: TextStyle(
                            fontSize: 12,
                            color: _getTypeColor(notification.type),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _formatDateTime(notification.timestamp),
                          style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                notification.title,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              Text(
                notification.message,
                style: const TextStyle(fontSize: 16, height: 1.6),
              ),
              const SizedBox(height: 24),
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
      ),
    );
  }

  IconData _getTypeIcon(models.NotificationType type) {
    switch (type) {
      case models.NotificationType.general:
        return Icons.info;
      case models.NotificationType.exam:
        return Icons.assignment;
      case models.NotificationType.assignment:
        return Icons.task;
      case models.NotificationType.attendance:
        return Icons.how_to_reg;
      case models.NotificationType.fee:
        return Icons.payment;
      case models.NotificationType.event:
        return Icons.event;
      case models.NotificationType.urgent:
        return Icons.warning;
    }
    return Icons.info;
  }

  Color _getTypeColor(models.NotificationType type) {
    switch (type) {
      case models.NotificationType.general:
        return Colors.blue;
      case models.NotificationType.exam:
        return Colors.purple;
      case models.NotificationType.assignment:
        return Colors.orange;
      case models.NotificationType.attendance:
        return Colors.green;
      case models.NotificationType.fee:
        return Colors.blueGrey;
      case models.NotificationType.event:
        return Colors.pink;
      case models.NotificationType.urgent:
        return Colors.red;
    }
    return Colors.grey;
  }

  String _getTypeName(models.NotificationType type) {
    switch (type) {
      case models.NotificationType.general:
        return 'GENERAL';
      case models.NotificationType.exam:
        return 'EXAM';
      case models.NotificationType.assignment:
        return 'ASSIGNMENT';
      case models.NotificationType.attendance:
        return 'ATTENDANCE';
      case models.NotificationType.fee:
        return 'FEE';
      case models.NotificationType.event:
        return 'EVENT';
      case models.NotificationType.urgent:
        return 'URGENT';
    }
    return 'UNKNOWN';
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }
}
