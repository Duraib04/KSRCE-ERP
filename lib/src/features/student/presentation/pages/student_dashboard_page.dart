import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class StudentDashboardPage extends StatelessWidget {
  const StudentDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
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
        gradient: const LinearGradient(colors: [AppColors.primary, Color(0xFF1A3A5C)]),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: isMobile
        ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              const CircleAvatar(radius: 24, backgroundColor: AppColors.accent,
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
            const CircleAvatar(radius: 32, backgroundColor: AppColors.accent,
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
      {'title': 'Attendance', 'value': '87%', 'icon': Icons.check_circle_outline, 'color': AppColors.secondary},
      {'title': 'CGPA', 'value': '8.42', 'icon': Icons.school, 'color': AppColors.primary},
      {'title': 'Pending Tasks', 'value': '3', 'icon': Icons.assignment_late, 'color': AppColors.accent},
      {'title': 'Exams', 'value': '2', 'icon': Icons.event_note, 'color': AppColors.error},
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
    final color = s['color'] as Color;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface, borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
          child: Icon(s['icon'] as IconData, color: color, size: 24),
        ),
        const SizedBox(height: 10),
        Text(s['value'] as String, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textDark)),
        const SizedBox(height: 4),
        Text(s['title'] as String, style: TextStyle(color: AppColors.textMedium, fontSize: 12), textAlign: TextAlign.center),
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
        color: AppColors.surface, borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(Icons.today, color: AppColors.primary, size: 20),
          const SizedBox(width: 8),
          Text("Today's Timetable", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
        ]),
        const Divider(height: 20),
        ...periods.map((p) {
          final isCurrent = p['current'] as bool;
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: EdgeInsets.all(isMobile ? 10 : 12),
            decoration: BoxDecoration(
              color: isCurrent ? AppColors.primary.withOpacity(0.08) : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: isCurrent ? Border.all(color: AppColors.primary.withOpacity(0.3)) : null,
            ),
            child: isMobile
              ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Text(p['time'] as String, style: TextStyle(color: isCurrent ? AppColors.primary : AppColors.textMedium, fontSize: 12, fontWeight: FontWeight.w600)),
                    const Spacer(),
                    if (isCurrent) Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(4)), child: const Text('NOW', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))),
                    Text(p['room'] as String, style: TextStyle(color: AppColors.textLight, fontSize: 11)),
                  ]),
                  const SizedBox(height: 4),
                  Text(p['subject'] as String, style: TextStyle(color: isCurrent ? AppColors.primary : AppColors.textDark, fontSize: 13, fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal)),
                  Text(p['faculty'] as String, style: TextStyle(color: AppColors.textLight, fontSize: 11)),
                ])
              : Row(children: [
                  SizedBox(width: 120, child: Text(p['time'] as String, style: TextStyle(color: isCurrent ? AppColors.primary : AppColors.textMedium, fontSize: 13, fontWeight: FontWeight.w500))),
                  Expanded(child: Text(p['subject'] as String, style: TextStyle(color: isCurrent ? AppColors.primary : AppColors.textDark, fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal))),
                  SizedBox(width: 80, child: Text(p['room'] as String, style: TextStyle(color: AppColors.textLight, fontSize: 13))),
                  SizedBox(width: 140, child: Text(p['faculty'] as String, style: TextStyle(color: AppColors.textLight, fontSize: 13))),
                  if (isCurrent) Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(4)), child: const Text('NOW', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold))),
                ]),
          );
        }),
      ]),
    );
  }

  Widget _buildRecentNotifications() {
    final notifications = [
      {'title': 'Internal Assessment 2 Schedule Released', 'time': '2 hours ago', 'icon': Icons.event_note, 'color': AppColors.accent},
      {'title': 'CS3501 Assignment 3 Due Tomorrow', 'time': '5 hours ago', 'icon': Icons.assignment_late, 'color': AppColors.error},
      {'title': 'Library Book Return Reminder', 'time': '1 day ago', 'icon': Icons.local_library, 'color': AppColors.primary},
      {'title': 'Placement Drive: TCS on 28 Feb', 'time': '2 days ago', 'icon': Icons.business, 'color': AppColors.secondary},
    ];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface, borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(Icons.notifications_active, color: AppColors.accent, size: 20),
          const SizedBox(width: 8),
          Text('Recent Notifications', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
        ]),
        const Divider(height: 20),
        ...notifications.map((n) => Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(8)),
          child: Row(children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(color: (n['color'] as Color).withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
              child: Icon(n['icon'] as IconData, color: n['color'] as Color, size: 18),
            ),
            const SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(n['title'] as String, style: TextStyle(color: AppColors.textDark, fontSize: 13, fontWeight: FontWeight.w500)),
              const SizedBox(height: 2),
              Text(n['time'] as String, style: TextStyle(color: AppColors.textLight, fontSize: 11)),
            ])),
          ]),
        )),
      ]),
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      {'label': 'Attendance', 'icon': Icons.fact_check, 'color': AppColors.secondary},
      {'label': 'Results', 'icon': Icons.assessment, 'color': AppColors.primary},
      {'label': 'Courses', 'icon': Icons.menu_book, 'color': const Color(0xFF3B82F6)},
      {'label': 'Assignments', 'icon': Icons.assignment, 'color': AppColors.accent},
      {'label': 'Exams', 'icon': Icons.event, 'color': AppColors.error},
      {'label': 'Fee Payment', 'icon': Icons.payment, 'color': const Color(0xFF14B8A6)},
    ];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface, borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Quick Actions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
        const Divider(height: 20),
        Wrap(spacing: 10, runSpacing: 10, children: actions.map((a) => ElevatedButton.icon(
          onPressed: () {},
          icon: Icon(a['icon'] as IconData, size: 16),
          label: Text(a['label'] as String, style: const TextStyle(fontSize: 12)),
          style: ElevatedButton.styleFrom(
            backgroundColor: (a['color'] as Color).withOpacity(0.1),
            foregroundColor: a['color'] as Color,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        )).toList()),
      ]),
    );
  }
}
