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

class _StudentDashboardState extends State<StudentDashboard>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  bool _isLoading = true;
  late AnimationController _animationController;
  late List<Animation<double>> _cardAnimations;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Create staggered animations for cards
    _cardAnimations = List.generate(
      4,
      (index) => Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            index * 0.1,
            0.6 + (index * 0.1),
            curve: Curves.easeOut,
          ),
        ),
      ),
    );

    _loadData();
  }

  Future<void> _loadData() async {
    // Simulate loading data
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _navigateTo(String route) {
    context.push(route);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      drawer: _buildDrawer(),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Modern drawer header
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                ],
              ),
            ),
            padding: EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.xl,
              AppSpacing.lg,
              AppSpacing.lg,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onPrimary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withValues(alpha: 0.3),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.person_rounded,
                    size: AppIconSize.lg,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                SizedBox(height: AppSpacing.md),
                Text(
                  widget.userId,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'B.Tech Computer Science',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.lg),
          _buildDrawerSection('ACADEMICS', [
            ('Dashboard', Icons.dashboard_rounded, StudentRoutes.dashboard),
            ('My Courses', Icons.class_rounded, StudentRoutes.courses),
            ('Assignments', Icons.assignment_rounded, StudentRoutes.assignments),
            ('Grades & Results', Icons.grade_rounded, StudentRoutes.results),
            ('Time Table', Icons.event_rounded, StudentRoutes.timeTable),
          ]),
          SizedBox(height: AppSpacing.md),
          _buildDrawerSection('ATTENDANCE', [
            ('Attendance', Icons.calendar_today_rounded, StudentRoutes.attendance),
          ]),
          SizedBox(height: AppSpacing.md),
          _buildDrawerSection('COMMUNICATION', [
            ('Notifications', Icons.notifications_rounded, StudentRoutes.notifications),
            ('Complaints', Icons.message_rounded, StudentRoutes.complaints),
          ]),
          SizedBox(height: AppSpacing.md),
          _buildDrawerSection('ACCOUNT', [
            ('My Profile', Icons.person_rounded, StudentRoutes.profile),
            ('Settings', Icons.settings_rounded, ''),
          ]),
          const Divider(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _showLogoutDialog,
                icon: const Icon(Icons.logout_rounded),
                label: const Text('Logout'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: BorderSide(color: AppColors.error.withValues(alpha: 0.5)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerSection(
    String title,
    List<(String, IconData, String)> items,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Text(
            title,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.textSecondaryLight,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ),
        SizedBox(height: AppSpacing.sm),
        ...items
            .map((item) => _buildDrawerTile(item.$1, item.$2, item.$3))
            .toList(),
      ],
    );
  }

  Widget _buildDrawerTile(String title, IconData icon, String route) {
    return ListTile(
      leading: Icon(icon, color: AppColors.student, size: AppIconSize.md),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xs,
      ),
      onTap: route.isEmpty
          ? null
          : () {
              _navigateTo(route);
            },
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Padding(
        padding: AppSpacing.paddingLg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LoadingShimmer(height: 120, width: double.infinity),
            SizedBox(height: AppSpacing.xl),
            LoadingShimmer.compact(count: 4),
            SizedBox(height: AppSpacing.xxl),
            LoadingShimmer.list(count: 3),
          ],
        ),
      );
    }

    return CustomScrollView(
      slivers: [
        // Branded hero header
        SliverAppBar(
          expandedHeight: 220,
          floating: false,
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
          flexibleSpace: FlexibleSpaceBar(
            background: _buildHeroHeader(),
          ),
        ),
        // Main content
        SliverToBoxAdapter(
          child: Padding(
            padding: AppSpacing.paddingLg,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildQuickActions(),
                SizedBox(height: AppSpacing.xxl),
                _buildTodaySchedule(),
                SizedBox(height: AppSpacing.xxl),
                _buildAcademicSnapshot(),
                SizedBox(height: AppSpacing.xxl),
                _buildAnnouncements(),
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
                theme.colorScheme.primary.withValues(alpha: 0.85),
                theme.colorScheme.secondary.withValues(alpha: 0.65),
                Colors.black.withValues(alpha: 0.45),
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
                  'Student ERP',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                    letterSpacing: 0.6,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: AppSpacing.xs),
                Text(
                  'Welcome back',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: AppSpacing.xs),
                Text(
                  widget.userId,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: AppSpacing.lg),
                Wrap(
                  spacing: AppSpacing.md,
                  runSpacing: AppSpacing.sm,
                  children: [
                    _buildHeroInfoPill('Semester', 'VI'),
                    _buildHeroInfoPill('Attendance', '92%'),
                    _buildHeroInfoPill('CGPA', '3.85'),
                  ],
                ),
                SizedBox(height: AppSpacing.lg),
                Wrap(
                  spacing: AppSpacing.md,
                  runSpacing: AppSpacing.sm,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () => _navigateTo(StudentRoutes.timeTable),
                      icon: const Icon(Icons.event_rounded, size: 18),
                      label: const Text('Timetable'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: BorderSide(color: Colors.white.withValues(alpha: 0.6)),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _navigateTo(StudentRoutes.attendance),
                      icon: const Icon(Icons.fact_check_rounded, size: 18),
                      label: const Text('Attendance'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accentGold,
                        foregroundColor: Colors.black,
                        elevation: 0,
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

  Widget _buildHeroInfoPill(String label, String value) {
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
          subtitle: 'Common ERP tasks at a glance.',
        ),
        SizedBox(height: AppSpacing.md),
        ResponsiveGrid(
          minItemWidth: 220,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.7,
          children: [
            _buildQuickActionCard(
              title: 'Courses',
              description: 'View enrolled subjects and faculty.',
              icon: Icons.class_rounded,
              color: AppColors.student,
              onTap: () => _navigateTo(StudentRoutes.courses),
            ),
            _buildQuickActionCard(
              title: 'Assignments',
              description: 'Track pending and submitted work.',
              icon: Icons.assignment_rounded,
              color: AppColors.warning,
              onTap: () => _navigateTo(StudentRoutes.assignments),
            ),
            _buildQuickActionCard(
              title: 'Results',
              description: 'Semester performance and grades.',
              icon: Icons.grade_rounded,
              color: AppColors.success,
              onTap: () => _navigateTo(StudentRoutes.results),
            ),
            _buildQuickActionCard(
              title: 'Notifications',
              description: 'Announcements and circulars.',
              icon: Icons.notifications_rounded,
              color: AppColors.info,
              onTap: () => _navigateTo(StudentRoutes.notifications),
            ),
          ],
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

  Widget _buildTodaySchedule() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          title: 'Today',
          subtitle: 'Your schedule for the next sessions.',
          trailing: TextButton(
            onPressed: () => _navigateTo(StudentRoutes.timeTable),
            child: const Text('View timetable'),
          ),
        ),
        AppCard.outlined(
          margin: EdgeInsets.zero,
          contentPadding: AppSpacing.paddingLg,
          showHeaderDivider: false,
          child: Column(
            children: [
              _buildScheduleItem(
                title: 'Mathematics 101',
                time: '10:00 AM - 11:00 AM',
                location: 'Lecture Hall A-5',
                instructor: 'Dr. John Smith',
                color: AppColors.student,
              ),
              SizedBox(height: AppSpacing.md),
              _buildScheduleItem(
                title: 'Data Structures Lab',
                time: '12:15 PM - 2:00 PM',
                location: 'Lab 3',
                instructor: 'Dr. Sarah Wilson',
                color: AppColors.info,
              ),
              SizedBox(height: AppSpacing.md),
              _buildScheduleItem(
                title: 'English Literature',
                time: '3:30 PM - 4:30 PM',
                location: 'Seminar Room 2',
                instructor: 'Prof. Emily Brown',
                color: AppColors.warning,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildScheduleItem({
    required String title,
    required String time,
    required String location,
    required String instructor,
    required Color color,
  }) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadius.radiusMd,
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4,
            height: 64,
            decoration: BoxDecoration(
              color: color,
              borderRadius: AppRadius.radiusFull,
            ),
          ),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: AppSpacing.xs),
                Text(
                  instructor,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 14, color: color),
                    SizedBox(width: AppSpacing.xs),
                    Text(
                      time,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                    SizedBox(width: AppSpacing.lg),
                    Icon(Icons.location_on_rounded, size: 14, color: color),
                    SizedBox(width: AppSpacing.xs),
                    Text(
                      location,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAcademicSnapshot() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          title: 'Academic Snapshot',
          subtitle: 'Progress and performance overview.',
        ),
        SizedBox(height: AppSpacing.md),
        ResponsiveGrid(
          minItemWidth: 220,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _AnimatedStatCard(
              animation: _cardAnimations[0],
              child: const StatCard(
                icon: Icons.trending_up,
                value: '3.85',
                title: 'CGPA',
                subtitle: 'Consistent improvement',
                color: AppColors.student,
                trendIcon: Icons.trending_up,
              ),
            ),
            _AnimatedStatCard(
              animation: _cardAnimations[1],
              child: const StatCard(
                icon: Icons.fact_check_rounded,
                value: '92%',
                title: 'Attendance',
                subtitle: 'On track',
                color: AppColors.success,
              ),
            ),
            _AnimatedStatCard(
              animation: _cardAnimations[2],
              child: const StatCard(
                icon: Icons.class_rounded,
                value: '5',
                title: 'Courses',
                subtitle: 'Active this term',
                color: AppColors.secondaryBlue,
              ),
            ),
            _AnimatedStatCard(
              animation: _cardAnimations[3],
              child: const StatCard(
                icon: Icons.assignment_rounded,
                value: '12',
                title: 'Assignments',
                subtitle: '3 due soon',
                color: AppColors.warning,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAnnouncements() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          title: 'Announcements',
          subtitle: 'Important circulars and updates.',
          trailing: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.15),
              borderRadius: AppRadius.radiusSm,
            ),
            child: Text(
              '2 New',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.error,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        SizedBox(height: AppSpacing.md),
        _buildAnnouncementCard(
          title: 'Semester Results Published',
          description:
              'Your semester results are now available in the grades section. Review your performance and progress.',
          icon: Icons.celebration_rounded,
          color: AppColors.success,
          timestamp: 'Today at 9:30 AM',
          priority: 'high',
        ),
        SizedBox(height: AppSpacing.md),
        _buildAnnouncementCard(
          title: 'Assignment Deadline Extended',
          description:
              'The deadline for the DSA assignment has been extended to Friday. Please submit on time.',
          icon: Icons.schedule_rounded,
          color: AppColors.warning,
          timestamp: 'Yesterday at 3:15 PM',
          priority: 'medium',
        ),
        SizedBox(height: AppSpacing.md),
        _buildAnnouncementCard(
          title: 'Campus Event: Tech Fest 2026',
          description:
              'Registrations are open for the annual tech fest. Check circulars for competitions and workshops.',
          icon: Icons.event_rounded,
          color: AppColors.student,
          timestamp: '2 days ago',
          priority: 'low',
        ),
      ],
    );
  }

  Widget _buildAnnouncementCard({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required String timestamp,
    required String priority,
  }) {
    return AppCard.outlined(
      margin: EdgeInsets.zero,
      contentPadding: AppSpacing.paddingLg,
      borderColor: color.withValues(alpha: 0.2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: AppRadius.radiusMd,
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: AppIconSize.lg,
                ),
              ),
              SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        height: 1.3,
                      ),
                    ),
                    SizedBox(height: AppSpacing.xs),
                    Text(
                      timestamp,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.textSecondaryLight,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: (priority == 'high'
                      ? AppColors.error
                      : priority == 'medium'
                          ? AppColors.warning
                          : AppColors.success)
                      .withValues(alpha: 0.15),
                  borderRadius: AppRadius.radiusSm,
                ),
                child: Text(
                  priority.toUpperCase(),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: priority == 'high'
                        ? AppColors.error
                        : priority == 'medium'
                            ? AppColors.warning
                            : AppColors.success,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          Text(
            description,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondaryLight,
              height: 1.5,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: AppSpacing.md),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () {},
              icon: Icon(Icons.read_more_rounded, size: 16, color: color),
              label: Text(
                'Read More',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
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
      backgroundColor: Colors.white,
      elevation: 8,
      selectedItemColor: AppColors.student,
      unselectedItemColor: AppColors.textSecondaryLight,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_rounded),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.class_rounded),
          label: 'Courses',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment_rounded),
          label: 'Tasks',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.more_horiz_rounded),
          label: 'More',
        ),
      ],
      onTap: (index) {
        setState(() => _selectedIndex = index);
        switch (index) {
          case 0:
            setState(() => _selectedIndex = 0);
            break;
          case 1:
            _navigateTo(StudentRoutes.courses);
            break;
          case 2:
            _navigateTo(StudentRoutes.assignments);
            break;
          case 3:
            Scaffold.of(context).openDrawer();
            break;
        }
      },
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

/// Animated card wrapper for staggered animations
class _AnimatedStatCard extends StatelessWidget {
  final Animation<double> animation;
  final Widget child;

  const _AnimatedStatCard({
    required this.animation,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        return Transform.translate(
          offset: Offset(0, (1 - animation.value) * 30),
          child: Opacity(
            opacity: animation.value,
            child: Transform.scale(
              scale: 0.9 + (animation.value * 0.1),
              child: child,
            ),
          ),
        );
      },
    );
  }
}