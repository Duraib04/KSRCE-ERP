import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/data_service.dart';
import '../../../../core/theme/app_colors.dart';

class AdminFacultyManagementPage extends StatefulWidget {
  const AdminFacultyManagementPage({super.key});
  @override
  State<AdminFacultyManagementPage> createState() => _AdminFacultyManagementPageState();
}

class _AdminFacultyManagementPageState extends State<AdminFacultyManagementPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DataService>(builder: (context, ds, _) {
      if (!ds.isLoaded) return const Scaffold(backgroundColor: AppColors.background, body: Center(child: CircularProgressIndicator()));
      final allFaculty = ds.faculty;

      return Scaffold(
        backgroundColor: AppColors.background,
        body: LayoutBuilder(builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 700;
          return SingleChildScrollView(
            padding: EdgeInsets.all(isMobile ? 16 : 24),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                const Icon(Icons.person_add, color: AppColors.primary, size: 28),
                const SizedBox(width: 12),
                const Expanded(child: Text('Faculty Management', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textDark))),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add, size: 18), label: const Text('Add Faculty'),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                  onPressed: () => _showAddFacultyDialog(context, ds),
                ),
              ]),
              const SizedBox(height: 8),
              Text('${allFaculty.length} faculty members', style: const TextStyle(color: AppColors.textLight, fontSize: 14)),
              const SizedBox(height: 20),
              ...allFaculty.map((f) {
                final deptCode = ds.getDepartmentCode(f['departmentId'] as String? ?? '');
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
                  child: Row(children: [
                    CircleAvatar(radius: 20, backgroundColor: AppColors.primary.withOpacity(0.15),
                      child: Text((f['name'] as String? ?? '?')[0], style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold))),
                    const SizedBox(width: 12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [
                        Text(f['name'] as String? ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textDark)),
                        if (f['isHOD'] == true) ...[const SizedBox(width: 6), Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: AppColors.accent.withOpacity(0.15), borderRadius: BorderRadius.circular(4)), child: const Text('HOD', style: TextStyle(color: AppColors.accent, fontSize: 10, fontWeight: FontWeight.bold)))],
                      ]),
                      Text('${f['facultyId']} | $deptCode | ${f['designation'] ?? ''}', style: const TextStyle(color: AppColors.textLight, fontSize: 12)),
                    ])),
                    Text(f['email'] as String? ?? '', style: const TextStyle(color: AppColors.textLight, fontSize: 11)),
                  ]),
                );
              }),
            ]),
          );
        }),
      );
    });
  }

  void _showAddFacultyDialog(BuildContext context, DataService ds) {
    final nameC = TextEditingController();
    final emailC = TextEditingController();
    final phoneC = TextEditingController();
    final desigC = TextEditingController();
    final qualC = TextEditingController();
    String? selectedDeptId;

    showDialog(context: context, builder: (ctx) => StatefulBuilder(builder: (ctx2, setS) => AlertDialog(
      backgroundColor: AppColors.surface,
      title: const Text('Add Faculty', style: TextStyle(color: AppColors.textDark)),
      content: SizedBox(width: 400, child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(controller: nameC, decoration: const InputDecoration(labelText: 'Full Name', border: OutlineInputBorder())),
        const SizedBox(height: 10),
        TextField(controller: emailC, decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder())),
        const SizedBox(height: 10),
        TextField(controller: phoneC, decoration: const InputDecoration(labelText: 'Phone', border: OutlineInputBorder())),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(value: selectedDeptId, isExpanded: true,
          decoration: const InputDecoration(labelText: 'Department', border: OutlineInputBorder()),
          items: ds.departments.map((d) => DropdownMenuItem(value: d['departmentId'] as String, child: Text('${d['departmentCode']} - ${d['departmentName']}', style: const TextStyle(fontSize: 13)))).toList(),
          onChanged: (v) => setS(() => selectedDeptId = v)),
        const SizedBox(height: 10),
        TextField(controller: desigC, decoration: const InputDecoration(labelText: 'Designation', border: OutlineInputBorder())),
        const SizedBox(height: 10),
        TextField(controller: qualC, decoration: const InputDecoration(labelText: 'Qualification', border: OutlineInputBorder())),
      ]))),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
          onPressed: () {
            if (nameC.text.isNotEmpty && selectedDeptId != null) {
              ds.addFaculty({'name': nameC.text, 'email': emailC.text, 'phone': phoneC.text, 'departmentId': selectedDeptId, 'designation': desigC.text, 'qualification': qualC.text, 'specialization': '', 'dateOfJoining': DateTime.now().toIso8601String().substring(0, 10)});
              Navigator.pop(ctx); setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${nameC.text} added as faculty'), backgroundColor: AppColors.secondary, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))));
            }
          },
          child: const Text('Create'),
        ),
      ],
    )));
  }
}
