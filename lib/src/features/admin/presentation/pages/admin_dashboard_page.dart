import 'package:flutter/material.dart';
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Admin Dashboard', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 8),
          Text('Welcome back, Administrator', style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.6))),
          const SizedBox(height: 32),
          // Stats cards
          LayoutBuilder(builder: (context, constraints) {
            final isWide = constraints.maxWidth > 800;
            final cards = [
              _StatCard(icon: Icons.people, label: 'Total Students', value: '$totalStudents', color: const Color(0xFF1565C0)),
              _StatCard(icon: Icons.person, label: 'Active Users', value: '$activeUsers', color: const Color(0xFF4CAF50)),
              _StatCard(icon: Icons.book, label: 'Total Courses', value: '$totalCourses', color: const Color(0xFFD4A843)),
              _StatCard(icon: Icons.warning_amber, label: 'Pending Complaints', value: '$pendingComplaints', color: const Color(0xFFEF5350)),
            ];
            if (isWide) {
              return Row(children: cards.map((c) => Expanded(child: Padding(padding: const EdgeInsets.only(right: 16), child: c))).toList());
            }
            return Wrap(spacing: 16, runSpacing: 16, children: cards.map((c) => SizedBox(width: (constraints.maxWidth - 16) / 2, child: c)).toList());
          }),
          const SizedBox(height: 32),
          // Quick Actions
          const Text('Quick Actions', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 16),
          Wrap(spacing: 16, runSpacing: 16, children: [
            _ActionButton(icon: Icons.upload_file, label: 'Upload Students\n(Excel/CSV)', color: const Color(0xFF1565C0), route: '/admin/users'),
            _ActionButton(icon: Icons.people, label: 'Manage\nUsers', color: const Color(0xFF4CAF50), route: '/admin/users'),
            _ActionButton(icon: Icons.analytics, label: 'View\nReports', color: const Color(0xFFD4A843), route: '/admin/reports'),
            _ActionButton(icon: Icons.notifications, label: 'Send\nNotification', color: const Color(0xFF7E57C2), route: '/admin/notifications'),
          ]),
          const SizedBox(height: 32),
          // Recent Activity
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF111D35),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF1E3055)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Recent Activity', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 16),
                _ActivityItem(icon: Icons.person_add, text: '5 new students registered', time: '2 hours ago', color: const Color(0xFF4CAF50)),
                _ActivityItem(icon: Icons.upload, text: 'Bulk upload completed (120 records)', time: '5 hours ago', color: const Color(0xFF1565C0)),
                _ActivityItem(icon: Icons.block, text: 'User STU003 temporarily suspended', time: '1 day ago', color: const Color(0xFFEF5350)),
                _ActivityItem(icon: Icons.check_circle, text: '3 complaints resolved', time: '2 days ago', color: const Color(0xFFD4A843)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon; final String label; final String value; final Color color;
  const _StatCard({required this.icon, required this.label, required this.value, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF111D35), borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1E3055)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: color, size: 24)),
        const SizedBox(height: 12),
        Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.6))),
      ]),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon; final String label; final Color color; final String route;
  const _ActionButton({required this.icon, required this.label, required this.color, required this.route});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 150, padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: const Color(0xFF111D35), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFF1E3055))),
        child: Column(children: [
          Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: color.withOpacity(0.15), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 28)),
          const SizedBox(height: 12),
          Text(label, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
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
      child: Row(children: [
        Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: color.withOpacity(0.15), shape: BoxShape.circle),
          child: Icon(icon, color: color, size: 18)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(text, style: const TextStyle(color: Colors.white, fontSize: 14)),
          Text(time, style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 12)),
        ])),
      ]),
    );
  }
}
