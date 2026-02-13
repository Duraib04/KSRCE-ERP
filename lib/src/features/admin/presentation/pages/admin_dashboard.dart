import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes.dart';
import '../../../../services/auth_service.dart';

class AdminDashboard extends StatefulWidget {
  final String userId;

  const AdminDashboard({Key? key, required this.userId}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;

  void _navigateTo(String route) {
    context.push(route);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
            tooltip: 'Notifications',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _showLogoutDialog,
            tooltip: 'Logout',
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.admin_panel_settings, size: 40),
                ),
                const SizedBox(height: 12),
                Text(
                  'Admin: ${widget.userId}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'System Administrator',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            selected: _selectedIndex == 0,
            onTap: () {
              setState(() => _selectedIndex = 0);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.school),
            title: const Text('Students'),
            selected: _selectedIndex == 1,
            onTap: () {
              _navigateTo(AdminRoutes.studentsList);
            },
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Faculty'),
            selected: _selectedIndex == 2,
            onTap: () {
              _navigateTo(AdminRoutes.facultyManagement);
            },
          ),
          ListTile(
            leading: const Icon(Icons.book),
            title: const Text('Courses'),
            selected: _selectedIndex == 3,
            onTap: () {
              _navigateTo(AdminRoutes.courseManagement);
            },
          ),
          ListTile(
            leading: const Icon(Icons.assessment),
            title: const Text('Administration'),
            selected: _selectedIndex == 4,
            onTap: () {
              _navigateTo(AdminRoutes.dashboard);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('System Settings'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.security),
            title: const Text('Security'),
            onTap: () => Navigator.pop(context),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pop(context);
              _showLogoutDialog();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'System Overview',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            _buildSystemMetrics(),
            const SizedBox(height: 32),
            _buildQuickActions(),
            const SizedBox(height: 32),
            _buildRecentActivity(),
            const SizedBox(height: 32),
            _buildSystemHealth(),
          ],
        ),
      ),
    );
  }

  Widget _buildSystemMetrics() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _MetricCard(
          icon: Icons.people,
          value: '1,245',
          label: 'Total Users',
          color: Colors.blue,
        ),
        _MetricCard(
          icon: Icons.person_add,
          value: '45',
          label: 'Active Sessions',
          color: Colors.green,
        ),
        _MetricCard(
          icon: Icons.warning,
          value: '3',
          label: 'System Alerts',
          color: Colors.orange,
        ),
        _MetricCard(
          icon: Icons.storage,
          value: '785 GB',
          label: 'Storage Used',
          color: Colors.purple,
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 2.5,
          children: [
            _ActionButton(
              icon: Icons.person_add,
              label: 'Add User',
              onTap: () {},
            ),
            _ActionButton(
              icon: Icons.lock,
              label: 'Manage Roles',
              onTap: () {},
            ),
            _ActionButton(
              icon: Icons.update,
              label: 'System Update',
              onTap: () {},
            ),
            _ActionButton(
              icon: Icons.backup,
              label: 'Backup',
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecentActivity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                _ActivityItem(
                  icon: Icons.person,
                  title: 'New user registration',
                  subtitle: 'User ID: S20260215',
                  time: '2 hours ago',
                ),
                const Divider(height: 16),
                _ActivityItem(
                  icon: Icons.edit,
                  title: 'Course structure updated',
                  subtitle: 'Mathematics dept - 5 new courses',
                  time: '4 hours ago',
                ),
                const Divider(height: 16),
                _ActivityItem(
                  icon: Icons.warning,
                  title: 'System alert: High CPU usage',
                  subtitle: 'Server-02: 87% CPU utilization',
                  time: '6 hours ago',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSystemHealth() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'System Health',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _HealthIndicator(
                  label: 'API Server',
                  status: 'Operational',
                  statusColor: Colors.green,
                ),
                const SizedBox(height: 16),
                _HealthIndicator(
                  label: 'Database',
                  status: 'Operational',
                  statusColor: Colors.green,
                ),
                const SizedBox(height: 16),
                _HealthIndicator(
                  label: 'Email Service',
                  status: 'Operational',
                  statusColor: Colors.green,
                ),
                const SizedBox(height: 16),
                _HealthIndicator(
                  label: 'Backup Service',
                  status: 'Running',
                  statusColor: Colors.blue,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        setState(() => _selectedIndex = index);
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people),
          label: 'Users',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assessment),
          label: 'Reports',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.more_horiz),
          label: 'More',
        ),
      ],
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              AuthService.logout();
              context.go(AuthRoutes.login);
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _MetricCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 24),
              const SizedBox(height: 6),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String time;

  const _ActivityItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: Colors.blue),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
        Text(
          time,
          style: TextStyle(fontSize: 11, color: Colors.grey[400]),
        ),
      ],
    );
  }
}

class _HealthIndicator extends StatelessWidget {
  final String label;
  final String status;
  final Color statusColor;

  const _HealthIndicator({
    required this.label,
    required this.status,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            border: Border.all(color: statusColor),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            status,
            style: TextStyle(
              color: statusColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
