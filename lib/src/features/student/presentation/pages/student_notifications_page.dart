import 'package:flutter/material.dart';

class StudentNotificationsPage extends StatefulWidget {
  const StudentNotificationsPage({super.key});

  @override
  State<StudentNotificationsPage> createState() => _StudentNotificationsPageState();
}

class _StudentNotificationsPageState extends State<StudentNotificationsPage> {
  final List<Map<String, dynamic>> _notifications = [
    {'title': 'Internal Assessment 2 Schedule Released', 'desc': 'IA-2 examinations for Semester 5 will commence from 02 March 2026. Detailed schedule has been uploaded.', 'time': '2 hours ago', 'type': 'Academic', 'icon': Icons.event_note, 'color': Colors.orange, 'read': false},
    {'title': 'CS3501 Assignment 3 - Lexical Analyzer', 'desc': 'New assignment posted for Compiler Design. Implement a Lexical Analyzer using Lex tool. Due: 25 Feb 2026.', 'time': '5 hours ago', 'type': 'Academic', 'icon': Icons.assignment, 'color': Colors.blue, 'read': false},
    {'title': 'Library Book Return Reminder', 'desc': 'Your book "Probability & Statistics for Engineers" is overdue. Please return it at the earliest to avoid fine accumulation.', 'time': '1 day ago', 'type': 'Administrative', 'icon': Icons.local_library, 'color': Colors.redAccent, 'read': false},
    {'title': 'TCS Campus Drive - 28 Feb 2026', 'desc': 'TCS is visiting campus for recruitment on 28th February. Eligible: B.E/B.Tech (CSE, IT, ECE) with CGPA >= 7.0. Register before 26 Feb.', 'time': '2 days ago', 'type': 'Events', 'icon': Icons.business, 'color': const Color(0xFFD4A843), 'read': true},
    {'title': 'Semester Fee Payment Reminder', 'desc': 'Pending fee amount of Rs. 50,000 for Semester 5 is due by 15 March 2026. Late payment will attract a penalty of Rs. 100/day.', 'time': '3 days ago', 'type': 'Administrative', 'icon': Icons.payment, 'color': Colors.orange, 'read': true},
    {'title': 'Annual Sports Day - 10 March 2026', 'desc': 'Annual Sports Day will be held on 10 March 2026 at the college ground. All students are encouraged to participate. Register events by 05 March.', 'time': '4 days ago', 'type': 'Events', 'icon': Icons.sports, 'color': Colors.green, 'read': true},
    {'title': 'CS3591 Guest Lecture', 'desc': 'Guest lecture on "5G and Beyond" by Dr. Arvind Kumar from IIT Madras on 27 Feb 2026 at Seminar Hall. Attendance is mandatory for CN students.', 'time': '5 days ago', 'type': 'Academic', 'icon': Icons.school, 'color': Colors.purple, 'read': true},
    {'title': 'Holiday Notice - Maha Shivaratri', 'desc': 'College will remain closed on 28 February 2026 (Saturday) on account of Maha Shivaratri.', 'time': '1 week ago', 'type': 'Administrative', 'icon': Icons.celebration, 'color': Colors.teal, 'read': true},
    {'title': 'Hackathon Registration Open', 'desc': 'KSRCE Hackathon 2026 - "InnoVate" registration is now open. Team size: 3-4. Theme: Sustainable Development. Last date: 05 March 2026.', 'time': '1 week ago', 'type': 'Events', 'icon': Icons.code, 'color': Colors.cyan, 'read': true},
    {'title': 'Attendance Warning - CS3551', 'desc': 'Your attendance in Distributed Computing is 83.3%. Maintain minimum 75% to be eligible for end semester exam.', 'time': '10 days ago', 'type': 'Academic', 'icon': Icons.warning, 'color': Colors.orange, 'read': true},
  ];

  @override
  Widget build(BuildContext context) {
    int unread = _notifications.where((n) => !(n['read'] as bool)).length;
    return Scaffold(
      backgroundColor: const Color(0xFF0D1F3C),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.notifications, color: Color(0xFFD4A843), size: 28),
                const SizedBox(width: 12),
                const Text('Notifications', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(width: 12),
                if (unread > 0) Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(12)),
                  child: Text('$unread new', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () => setState(() { for (var n in _notifications) n['read'] = true; }),
                  icon: const Icon(Icons.done_all, size: 16),
                  label: const Text('Mark all as read'),
                  style: TextButton.styleFrom(foregroundColor: const Color(0xFF1565C0)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text('Stay updated with academic and college activities', style: TextStyle(color: Colors.white60, fontSize: 14)),
            const SizedBox(height: 20),
            _buildFilterChips(),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _notifications.length,
                itemBuilder: (context, index) => _buildNotificationCard(_notifications[index], index),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = ['All', 'Academic', 'Administrative', 'Events'];
    return Row(
      children: filters.map((f) => Padding(
        padding: const EdgeInsets.only(right: 10),
        child: FilterChip(
          label: Text(f),
          selected: f == 'All',
          onSelected: (v) {},
          selectedColor: const Color(0xFF1565C0).withOpacity(0.3),
          backgroundColor: const Color(0xFF111D35),
          labelStyle: TextStyle(color: f == 'All' ? const Color(0xFF64B5F6) : Colors.white54, fontSize: 13),
          side: BorderSide(color: f == 'All' ? const Color(0xFF1565C0) : const Color(0xFF1E3055)),
        ),
      )).toList(),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> n, int index) {
    final isRead = n['read'] as bool;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isRead ? const Color(0xFF111D35) : const Color(0xFF111D35).withOpacity(0.8),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isRead ? const Color(0xFF1E3055) : (n['color'] as Color).withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (n['color'] as Color).withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(n['icon'] as IconData, color: n['color'] as Color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                if (!isRead) Container(width: 8, height: 8, margin: const EdgeInsets.only(right: 8), decoration: BoxDecoration(color: const Color(0xFF1565C0), borderRadius: BorderRadius.circular(4))),
                Expanded(child: Text(n['title'] as String, style: TextStyle(color: Colors.white, fontWeight: isRead ? FontWeight.normal : FontWeight.bold, fontSize: 14))),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: (n['color'] as Color).withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                  child: Text(n['type'] as String, style: TextStyle(color: n['color'] as Color, fontSize: 11)),
                ),
              ]),
              const SizedBox(height: 6),
              Text(n['desc'] as String, style: const TextStyle(color: Colors.white54, fontSize: 13)),
              const SizedBox(height: 6),
              Text(n['time'] as String, style: const TextStyle(color: Colors.white38, fontSize: 11)),
            ],
          )),
        ],
      ),
    );
  }
}
