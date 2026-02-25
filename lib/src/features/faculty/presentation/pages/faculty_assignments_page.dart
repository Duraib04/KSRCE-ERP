import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/data_service.dart';
import '../../../../core/theme/app_colors.dart';

class FacultyAssignmentsPage extends StatelessWidget {
  const FacultyAssignmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DataService>(builder: (context, ds, _) {
      final fid = ds.currentUserId ?? '';
      final facCourses = ds.getFacultyCourses(fid);
      final courseIds = facCourses.map((c) => c['courseId'] as String).toSet();
      final assignments = ds.assignments.where((a) => courseIds.contains(a['courseId'])).toList();
      final pending = assignments.where((a) => a['status'] == 'pending').length;
      final completed = assignments.where((a) => a['status'] == 'submitted' || a['status'] == 'graded').length;

      return Scaffold(
        backgroundColor: AppColors.background,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: const [
              Icon(Icons.assignment, color: AppColors.primary, size: 28),
              SizedBox(width: 12),
              Text('Assignments', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textDark)),
            ]),
            const SizedBox(height: 24),
            Row(children: [
              _stat('Total', '${assignments.length}', AppColors.primary, Icons.assignment),
              const SizedBox(width: 16),
              _stat('Pending', '$pending', Colors.orange, Icons.pending),
              const SizedBox(width: 16),
              _stat('Submitted', '$completed', Colors.green, Icons.check_circle),
            ]),
            const SizedBox(height: 24),
            _buildAssignmentList(assignments),
          ]),
        ),
      );
    });
  }

  Widget _stat(String label, String value, Color color, IconData icon) {
    return Expanded(child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
      child: Column(children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: const TextStyle(color: AppColors.textLight, fontSize: 12)),
      ]),
    ));
  }

  Widget _buildAssignmentList(List<Map<String, dynamic>> assignments) {
    if (assignments.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)),
        child: const Center(child: Text('No assignments found', style: TextStyle(color: AppColors.textLight))),
      );
    }
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Assignment List', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
        const SizedBox(height: 16),
        ...assignments.map((a) {
          final status = a['status'] ?? 'pending';
          final color = status == 'graded' ? Colors.green : status == 'submitted' ? Colors.blue : Colors.orange;
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(8)),
            child: Row(children: [
              const Icon(Icons.assignment, color: AppColors.primary, size: 20),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(a['title'] ?? '', style: const TextStyle(color: AppColors.textDark, fontWeight: FontWeight.w600, fontSize: 14)),
                Text('${a['courseId'] ?? ''} | Due: ${a['dueDate'] ?? '-'}', style: const TextStyle(color: AppColors.textLight, fontSize: 12)),
              ])),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
                child: Text(status.toString().toUpperCase(), style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ]),
          );
        }),
      ]),
    );
  }
}
