import 'package:flutter/material.dart';

class StudentDashboardPage extends StatelessWidget {
  const StudentDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1F3C),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeHeader(),
            const SizedBox(height: 24),
            _buildStatsRow(),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 3, child: _buildTodayTimetable()),
                const SizedBox(width: 24),
                Expanded(flex: 2, child: _buildRecentNotifications()),
              ],
            ),
            const SizedBox(height: 24),
            _buildQuickActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1565C0), Color(0xFF0D47A1)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 32,
            backgroundColor: Color(0xFFD4A843),
            child: Text('RA', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Welcome back, Rahul Anand! 👋', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
              SizedBox(height: 4),
              Text('B.E. Computer Science & Engineering | 3rd Year | Sem 5', style: TextStyle(fontSize: 14, color: Colors.white70)),
              Text('Roll No: 727622BCS052 | Section: B', style: TextStyle(fontSize: 13, color: Colors.white60)),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: const [
              Text('Academic Year 2025-26', style: TextStyle(color: Colors.white70, fontSize: 13)),
              SizedBox(height: 4),
              Text('Tuesday, 24 Feb 2026', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    final stats = [
      {'title': 'Attendance', 'value': '87%', 'icon': Icons.check_circle_outline, 'color': Colors.green},
      {'title': 'CGPA', 'value': '8.42', 'icon': Icons.school, 'color': const Color(0xFFD4A843)},
      {'title': 'Pending Assignments', 'value': '3', 'icon': Icons.assignment_late, 'color': Colors.orange},
      {'title': 'Upcoming Exams', 'value': '2', 'icon': Icons.event_note, 'color': Colors.redAccent},
    ];
    return Row(
      children: stats.map((s) {
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF111D35),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF1E3055)),
            ),
            child: Column(
              children: [
                Icon(s['icon'] as IconData, color: s['color'] as Color, size: 32),
                const SizedBox(height: 12),
                Text(s['value'] as String, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 4),
                Text(s['title'] as String, style: const TextStyle(color: Colors.white70, fontSize: 13)),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTodayTimetable() {
    final periods = [
      {'time': '08:30 - 09:20', 'subject': 'CS3501 - Compiler Design', 'room': 'Room 301', 'faculty': 'Dr. K. Ramesh', 'current': false},
      {'time': '09:20 - 10:10', 'subject': 'CS3591 - Computer Networks', 'room': 'Room 302', 'faculty': 'Prof. S. Lakshmi', 'current': false},
      {'time': '10:20 - 11:10', 'subject': 'CS3551 - Distributed Computing', 'room': 'Room 301', 'faculty': 'Dr. M. Venkatesh', 'current': true},
      {'time': '11:10 - 12:00', 'subject': 'MA3391 - Probability & Statistics', 'room': 'Room 201', 'faculty': 'Dr. P. Anitha', 'current': false},
      {'time': '01:00 - 01:50', 'subject': 'GE3591 - Environmental Science', 'room': 'Room 105', 'faculty': 'Prof. R. Devi', 'current': false},
      {'time': '01:50 - 03:30', 'subject': 'CS3512 - Compiler Design Lab', 'room': 'Lab 4', 'faculty': 'Dr. K. Ramesh', 'current': false},
    ];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF111D35),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1E3055)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.today, color: Color(0xFFD4A843), size: 20),
              SizedBox(width: 8),
              Text("Today's Timetable", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            ],
          ),
          const SizedBox(height: 16),
          ...periods.map((p) {
            final isCurrent = p['current'] as bool;
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isCurrent ? const Color(0xFF1565C0).withOpacity(0.2) : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: isCurrent ? Border.all(color: const Color(0xFF1565C0)) : null,
              ),
              child: Row(
                children: [
                  SizedBox(width: 120, child: Text(p['time'] as String, style: TextStyle(color: isCurrent ? Colors.white : Colors.white70, fontSize: 13, fontWeight: FontWeight.w500))),
                  Expanded(child: Text(p['subject'] as String, style: TextStyle(color: isCurrent ? Colors.white : Colors.white70, fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal))),
                  SizedBox(width: 80, child: Text(p['room'] as String, style: const TextStyle(color: Colors.white54, fontSize: 13))),
                  SizedBox(width: 140, child: Text(p['faculty'] as String, style: const TextStyle(color: Colors.white54, fontSize: 13))),
                  if (isCurrent) Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: const Color(0xFF1565C0), borderRadius: BorderRadius.circular(4)), child: const Text('NOW', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold))),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildRecentNotifications() {
    final notifications = [
      {'title': 'Internal Assessment 2 Schedule Released', 'time': '2 hours ago', 'icon': Icons.event_note, 'color': Colors.orange},
      {'title': 'CS3501 Assignment 3 Due Tomorrow', 'time': '5 hours ago', 'icon': Icons.assignment_late, 'color': Colors.redAccent},
      {'title': 'Library Book Return Reminder', 'time': '1 day ago', 'icon': Icons.local_library, 'color': Colors.blue},
      {'title': 'Placement Drive: TCS on 28 Feb', 'time': '2 days ago', 'icon': Icons.business, 'color': const Color(0xFFD4A843)},
    ];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF111D35),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1E3055)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.notifications_active, color: Color(0xFFD4A843), size: 20),
              SizedBox(width: 8),
              Text('Recent Notifications', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            ],
          ),
          const SizedBox(height: 16),
          ...notifications.map((n) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFF0D1F3C), borderRadius: BorderRadius.circular(8)),
            child: Row(
              children: [
                Icon(n['icon'] as IconData, color: n['color'] as Color, size: 20),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(n['title'] as String, style: const TextStyle(color: Colors.white, fontSize: 13)),
                  const SizedBox(height: 2),
                  Text(n['time'] as String, style: const TextStyle(color: Colors.white54, fontSize: 11)),
                ])),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      {'label': 'View Attendance', 'icon': Icons.fact_check, 'color': Colors.green},
      {'label': 'View Results', 'icon': Icons.assessment, 'color': const Color(0xFFD4A843)},
      {'label': 'My Courses', 'icon': Icons.menu_book, 'color': Colors.blue},
      {'label': 'Assignments', 'icon': Icons.assignment, 'color': Colors.orange},
      {'label': 'Exam Schedule', 'icon': Icons.event, 'color': Colors.redAccent},
      {'label': 'Fee Payment', 'icon': Icons.payment, 'color': Colors.teal},
    ];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF111D35),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1E3055)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Quick Actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 12,
            children: actions.map((a) => ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(a['icon'] as IconData, size: 18),
              label: Text(a['label'] as String),
              style: ElevatedButton.styleFrom(
                backgroundColor: (a['color'] as Color).withOpacity(0.15),
                foregroundColor: a['color'] as Color,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }
}
