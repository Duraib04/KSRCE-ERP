import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/data_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_card_styles.dart';

class FacultyExamsPage extends StatelessWidget {
  const FacultyExamsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DataService>(builder: (context, ds, _) {
      final fid = ds.currentUserId ?? '';
      final exams = ds.getFacultyExams(fid);
      final courses = ds.getFacultyCourses(fid);

      return Scaffold(
        backgroundColor: AppColors.background,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: const [
              Icon(Icons.quiz, color: AppColors.primary, size: 28),
              SizedBox(width: 12),
              Text('Exam Management', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textDark)),
            ]),
            const SizedBox(height: 24),
            Row(children: [
              _stat('My Exams', '${exams.length}', AppColors.primary, Icons.event_note),
              const SizedBox(width: 16),
              _stat('Courses', '${courses.length}', Colors.green, Icons.class_),
            ]),
            const SizedBox(height: 24),
            _buildExamList(exams),
          ]),
        ),
      );
    });
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

  Widget _buildExamList(List<Map<String, dynamic>> exams) {
    if (exams.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)),
        child: const Center(child: Text('No exams assigned', style: TextStyle(color: AppColors.textLight))),
      );
    }
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppCardStyles.elevated,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Exam Schedule', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
        const SizedBox(height: 16),
        ...exams.map((e) {
          final type = (e['type'] ?? '').toString();
          final isInternal = type.toLowerCase().contains('internal');
          final color = isInternal ? Colors.orange : Colors.redAccent;
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(8)),
            child: Row(children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(6)),
                child: Text(type, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('${e['courseId'] ?? ''} - ${e['examName'] ?? ''}', style: const TextStyle(color: AppColors.textDark, fontWeight: FontWeight.w600, fontSize: 14)),
                Text('${e['date'] ?? ''} | ${e['time'] ?? ''} | ${e['venue'] ?? ''}', style: const TextStyle(color: AppColors.textLight, fontSize: 12)),
              ])),
            ]),
          );
        }),
      ]),
    );
  }
}
