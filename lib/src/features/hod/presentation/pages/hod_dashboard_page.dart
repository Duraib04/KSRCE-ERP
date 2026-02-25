import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/data_service.dart';
import '../../../../core/theme/app_colors.dart';

class HodDashboardPage extends StatelessWidget {
  const HodDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DataService>(builder: (context, ds, _) {
      if (!ds.isLoaded) return const Scaffold(backgroundColor: AppColors.background, body: Center(child: CircularProgressIndicator()));

      final fac = ds.currentFaculty ?? {};
      final name = fac['name'] as String? ?? 'HOD';
      final deptId = fac['departmentId'] as String? ?? '';
      final dept = ds.getHODDepartment(ds.currentUserId ?? '') ?? {};
      final deptName = dept['departmentName'] as String? ?? deptId;
      final deptCode = dept['departmentCode'] as String? ?? '';

      final deptFaculty = ds.getDepartmentFaculty(deptId);
      final deptStudents = ds.getDepartmentStudents(deptId);
      final deptClasses = ds.getDepartmentClasses(deptId);
      final deptCourses = ds.getDepartmentCourses(deptId);
      final mentorAssigns = ds.getDepartmentMentorAssignments(deptId);

      return Scaffold(
        backgroundColor: AppColors.background,
        body: LayoutBuilder(builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 700;
          return SingleChildScrollView(
            padding: EdgeInsets.all(isMobile ? 16 : 24),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Welcome
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(isMobile ? 16 : 24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF1A365D), Color(0xFF2D4A7A)]),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 12, offset: const Offset(0, 4))],
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    CircleAvatar(radius: isMobile ? 24 : 32, backgroundColor: AppColors.accent,
                      child: Text(name.split(' ').where((w) => w.isNotEmpty).map((w) => w[0]).take(2).join().toUpperCase(),
                        style: TextStyle(color: Colors.white, fontSize: isMobile ? 16 : 20, fontWeight: FontWeight.bold))),
                    const SizedBox(width: 16),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Welcome, $name', style: TextStyle(color: Colors.white, fontSize: isMobile ? 18 : 22, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('Head of Department - $deptName ($deptCode)', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13)),
                    ])),
                  ]),
                ]),
              ),
              const SizedBox(height: 24),
              // Stats
              GridView.count(
                crossAxisCount: isMobile ? 2 : 4, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: isMobile ? 1.3 : 1.5,
                children: [
                  _statCard(Icons.people, 'Faculty', '${deptFaculty.length}', AppColors.primary),
                  _statCard(Icons.school, 'Students', '${deptStudents.length}', AppColors.secondary),
                  _statCard(Icons.class_, 'Classes', '${deptClasses.length}', AppColors.accent),
                  _statCard(Icons.menu_book, 'Courses', '${deptCourses.length}', Colors.purple),
                ],
              ),
              const SizedBox(height: 28),
              // Classes overview
              const Text('Classes & Advisers', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
              const SizedBox(height: 12),
              ...deptClasses.map((c) {
                final adviserId = c['classAdviserId'] as String? ?? '';
                final adviserName = adviserId.isNotEmpty ? ds.getFacultyName(adviserId) : 'Not Assigned';
                final studentCount = (c['studentIds'] as List<dynamic>?)?.length ?? 0;
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
                  child: Row(children: [
                    Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                      child: const Icon(Icons.class_, color: AppColors.primary, size: 22)),
                    const SizedBox(width: 14),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Year ${c['year']} - Section ${c['section']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textDark)),
                      const SizedBox(height: 4),
                      Text('Adviser: $adviserName | $studentCount students', style: const TextStyle(color: AppColors.textLight, fontSize: 13)),
                    ])),
                    Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: adviserId.isNotEmpty ? AppColors.secondary.withOpacity(0.15) : Colors.orange.withOpacity(0.15), borderRadius: BorderRadius.circular(6)),
                      child: Text(adviserId.isNotEmpty ? 'Assigned' : 'Pending', style: TextStyle(color: adviserId.isNotEmpty ? AppColors.secondary : Colors.orange, fontSize: 12, fontWeight: FontWeight.bold))),
                  ]),
                );
              }),
              const SizedBox(height: 28),
              // Mentor assignments overview
              const Text('Mentor Assignments', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
              const SizedBox(height: 12),
              if (mentorAssigns.isEmpty)
                Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
                  child: const Center(child: Text('No mentor assignments yet', style: TextStyle(color: AppColors.textLight))))
              else
                ...mentorAssigns.map((m) {
                  final menteeCount = (m['menteeIds'] as List<dynamic>?)?.length ?? 0;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
                    child: Row(children: [
                      CircleAvatar(radius: 18, backgroundColor: Colors.teal.withOpacity(0.15), child: const Icon(Icons.person, color: Colors.teal, size: 18)),
                      const SizedBox(width: 12),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(m['mentorName'] as String? ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textDark)),
                        Text('Year ${m['year']} Sec ${m['section']} | $menteeCount mentees', style: const TextStyle(color: AppColors.textLight, fontSize: 12)),
                      ])),
                    ]),
                  );
                }),
              const SizedBox(height: 16),
            ]),
          );
        }),
      );
    });
  }

  Widget _statCard(IconData icon, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: color, size: 22)),
        const SizedBox(height: 10),
        Text(value, style: const TextStyle(color: AppColors.textDark, fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: AppColors.textLight, fontSize: 12)),
      ]),
    );
  }
}
