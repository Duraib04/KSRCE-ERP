import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes.dart';
import '../../../../services/auth_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/design_tokens.dart';
import '../../../../core/presentation/core_widgets.dart';

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
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.admin,
                  Theme.of(context).colorScheme.primary,
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Theme.of(context).colorScheme.onPrimary,
                  child: Icon(
                    Icons.admin_panel_settings,
                    size: 40,
                    color: AppColors.admin,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Admin: ${widget.userId}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'System Administrator',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.8),
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
            leading: const Icon(Icons.logout, color: AppColors.error),
            title: const Text('Logout', style: TextStyle(color: AppColors.error)),
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
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 220,
          pinned: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu_rounded),
              tooltip: 'Menu',
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_rounded),
              tooltip: 'Notifications',
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.logout_rounded),
              tooltip: 'Logout',
              onPressed: _showLogoutDialog,
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: _buildHeroHeader(),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: AppSpacing.paddingLg,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSystemMetrics(),
                SizedBox(height: AppSpacing.xxl),
                _buildQuickActions(),
                SizedBox(height: AppSpacing.xxl),
                _buildRecentActivity(),
                SizedBox(height: AppSpacing.xxl),
                _buildSystemHealth(),
                SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeroHeader() {
    final theme = Theme.of(context);
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          'assets/images/b-block.jpeg',
          fit: BoxFit.cover,
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.admin.withValues(alpha: 0.85),
                theme.colorScheme.primary.withValues(alpha: 0.65),
                Colors.black.withValues(alpha: 0.4),
              ],
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Admin Dashboard',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                    letterSpacing: 0.6,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: AppSpacing.xs),
                Text(
                  'System Overview',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    StatusBadge.active(label: 'System Operational'),
                    SizedBox(width: AppSpacing.md),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        borderRadius: AppRadius.radiusFull,
                        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                      ),
                      child: Text(
                        'Users: 1245',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.update_rounded),
                      label: const Text('System Update'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: BorderSide(color: Colors.white.withValues(alpha: 0.6)),
                      ),
                    ),
                    SizedBox(width: AppSpacing.md),
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.backup_rounded),
                      label: const Text('Backup Now'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: BorderSide(color: Colors.white.withValues(alpha: 0.6)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSystemMetrics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'System Metrics',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
        SizedBox(height: AppSpacing.md),
        ResponsiveGrid(
          minItemWidth: 220,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            const StatCard(
              icon: Icons.people_rounded,
              value: '1,245',
              title: 'Total Users',
              color: AppColors.admin,
            ),
            const StatCard(
              icon: Icons.person_add_rounded,
              value: '45',
              title: 'Active Sessions',
              color: AppColors.success,
            ),
            const StatCard(
              icon: Icons.warning_rounded,
              value: '3',
              title: 'System Alerts',
              color: AppColors.warning,
            ),
            const StatCard(
              icon: Icons.storage_rounded,
              value: '785 GB',
              title: 'Storage Used',
              color: AppColors.secondaryBlue,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
        SizedBox(height: AppSpacing.md),
        ResponsiveGrid(
          minItemWidth: 220,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.8,
          children: [
            _ActionButton(
              icon: Icons.person_add_rounded,
              label: 'Add User',
              color: AppColors.success,
              onTap: () {},
            ),
            _ActionButton(
              icon: Icons.lock_rounded,
              label: 'Manage Roles',
              color: AppColors.info,
              onTap: () {},
            ),
            _ActionButton(
              icon: Icons.update_rounded,
              label: 'System Update',
              color: AppColors.warning,
              onTap: () {},
            ),
            _ActionButton(
              icon: Icons.backup_rounded,
              label: 'Backup System',
              color: AppColors.admin,
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecentActivity() {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
        SizedBox(height: AppSpacing.md),
        AppCard.outlined(
          margin: EdgeInsets.zero,
          contentPadding: AppSpacing.paddingLg,
          child: Column(
            children: [
              _ActivityItem(
                icon: Icons.person,
                title: 'New user registration',
                subtitle: 'User ID: S20260215',
                time: '2 hours ago',
              ),
              SizedBox(height: AppSpacing.md),
              _ActivityItem(
                icon: Icons.edit_rounded,
                title: 'Course structure updated',
                subtitle: 'Mathematics dept - 5 new courses',
                time: '4 hours ago',
              ),
              SizedBox(height: AppSpacing.md),
              _ActivityItem(
                icon: Icons.warning_rounded,
                title: 'System alert: High CPU usage',
                subtitle: 'Server-02: 87% CPU utilization',
                time: '6 hours ago',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSystemHealth() {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'System Health',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
        SizedBox(height: AppSpacing.md),
        AppCard.outlined(
          margin: EdgeInsets.zero,
          contentPadding: AppSpacing.paddingLg,
          child: Column(
            children: [
              _HealthIndicator(
                label: 'API Server',
                status: 'Operational',
                statusColor: AppColors.success,
              ),
              SizedBox(height: AppSpacing.md),
              _HealthIndicator(
                label: 'Database',
                status: 'Operational',
                statusColor: AppColors.success,
              ),
              SizedBox(height: AppSpacing.md),
              _HealthIndicator(
                label: 'Email Service',
                status: 'Operational',
                statusColor: AppColors.success,
              ),
              SizedBox(height: AppSpacing.md),
              _HealthIndicator(
                label: 'Backup Service',
                status: 'Running',
                statusColor: AppColors.secondaryBlue,
              ),
            ],
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


class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Center(
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.radiusMd,
          child: Padding(
            padding: AppSpacing.paddingLg,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: AppRadius.radiusSm,
                  ),
                  child: Icon(icon, size: 24, color: color),
                ),
                SizedBox(height: AppSpacing.md),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
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
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.12),
                borderRadius: AppRadius.radiusSm,
              ),
              child: Icon(icon, size: 18, color: theme.colorScheme.primary),
            ),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: AppSpacing.xs),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              time,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
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
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: statusColor,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: AppSpacing.sm),
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.1),
            border: Border.all(color: statusColor),
            borderRadius: AppRadius.radiusSm,
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
