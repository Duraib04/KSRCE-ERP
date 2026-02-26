// ignore_for_file: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/data_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_card_styles.dart';
import '../../../../core/services/file_upload_service.dart';
import '../../../shared/widgets/file_upload_widget.dart';

class FacultyAssignmentsPage extends StatefulWidget {
  const FacultyAssignmentsPage({super.key});

  @override
  State<FacultyAssignmentsPage> createState() => _FacultyAssignmentsPageState();
}

class _FacultyAssignmentsPageState extends State<FacultyAssignmentsPage> {

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
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _showCreateAssignment(context, ds, facCourses),
          backgroundColor: AppColors.primary,
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text('Create Assignment', style: TextStyle(color: Colors.white)),
        ),
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
      decoration: AppCardStyles.elevated,
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
      decoration: AppCardStyles.elevated,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Assignment List', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
        const SizedBox(height: 16),
        ...assignments.map((a) {
          final status = a['status'] ?? 'pending';
          final color = status == 'graded' ? Colors.green : status == 'submitted' ? Colors.blue : Colors.orange;
          return InkWell(
            onTap: () => _showAssignmentDetails(context, a),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(8)),
              child: Row(children: [
                const Icon(Icons.assignment, color: AppColors.primary, size: 20),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(a['title'] ?? '', style: const TextStyle(color: AppColors.textDark, fontWeight: FontWeight.w600, fontSize: 14)),
                  Text('${a['courseId'] ?? ''} | Due: ${a['dueDate'] ?? '-'}', style: const TextStyle(color: AppColors.textLight, fontSize: 12)),
                  if (a['submissionUrl'] != null)
                    const Text('📎 Student submitted a file', style: TextStyle(color: AppColors.secondary, fontSize: 11)),
                ])),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
                  child: Text(status.toString().toUpperCase(), style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ]),
            ),
          );
        }),
      ]),
    );
  }

  void _showAssignmentDetails(BuildContext context, Map<String, dynamic> a) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)))),
          const SizedBox(height: 16),
          Text(a['title'] ?? '', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textDark)),
          const SizedBox(height: 8),
          Text('${a['courseId'] ?? ''} — ${a['courseName'] ?? ''}', style: const TextStyle(color: AppColors.textMedium, fontSize: 14)),
          const SizedBox(height: 12),
          Row(children: [
            _chip('Due: ${a['dueDate'] ?? '-'}', Colors.orange),
            const SizedBox(width: 8),
            _chip('Max: ${a['maxMarks'] ?? '-'}', AppColors.primary),
            const SizedBox(width: 8),
            _chip('Status: ${a['status'] ?? 'pending'}', a['status'] == 'submitted' ? Colors.blue : Colors.orange),
          ]),
          if (a['submissionUrl'] != null) ...[
            const SizedBox(height: 16),
            const Text('Student Submission', style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 8),
            FileLink(
              url: a['submissionUrl'] as String,
              fileName: a['submissionFileName'] as String? ?? 'Submission',
              format: a['submissionFormat'] as String?,
            ),
          ],
          if (a['referenceUrl'] != null) ...[
            const SizedBox(height: 16),
            const Text('Reference Material', style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 8),
            FileLink(
              url: a['referenceUrl'] as String,
              fileName: a['referenceName'] as String? ?? 'Reference',
              format: a['referenceFormat'] as String?,
            ),
          ],
          const SizedBox(height: 20),
        ]),
      ),
    );
  }

  Widget _chip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
      child: Text(text, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w500)),
    );
  }

  void _showCreateAssignment(BuildContext context, DataService ds, List<Map<String, dynamic>> courses) {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final maxMarksCtrl = TextEditingController(text: '100');
    final dueDateCtrl = TextEditingController();
    String? selectedCourseId = courses.isNotEmpty ? courses.first['courseId'] as String : null;
    UploadResult? attachedFile;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(builder: (ctx, setDlgState) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Create Assignment', style: TextStyle(color: AppColors.textDark, fontSize: 18)),
          content: SizedBox(
            width: 450,
            child: SingleChildScrollView(
              child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                DropdownButtonFormField<String>(
                  value: selectedCourseId,
                  decoration: _inputDeco('Course'),
                  dropdownColor: AppColors.surface,
                  style: const TextStyle(color: AppColors.textDark, fontSize: 14),
                  items: courses.map((c) => DropdownMenuItem(value: c['courseId'] as String,
                    child: Text('${c['courseId']} - ${c['courseName']}'))).toList(),
                  onChanged: (v) => setDlgState(() => selectedCourseId = v),
                ),
                const SizedBox(height: 12),
                TextField(controller: titleCtrl, style: const TextStyle(color: AppColors.textDark), decoration: _inputDeco('Title')),
                const SizedBox(height: 12),
                TextField(controller: descCtrl, style: const TextStyle(color: AppColors.textDark), maxLines: 3, decoration: _inputDeco('Description')),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(child: TextField(controller: maxMarksCtrl, style: const TextStyle(color: AppColors.textDark), decoration: _inputDeco('Max Marks'), keyboardType: TextInputType.number)),
                  const SizedBox(width: 12),
                  Expanded(child: TextField(
                    controller: dueDateCtrl, style: const TextStyle(color: AppColors.textDark), decoration: _inputDeco('Due Date (YYYY-MM-DD)'),
                    onTap: () async {
                      final picked = await showDatePicker(context: ctx, initialDate: DateTime.now().add(const Duration(days: 7)),
                        firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 365)));
                      if (picked != null) dueDateCtrl.text = picked.toIso8601String().substring(0, 10);
                    },
                  )),
                ]),
                const SizedBox(height: 16),
                const Text('Reference Material (optional)', style: TextStyle(color: AppColors.textMedium, fontSize: 13)),
                const SizedBox(height: 8),
                if (attachedFile != null) ...[
                  Row(children: [
                    Icon(FileUploadService.getFileIcon(attachedFile!.format), color: AppColors.primary, size: 18),
                    const SizedBox(width: 6),
                    Expanded(child: Text(attachedFile!.originalName, style: const TextStyle(color: AppColors.textDark, fontSize: 13), overflow: TextOverflow.ellipsis)),
                    IconButton(icon: const Icon(Icons.close, size: 16), onPressed: () => setDlgState(() => attachedFile = null)),
                  ]),
                ] else
                  OutlinedButton.icon(
                    onPressed: () async {
                      final svc = FileUploadService();
                      final file = await svc.pickFile(accept: '.pdf,.doc,.docx,.ppt,.pptx,.jpg,.png');
                      if (file == null) return;
                      try {
                        final result = await svc.uploadFile(file, folder: 'ksrce/assignments/references');
                        setDlgState(() => attachedFile = result);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Upload failed: $e'), backgroundColor: Colors.red));
                      }
                    },
                    icon: const Icon(Icons.attach_file, size: 16),
                    label: const Text('Attach File'),
                    style: OutlinedButton.styleFrom(foregroundColor: AppColors.primary),
                  ),
              ]),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                if (titleCtrl.text.isEmpty || selectedCourseId == null) return;
                // In a real app, this would save to backend
                if (attachedFile != null) {
                  ds.addUploadedFile({
                    'url': attachedFile!.url,
                    'originalName': attachedFile!.originalName,
                    'format': attachedFile!.format,
                    'sizeBytes': attachedFile!.sizeBytes,
                    'category': 'assignments',
                    'uploadedBy': ds.currentUserId ?? '',
                    'courseId': selectedCourseId,
                    'assignmentTitle': titleCtrl.text,
                  });
                }
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Assignment "${titleCtrl.text}" created!'), backgroundColor: AppColors.secondary),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
              child: const Text('Create'),
            ),
          ],
        );
      }),
    );
  }

  InputDecoration _inputDeco(String label) {
    return InputDecoration(
      labelText: label, labelStyle: const TextStyle(color: AppColors.textLight, fontSize: 13),
      filled: true, fillColor: AppColors.background,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: AppColors.border)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: AppColors.border)),
    );
  }
}
