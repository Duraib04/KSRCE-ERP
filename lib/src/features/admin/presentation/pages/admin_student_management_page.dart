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
                final sid = s['studentId'] as String? ?? '';
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
                      Text('$sid | $deptCode | Year ${s['year']} Sec ${s['section']} | CGPA: ${s['cgpa'] ?? 'N/A'}', style: const TextStyle(color: AppColors.textLight, fontSize: 12)),
                    ])),
                    IconButton(
                      icon: const Icon(Icons.edit, size: 18, color: AppColors.primary),
                      tooltip: 'Edit Student',
                      onPressed: () => _showEditStudentDialog(context, ds, s),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 18, color: Colors.red),
                      tooltip: 'Delete Student',
                      onPressed: () => _confirmDeleteStudent(context, ds, sid, s['name'] as String? ?? ''),
                    ),
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

  void _showEditStudentDialog(BuildContext context, DataService ds, Map<String, dynamic> student) {
    final nameC = TextEditingController(text: student['name'] as String? ?? '');
    final emailC = TextEditingController(text: student['email'] as String? ?? '');
    final phoneC = TextEditingController(text: student['phone'] as String? ?? '');
    final yearC = TextEditingController(text: '${student['year'] ?? ''}');
    final sectionC = TextEditingController(text: student['section'] as String? ?? '');
    final cgpaC = TextEditingController(text: '${student['cgpa'] ?? ''}');
    final dobC = TextEditingController(text: student['dateOfBirth'] as String? ?? '');
    final bloodC = TextEditingController(text: student['bloodGroup'] as String? ?? '');
    final addressC = TextEditingController(text: student['address'] as String? ?? '');
    final parentNameC = TextEditingController(text: student['parentName'] as String? ?? '');
    final parentPhoneC = TextEditingController(text: student['parentPhone'] as String? ?? '');
    String? selectedDeptId = student['departmentId'] as String?;
    final sid = student['studentId'] as String? ?? '';

    showDialog(context: context, builder: (ctx) => StatefulBuilder(builder: (ctx2, setS) => AlertDialog(
      backgroundColor: AppColors.surface,
      title: Row(children: [
        const Icon(Icons.edit, color: AppColors.primary, size: 20),
        const SizedBox(width: 8),
        Text('Edit Student — $sid', style: const TextStyle(color: AppColors.textDark, fontSize: 18)),
      ]),
      content: SizedBox(width: 480, child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(controller: nameC, decoration: const InputDecoration(labelText: 'Full Name', prefixIcon: Icon(Icons.person_outline), border: OutlineInputBorder())),
        const SizedBox(height: 10),
        TextField(controller: emailC, decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_outlined), border: OutlineInputBorder())),
        const SizedBox(height: 10),
        TextField(controller: phoneC, decoration: const InputDecoration(labelText: 'Phone', prefixIcon: Icon(Icons.phone_outlined), border: OutlineInputBorder())),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(value: selectedDeptId, isExpanded: true,
          decoration: const InputDecoration(labelText: 'Department', prefixIcon: Icon(Icons.business_outlined), border: OutlineInputBorder()),
          items: ds.departments.map((d) => DropdownMenuItem(value: d['departmentId'] as String, child: Text('${d['departmentCode']} - ${d['departmentName']}', style: const TextStyle(fontSize: 13)))).toList(),
          onChanged: (v) => setS(() => selectedDeptId = v)),
        const SizedBox(height: 10),
        Row(children: [
          Expanded(child: TextField(controller: yearC, decoration: const InputDecoration(labelText: 'Year', prefixIcon: Icon(Icons.calendar_today), border: OutlineInputBorder()), keyboardType: TextInputType.number)),
          const SizedBox(width: 10),
          Expanded(child: TextField(controller: sectionC, decoration: const InputDecoration(labelText: 'Section', prefixIcon: Icon(Icons.class_outlined), border: OutlineInputBorder()))),
        ]),
        const SizedBox(height: 10),
        Row(children: [
          Expanded(child: TextField(controller: cgpaC, decoration: const InputDecoration(labelText: 'CGPA', prefixIcon: Icon(Icons.grade_outlined), border: OutlineInputBorder()), keyboardType: TextInputType.number)),
          const SizedBox(width: 10),
          Expanded(child: TextField(controller: bloodC, decoration: const InputDecoration(labelText: 'Blood Group', prefixIcon: Icon(Icons.bloodtype_outlined), border: OutlineInputBorder()))),
        ]),
        const SizedBox(height: 10),
        TextField(controller: dobC, decoration: const InputDecoration(labelText: 'Date of Birth (YYYY-MM-DD)', prefixIcon: Icon(Icons.cake_outlined), border: OutlineInputBorder())),
        const SizedBox(height: 10),
        TextField(controller: addressC, decoration: const InputDecoration(labelText: 'Address', prefixIcon: Icon(Icons.home_outlined), border: OutlineInputBorder()), maxLines: 2),
        const SizedBox(height: 10),
        Row(children: [
          Expanded(child: TextField(controller: parentNameC, decoration: const InputDecoration(labelText: 'Parent Name', prefixIcon: Icon(Icons.family_restroom), border: OutlineInputBorder()))),
          const SizedBox(width: 10),
          Expanded(child: TextField(controller: parentPhoneC, decoration: const InputDecoration(labelText: 'Parent Phone', prefixIcon: Icon(Icons.phone), border: OutlineInputBorder()))),
        ]),
      ]))),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
        ElevatedButton.icon(
          icon: const Icon(Icons.save, size: 18),
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
          onPressed: () {
            if (nameC.text.isNotEmpty) {
              ds.updateStudent(sid, {
                'name': nameC.text,
                'email': emailC.text,
                'phone': phoneC.text,
                'departmentId': selectedDeptId,
                'department': selectedDeptId != null ? ds.getDepartmentName(selectedDeptId!) : '',
                'year': yearC.text,
                'section': sectionC.text.toUpperCase(),
                'cgpa': double.tryParse(cgpaC.text) ?? 0.0,
                'dateOfBirth': dobC.text,
                'bloodGroup': bloodC.text,
                'address': addressC.text,
                'parentName': parentNameC.text,
                'parentPhone': parentPhoneC.text,
              });
              Navigator.pop(ctx);
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('${nameC.text} updated successfully'),
                backgroundColor: AppColors.secondary,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ));
            }
          },
          label: const Text('Save Changes'),
        ),
      ],
    )));
  }

  void _confirmDeleteStudent(BuildContext context, DataService ds, String sid, String name) {
    showDialog(context: context, builder: (ctx) => AlertDialog(
      backgroundColor: AppColors.surface,
      title: const Text('Delete Student', style: TextStyle(color: Colors.red)),
      content: Text('Are you sure you want to delete $name ($sid)?\n\nThis action cannot be undone.', style: const TextStyle(color: AppColors.textMedium)),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
          onPressed: () {
            ds.deleteStudent(sid);
            Navigator.pop(ctx);
            setState(() {});
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('$name deleted'), backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ));
          },
          child: const Text('Delete'),
        ),
      ],
    ));
  }
}
