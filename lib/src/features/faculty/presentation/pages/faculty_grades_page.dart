import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/data_service.dart';
import '../../../../core/theme/app_colors.dart';

class FacultyGradesPage extends StatefulWidget {
  const FacultyGradesPage({super.key});

  @override
  State<FacultyGradesPage> createState() => _FacultyGradesPageState();
}

class _FacultyGradesPageState extends State<FacultyGradesPage> {
  String? _selectedCourse;

  @override
  Widget build(BuildContext context) {
    return Consumer<DataService>(builder: (context, ds, _) {
      final fid = ds.currentUserId ?? '';
      final courses = ds.getFacultyCourses(fid);
      if (_selectedCourse == null && courses.isNotEmpty) {
        _selectedCourse = courses.first['courseId'] as String?;
      }
      final results = _selectedCourse != null ? ds.results.where((r) => r['courseId'] == _selectedCourse).toList() : <Map<String, dynamic>>[];
      final students = _selectedCourse != null ? ds.getCourseStudents(_selectedCourse!) : <Map<String, dynamic>>[];

      // Grade distribution
      final gradeMap = <String, int>{};
      for (final r in results) {
        final grade = r['grade'] ?? 'N/A';
        gradeMap[grade] = (gradeMap[grade] ?? 0) + 1;
      }

      return Scaffold(
        backgroundColor: AppColors.background,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: const [
              Icon(Icons.grading, color: AppColors.primary, size: 28),
              SizedBox(width: 12),
              Text('Grade Management', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textDark)),
            ]),
            const SizedBox(height: 24),
            _buildCourseSelector(courses),
            const SizedBox(height: 24),
            _buildGradeDistribution(gradeMap),
            const SizedBox(height: 24),
            _buildStudentGrades(students, results),
          ]),
        ),
      );
    });
  }

  Widget _buildCourseSelector(List<Map<String, dynamic>> courses) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
      child: Row(children: [
        const Text('Select Course: ', style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.w600)),
        const SizedBox(width: 12),
        Expanded(child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.border)),
          child: DropdownButton<String>(
            value: _selectedCourse, isExpanded: true, dropdownColor: AppColors.surface,
            style: const TextStyle(color: AppColors.textDark), underline: const SizedBox(),
            items: courses.map((c) => DropdownMenuItem(value: c['courseId'] as String?, child: Text('${c['courseId']} - ${c['courseName'] ?? ''}'))).toList(),
            onChanged: (v) => setState(() => _selectedCourse = v),
          ),
        )),
      ]),
    );
  }

  Widget _buildGradeDistribution(Map<String, int> gradeMap) {
    final grades = ['O', 'A+', 'A', 'B+', 'B', 'C', 'F'];
    final maxCount = gradeMap.values.fold(0, (max, v) => v > max ? v : max);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Grade Distribution', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
        const SizedBox(height: 16),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: grades.map((g) {
          final count = gradeMap[g] ?? 0;
          final height = maxCount > 0 ? (count / maxCount * 100) : 0.0;
          final color = g == 'O' || g == 'A+' ? Colors.green : g == 'A' || g == 'B+' ? Colors.blue : g == 'F' ? Colors.redAccent : Colors.orange;
          return Column(children: [
            Text('$count', style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
            const SizedBox(height: 4),
            Container(width: 30, height: height.clamp(4.0, 100.0), decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4))),
            const SizedBox(height: 4),
            Text(g, style: const TextStyle(color: AppColors.textMedium, fontSize: 12)),
          ]);
        }).toList()),
      ]),
    );
  }

  Widget _buildStudentGrades(List<Map<String, dynamic>> students, List<Map<String, dynamic>> results) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Student Grades', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
        const SizedBox(height: 16),
        if (students.isEmpty) const Center(child: Text('No students', style: TextStyle(color: AppColors.textLight))),
        ...students.map((s) {
          final sid = s['studentId'] ?? '';
          final result = results.where((r) => r['studentId'] == sid).toList();
          final grade = result.isNotEmpty ? (result.first['grade'] ?? '-') : '-';
          final marks = result.isNotEmpty ? '${result.first['marks'] ?? '-'}/${result.first['totalMarks'] ?? 100}' : '-';
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(8)),
            child: Row(children: [
              SizedBox(width: 100, child: Text(sid, style: const TextStyle(color: AppColors.textMedium, fontSize: 13))),
              Expanded(child: Text(s['name'] ?? '', style: const TextStyle(color: AppColors.textDark, fontWeight: FontWeight.w500))),
              SizedBox(width: 100, child: Text(marks, style: const TextStyle(color: AppColors.textMedium, fontSize: 13))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
                child: Text(grade, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13)),
              ),
            ]),
          );
        }),
      ]),
    );
  }
}
