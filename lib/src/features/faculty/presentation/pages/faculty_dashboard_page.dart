import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../../core/data_service.dart';
import '../../../../core/theme/app_colors.dart';

class FacultyDashboardPage extends StatelessWidget {
  const FacultyDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DataService>(builder: (context, ds, _) {
      if (!ds.isLoaded) {
        return const Scaffold(backgroundColor: AppColors.background, body: Center(child: CircularProgressIndicator()));
      }
      final facultyId = ds.currentUserId ?? '';
      final facultyCourses = ds.getFacultyCourses(facultyId);
      final now = DateTime.now();
      final dayName = DateFormat('EEEE').format(now);
      final dateStr = DateFormat('d MMM yyyy').format(now);
      final todayTimetable = ds.getTimetableForDay(dayName);
      final notifications = ds.notifications;
      final students = ds.students;

      // Find faculty name from courses
      String facultyName = 'Faculty';
      if (facultyCourses.isNotEmpty) {
        facultyName = facultyCourses.first['facultyName'] as String? ?? 'Faculty';
      }
      final initials = facultyName.split(' ').where((w) => w.isNotEmpty).map((w) => w[0]).take(2).join().toUpperCase();

      return Scaffold(
        backgroundColor: AppColors.background,
        body: LayoutBuilder(builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 700;
          return SingleChildScrollView(
            padding: EdgeInsets.all(isMobile ? 16 : 24),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _buildWelcomeHeader(isMobile, facultyName, initials, dayName, dateStr),
              const SizedBox(height: 24),
              _buildStats(isMobile, facultyCourses, todayTimetable, students, notifications),
              const SizedBox(height: 28),
              const Text("Today's Schedule", style: TextStyle(color: AppColors.textDark, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              ..._buildTodaySchedule(isMobile, todayTimetable, dayName),
              const SizedBox(height: 28),
              const Text('My Courses', style: TextStyle(color: AppColors.textDark, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              ...facultyCourses.map((c) => _buildCourseCard(c, isMobile)),
              const SizedBox(height: 28),
              const Text('Recent Notifications', style: TextStyle(color: AppColors.textDark, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              ...notifications.take(4).map((n) => _buildNotifTile(n)),
              const SizedBox(height: 16),
            ]),
          );
        }),
      );
    });
  }

  Widget _buildWelcomeHeader(bool isMobile, String name, String initials, String dayName, String dateStr) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [AppColors.primary, Color(0xFF1A3A5C)]),
        boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))],
        borderRadius: BorderRadius.circular(16),
      ),
      child: isMobile
        ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              CircleAvatar(radius: 24, backgroundColor: AppColors.accent,
                child: Text(initials, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))),
              const SizedBox(width: 12),
              Expanded(child: Text('Welcome back, $name', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))),
            ]),
            const SizedBox(height: 8),
            Text('$dayName, $dateStr', style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12)),
          ])
        : Row(children: [
            CircleAvatar(radius: 32, backgroundColor: AppColors.accent,
              child: Text(initials, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold))),
            const SizedBox(width: 20),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Welcome back, $name', style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text('Faculty | KSRCE', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14)),
            ])),
            Text('$dayName, $dateStr', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14)),
          ]),
    );
  }

  Widget _buildStats(bool isMobile, List<Map<String, dynamic>> courses, List<Map<String, dynamic>> todaySchedule, List<Map<String, dynamic>> students, List<Map<String, dynamic>> notifs) {
    final stats = [
      {'icon': Icons.people, 'label': 'Total Students', 'value': '${students.length}', 'color': AppColors.primary},
      {'icon': Icons.menu_book, 'label': 'Courses Teaching', 'value': '${courses.length}', 'color': Colors.teal},
      {'icon': Icons.class_, 'label': 'Classes Today', 'value': '${todaySchedule.length}', 'color': AppColors.accent},
      {'icon': Icons.notifications_active, 'label': 'Notifications', 'value': '${notifs.length}', 'color': Colors.purple},
    ];
    if (isMobile) {
      return GridView.count(
        crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 1.4,
        children: stats.map((s) => _buildStatCard(s)).toList(),
      );
    }
    return Row(children: stats.map((s) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 6), child: _buildStatCard(s)))).toList());
  }

  Widget _buildStatCard(Map<String, Object> s) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface, borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: (s['color'] as Color).withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
          child: Icon(s['icon'] as IconData, color: s['color'] as Color, size: 22),
        ),
        const SizedBox(height: 10),
        Text(s['value'] as String, style: const TextStyle(color: AppColors.textDark, fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(s['label'] as String, style: const TextStyle(color: AppColors.textLight, fontSize: 12)),
      ]),
    );
  }

  List<Widget> _buildTodaySchedule(bool isMobile, List<Map<String, dynamic>> schedule, String dayName) {
    if (schedule.isEmpty) {
      return [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
          child: Center(child: Text('No classes scheduled for $dayName', style: const TextStyle(color: AppColors.textLight, fontSize: 14))),
        ),
      ];
    }
    return schedule.map((s) {
      final isLab = (s['type'] as String? ?? '') == 'Lab';
      final color = isLab ? AppColors.accent : AppColors.primary;
      final timeStr = '${s['startTime'] ?? ''} - ${s['endTime'] ?? ''}';
      final course = '${s['courseCode'] ?? ''} - ${s['courseName'] ?? ''}';
      final room = s['room'] as String? ?? '';
      final type = s['type'] as String? ?? 'Lecture';

      return Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.all(isMobile ? 12 : 16),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
        child: Row(children: [
          Container(width: 4, height: 50, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 16),
          SizedBox(width: isMobile ? 80 : 130, child: Text(timeStr, style: const TextStyle(color: AppColors.textMedium, fontSize: 13, fontWeight: FontWeight.w500))),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(course, style: const TextStyle(color: AppColors.textDark, fontSize: 14, fontWeight: FontWeight.w600)),
            const SizedBox(height: 2),
            Text(room, style: const TextStyle(color: AppColors.textLight, fontSize: 12)),
          ])),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
            child: Text(type, style: TextStyle(color: color, fontSize: 12)),
          ),
        ]),
      );
    }).toList();
  }

  Widget _buildCourseCard(Map<String, dynamic> c, bool isMobile) {
    final code = c['courseCode'] as String? ?? '';
    final name = c['courseName'] as String? ?? '';
    final credits = c['credits']?.toString() ?? '0';
    final room = c['room'] as String? ?? '';
    final total = c['totalClasses'] ?? 0;
    final attended = c['attendedClasses'] ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.15), borderRadius: BorderRadius.circular(6)),
          child: Text(code, style: const TextStyle(color: Color(0xFF64B5F6), fontWeight: FontWeight.bold, fontSize: 13)),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(name, style: const TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 4),
          Text('$credits Credits | $room | $total classes conducted', style: const TextStyle(color: AppColors.textLight, fontSize: 12)),
        ])),
      ]),
    );
  }

  Widget _buildNotifTile(Map<String, dynamic> n) {
    final Map<String, IconData> typeIcons = {
      'assignment': Icons.assignment, 'exam': Icons.event_note, 'attendance': Icons.fact_check,
      'event': Icons.celebration, 'alert': Icons.warning_amber,
    };
    final Map<String, Color> typeColors = {
      'assignment': Colors.blue, 'exam': Colors.orange, 'attendance': Colors.redAccent,
      'event': AppColors.secondary, 'alert': Colors.orange,
    };
    final type = n['type'] as String? ?? 'alert';
    final icon = typeIcons[type] ?? Icons.notifications;
    final color = typeColors[type] ?? AppColors.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.border)),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        CircleAvatar(radius: 18, backgroundColor: color.withOpacity(0.15), child: Icon(icon, color: color, size: 18)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(n['title'] as String? ?? '', style: const TextStyle(color: AppColors.textDark, fontSize: 13, fontWeight: FontWeight.w600)),
          const SizedBox(height: 3),
          Text(n['message'] as String? ?? '', style: const TextStyle(color: AppColors.textLight, fontSize: 12)),
        ])),
        if (n['sender'] != null)
          Text(n['sender'] as String, style: const TextStyle(color: AppColors.textLight, fontSize: 11)),
      ]),
    );
  }
}
