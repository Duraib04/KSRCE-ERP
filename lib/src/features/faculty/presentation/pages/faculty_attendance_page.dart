import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/data_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_card_styles.dart';

class FacultyAttendancePage extends StatefulWidget {
  const FacultyAttendancePage({super.key});

  @override
  State<FacultyAttendancePage> createState() => _FacultyAttendancePageState();
}

class _FacultyAttendancePageState extends State<FacultyAttendancePage> {
  String? _selectedCourse;

  @override
  Widget build(BuildContext context) {
    return Consumer<DataService>(builder: (context, ds, _) {
      final fid = ds.currentUserId ?? '';
      final courses = ds.getFacultyCourses(fid);
      if (_selectedCourse == null && courses.isNotEmpty) {
        _selectedCourse = courses.first['courseId'] as String?;
      }
      final students = _selectedCourse != null ? ds.getCourseStudents(_selectedCourse!) : <Map<String, dynamic>>[];
      final attendance = _selectedCourse != null ? ds.getCourseAttendance(_selectedCourse!) : <Map<String, dynamic>>[];

      return Scaffold(
        backgroundColor: AppColors.background,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: const [
              Icon(Icons.fact_check, color: AppColors.primary, size: 28),
              SizedBox(width: 12),
              Text('Attendance Management', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textDark)),
            ]),
            const SizedBox(height: 24),
            _buildCourseSelector(courses),
            const SizedBox(height: 24),
            _buildAttendanceStats(attendance),
            const SizedBox(height: 24),
            _buildStudentList(students, attendance),
          ]),
        ),
      );
    });
  }

  Widget _buildCourseSelector(List<Map<String, dynamic>> courses) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppCardStyles.elevated,
      child: Row(children: [
        const Text('Select Course: ', style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.w600)),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: AppCardStyles.flat,
            child: DropdownButton<String>(
              value: _selectedCourse, isExpanded: true, dropdownColor: AppColors.surface,
              style: const TextStyle(color: AppColors.textDark), underline: const SizedBox(),
              items: courses.map((c) => DropdownMenuItem(value: c['courseId'] as String?, child: Text('${c['courseId']} - ${c['courseName'] ?? ''}'))).toList(),
              onChanged: (v) => setState(() => _selectedCourse = v),
            ),
          ),
        ),
      ]),
    );
  }

  Widget _buildAttendanceStats(List<Map<String, dynamic>> attendance) {
    int totalStudents = 0, avgAttendance = 0;
    if (attendance.isNotEmpty) {
      totalStudents = attendance.length;
      int totalPresent = 0, totalClasses = 0;
      for (final a in attendance) {
        totalPresent += (a['attendedClasses'] as int?) ?? 0;
        totalClasses += (a['totalClasses'] as int?) ?? 0;
      }
      avgAttendance = totalClasses > 0 ? (totalPresent * 100 ~/ totalClasses) : 0;
    }
    final belowThreshold = attendance.where((a) {
      final total = (a['totalClasses'] as int?) ?? 1;
      final attended = (a['attendedClasses'] as int?) ?? 0;
      return total > 0 && (attended / total * 100) < 75;
    }).length;

    return Row(children: [
      _stat('Total Students', '$totalStudents', AppColors.primary, Icons.people),
      const SizedBox(width: 16),
      _stat('Avg Attendance', '$avgAttendance%', Colors.green, Icons.trending_up),
      const SizedBox(width: 16),
      _stat('Below 75%', '$belowThreshold', Colors.redAccent, Icons.warning),
    ]);
  }

  Widget _stat(String label, String value, Color color, IconData icon) {
    return Expanded(child: Container(
      padding: const EdgeInsets.all(16),
      decoration: AppCardStyles.elevated,
      child: Column(children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: const TextStyle(color: AppColors.textLight, fontSize: 12)),
      ]),
    ));
  }

  Widget _buildStudentList(List<Map<String, dynamic>> students, List<Map<String, dynamic>> attendance) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppCardStyles.elevated,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Student Attendance', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
        const SizedBox(height: 16),
        if (students.isEmpty) const Center(child: Text('No students enrolled', style: TextStyle(color: AppColors.textLight))),
        ...students.map((s) {
          final sid = s['studentId'] as String? ?? '';
          final att = attendance.where((a) => a['studentId'] == sid).toList();
          int attended = 0, total = 0;
          if (att.isNotEmpty) {
            attended = (att.first['attendedClasses'] as int?) ?? 0;
            total = (att.first['totalClasses'] as int?) ?? 0;
          }
          final pct = total > 0 ? (attended / total * 100) : 0.0;
          final color = pct >= 75 ? Colors.green : pct >= 60 ? Colors.orange : Colors.redAccent;
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(8)),
            child: Row(children: [
              SizedBox(width: 100, child: Text(sid, style: const TextStyle(color: AppColors.textMedium, fontSize: 13))),
              Expanded(child: Text(s['name'] ?? '', style: const TextStyle(color: AppColors.textDark, fontWeight: FontWeight.w500, fontSize: 14))),
              SizedBox(width: 100, child: Text('$attended/$total', style: const TextStyle(color: AppColors.textMedium, fontSize: 13))),
              SizedBox(width: 80, child: Text('${pct.toStringAsFixed(1)}%', style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14))),
              SizedBox(width: 120, child: LinearProgressIndicator(value: pct / 100, backgroundColor: AppColors.border, valueColor: AlwaysStoppedAnimation(color))),
            ]),
          );
        }),
      ]),
    );
  }
}
