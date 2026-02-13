import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes.dart';
import '../../../../services/auth_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/design_tokens.dart';
import '../../../../core/presentation/core_widgets.dart';

class StudentDashboard extends StatefulWidget {
  final String userId;

  const StudentDashboard({Key? key, required this.userId}) : super(key: key);

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  int _selectedIndex = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // Simulate loading data
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _navigateTo(String route) {
    context.push(route);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Dashboard'),
        centerTitle: true,
        elevation: 0,
        actions: [
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
                  child: Icon(Icons.person, size: 40),
                ),
                const SizedBox(height: 12),
                Text(
                  widget.userId,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Student',
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
            leading: const Icon(Icons.class_),
            title: const Text('My Courses'),
            selected: _selectedIndex == 1,
            onTap: () {
              _navigateTo(StudentRoutes.courses);
            },
          ),
          ListTile(
            leading: const Icon(Icons.assignment),
            title: const Text('Assignments'),
            selected: _selectedIndex == 2,
            onTap: () {
              _navigateTo(StudentRoutes.assignments);
            },
          ),
          ListTile(
            leading: const Icon(Icons.grade),
            title: const Text('Grades & Results'),
            selected: _selectedIndex == 3,
            onTap: () {
              _navigateTo(StudentRoutes.results);
            },
          ),
          ListTile(
            leading: const Icon(Icons.event),
            title: const Text('Time Table'),
            selected: _selectedIndex == 4,
            onTap: () {
              _navigateTo(StudentRoutes.timeTable);
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text('Attendance'),
            selected: _selectedIndex == 5,
            onTap: () {
              _navigateTo(StudentRoutes.attendance);
            },
          ),
          ListTile(
            leading: const Icon(Icons.notification_important),
            title: const Text('Notifications'),
            selected: _selectedIndex == 6,
            onTap: () {
              _navigateTo(StudentRoutes.notifications);
            },
          ),
          ListTile(
            leading: const Icon(Icons.message),
            title: const Text('Complaints'),
            selected: _selectedIndex == 7,
            onTap: () {
              _navigateTo(StudentRoutes.complaints);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('My Profile'),
            onTap: () {
              _navigateTo(StudentRoutes.profile);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
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
    if (_isLoading) {
      return Padding(
        padding: AppSpacing.paddingLg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LoadingShimmer(height: 32, width: 200),
            SizedBox(height: AppSpacing.xl),
            LoadingShimmer.compact(count: 4),
            SizedBox(height: AppSpacing.xxl),
            LoadingShimmer.list(count: 3),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Padding(
        padding: AppSpacing.paddingLg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome header
            PageHeaderCompact(
              title: 'Welcome, ${widget.userId}!',
            ),
            SizedBox(height: AppSpacing.xl),
            
            // Quick stats with responsive grid
            _buildQuickStats(),
            SizedBox(height: AppSpacing.xxl),
            
            // Upcoming classes
            _buildUpcomingClasses(),
            SizedBox(height: AppSpacing.xxl),
            
            // Announcements
            _buildAnnouncements(),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Stats',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        SizedBox(height: AppSpacing.md),
        ResponsiveGrid(
          minItemWidth: 150,
          spacing: AppSpacing.sm,
          childAspectRatio: 1.1,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            StatCard(
              icon: Icons.trending_up,
              value: '3.85',
              title: 'GPA',
              subtitle: 'Overall',
              color: AppColors.student,
              trendIcon: Icons.trending_up,
            ),
            StatCard(
              icon: Icons.check_circle,
              value: '92%',
              title: 'Attendance',
              subtitle: '+2% this month',
              color: AppColors.success,
              trendIcon: Icons.trending_up,
            ),
            StatCard(
              icon: Icons.class_,
              value: '5',
              title: 'Courses',
              subtitle: 'This semester',
              color: AppColors.info,
            ),
            StatCard(
              icon: Icons.pending_actions,
              value: '3',
              title: 'Pending Tasks',
              subtitle: 'Due this week',
              color: AppColors.warning,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildUpcomingClasses() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upcoming Classes',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        Card(
          child: ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.school, color: Colors.white),
              backgroundColor: Colors.blue,
            ),
            title: const Text('Mathematics 101'),
            subtitle: const Text('Today • 10:00 AM'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
        ),
        const SizedBox(height: 8),
        Card(
          child: ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.science, color: Colors.white),
              backgroundColor: Colors.green,
            ),
            title: const Text('Physics Lab'),
            subtitle: const Text('Tomorrow • 2:00 PM'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildAnnouncements() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Announcements',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Semester Results Published',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Your 2nd semester results are now available in the grades section',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(height: 8),
                Text(
                  'Today at 9:30 AM',
                  style: TextStyle(fontSize: 11, color: Colors.grey[400]),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Assignment Deadline Extended',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'The deadline for DSA assignment has been extended to Friday',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(height: 8),
                Text(
                  'Yesterday at 3:15 PM',
                  style: TextStyle(fontSize: 11, color: Colors.grey[400]),
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
        switch (index) {
          case 0:
            // Home/Dashboard
            setState(() => _selectedIndex = 0);
            break;
          case 1:
            // Courses
            _navigateTo(StudentRoutes.courses);
            break;
          case 2:
            // Assignments
            _navigateTo(StudentRoutes.assignments);
            break;
          case 3:
            // More
            Scaffold.of(context).openDrawer();
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.class_),
          label: 'Courses',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment),
          label: 'Assignments',
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
