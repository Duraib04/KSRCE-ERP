import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/data_service.dart';
import '../../../../core/theme/app_colors.dart';

class AdminDepartmentsPage extends StatefulWidget {
  const AdminDepartmentsPage({super.key});
  @override
  State<AdminDepartmentsPage> createState() => _AdminDepartmentsPageState();
}

class _AdminDepartmentsPageState extends State<AdminDepartmentsPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DataService>(builder: (context, ds, _) {
      if (!ds.isLoaded) return const Scaffold(backgroundColor: AppColors.background, body: Center(child: CircularProgressIndicator()));
      final depts = ds.departments;

      return Scaffold(
        backgroundColor: AppColors.background,
        body: LayoutBuilder(builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 700;
          return SingleChildScrollView(
            padding: EdgeInsets.all(isMobile ? 16 : 24),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                const Icon(Icons.business, color: AppColors.primary, size: 28),
                const SizedBox(width: 12),
                const Expanded(child: Text('Department Management', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textDark))),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add, size: 18), label: const Text('Add Department'),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                  onPressed: () => _showAddDeptDialog(context, ds),
                ),
              ]),
              const SizedBox(height: 20),
              ...depts.map((d) {
                final hodId = d['hodId'] as String? ?? '';
                final hodName = hodId.isNotEmpty ? ds.getFacultyName(hodId) : 'Not Assigned';
                final facCount = ds.getDepartmentFaculty(d['departmentId'] as String).length;
                final stuCount = ds.getDepartmentStudents(d['departmentId'] as String).length;

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.15), borderRadius: BorderRadius.circular(6)),
                        child: Text(d['departmentCode'] as String? ?? '', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 14))),
                      const SizedBox(width: 12),
                      Expanded(child: Text(d['departmentName'] as String? ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textDark))),
                    ]),
                    const SizedBox(height: 12),
                    Row(children: [
                      _badge(Icons.supervisor_account, 'HOD: $hodName', hodId.isNotEmpty ? AppColors.secondary : Colors.orange),
                      const SizedBox(width: 8),
                      _badge(Icons.people, '$facCount faculty', AppColors.primary),
                      const SizedBox(width: 8),
                      _badge(Icons.school, '$stuCount students', Colors.teal),
                    ]),
                  ]),
                );
              }),
            ]),
          );
        }),
      );
    });
  }

  Widget _badge(IconData icon, String text, Color color) {
    return Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(icon, size: 14, color: color), const SizedBox(width: 4), Flexible(child: Text(text, style: TextStyle(color: color, fontSize: 11), overflow: TextOverflow.ellipsis))]));
  }

  void _showAddDeptDialog(BuildContext context, DataService ds) {
    final nameC = TextEditingController();
    final codeC = TextEditingController();
    showDialog(context: context, builder: (ctx) => AlertDialog(
      backgroundColor: AppColors.surface,
      title: const Text('Add Department', style: TextStyle(color: AppColors.textDark)),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(controller: nameC, decoration: const InputDecoration(labelText: 'Department Name', border: OutlineInputBorder())),
        const SizedBox(height: 12),
        TextField(controller: codeC, decoration: const InputDecoration(labelText: 'Department Code (e.g. CSE)', border: OutlineInputBorder())),
      ]),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
          onPressed: () {
            if (nameC.text.isNotEmpty && codeC.text.isNotEmpty) {
              ds.addDepartment({'departmentName': nameC.text, 'departmentCode': codeC.text.toUpperCase(), 'hodId': ''});
              Navigator.pop(ctx); setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${nameC.text} department created'), backgroundColor: AppColors.secondary, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))));
            }
          },
          child: const Text('Create'),
        ),
      ],
    ));
  }
}
