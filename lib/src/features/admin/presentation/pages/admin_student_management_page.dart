import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/data_service.dart';
import '../../../../core/theme/app_colors.dart';

class AdminStudentManagementPage extends StatefulWidget {
  const AdminStudentManagementPage({super.key});
  @override
  State<AdminStudentManagementPage> createState() => _AdminStudentManagementPageState();
}

class _AdminStudentManagementPageState extends State<AdminStudentManagementPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DataService>(builder: (context, ds, _) {
      if (!ds.isLoaded) return const Scaffold(backgroundColor: AppColors.background, body: Center(child: CircularProgressIndicator()));
      final allStudents = ds.students;

      return Scaffold(
        backgroundColor: AppColors.background,
        body: LayoutBuilder(builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 700;
          return SingleChildScrollView(
            padding: EdgeInsets.all(isMobile ? 16 : 24),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                const Icon(Icons.group_add, color: AppColors.primary, size: 28),
                const SizedBox(width: 12),
                const Expanded(child: Text('Student Management', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textDark))),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add, size: 18), label: const Text('Add Student'),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                  onPressed: () => _showAddStudentDialog(context, ds),
                ),
              ]),
              const SizedBox(height: 8),
              Text('${allStudents.length} students enrolled', style: const TextStyle(color: AppColors.textLight, fontSize: 14)),
              const SizedBox(height: 20),
              ...allStudents.map((s) {
                final deptCode = ds.getDepartmentCode(s['departmentId'] as String? ?? '');
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.border)),
                  child: Row(children: [
                    CircleAvatar(radius: 18, backgroundColor: AppColors.secondary.withOpacity(0.15),
                      child: Text((s['name'] as String? ?? '?')[0], style: const TextStyle(color: AppColors.secondary, fontWeight: FontWeight.bold, fontSize: 14))),
                    const SizedBox(width: 12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(s['name'] as String? ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textDark)),
                      Text('${s['studentId']} | $deptCode | Year ${s['year']} Sec ${s['section']} | CGPA: ${s['cgpa'] ?? 'N/A'}', style: const TextStyle(color: AppColors.textLight, fontSize: 12)),
                    ])),
                  ]),
                );
              }),
            ]),
          );
        }),
      );
    });
  }

  void _showAddStudentDialog(BuildContext context, DataService ds) {
    final nameC = TextEditingController();
    final emailC = TextEditingController();
    final phoneC = TextEditingController();
    String? selectedDeptId;
    final yearC = TextEditingController();
    final sectionC = TextEditingController();

    showDialog(context: context, builder: (ctx) => StatefulBuilder(builder: (ctx2, setS) => AlertDialog(
      backgroundColor: AppColors.surface,
      title: const Text('Add Student', style: TextStyle(color: AppColors.textDark)),
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
        Row(children: [
          Expanded(child: TextField(controller: yearC, decoration: const InputDecoration(labelText: 'Year', border: OutlineInputBorder()), keyboardType: TextInputType.number)),
          const SizedBox(width: 10),
          Expanded(child: TextField(controller: sectionC, decoration: const InputDecoration(labelText: 'Section', border: OutlineInputBorder()))),
        ]),
      ]))),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
          onPressed: () {
            if (nameC.text.isNotEmpty && selectedDeptId != null && yearC.text.isNotEmpty && sectionC.text.isNotEmpty) {
              ds.addStudent({'name': nameC.text, 'email': emailC.text, 'phone': phoneC.text, 'departmentId': selectedDeptId, 'department': ds.getDepartmentName(selectedDeptId!), 'year': yearC.text, 'section': sectionC.text.toUpperCase(), 'cgpa': 0.0, 'dateOfBirth': '', 'bloodGroup': '', 'address': '', 'parentName': '', 'parentPhone': '', 'admissionDate': DateTime.now().toIso8601String().substring(0, 10)});
              Navigator.pop(ctx); setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${nameC.text} enrolled successfully'), backgroundColor: AppColors.secondary, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))));
            }
          },
          child: const Text('Enroll'),
        ),
      ],
    )));
  }
}
