import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes.dart';
import '../../../../services/auth_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/design_tokens.dart';
import '../../../../core/presentation/core_widgets.dart';
import '../../data/faculty_data_service.dart';

class FacultyDashboard extends StatefulWidget {
  final String userId;

  const FacultyDashboard({Key? key, required this.userId}) : super(key: key);

  @override
  State<FacultyDashboard> createState() => _FacultyDashboardState();
}

class _FacultyDashboardState extends State<FacultyDashboard> {
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
                  AppColors.faculty,
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
                  child: Icon(Icons.person, size: 40, color: AppColors.faculty),
                ),
                const SizedBox(height: 12),
                Text(
                  'Dr. ${widget.userId}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Faculty Member',
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
            leading: const Icon(Icons.class_),
            title: const Text('My Classes'),
            selected: _selectedIndex == 1,
            onTap: () {
              _navigateTo(FacultyRoutes.myClasses);
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text('Schedule'),
            selected: _selectedIndex == 2,
            onTap: () {
              _navigateTo(FacultyRoutes.schedule);
            },
          ),
          ListTile(
            leading: const Icon(Icons.event_note),
            title: const Text('Attendance'),
            selected: _selectedIndex == 3,
            onTap: () {
              _navigateTo(FacultyRoutes.attendance);
            },
          ),
          ListTile(
            leading: const Icon(Icons.assessment),
            title: const Text('Grades'),
            selected: _selectedIndex == 4,
            onTap: () {
              _navigateTo(FacultyRoutes.grades);
            },
          ),
          ListTile(
            leading: const Icon(Icons.apps),
            title: const Text('All Features'),
            selected: _selectedIndex == 7,
            onTap: () {
              _navigateTo(FacultyRoutes.features);
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notices'),
            selected: _selectedIndex == 5,
            onTap: () {
              _navigateTo(FacultyRoutes.notices);
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            selected: _selectedIndex == 6,
            onTap: () {
              _navigateTo(FacultyRoutes.profile);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
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
          expandedHeight: 210,
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
                _buildQuickActions(),
                SizedBox(height: AppSpacing.xxl),
                _buildTodayTeaching(),
                SizedBox(height: AppSpacing.xxl),
                _buildGradingQueue(),
                SizedBox(height: AppSpacing.xxl),
                _buildAnalytics(),
                SizedBox(height: AppSpacing.xxl),
                _buildRecentAnnouncements(),
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
          'assets/images/d-block.jpeg',
          fit: BoxFit.cover,
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.faculty.withValues(alpha: 0.85),
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
                  'Faculty ERP',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                    letterSpacing: 0.6,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: AppSpacing.xs),
                Text(
                  'Welcome back, Dr. ${widget.userId}',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.md,
                  runSpacing: AppSpacing.sm,
                  children: [
                    _buildHeroPill('Classes', '5'),
                    _buildHeroPill('Pending Grading', '3'),
                    _buildHeroPill('Today', '4 sessions'),
                  ],
                ),
                SizedBox(height: AppSpacing.lg),
                OutlinedButton.icon(
                  onPressed: () => _navigateTo(FacultyRoutes.schedule),
                  icon: const Icon(Icons.calendar_today),
                  label: const Text('View schedule'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: BorderSide(color: Colors.white.withValues(alpha: 0.6)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeroPill(String label, String value) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: AppRadius.radiusFull,
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
      ),
      child: RichText(
        text: TextSpan(
          text: '$label: ',
          style: theme.textTheme.labelSmall?.copyWith(
            color: Colors.white.withValues(alpha: 0.8),
            fontWeight: FontWeight.w600,
          ),
          children: [
            TextSpan(
              text: value,
              style: theme.textTheme.labelSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          title: 'Quick Actions',
          subtitle: 'Shortcuts to faculty workflows.',
        ),
        SizedBox(height: AppSpacing.md),
        ResponsiveGrid(
          minItemWidth: 220,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.7,
          children: [
            _buildQuickActionCard(
              title: 'My Classes',
              description: 'Manage sections and materials.',
              icon: Icons.class_rounded,
              color: AppColors.faculty,
              onTap: () => _navigateTo(FacultyRoutes.myClasses),
            ),
            _buildQuickActionCard(
              title: 'Attendance',
              description: 'Mark and review attendance.',
              icon: Icons.fact_check_rounded,
              color: AppColors.info,
              onTap: () => _navigateTo(FacultyRoutes.attendance),
            ),
            _buildQuickActionCard(
              title: 'Grades',
              description: 'Evaluate submissions quickly.',
              icon: Icons.grading_rounded,
              color: AppColors.warning,
              onTap: () => _navigateTo(FacultyRoutes.grades),
            ),
            _buildQuickActionCard(
              title: 'Schedule',
              description: 'View weekly teaching load.',
              icon: Icons.calendar_month_rounded,
              color: AppColors.secondaryBlue,
              onTap: () => _navigateTo(FacultyRoutes.schedule),
            ),
            _buildQuickActionCard(
              title: 'Notices',
              description: 'Post updates and circulars.',
              icon: Icons.notifications_active_rounded,
              color: AppColors.warning,
              onTap: () => _navigateTo(FacultyRoutes.notices),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAnalytics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          title: 'Analytics',
          subtitle: 'Quick insights on your classes.',
        ),
        AppCard.outlined(
          margin: EdgeInsets.zero,
          contentPadding: AppSpacing.paddingLg,
          child: FutureBuilder<Map<String, double>>(
            future: FacultyDataService.getFacultyAnalytics(widget.userId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return LoadingShimmer.compact(count: 3);
              }
              final data = snapshot.data ?? {};
              return Column(
                children: [
                  InfoRow(
                    icon: Icons.event_available,
                    label: 'Avg Attendance',
                    value: '${data['averageAttendance']?.toStringAsFixed(1) ?? '0'}%',
                  ),
                  InfoRow(
                    icon: Icons.assignment_turned_in,
                    label: 'Grading Completion',
                    value: '${data['gradingCompletion']?.toStringAsFixed(0) ?? '0'}%',
                  ),
                  InfoRow(
                    icon: Icons.thumb_up,
                    label: 'Student Satisfaction',
                    value: '${data['studentSatisfaction']?.toStringAsFixed(1) ?? '0'} / 5',
                    showDivider: false,
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionCard({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return Card(
      elevation: AppElevation.sm,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusMd),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.radiusMd,
        child: Padding(
          padding: AppSpacing.paddingLg,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: AppRadius.radiusSm,
                ),
                child: Icon(icon, color: color, size: AppIconSize.md),
              ),
              SizedBox(height: AppSpacing.md),
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: AppSpacing.xs),
              Text(
                description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTodayTeaching() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          title: 'Today’s Teaching',
          subtitle: 'Upcoming sessions and locations.',
          trailing: TextButton(
            onPressed: () => _navigateTo(FacultyRoutes.schedule),
            child: const Text('Full schedule'),
          ),
        ),
        AppCard.outlined(
          margin: EdgeInsets.zero,
          contentPadding: AppSpacing.paddingLg,
          child: Column(
            children: [
              _buildTeachingItem(
                course: 'Mathematics 101',
                section: 'III CSE • 45 students',
                time: '10:00 AM - 11:00 AM',
                room: 'Lecture Hall A-5',
                status: StatusBadge.inProgress(label: 'Ongoing'),
              ),
              SizedBox(height: AppSpacing.md),
              _buildTeachingItem(
                course: 'Physics Lab',
                section: 'III CSE • 35 students',
                time: '12:15 PM - 2:00 PM',
                room: 'Lab 3',
                status: StatusBadge.pending(label: 'Upcoming'),
              ),
              SizedBox(height: AppSpacing.md),
              _buildTeachingItem(
                course: 'Electronics',
                section: 'IV ECE • 42 students',
                time: '3:30 PM - 4:30 PM',
                room: 'Seminar Room 2',
                status: StatusBadge.pending(label: 'Later'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTeachingItem({
    required String course,
    required String section,
    required String time,
    required String room,
    required StatusBadge status,
  }) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadius.radiusMd,
        border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  course,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              status,
            ],
          ),
          SizedBox(height: AppSpacing.xs),
          Text(
            section,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Icon(Icons.access_time, size: 14, color: AppColors.faculty),
              SizedBox(width: AppSpacing.xs),
              Text(
                time,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              SizedBox(width: AppSpacing.lg),
              Icon(Icons.location_on_rounded, size: 14, color: AppColors.faculty),
              SizedBox(width: AppSpacing.xs),
              Text(
                room,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGradingQueue() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          title: 'Grading Queue',
          subtitle: 'Assignments awaiting review.',
          trailing: TextButton(
            onPressed: () => _navigateTo(FacultyRoutes.grades),
            child: const Text('Open grades'),
          ),
        ),
        AppCard.outlined(
          margin: EdgeInsets.zero,
          contentPadding: AppSpacing.paddingLg,
          child: Column(
            children: [
              _buildQueueItem(
                title: 'Mathematics 101 - Assignment 5',
                detail: 'Submitted: 38/45 • Due tomorrow',
                badge: StatusBadge.pending(),
              ),
              SizedBox(height: AppSpacing.md),
              _buildQueueItem(
                title: 'Physics Lab - Report Submission',
                detail: 'Submitted: 32/35 • Due in 2 days',
                badge: StatusBadge.warning(label: 'Due soon'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQueueItem({
    required String title,
    required String detail,
    required StatusBadge badge,
  }) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: AppColors.faculty.withValues(alpha: 0.1),
            borderRadius: AppRadius.radiusSm,
          ),
          child: Icon(Icons.assignment_rounded, color: AppColors.faculty, size: 18),
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
                detail,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
        badge,
      ],
    );
  }

  Widget _buildRecentAnnouncements() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          title: 'Announcements',
          subtitle: 'Faculty circulars and updates.',
        ),
        AppCard.outlined(
          margin: EdgeInsets.zero,
          contentPadding: AppSpacing.paddingLg,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAnnouncementItem(
                title: 'Grade Submission Deadline',
                message: 'Submit all grades by end of this month.',
                time: 'Today at 10:30 AM',
              ),
              SizedBox(height: AppSpacing.md),
              _buildAnnouncementItem(
                title: 'Semester Update Meeting',
                message: 'Faculty meeting next Friday at 3:00 PM in Hall A.',
                time: 'Yesterday at 2:45 PM',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAnnouncementItem({
    required String title,
    required String message,
    required String time,
  }) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: AppColors.faculty.withValues(alpha: 0.1),
            borderRadius: AppRadius.radiusSm,
          ),
          child: Icon(Icons.campaign_rounded, color: AppColors.faculty, size: 18),
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
                message,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              SizedBox(height: AppSpacing.xs),
              Text(
                time,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required String subtitle,
    Widget? trailing,
  }) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
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
        if (trailing != null) ...[
          SizedBox(width: AppSpacing.md),
          trailing,
        ],
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
          icon: Icon(Icons.class_),
          label: 'Classes',
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

