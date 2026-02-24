import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/data_service.dart';

class AdminReportsPage extends StatelessWidget {
  const AdminReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ds = Provider.of<DataService>(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Reports & Analytics', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 8),
        const Text('View system reports and analytics', style: TextStyle(fontSize: 14, color: Colors.white54)),
        const SizedBox(height: 32),
        LayoutBuilder(builder: (ctx, c) {
          final w = c.maxWidth > 800;
          return Wrap(spacing: 16, runSpacing: 16, children: [
            _ReportCard(title: 'Student Enrollment', icon: Icons.school, count: '${ds.students.length}', subtitle: 'Total registered students', color: const Color(0xFF1565C0), width: w ? (c.maxWidth - 32) / 3 : c.maxWidth),
            _ReportCard(title: 'Course Statistics', icon: Icons.book, count: '${ds.courses.length}', subtitle: 'Active courses', color: const Color(0xFF4CAF50), width: w ? (c.maxWidth - 32) / 3 : c.maxWidth),
            _ReportCard(title: 'Complaints', icon: Icons.warning, count: '${ds.complaints.length}', subtitle: '${ds.complaints.where((c) => c["status"] == "pending").length} pending', color: const Color(0xFFD4A843), width: w ? (c.maxWidth - 32) / 3 : c.maxWidth),
          ]);
        }),
        const SizedBox(height: 24),
        Container(
          width: double.infinity, padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: const Color(0xFF111D35), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFF1E3055))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Department-wise Student Count', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 16),
            ...() {
              final deptMap = <String, int>{};
              for (var s in ds.students) { final d = s['department'] ?? 'Unknown'; deptMap[d] = (deptMap[d] ?? 0) + 1; }
              return deptMap.entries.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(children: [
                  SizedBox(width: 120, child: Text(e.key, style: const TextStyle(color: Colors.white70))),
                  Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(value: e.value / (ds.students.isEmpty ? 1 : ds.students.length),
                      backgroundColor: const Color(0xFF1E3055), color: const Color(0xFF1565C0), minHeight: 22))),
                  const SizedBox(width: 12),
                  Text('${e.value}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ]),
              ));
            }(),
          ]),
        ),
        const SizedBox(height: 24),
        Container(
          width: double.infinity, padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: const Color(0xFF111D35), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFF1E3055))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Attendance Overview', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 16),
            ...ds.attendance.map((a) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(children: [
                SizedBox(width: 120, child: Text(a['courseId'] ?? '', style: const TextStyle(color: Colors.white70))),
                Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(value: (a['percentage'] ?? 0) / 100.0,
                    backgroundColor: const Color(0xFF1E3055),
                    color: (a['percentage'] ?? 0) >= 75 ? const Color(0xFF4CAF50) : const Color(0xFFEF5350), minHeight: 22))),
                const SizedBox(width: 12),
                Text('${a['percentage'] ?? 0}%', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ]),
            )),
          ]),
        ),
      ]),
    );
  }
}

class _ReportCard extends StatelessWidget {
  final String title, count, subtitle; final IconData icon; final Color color; final double width;
  const _ReportCard({required this.title, required this.icon, required this.count, required this.subtitle, required this.color, required this.width});
  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width, child: Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFF111D35), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFF1E3055))),
      child: Row(children: [
        Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: color, size: 28)),
        const SizedBox(width: 16),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(count, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
          Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white)),
          Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.white54)),
        ]),
      ]),
    ));
  }
}
