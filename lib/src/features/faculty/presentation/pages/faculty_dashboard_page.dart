import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class FacultyDashboardPage extends StatelessWidget {
  const FacultyDashboardPage({super.key});

  static const _bg = AppColors.background;
  static const _card = AppColors.surface;
  static const _border = AppColors.border;
  static const _accent = AppColors.primary;
  static const _gold = AppColors.accent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: LayoutBuilder(builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 700;
        return SingleChildScrollView(
          padding: EdgeInsets.all(isMobile ? 16 : 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeHeader(isMobile),
              const SizedBox(height: 24),
              _buildStats(isMobile, constraints.maxWidth),
              const SizedBox(height: 28),
              Text("Today's Schedule", style: TextStyle(color: AppColors.textDark, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              ..._buildTodaySchedule(isMobile),
              const SizedBox(height: 28),
              Text('Quick Actions', style: TextStyle(color: AppColors.textDark, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _buildQuickActions(isMobile),
              const SizedBox(height: 28),
              Text('Recent Notifications', style: TextStyle(color: AppColors.textDark, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _NotificationTile(icon: Icons.event, title: 'Faculty Senate Meeting', subtitle: 'Meeting scheduled for 26 Feb 2026, 10:00 AM at Senate Hall', time: '2h ago', color: _accent),
              _NotificationTile(icon: Icons.assignment, title: 'Internal Assessment - II Deadline', subtitle: 'Marks entry deadline: 28 Feb 2026 for all courses', time: '5h ago', color: Colors.orange),
              _NotificationTile(icon: Icons.campaign, title: 'Anna University Circular', subtitle: 'Revised academic calendar for Even Semester 2025-26 released', time: '1d ago', color: _gold),
              _NotificationTile(icon: Icons.science, title: 'Research Grant Update', subtitle: 'AICTE RPS grant disbursement - second installment approved', time: '2d ago', color: Colors.teal),
              _NotificationTile(icon: Icons.warning_amber, title: 'Low Attendance Alert', subtitle: '8 students in CS3501 below 75% attendance threshold', time: '2d ago', color: Colors.redAccent),
              _NotificationTile(icon: Icons.event_note, title: 'Department Technical Symposium', subtitle: 'CyberQuest 2026 - Volunteer faculty meeting on 27 Feb', time: '3d ago', color: Colors.purple),
              const SizedBox(height: 16),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildWelcomeHeader(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [AppColors.primary, const Color(0xFF1A3A5C)]),
        boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))],
        borderRadius: BorderRadius.circular(16),
      ),
      child: isMobile
        ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              const CircleAvatar(radius: 24, backgroundColor: AppColors.border,
                child: Text('RK', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))),
              const SizedBox(width: 12),
              Expanded(child: Text('Welcome back, Dr. R. Kumaran', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))),
            ]),
            const SizedBox(height: 8),
            Text('Associate Professor | Dept. of CSE', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13)),
            const SizedBox(height: 4),
            Text('Mon, 24 Feb 2026 | Even Sem 2025-26', style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12)),
          ])
        : Row(children: [
            const CircleAvatar(radius: 32, backgroundColor: AppColors.border,
              child: Text('RK', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold))),
            const SizedBox(width: 20),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Welcome back, Dr. R. Kumaran', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text('Associate Professor | Department of CSE | KSRCE', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14)),
              const SizedBox(height: 4),
              Text('Monday, 24 Feb 2026 | Even Semester 2025-26', style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13)),
            ])),
          ]),
    );
  }

  Widget _buildStats(bool isMobile, double maxWidth) {
    final stats = [
      {'icon': Icons.people, 'label': 'Total Students', 'value': '248', 'color': _accent},
      {'icon': Icons.menu_book, 'label': 'Courses Teaching', 'value': '4', 'color': Colors.teal},
      {'icon': Icons.bar_chart, 'label': 'Avg Attendance', 'value': '82.4%', 'color': Colors.orange},
      {'icon': Icons.assignment_late, 'label': 'Pending Evaluations', 'value': '37', 'color': Colors.redAccent},
      {'icon': Icons.class_, 'label': 'Classes Today', 'value': '4', 'color': _gold},
      {'icon': Icons.notifications_active, 'label': 'Notifications', 'value': '6', 'color': Colors.purple},
    ];
    if (isMobile) {
      return GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.4,
        children: stats.map((s) => _buildStatCard(s)).toList(),
      );
    }
    return Wrap(spacing: 16, runSpacing: 16,
      children: stats.map((s) => SizedBox(width: 180, child: _buildStatCard(s))).toList(),
    );
  }

  Widget _buildStatCard(Map<String, Object> s) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _card, borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _border),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: (s['color'] as Color).withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
          child: Icon(s['icon'] as IconData, color: s['color'] as Color, size: 22),
        ),
        const SizedBox(height: 10),
        Text(s['value'] as String, style: TextStyle(color: AppColors.textDark, fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(s['label'] as String, style: const TextStyle(color: AppColors.textLight, fontSize: 12)),
      ]),
    );
  }

  List<Widget> _buildTodaySchedule(bool isMobile) {
    final schedule = [
      {'time': '08:30 - 09:20', 'course': 'CS3501 - Compiler Design', 'section': 'A', 'room': 'CSE Lab 3 (Room 301)', 'type': 'Theory'},
      {'time': '09:20 - 10:10', 'course': 'CS3501 - Compiler Design', 'section': 'B', 'room': 'Room 405', 'type': 'Theory'},
      {'time': '11:00 - 11:50', 'course': 'CS3691 - Embedded Systems & IoT', 'section': 'A', 'room': 'Room 302', 'type': 'Theory'},
      {'time': '14:00 - 15:40', 'course': 'CS3511 - Compiler Design Lab', 'section': 'A (Batch 1)', 'room': 'CSE Lab 2', 'type': 'Lab'},
    ];
    return schedule.map((s) {
      final isLab = s['type'] == 'Lab';
      return Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.all(isMobile ? 12 : 16),
        decoration: BoxDecoration(color: _card, borderRadius: BorderRadius.circular(12), border: Border.all(color: _border), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6, offset: const Offset(0, 1))]),
        child: isMobile
          ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(width: 4, height: 50, decoration: BoxDecoration(color: isLab ? _gold : _accent, borderRadius: BorderRadius.circular(2))),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Text(s['time']!, style: const TextStyle(color: AppColors.textMedium, fontSize: 12, fontWeight: FontWeight.w600)),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: (isLab ? _gold : _accent).withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
                    child: Text(s['type']!, style: TextStyle(color: isLab ? _gold : _accent, fontSize: 11)),
                  ),
                ]),
                const SizedBox(height: 4),
                Text(s['course']!, style: TextStyle(color: AppColors.textDark, fontSize: 13, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text('Sec ${s['section']} | ${s['room']}', style: const TextStyle(color: AppColors.textLight, fontSize: 11)),
              ])),
            ])
          : Row(children: [
              Container(width: 4, height: 50, decoration: BoxDecoration(color: isLab ? _gold : _accent, borderRadius: BorderRadius.circular(2))),
              const SizedBox(width: 16),
              SizedBox(width: 130, child: Text(s['time']!, style: const TextStyle(color: AppColors.textMedium, fontSize: 14, fontWeight: FontWeight.w500))),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(s['course']!, style: TextStyle(color: AppColors.textDark, fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text('Section ${s['section']} | ${s['room']}', style: const TextStyle(color: AppColors.textLight, fontSize: 12)),
              ])),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: (isLab ? _gold : _accent).withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
                child: Text(s['type']!, style: TextStyle(color: isLab ? _gold : _accent, fontSize: 12)),
              ),
            ]),
      );
    }).toList();
  }

  Widget _buildQuickActions(bool isMobile) {
    final actions = [
      {'icon': Icons.fact_check, 'label': 'Mark Attendance', 'color': _accent},
      {'icon': Icons.grading, 'label': 'Enter Grades', 'color': Colors.teal},
      {'icon': Icons.assignment_add, 'label': 'Create Assignment', 'color': Colors.orange},
      {'icon': Icons.send, 'label': 'Send Notification', 'color': Colors.purple},
      {'icon': Icons.upload_file, 'label': 'Upload Syllabus', 'color': _gold},
      {'icon': Icons.analytics, 'label': 'View Reports', 'color': Colors.redAccent},
    ];
    if (isMobile) {
      return GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.9,
        children: actions.map((a) => _buildActionCard(a)).toList(),
      );
    }
    return Wrap(spacing: 12, runSpacing: 12,
      children: actions.map((a) => SizedBox(width: 150, child: _buildActionCard(a))).toList(),
    );
  }

  Widget _buildActionCard(Map<String, Object> a) {
    final color = a['color'] as Color;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(a['icon'] as IconData, color: color, size: 26),
            const SizedBox(height: 8),
            Text(a['label'] as String, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w500), textAlign: TextAlign.center),
          ]),
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
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.border)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(radius: 18, backgroundColor: color.withOpacity(0.15), child: Icon(icon, color: color, size: 18)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: TextStyle(color: AppColors.textDark, fontSize: 13, fontWeight: FontWeight.w600)),
            const SizedBox(height: 3),
            Text(subtitle, style: const TextStyle(color: AppColors.textLight, fontSize: 12)),
          ])),
          Text(time, style: const TextStyle(color: AppColors.textLight, fontSize: 11)),
        ],
      ),
    );
  }
}
