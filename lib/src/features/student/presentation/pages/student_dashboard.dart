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
                  AppColors.student,
                  AppColors.info,
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
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.student.withOpacity(0.3),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.person_rounded,
                    size: AppIconSize.lg,
                    color: AppColors.student,
                  ),
                ),
                SizedBox(height: AppSpacing.md),
                Text(
                  widget.userId,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'B.Tech Computer Science',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.white.withOpacity(0.85),
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
                  side: BorderSide(color: AppColors.error.withOpacity(0.5)),
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
        // Beautiful gradient header
        SliverAppBar(
          expandedHeight: 240,
          floating: false,
          pinned: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          flexibleSpace: FlexibleSpaceBar(
            background: _buildGradientHeader(),
          ),
        ),
        // Main content
        SliverToBoxAdapter(
          child: Padding(
            padding: AppSpacing.paddingLg,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Quick stats with 3D animations
                _buildQuickStats(),
                SizedBox(height: AppSpacing.xxl),

                // Upcoming classes
                _buildUpcomingClasses(),
                SizedBox(height: AppSpacing.xxl),

                // Announcements
                _buildAnnouncements(),
                SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGradientHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.student,
            AppColors.info,
            AppColors.student.withOpacity(0.7),
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome Back! 👋',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(height: AppSpacing.xs),
                      Text(
                        widget.userId,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.logout_rounded),
                      color: Colors.white,
                      onPressed: _showLogoutDialog,
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.lg),
              // Quick info
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildHeaderInfo('Credits', '120 / 150'),
                  _buildHeaderInfo('GPA', '3.85'),
                  _buildHeaderInfo('Attendance', '92%'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Colors.white.withOpacity(0.8),
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: AppSpacing.xs),
        Text(
          value,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStats() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Performance',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
        SizedBox(height: AppSpacing.md),
        _AnimatedStatCard(
          animation: _cardAnimations[0],
          child: _buildStatCardItem(
            icon: Icons.trending_up,
            value: '3.85',
            title: 'GPA',
            subtitle: 'Excellent Progress',
            color: AppColors.student,
            gradient: [AppColors.student, AppColors.info],
          ),
        ),
        SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: _AnimatedStatCard(
                animation: _cardAnimations[1],
                child: _buildCompactStatCard(
                  icon: Icons.check_circle,
                  value: '92%',
                  title: 'Attendance',
                  color: AppColors.success,
                ),
              ),
            ),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: _AnimatedStatCard(
                animation: _cardAnimations[2],
                child: _buildCompactStatCard(
                  icon: Icons.class_,
                  value: '5',
                  title: 'Courses',
                  color: AppColors.info,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: _AnimatedStatCard(
                animation: _cardAnimations[3],
                child: _buildCompactStatCard(
                  icon: Icons.pending_actions,
                  value: '3',
                  title: 'Tasks Due',
                  color: AppColors.warning,
                ),
              ),
            ),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: _AnimatedStatCard(
                animation: _cardAnimations[3],
                child: _buildCompactStatCard(
                  icon: Icons.assignment,
                  value: '12',
                  title: 'Assignments',
                  color: AppColors.student,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCardItem({
    required IconData icon,
    required String value,
    required String title,
    required String subtitle,
    required Color color,
    required List<Color> gradient,
  }) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradient,
        ),
        borderRadius: AppRadius.radiusLg,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: AppRadius.radiusMd,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: AppIconSize.lg,
            ),
          ),
          SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: AppSpacing.xs),
                Text(
                  title,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactStatCard({
    required IconData icon,
    required String value,
    required String title,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
        borderRadius: AppRadius.radiusMd,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: AppRadius.radiusSm,
            ),
            child: Icon(
              icon,
              color: color,
              size: AppIconSize.md,
            ),
          ),
          SizedBox(height: AppSpacing.md),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: AppSpacing.xs),
          Text(
            title,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.textSecondaryLight,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingClasses() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Upcoming Classes',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),
            TextButton(
              onPressed: () => _navigateTo(StudentRoutes.courses),
              child: Text(
                'See All',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.student,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.md),
        _buildClassCard(
          subject: 'Mathematics 101',
          instructor: 'Dr. John Smith',
          time: 'Today • 10:00 AM',
          room: 'Lecture Hall A-5',
          icon: Icons.calculate,
          color: AppColors.student,
          gradient: [AppColors.student, AppColors.info],
        ),
        SizedBox(height: AppSpacing.md),
        _buildClassCard(
          subject: 'Physics Lab',
          instructor: 'Dr. Sarah Wilson',
          time: 'Tomorrow • 2:00 PM',
          room: 'Lab 3',
          icon: Icons.science,
          color: AppColors.info,
          gradient: [AppColors.info, AppColors.success],
        ),
        SizedBox(height: AppSpacing.md),
        _buildClassCard(
          subject: 'English Literature',
          instructor: 'Prof. Emily Brown',
          time: 'Tomorrow • 4:30 PM',
          room: 'Seminar Room 2',
          icon: Icons.menu_book,
          color: AppColors.warning,
          gradient: [AppColors.warning, AppColors.student],
        ),
      ],
    );
  }

  Widget _buildClassCard({
    required String subject,
    required String instructor,
    required String time,
    required String room,
    required IconData icon,
    required Color color,
    required List<Color> gradient,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradient),
        borderRadius: AppRadius.radiusMd,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 15,
            spreadRadius: 3,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: AppRadius.radiusMd,
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: AppRadius.radiusMd,
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: AppIconSize.lg,
                  ),
                ),
                SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subject,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: AppSpacing.xs),
                      Text(
                        instructor,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.white.withOpacity(0.85),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: AppSpacing.sm),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            color: Colors.white.withOpacity(0.7),
                            size: 14,
                          ),
                          SizedBox(width: AppSpacing.xs),
                          Text(
                            time,
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 11,
                            ),
                          ),
                          SizedBox(width: AppSpacing.lg),
                          Icon(
                            Icons.location_on,
                            color: Colors.white.withOpacity(0.7),
                            size: 14,
                          ),
                          SizedBox(width: AppSpacing.xs),
                          Text(
                            room,
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: AppSpacing.md),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white.withOpacity(0.6),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnnouncements() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Latest Announcements',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.15),
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
          ],
        ),
        SizedBox(height: AppSpacing.md),
        _buildAnnouncementCard(
          title: 'Semester Results Published 🎓',
          description: 'Your 2nd semester results are now available in the grades section. Check your performance and progress.',
          icon: Icons.celebration_rounded,
          color: AppColors.success,
          timestamp: 'Today at 9:30 AM',
          priority: 'high',
        ),
        SizedBox(height: AppSpacing.md),
        _buildAnnouncementCard(
          title: 'Assignment Deadline Extended ⏰',
          description: 'The deadline for DSA assignment has been extended to Friday. Don\'t miss this opportunity!',
          icon: Icons.schedule_rounded,
          color: AppColors.warning,
          timestamp: 'Yesterday at 3:15 PM',
          priority: 'medium',
        ),
        SizedBox(height: AppSpacing.md),
        _buildAnnouncementCard(
          title: 'Campus Event: Tech Fest 2026 🚀',
          description: 'Join us for the Annual Tech Fest! Register now for exciting competitions and workshops.',
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
    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.radiusMd,
        border: Border.all(color: color.withOpacity(0.2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.08),
            blurRadius: 12,
            spreadRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
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
                      .withOpacity(0.15),
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