import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/data_service.dart';
import '../../../../core/theme/app_colors.dart';

class FacultySyllabusPage extends StatelessWidget {
  const FacultySyllabusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DataService>(builder: (context, ds, _) {
      final fid = ds.currentUserId ?? '';
      final syllabi = ds.getFacultySyllabus(fid);
      final courses = ds.getFacultyCourses(fid);

      return Scaffold(
        backgroundColor: AppColors.background,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: const [
              Icon(Icons.menu_book, color: AppColors.primary, size: 28),
              SizedBox(width: 12),
              Text('Syllabus Management', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textDark)),
            ]),
            const SizedBox(height: 8),
            Text('${courses.length} courses | ${syllabi.length} syllabi uploaded', style: const TextStyle(color: AppColors.textLight, fontSize: 14)),
            const SizedBox(height: 24),
            if (syllabi.isEmpty && courses.isEmpty)
              const Center(child: Padding(padding: EdgeInsets.all(40), child: Text('No courses assigned', style: TextStyle(color: AppColors.textLight, fontSize: 16)))),
            ...courses.map((course) {
              final cid = course['courseId'] ?? '';
              final courseSyl = syllabi.where((s) => s['courseId'] == cid).toList();
              if (courseSyl.isEmpty) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
                  child: Row(children: [
                    Expanded(child: Text('$cid - ${course['courseName'] ?? ''}', style: const TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold))),
                    const Text('Syllabus not uploaded', style: TextStyle(color: AppColors.textLight, fontSize: 13)),
                  ]),
                );
              }
              final syl = courseSyl.first;
              final units = (syl['units'] as List<dynamic>?) ?? [];
              final progress = ds.getSyllabusProgress(syl);
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Expanded(child: Text('$cid - ${course['courseName'] ?? syl['courseName'] ?? ''}', style: const TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 16))),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
                      child: Text('${progress.toStringAsFixed(0)}%', style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                  ]),
                  const SizedBox(height: 10),
                  LinearProgressIndicator(value: progress / 100, backgroundColor: AppColors.border, valueColor: const AlwaysStoppedAnimation(AppColors.primary)),
                  const SizedBox(height: 16),
                  ...units.map((u) {
                    final totalH = (u['totalHours'] as int?) ?? 1;
                    final compH = (u['completedHours'] as int?) ?? 0;
                    final unitProg = totalH > 0 ? compH / totalH : 0.0;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(8)),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(children: [
                          Expanded(child: Text('Unit ${u['unitNumber'] ?? '-'}: ${u['title'] ?? ''}', style: const TextStyle(color: AppColors.textDark, fontWeight: FontWeight.w600, fontSize: 14))),
                          Text('$compH/$totalH hrs', style: const TextStyle(color: AppColors.textMedium, fontSize: 12)),
                        ]),
                        const SizedBox(height: 6),
                        LinearProgressIndicator(value: unitProg, backgroundColor: AppColors.border, valueColor: AlwaysStoppedAnimation(unitProg >= 1.0 ? Colors.green : AppColors.accent)),
                      ]),
                    );
                  }),
                ]),
              );
            }),
          ]),
        ),
      );
    });
  }
}
