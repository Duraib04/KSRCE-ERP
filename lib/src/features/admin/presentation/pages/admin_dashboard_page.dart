import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:provider/provider.dart';
import '../../../../core/data_service.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ds = Provider.of<DataService>(context);
    final totalStudents = ds.students.length;
    final totalCourses = ds.courses.length;
    final pendingComplaints = ds.complaints.where((c) => c['status'] == 'pending').length;
    final activeUsers = ds.users.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: LayoutBuilder(builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Admin Dashboard', style: TextStyle(fontSize: isMobile ? 22 : 28, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            Text('Welcome back, Administrator', style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.6))),
            const SizedBox(height: 24),
            _buildStatsGrid(isMobile, constraints.maxWidth, totalStudents, activeUsers, totalCourses, pendingComplaints),
            const SizedBox(height: 28),
            Text('Quick Actions', style: TextStyle(fontSize: isMobile ? 18 : 20, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 16),
            _buildQuickActions(isMobile, constraints.maxWidth),
            const SizedBox(height: 28),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(isMobile ? 16 : 20),
              decoration: BoxDecoration(
                color: AppColors.surface, borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Recent Activity', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                const SizedBox(height: 16),
                _ActivityItem(icon: Icons.person_add, text: '5 new students registered', time: '2 hours ago', color: const Color(0xFF4CAF50)),
                _ActivityItem(icon: Icons.upload, text: 'Bulk upload completed (120 records)', time: '5 hours ago', color: AppColors.primary),
                _ActivityItem(icon: Icons.block, text: 'User STU003 temporarily suspended', time: '1 day ago', color: const Color(0xFFEF5350)),
                _ActivityItem(icon: Icons.check_circle, text: '3 complaints resolved', time: '2 days ago', color: AppColors.accent),
              ]),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildStatsGrid(bool isMobile, double maxWidth, int totalStudents, int activeUsers, int totalCourses, int pendingComplaints) {
    final cards = [
      {'icon': Icons.people, 'label': 'Total Students', 'value': '$totalStudents', 'color': AppColors.primary},
      {'icon': Icons.person, 'label': 'Active Users', 'value': '$activeUsers', 'color': const Color(0xFF4CAF50)},
      {'icon': Icons.book, 'label': 'Total Courses', 'value': '$totalCourses', 'color': AppColors.accent},
      {'icon': Icons.warning_amber, 'label': 'Pending Complaints', 'value': '$pendingComplaints', 'color': const Color(0xFFEF5350)},
    ];
    if (isMobile) {
      return GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.3,
        children: cards.map((c) => _buildStatCard(c)).toList(),
      );
    }
    return Row(children: cards.map((c) => Expanded(child: Padding(
      padding: const EdgeInsets.only(right: 16), child: _buildStatCard(c),
    ))).toList());
  }

  Widget _buildStatCard(Map<String, Object> c) {
    final color = c['color'] as Color;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface, borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
          child: Icon(c['icon'] as IconData, color: color, size: 22)),
        const SizedBox(height: 10),
        Text(c['value'] as String, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textDark)),
        const SizedBox(height: 4),
        Text(c['label'] as String, style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.6))),
      ]),
    );
  }

  Widget _buildQuickActions(bool isMobile, double maxWidth) {
    final actions = [
      {'icon': Icons.upload_file, 'label': 'Upload Students\n(Excel/CSV)', 'color': AppColors.primary, 'route': '/admin/users'},
      {'icon': Icons.people, 'label': 'Manage\nUsers', 'color': const Color(0xFF4CAF50), 'route': '/admin/users'},
      {'icon': Icons.analytics, 'label': 'View\nReports', 'color': AppColors.accent, 'route': '/admin/reports'},
      {'icon': Icons.notifications, 'label': 'Send\nNotification', 'color': const Color(0xFF7E57C2), 'route': '/admin/notifications'},
    ];
    if (isMobile) {
      return GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.2,
        children: actions.map((a) => _buildActionCard(a)).toList(),
      );
    }
    return Wrap(spacing: 16, runSpacing: 16,
      children: actions.map((a) => SizedBox(width: 150, child: _buildActionCard(a))).toList(),
    );
  }

  Widget _buildActionCard(Map<String, Object> a) {
    final color = a['color'] as Color;
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: color.withOpacity(0.15), shape: BoxShape.circle),
            child: Icon(a['icon'] as IconData, color: color, size: 26)),
          const SizedBox(height: 10),
          Text(a['label'] as String, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
        ]),
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final IconData icon; final String text; final String time; final Color color;
  const _ActivityItem({required this.icon, required this.text, required this.time, required this.color});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: color.withOpacity(0.15), shape: BoxShape.circle),
          child: Icon(icon, color: color, size: 18)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(text, style: const TextStyle(color: AppColors.textDark, fontSize: 13)),
          const SizedBox(height: 2),
          Text(time, style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 12)),
        ])),
      ]),
    );
  }
}
