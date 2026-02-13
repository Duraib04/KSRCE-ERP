import 'package:flutter/material.dart';

class StudentAnnouncementsPage extends StatefulWidget {
  final String userId;

  const StudentAnnouncementsPage({Key? key, required this.userId})
      : super(key: key);

  @override
  State<StudentAnnouncementsPage> createState() =>
      _StudentAnnouncementsPageState();
}

class _StudentAnnouncementsPageState extends State<StudentAnnouncementsPage> {
  late List<Announcement> announcements;

  @override
  void initState() {
    super.initState();
    _loadAnnouncements();
  }

  void _loadAnnouncements() {
    announcements = [
      Announcement(
        title: 'Semester Exam Schedule Released',
        content:
            'The semester exam schedule for IV semester has been released. Please check the examination section for more details.',
        postedBy: 'Dr. Rajesh Kumar (HOD)',
        postedDate: DateTime.now().subtract(const Duration(hours: 2)),
        priority: 'High',
        category: 'Academic',
      ),
      Announcement(
        title: 'Mid-Semester Evaluation Results',
        content:
            'Mid-semester evaluation results are now available. Visit the grades section to view your marks and feedback.',
        postedBy: 'Academic Office',
        postedDate: DateTime.now().subtract(const Duration(days: 1)),
        priority: 'Medium',
        category: 'Grades',
      ),
      Announcement(
        title: 'Library Extension Closed for Maintenance',
        content:
            'The library extension will be closed from 15th Feb to 17th Feb for maintenance. Please plan accordingly.',
        postedBy: 'Library Department',
        postedDate: DateTime.now().subtract(const Duration(days: 2)),
        priority: 'Low',
        category: 'Campus',
      ),
      Announcement(
        title: 'Internship Opportunity: Tech Companies',
        content:
            'Multiple tech companies are offering internship opportunities. Visit the placement office for applications.',
        postedBy: 'Placement Cell',
        postedDate: DateTime.now().subtract(const Duration(days: 3)),
        priority: 'High',
        category: 'Placement',
      ),
      Announcement(
        title: 'Club Membership Drive 2026',
        content:
            'All clubs are recruiting new members. Check the bulletin board for club details and registration information.',
        postedBy: 'Student Affairs',
        postedDate: DateTime.now().subtract(const Duration(days: 4)),
        priority: 'Low',
        category: 'Activities',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Announcements'),
        elevation: 0,
      ),
      body: announcements.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_off,
                      size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'No announcements',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: announcements.length,
              itemBuilder: (context, index) {
                return _buildAnnouncementCard(announcements[index]);
              },
            ),
    );
  }

  Widget _buildAnnouncementCard(Announcement announcement) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: () {
          _showAnnouncementDetails(announcement);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                announcement.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: _getPriorityColor(announcement.priority),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                announcement.priority,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ],
              ),
              Text(
                announcement.content,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        announcement.postedBy,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        _formatTime(announcement.postedDate),
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  Chip(
                    label: Text(
                      announcement.category,
                      style: const TextStyle(fontSize: 11),
                    ),
                    backgroundColor: Colors.blue.shade100,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAnnouncementDetails(Announcement announcement) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(announcement.title),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(announcement.content),
              const SizedBox(height: 16),
              Text(
                'Posted by: ${announcement.postedBy}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                'Date: ${_formatTime(announcement.postedDate)}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      case 'Low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inHours < 1) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }
}

class Announcement {
  final String title;
  final String content;
  final String postedBy;
  final DateTime postedDate;
  final String priority;
  final String category;

  Announcement({
    required this.title,
    required this.content,
    required this.postedBy,
    required this.postedDate,
    required this.priority,
    required this.category,
  });
}
