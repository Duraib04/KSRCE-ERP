import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/data_service.dart';
import '../../../../core/theme/app_colors.dart';

class StudentDashboardPage extends StatelessWidget {
  const StudentDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DataService>(builder: (context, ds, _) {
      if (!ds.isLoaded) {
        return const Scaffold(
          backgroundColor: AppColors.background,
          body: Center(child: CircularProgressIndicator()),
        );
      }
      final student = ds.currentStudent ?? {};
      final name = (student['name'] as String?) ?? 'Student';
      final dept = (student['department'] as String?) ?? '';
      final year = (student['year'] as String?) ?? '';
      final section = (student['section'] as String?) ?? '';
      final cgpa = ds.currentCGPA;
      final attPct = ds.overallAttendancePercentage;
      final pendingCount = ds.pendingAssignmentsCount;
      final initials = name.split(' ').map((w) => w.isNotEmpty ? w[0] : '').take(2).join().toUpperCase();
      final now = DateTime.now();
      final dayName = DateFormat('EEEE').format(now);
      final dateStr = DateFormat('d MMM yyyy').format(now);
      final todayTimetable = ds.getTimetableForDay(dayName);
      final unreadCount = ds.unreadNotificationCount;
      final notifications = ds.notifications;

      return Scaffold(
        backgroundColor: AppColors.background,
        body: LayoutBuilder(builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 700;
          return SingleChildScrollView(
            padding: EdgeInsets.all(isMobile ? 16 : 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWelcomeHeader(isMobile, name, initials, dept, year, section, student['studentId'] as String? ?? ds.currentUserId ?? '', dayName, dateStr),
                const SizedBox(height: 24),
                _buildStatsRow(isMobile, attPct, cgpa, pendingCount, unreadCount),
                const SizedBox(height: 24),
                if (isMobile) ...[
                  _buildTodayTimetable(isMobile, todayTimetable, dayName),
                  const SizedBox(height: 16),
                  _buildRecentNotifications(notifications),
                ] else
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 3, child: _buildTodayTimetable(isMobile, todayTimetable, dayName)),
                      const SizedBox(width: 24),
                      Expanded(flex: 2, child: _buildRecentNotifications(notifications)),
                    ],
                  ),
                const SizedBox(height: 24),
                _buildQuickActions(context),
              ],
            ),
          );
        }),
      );
    });
  }

  Widget _buildWelcomeHeader(bool isMobile, String name, String initials, String dept, String year, String section, String rollNo, String dayName, String dateStr) {
    final firstName = name.split(' ').first;
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
              CircleAvatar(radius: 24, backgroundColor: AppColors.accent,
                child: Text(initials, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white))),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Welcome back, $firstName!', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 2),
                Text('$dept | Year $year | Sec $section', style: const TextStyle(fontSize: 12, color: Colors.white70)),
              ])),
            ]),
            const SizedBox(height: 12),
            Text('Roll: $rollNo', style: const TextStyle(fontSize: 12, color: Colors.white60)),
            const SizedBox(height: 4),
            Text('$dayName, $dateStr', style: const TextStyle(color: Colors.white70, fontSize: 12)),
          ])
        : Row(children: [
            CircleAvatar(radius: 32, backgroundColor: AppColors.accent,
              child: Text(initials, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white))),
            const SizedBox(width: 20),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Welcome back, $name!', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 4),
              Text('$dept | Year $year | Section $section', style: const TextStyle(fontSize: 14, color: Colors.white70)),
              Text('Roll No: $rollNo', style: const TextStyle(fontSize: 13, color: Colors.white60)),
            ])),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              const Text('Academic Year 2025-26', style: TextStyle(color: Colors.white70, fontSize: 13)),
              const SizedBox(height: 4),
              Text('$dayName, $dateStr', style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500)),
            ]),
          ]),
    );
  }

  Widget _buildStatsRow(bool isMobile, double attPct, double cgpa, int pendingCount, int unreadCount) {
    final stats = [
      {'title': 'Attendance', 'value': '${attPct.toStringAsFixed(0)}%', 'icon': Icons.check_circle_outline, 'color': AppColors.secondary},
      {'title': 'CGPA', 'value': cgpa.toStringAsFixed(1), 'icon': Icons.school, 'color': AppColors.primary},
      {'title': 'Pending Tasks', 'value': '$pendingCount', 'icon': Icons.assignment_late, 'color': AppColors.accent},
      {'title': 'Notifications', 'value': '$unreadCount', 'icon': Icons.notifications, 'color': AppColors.error},
    ];
    if (isMobile) {
      return GridView.count(
        crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 1.5,
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
        Text(s['value'] as String, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textDark)),
        const SizedBox(height: 4),
        Text(s['title'] as String, style: const TextStyle(color: AppColors.textMedium, fontSize: 12), textAlign: TextAlign.center),
      ]),
    );
  }

  Widget _buildTodayTimetable(bool isMobile, List<Map<String, dynamic>> todayPeriods, String dayName) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface, borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.today, color: AppColors.primary, size: 20),
          const SizedBox(width: 8),
          Text("Today's Timetable ($dayName)", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
        ]),
        const Divider(height: 20),
        if (todayPeriods.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(child: Text('No classes scheduled for today', style: TextStyle(color: AppColors.textLight, fontSize: 14))),
          )
        else
          ...todayPeriods.map((p) {
            final timeStr = '${p['startTime'] ?? ''} - ${p['endTime'] ?? ''}';
            final subject = '${p['courseCode'] ?? ''} - ${p['courseName'] ?? ''}';
            final room = (p['room'] as String?) ?? '';
            final faculty = (p['facultyName'] as String?) ?? '';
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: EdgeInsets.all(isMobile ? 10 : 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: isMobile
                ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Text(timeStr, style: const TextStyle(color: AppColors.textMedium, fontSize: 12, fontWeight: FontWeight.w600)),
                      const Spacer(),
                      Text(room, style: const TextStyle(color: AppColors.textLight, fontSize: 11)),
                    ]),
                    const SizedBox(height: 4),
                    Text(subject, style: const TextStyle(color: AppColors.textDark, fontSize: 13)),
                    Text(faculty, style: const TextStyle(color: AppColors.textLight, fontSize: 11)),
                  ])
                : Row(children: [
                    SizedBox(width: 120, child: Text(timeStr, style: const TextStyle(color: AppColors.textMedium, fontSize: 13, fontWeight: FontWeight.w500))),
                    Expanded(child: Text(subject, style: const TextStyle(color: AppColors.textDark))),
                    SizedBox(width: 80, child: Text(room, style: const TextStyle(color: AppColors.textLight, fontSize: 13))),
                    SizedBox(width: 140, child: Text(faculty, style: const TextStyle(color: AppColors.textLight, fontSize: 13))),
                  ]),
            );
          }),
      ]),
    );
  }

  Widget _buildRecentNotifications(List<Map<String, dynamic>> allNotifs) {
    final recent = allNotifs.take(4).toList();
    final Map<String, IconData> typeIcons = {
      'assignment': Icons.assignment, 'exam': Icons.event_note, 'attendance': Icons.fact_check,
      'event': Icons.celebration, 'alert': Icons.warning_amber,
    };
    final Map<String, Color> typeColors = {
      'assignment': AppColors.accent, 'exam': AppColors.error, 'attendance': AppColors.secondary,
      'event': AppColors.primary, 'alert': Colors.orange,
    };
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface, borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.notifications_active, color: AppColors.accent, size: 20),
          const SizedBox(width: 8),
          const Text('Recent Notifications', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
        ]),
        const Divider(height: 20),
        if (recent.isEmpty)
          const Padding(padding: EdgeInsets.symmetric(vertical: 16), child: Center(child: Text('No notifications', style: TextStyle(color: AppColors.textLight))))
        else
          ...recent.map((n) {
            final type = (n['type'] as String?) ?? 'alert';
            final icon = typeIcons[type] ?? Icons.notifications;
            final color = typeColors[type] ?? AppColors.primary;
            final timeStr = _formatTime(n['timestamp'] as String?);
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(8)),
              child: Row(children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                  child: Icon(icon, color: color, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(n['title'] as String? ?? '', style: const TextStyle(color: AppColors.textDark, fontSize: 13, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 2),
                  Text(timeStr, style: const TextStyle(color: AppColors.textLight, fontSize: 11)),
                ])),
                if (n['isRead'] == false)
                  Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)),
              ]),
            );
          }),
      ]),
    );
  }

  String _formatTime(String? timestamp) {
    if (timestamp == null) return '';
    try {
      final dt = DateTime.parse(timestamp);
      final diff = DateTime.now().difference(dt);
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      if (diff.inDays < 7) return '${diff.inDays}d ago';
      return DateFormat('d MMM').format(dt);
    } catch (_) {
      return '';
    }
  }

  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      {'label': 'Attendance', 'icon': Icons.fact_check, 'color': AppColors.secondary, 'route': '/student/attendance'},
      {'label': 'Results', 'icon': Icons.assessment, 'color': AppColors.primary, 'route': '/student/results'},
      {'label': 'Courses', 'icon': Icons.menu_book, 'color': const Color(0xFF3B82F6), 'route': '/student/courses'},
      {'label': 'Assignments', 'icon': Icons.assignment, 'color': AppColors.accent, 'route': '/student/assignments'},
      {'label': 'Exams', 'icon': Icons.event, 'color': AppColors.error, 'route': '/student/exams'},
      {'label': 'Notifications', 'icon': Icons.notifications, 'color': const Color(0xFF14B8A6), 'route': '/student/notifications'},
    ];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface, borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Quick Actions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
        const Divider(height: 20),
        Wrap(spacing: 10, runSpacing: 10, children: actions.map((a) => ElevatedButton.icon(
          onPressed: () => context.go(a['route'] as String),
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
