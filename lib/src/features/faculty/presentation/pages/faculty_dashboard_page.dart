import 'package:flutter/material.dart';

class FacultyDashboardPage extends StatelessWidget {
  const FacultyDashboardPage({super.key});

  static const _bg = Color(0xFF0D1F3C);
  static const _card = Color(0xFF111D35);
  static const _border = Color(0xFF1E3055);
  static const _accent = Color(0xFF1565C0);
  static const _gold = Color(0xFFD4A843);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Header
            Container(
              width: double.infinity,
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
                    backgroundColor: Colors.white24,
                    child: Text('RK', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Welcome back, Dr. R. Kumaran',
                          style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Associate Professor | Department of CSE | KSRCE',
                          style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Monday, 24 Feb 2026 | Even Semester 2025-26',
                          style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Stats Cards
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _StatCard(icon: Icons.people, label: 'Total Students', value: '248', color: _accent),
                _StatCard(icon: Icons.menu_book, label: 'Courses Teaching', value: '4', color: Colors.teal),
                _StatCard(icon: Icons.bar_chart, label: 'Avg Attendance', value: '82.4%', color: Colors.orange),
                _StatCard(icon: Icons.assignment_late, label: 'Pending Evaluations', value: '37', color: Colors.redAccent),
                _StatCard(icon: Icons.class_, label: 'Classes Today', value: '4', color: _gold),
                _StatCard(icon: Icons.notifications_active, label: 'Notifications', value: '6', color: Colors.purple),
              ],
            ),
            const SizedBox(height: 28),

            // Today's Schedule
            const Text("Today's Schedule", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ..._buildTodaySchedule(),
            const SizedBox(height: 28),

            // Quick Actions
            const Text('Quick Actions', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _QuickAction(icon: Icons.fact_check, label: 'Mark Attendance', color: _accent),
                _QuickAction(icon: Icons.grading, label: 'Enter Grades', color: Colors.teal),
                _QuickAction(icon: Icons.assignment_add, label: 'Create Assignment', color: Colors.orange),
                _QuickAction(icon: Icons.send, label: 'Send Notification', color: Colors.purple),
                _QuickAction(icon: Icons.upload_file, label: 'Upload Syllabus', color: _gold),
                _QuickAction(icon: Icons.analytics, label: 'View Reports', color: Colors.redAccent),
              ],
            ),
            const SizedBox(height: 28),

            // Recent Notifications
            const Text('Recent Notifications', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _NotificationTile(
              icon: Icons.event,
              title: 'Faculty Senate Meeting',
              subtitle: 'Meeting scheduled for 26 Feb 2026, 10:00 AM at Senate Hall',
              time: '2h ago',
              color: _accent,
            ),
            _NotificationTile(
              icon: Icons.assignment,
              title: 'Internal Assessment - II Deadline',
              subtitle: 'Marks entry deadline: 28 Feb 2026 for all courses',
              time: '5h ago',
              color: Colors.orange,
            ),
            _NotificationTile(
              icon: Icons.campaign,
              title: 'Anna University Circular',
              subtitle: 'Revised academic calendar for Even Semester 2025-26 released',
              time: '1d ago',
              color: _gold,
            ),
            _NotificationTile(
              icon: Icons.science,
              title: 'Research Grant Update',
              subtitle: 'AICTE RPS grant disbursement - second installment approved',
              time: '2d ago',
              color: Colors.teal,
            ),
            _NotificationTile(
              icon: Icons.warning_amber,
              title: 'Low Attendance Alert',
              subtitle: '8 students in CS3501 below 75% attendance threshold',
              time: '2d ago',
              color: Colors.redAccent,
            ),
            _NotificationTile(
              icon: Icons.event_note,
              title: 'Department Technical Symposium',
              subtitle: 'CyberQuest 2026 - Volunteer faculty meeting on 27 Feb',
              time: '3d ago',
              color: Colors.purple,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildTodaySchedule() {
    final schedule = [
      {'time': '08:30 - 09:20', 'course': 'CS3501 - Compiler Design', 'section': 'A', 'room': 'CSE Lab 3 (Room 301)', 'type': 'Theory'},
      {'time': '09:20 - 10:10', 'course': 'CS3501 - Compiler Design', 'section': 'B', 'room': 'Room 405', 'type': 'Theory'},
      {'time': '11:00 - 11:50', 'course': 'CS3691 - Embedded Systems & IoT', 'section': 'A', 'room': 'Room 302', 'type': 'Theory'},
      {'time': '14:00 - 15:40', 'course': 'CS3511 - Compiler Design Lab', 'section': 'A (Batch 1)', 'room': 'CSE Lab 2', 'type': 'Lab'},
    ];

    return schedule.map((s) {
      return Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _border),
        ),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 50,
              decoration: BoxDecoration(
                color: s['type'] == 'Lab' ? _gold : _accent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 16),
            SizedBox(
              width: 130,
              child: Text(s['time']!, style: const TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500)),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(s['course']!, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text('Section ${s['section']} | ${s['room']}', style: const TextStyle(color: Colors.white54, fontSize: 12)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: s['type'] == 'Lab' ? _gold.withOpacity(0.15) : _accent.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(s['type']!, style: TextStyle(color: s['type'] == 'Lab' ? _gold : _accent, fontSize: 12)),
            ),
          ],
        ),
      );
    }).toList();
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  const _StatCard({required this.icon, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF111D35),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF1E3055)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Colors.white54, fontSize: 13)),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _QuickAction({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {},
        child: Container(
          width: 150,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 8),
              Text(label, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w500), textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String time;
  final Color color;
  const _NotificationTile({required this.icon, required this.title, required this.subtitle, required this.time, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF111D35),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF1E3055)),
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 20, backgroundColor: color.withOpacity(0.15), child: Icon(icon, color: color, size: 20)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(height: 3),
                Text(subtitle, style: const TextStyle(color: Colors.white54, fontSize: 12)),
              ],
            ),
          ),
          Text(time, style: const TextStyle(color: Colors.white38, fontSize: 11)),
        ],
      ),
    );
  }
}
