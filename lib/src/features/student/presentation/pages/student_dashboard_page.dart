import 'package:flutter/material.dart';

class StudentDashboardPage extends StatelessWidget {
  const StudentDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1F3C),
      body: LayoutBuilder(builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 700;
        return SingleChildScrollView(
          padding: EdgeInsets.all(isMobile ? 16 : 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeHeader(isMobile),
              const SizedBox(height: 24),
              _buildStatsRow(isMobile, constraints.maxWidth),
              const SizedBox(height: 24),
              if (isMobile) ...[
                _buildTodayTimetable(isMobile),
                const SizedBox(height: 16),
                _buildRecentNotifications(),
              ] else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: _buildTodayTimetable(isMobile)),
                    const SizedBox(width: 24),
                    Expanded(flex: 2, child: _buildRecentNotifications()),
                  ],
                ),
              const SizedBox(height: 24),
              _buildQuickActions(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildWelcomeHeader(bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF1565C0), Color(0xFF0D47A1)]),
        borderRadius: BorderRadius.circular(16),
      ),
      child: isMobile
        ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              const CircleAvatar(radius: 24, backgroundColor: Color(0xFFD4A843),
                child: Text('RA', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white))),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
                Text('Welcome back, Rahul!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                SizedBox(height: 2),
                Text('B.E. CSE | 3rd Year | Sem 5', style: TextStyle(fontSize: 12, color: Colors.white70)),
              ])),
            ]),
            const SizedBox(height: 12),
            Text('Roll: 727622BCS052 | Sec: B', style: const TextStyle(fontSize: 12, color: Colors.white60)),
            const SizedBox(height: 4),
            Text('Tuesday, 24 Feb 2026', style: const TextStyle(color: Colors.white70, fontSize: 12)),
          ])
        : Row(children: [
            const CircleAvatar(radius: 32, backgroundColor: Color(0xFFD4A843),
              child: Text('RA', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white))),
            const SizedBox(width: 20),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
              Text('Welcome back, Rahul Anand!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
              SizedBox(height: 4),
              Text('B.E. Computer Science & Engineering | 3rd Year | Sem 5', style: TextStyle(fontSize: 14, color: Colors.white70)),
              Text('Roll No: 727622BCS052 | Section: B', style: TextStyle(fontSize: 13, color: Colors.white60)),
            ])),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: const [
              Text('Academic Year 2025-26', style: TextStyle(color: Colors.white70, fontSize: 13)),
              SizedBox(height: 4),
              Text('Tuesday, 24 Feb 2026', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500)),
            ]),
          ]),
    );
  }

  Widget _buildStatsRow(bool isMobile, double maxWidth) {
    final stats = [
      {'title': 'Attendance', 'value': '87%', 'icon': Icons.check_circle_outline, 'color': Colors.green},
      {'title': 'CGPA', 'value': '8.42', 'icon': Icons.school, 'color': const Color(0xFFD4A843)},
      {'title': 'Pending Tasks', 'value': '3', 'icon': Icons.assignment_late, 'color': Colors.orange},
      {'title': 'Exams', 'value': '2', 'icon': Icons.event_note, 'color': Colors.redAccent},
    ];
    if (isMobile) {
      return GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.5,
        children: stats.map((s) => _statCard(s)).toList(),
      );
    }
    return Row(
      children: stats.map((s) => Expanded(
        child: Container(margin: const EdgeInsets.symmetric(horizontal: 8), child: _statCard(s)),
      )).toList(),
    );
  }

  Widget _statCard(Map<String, Object> s) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF111D35), borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1E3055)),
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(s['icon'] as IconData, color: s['color'] as Color, size: 28),
        const SizedBox(height: 8),
        Text(s['value'] as String, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 4),
        Text(s['title'] as String, style: const TextStyle(color: Colors.white70, fontSize: 12), textAlign: TextAlign.center),
      ]),
    );
  }

  Widget _buildTodayTimetable(bool isMobile) {
    final periods = [
      {'time': '08:30 - 09:20', 'subject': 'CS3501 - Compiler Design', 'room': 'Room 301', 'faculty': 'Dr. K. Ramesh', 'current': false},
      {'time': '09:20 - 10:10', 'subject': 'CS3591 - Computer Networks', 'room': 'Room 302', 'faculty': 'Prof. S. Lakshmi', 'current': false},
      {'time': '10:20 - 11:10', 'subject': 'CS3551 - Distributed Computing', 'room': 'Room 301', 'faculty': 'Dr. M. Venkatesh', 'current': true},
      {'time': '11:10 - 12:00', 'subject': 'MA3391 - Probability & Statistics', 'room': 'Room 201', 'faculty': 'Dr. P. Anitha', 'current': false},
      {'time': '01:00 - 01:50', 'subject': 'GE3591 - Environmental Science', 'room': 'Room 105', 'faculty': 'Prof. R. Devi', 'current': false},
      {'time': '01:50 - 03:30', 'subject': 'CS3512 - Compiler Design Lab', 'room': 'Lab 4', 'faculty': 'Dr. K. Ramesh', 'current': false},
    ];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF111D35), borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1E3055)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: const [
          Icon(Icons.today, color: Color(0xFFD4A843), size: 20),
          SizedBox(width: 8),
          Text("Today's Timetable", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
        ]),
        const SizedBox(height: 12),
        ...periods.map((p) {
          final isCurrent = p['current'] as bool;
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: EdgeInsets.all(isMobile ? 10 : 12),
            decoration: BoxDecoration(
              color: isCurrent ? const Color(0xFF1565C0).withOpacity(0.2) : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: isCurrent ? Border.all(color: const Color(0xFF1565C0)) : null,
            ),
            child: isMobile
              ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Text(p['time'] as String, style: TextStyle(color: isCurrent ? Colors.white : Colors.white70, fontSize: 12, fontWeight: FontWeight.w600)),
                    const Spacer(),
                    if (isCurrent) Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: const Color(0xFF1565C0), borderRadius: BorderRadius.circular(4)), child: const Text('NOW', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))),
                    Text(p['room'] as String, style: const TextStyle(color: Colors.white54, fontSize: 11)),
                  ]),
                  const SizedBox(height: 4),
                  Text(p['subject'] as String, style: TextStyle(color: isCurrent ? Colors.white : Colors.white70, fontSize: 13, fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal)),
                  Text(p['faculty'] as String, style: const TextStyle(color: Colors.white38, fontSize: 11)),
                ])
              : Row(children: [
                  SizedBox(width: 120, child: Text(p['time'] as String, style: TextStyle(color: isCurrent ? Colors.white : Colors.white70, fontSize: 13, fontWeight: FontWeight.w500))),
                  Expanded(child: Text(p['subject'] as String, style: TextStyle(color: isCurrent ? Colors.white : Colors.white70, fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal))),
                  SizedBox(width: 80, child: Text(p['room'] as String, style: const TextStyle(color: Colors.white54, fontSize: 13))),
                  SizedBox(width: 140, child: Text(p['faculty'] as String, style: const TextStyle(color: Colors.white54, fontSize: 13))),
                  if (isCurrent) Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: const Color(0xFF1565C0), borderRadius: BorderRadius.circular(4)), child: const Text('NOW', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold))),
                ]),
          );
        }),
      ]),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF111D35), borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1E3055)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: const [
          Icon(Icons.notifications_active, color: Color(0xFFD4A843), size: 20),
          SizedBox(width: 8),
          Text('Recent Notifications', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
        ]),
        const SizedBox(height: 12),
        ...notifications.map((n) => Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: const Color(0xFF0D1F3C), borderRadius: BorderRadius.circular(8)),
          child: Row(children: [
            Icon(n['icon'] as IconData, color: n['color'] as Color, size: 20),
            const SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(n['title'] as String, style: const TextStyle(color: Colors.white, fontSize: 13)),
              const SizedBox(height: 2),
              Text(n['time'] as String, style: const TextStyle(color: Colors.white54, fontSize: 11)),
            ])),
          ]),
        )),
      ]),
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      {'label': 'Attendance', 'icon': Icons.fact_check, 'color': Colors.green},
      {'label': 'Results', 'icon': Icons.assessment, 'color': const Color(0xFFD4A843)},
      {'label': 'Courses', 'icon': Icons.menu_book, 'color': Colors.blue},
      {'label': 'Assignments', 'icon': Icons.assignment, 'color': Colors.orange},
      {'label': 'Exams', 'icon': Icons.event, 'color': Colors.redAccent},
      {'label': 'Fee Payment', 'icon': Icons.payment, 'color': Colors.teal},
    ];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF111D35), borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1E3055)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Quick Actions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 12),
        Wrap(spacing: 10, runSpacing: 10, children: actions.map((a) => ElevatedButton.icon(
          onPressed: () {},
          icon: Icon(a['icon'] as IconData, size: 16),
          label: Text(a['label'] as String, style: const TextStyle(fontSize: 12)),
          style: ElevatedButton.styleFrom(
            backgroundColor: (a['color'] as Color).withOpacity(0.15),
            foregroundColor: a['color'] as Color,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        )).toList()),
      ]),
    );
  }
}
