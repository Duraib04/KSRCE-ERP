import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';

class NavItem {
  final String title;
  final IconData icon;
  final String route;
  final List<NavItem>? children;
  NavItem({required this.title, required this.icon, required this.route, this.children});
}

class DashboardShell extends StatefulWidget {
  final Widget child;
  final String role; // 'student', 'faculty', 'hod', or 'admin'
  final String currentRoute;
  const DashboardShell({super.key, required this.child, required this.role, required this.currentRoute});

  @override
  State<DashboardShell> createState() => _DashboardShellState();
}

class _DashboardShellState extends State<DashboardShell> {
  bool _isSidebarCollapsed = false;
  final Map<String, bool> _expandedGroups = {};

  List<NavItem> get _navItems {
    if (widget.role == 'student') {
      return [
        NavItem(title: 'Dashboard', icon: Icons.dashboard, route: '/student/dashboard'),
        NavItem(title: 'Profile', icon: Icons.person, route: '/student/profile'),
        NavItem(title: 'Academics', icon: Icons.school, route: '', children: [
          NavItem(title: 'My Courses', icon: Icons.book, route: '/student/courses'),
          NavItem(title: 'Timetable', icon: Icons.schedule, route: '/student/timetable'),
          NavItem(title: 'Syllabus', icon: Icons.description, route: '/student/syllabus'),
        ]),
        NavItem(title: 'Performance', icon: Icons.trending_up, route: '', children: [
          NavItem(title: 'Attendance', icon: Icons.fact_check, route: '/student/attendance'),
          NavItem(title: 'Results', icon: Icons.assessment, route: '/student/results'),
          NavItem(title: 'Assignments', icon: Icons.assignment, route: '/student/assignments'),
        ]),
        NavItem(title: 'Exam Schedule', icon: Icons.event_note, route: '/student/exams'),
        NavItem(title: 'Fee Details', icon: Icons.payment, route: '/student/fees'),
        NavItem(title: 'Library', icon: Icons.local_library, route: '/student/library'),
        NavItem(title: 'Notifications', icon: Icons.notifications, route: '/student/notifications'),
        NavItem(title: 'Services', icon: Icons.miscellaneous_services, route: '', children: [
          NavItem(title: 'Complaints', icon: Icons.report_problem, route: '/student/complaints'),
          NavItem(title: 'Leave Apply', icon: Icons.event_busy, route: '/student/leave'),
          NavItem(title: 'Certificates', icon: Icons.card_membership, route: '/student/certificates'),
        ]),
        NavItem(title: 'Placements', icon: Icons.work, route: '/student/placements'),
        NavItem(title: 'Events', icon: Icons.event, route: '/student/events'),
        NavItem(title: 'Settings', icon: Icons.settings, route: '/student/settings'),
      ];
    } else if (widget.role == 'admin') {
      return [
        NavItem(title: 'Dashboard', icon: Icons.dashboard, route: '/admin/dashboard'),
        NavItem(title: 'Departments', icon: Icons.business, route: '/admin/departments'),
        NavItem(title: 'Management', icon: Icons.manage_accounts, route: '', children: [
          NavItem(title: 'Faculty Mgmt', icon: Icons.person_add, route: '/admin/faculty'),
          NavItem(title: 'Student Mgmt', icon: Icons.group_add, route: '/admin/students'),
          NavItem(title: 'Course Mgmt', icon: Icons.menu_book, route: '/admin/courses'),
          NavItem(title: 'Class Mgmt', icon: Icons.class_, route: '/admin/classes'),
        ]),
        NavItem(title: 'HOD Assignment', icon: Icons.supervisor_account, route: '/admin/hod-assignment'),
        NavItem(title: 'User Management', icon: Icons.people, route: '/admin/users'),
        NavItem(title: 'Reports', icon: Icons.analytics, route: '/admin/reports'),
        NavItem(title: 'Notifications', icon: Icons.notifications, route: '/admin/notifications'),
        NavItem(title: 'Settings', icon: Icons.settings, route: '/admin/settings'),
      ];
    } else if (widget.role == 'hod') {
      return [
        NavItem(title: 'Dashboard', icon: Icons.dashboard, route: '/hod/dashboard'),
        NavItem(title: 'Department', icon: Icons.business, route: '', children: [
          NavItem(title: 'Faculty', icon: Icons.people, route: '/hod/faculty'),
          NavItem(title: 'Students', icon: Icons.school, route: '/hod/students'),
          NavItem(title: 'Courses', icon: Icons.menu_book, route: '/hod/courses'),
        ]),
        NavItem(title: 'Assignments', icon: Icons.assignment_ind, route: '', children: [
          NavItem(title: 'Class Advisers', icon: Icons.person_pin, route: '/hod/class-advisers'),
          NavItem(title: 'Mentors', icon: Icons.group, route: '/hod/mentors'),
        ]),
        NavItem(title: 'Notifications', icon: Icons.notifications, route: '/hod/notifications'),
        NavItem(title: 'Settings', icon: Icons.settings, route: '/hod/settings'),
      ];
    } else {
      return [
        NavItem(title: 'Dashboard', icon: Icons.dashboard, route: '/faculty/dashboard'),
        NavItem(title: 'Profile', icon: Icons.person, route: '/faculty/profile'),
        NavItem(title: 'Academics', icon: Icons.school, route: '', children: [
          NavItem(title: 'My Courses', icon: Icons.book, route: '/faculty/courses'),
          NavItem(title: 'Timetable', icon: Icons.schedule, route: '/faculty/timetable'),
          NavItem(title: 'Syllabus', icon: Icons.description, route: '/faculty/syllabus'),
        ]),
        NavItem(title: 'Management', icon: Icons.manage_accounts, route: '', children: [
          NavItem(title: 'Attendance', icon: Icons.fact_check, route: '/faculty/attendance'),
          NavItem(title: 'Assignments', icon: Icons.assignment, route: '/faculty/assignments'),
          NavItem(title: 'Grade Entry', icon: Icons.grading, route: '/faculty/grades'),
          NavItem(title: 'Student List', icon: Icons.people, route: '/faculty/students'),
        ]),
        NavItem(title: 'Exams', icon: Icons.event_note, route: '/faculty/exams'),
        NavItem(title: 'Leave Mgmt', icon: Icons.event_busy, route: '/faculty/leave'),
        NavItem(title: 'Research', icon: Icons.science, route: '/faculty/research'),
        NavItem(title: 'Notifications', icon: Icons.notifications, route: '/faculty/notifications'),
        NavItem(title: 'Complaints', icon: Icons.report_problem, route: '/faculty/complaints'),
        NavItem(title: 'Reports', icon: Icons.analytics, route: '/faculty/reports'),
        NavItem(title: 'Events', icon: Icons.event, route: '/faculty/events'),
        NavItem(title: 'Settings', icon: Icons.settings, route: '/faculty/settings'),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    
    if (isMobile) {
      return Scaffold(
        appBar: _buildAppBar(),
        drawer: _buildDrawer(),
        body: Container(
          decoration: const BoxDecoration(
            color: AppColors.background,
          ),
          child: widget.child,
        ),
      );
    }

    return Scaffold(
      body: Row(
        children: [
          _buildSidebar(),
          Expanded(
            child: Column(
              children: [
                _buildTopBar(),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.background,
                    ),
                    child: widget.child,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.surface,
      title: Text(
        widget.role == 'student' ? 'Student Portal' : widget.role == 'admin' ? 'Admin Portal' : widget.role == 'hod' ? 'HOD Portal' : 'Faculty Portal',
        style: Theme.of(context).textTheme.titleLarge,
      ),
      iconTheme: const IconThemeData(color: AppColors.textDark),
      actions: [
        IconButton(icon: const Icon(Icons.notifications_outlined), onPressed: () {
          context.go('/${widget.role}/notifications');
        }),
        _buildProfileMenu(),
      ],
    );
  }

  Widget _buildProfileMenu() {
    return PopupMenuButton<String>(
      icon: const CircleAvatar(
        radius: 16,
        backgroundColor: AppColors.primary,
        child: Icon(Icons.person, size: 18, color: Colors.white),
      ),
      color: AppColors.surface,
      itemBuilder: (context) => [
        PopupMenuItem(value: 'profile', child: Row(children: [
          const Icon(Icons.person_outline, color: AppColors.textMedium, size: 18),
          const SizedBox(width: 8),
          const Text('Profile', style: TextStyle(color: AppColors.textDark)),
        ])),
        PopupMenuItem(value: 'settings', child: Row(children: [
          const Icon(Icons.settings_outlined, color: AppColors.textMedium, size: 18),
          const SizedBox(width: 8),
          const Text('Settings', style: TextStyle(color: AppColors.textDark)),
        ])),
        const PopupMenuDivider(),
        PopupMenuItem(value: 'logout', child: Row(children: [
          Icon(Icons.logout, color: AppColors.error, size: 18),
          const SizedBox(width: 8),
          Text('Logout', style: TextStyle(color: AppColors.error)),
        ])),
      ],
      onSelected: (value) {
        if (value == 'logout') { context.go('/login'); }
        else if (value == 'profile') { context.go('/${widget.role}/profile'); }
        else if (value == 'settings') { context.go('/${widget.role}/settings'); }
      },
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: AppColors.surface,
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [AppColors.primary, Color(0xFF1E3A5F)]),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const CircleAvatar(radius: 30, backgroundColor: Colors.white24, child: Icon(Icons.person, size: 30, color: Colors.white)),
                const SizedBox(height: 10),
                Text(widget.role == 'student' ? 'Student Name' : widget.role == 'admin' ? 'Administrator' : widget.role == 'hod' ? 'Head of Department' : 'Faculty Name', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                Text(widget.role == 'student' ? 'S20210001' : widget.role == 'admin' ? 'ADM001' : widget.role == 'hod' ? 'HOD' : 'FAC001', style: const TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: _navItems.map((item) => _buildDrawerItem(item)).toList(),
            ),
          ),
          const Divider(color: AppColors.border),
          ListTile(
            leading: const Icon(Icons.logout, color: AppColors.error),
            title: const Text('Logout', style: TextStyle(color: AppColors.error)),
            onTap: () => context.go('/login'),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(NavItem item) {
    if (item.children != null && item.children!.isNotEmpty) {
      return ExpansionTile(
        leading: Icon(item.icon, color: AppColors.textLight, size: 20),
        title: Text(item.title, style: const TextStyle(color: AppColors.textDark, fontSize: 14)),
        iconColor: AppColors.textLight,
        collapsedIconColor: AppColors.textLight,
        children: item.children!.map((child) => ListTile(
          contentPadding: const EdgeInsets.only(left: 56),
          leading: Icon(child.icon, color: widget.currentRoute == child.route ? AppColors.primary : AppColors.textLight, size: 18),
          title: Text(child.title, style: TextStyle(
            color: widget.currentRoute == child.route ? AppColors.primary : AppColors.textMedium,
            fontSize: 13,
          )),
          selected: widget.currentRoute == child.route,
          onTap: () { Navigator.pop(context); context.go(child.route); },
        )).toList(),
      );
    }
    return ListTile(
      leading: Icon(item.icon, color: widget.currentRoute == item.route ? AppColors.primary : AppColors.textLight, size: 20),
      title: Text(item.title, style: TextStyle(
        color: widget.currentRoute == item.route ? AppColors.primary : AppColors.textDark,
        fontSize: 14,
        fontWeight: widget.currentRoute == item.route ? FontWeight.w600 : FontWeight.normal,
      )),
      selected: widget.currentRoute == item.route,
      selectedTileColor: AppColors.primaryOverlay(opacity: 0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      onTap: () { Navigator.pop(context); context.go(item.route); },
    );
  }

  Widget _buildSidebar() {
    final sidebarWidth = _isSidebarCollapsed ? 70.0 : 260.0;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: sidebarWidth,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(right: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                if (!_isSidebarCollapsed) ...[
                  Container(
                    width: 32, height: 32,
                    decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.primary, width: 1.5)),
                    child: const Icon(Icons.school, size: 18, color: AppColors.primary),
                  ),
                  const SizedBox(width: 10),
                  const Text('KSRCE ERP', style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 16)),
                ],
                const Spacer(),
                IconButton(
                  icon: Icon(_isSidebarCollapsed ? Icons.menu : Icons.menu_open, color: AppColors.textLight, size: 20),
                  onPressed: () => setState(() => _isSidebarCollapsed = !_isSidebarCollapsed),
                ),
              ],
            ),
          ),
          const Divider(color: AppColors.border, height: 1),
          // Nav Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              children: _navItems.map((item) => _buildSidebarItem(item)).toList(),
            ),
          ),
          const Divider(color: AppColors.border, height: 1),
          // Logout
          Padding(
            padding: const EdgeInsets.all(8),
            child: _isSidebarCollapsed
              ? IconButton(
                  icon: Icon(Icons.logout, color: Colors.red.shade300, size: 20),
                  onPressed: () => context.go('/login'),
                  tooltip: 'Logout',
                )
              : ListTile(
                  leading: Icon(Icons.logout, color: Colors.red.shade300, size: 20),
                  title: Text('Logout', style: TextStyle(color: Colors.red.shade300, fontSize: 14)),
                  dense: true,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  onTap: () => context.go('/login'),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(NavItem item) {
    final isActive = widget.currentRoute == item.route;
    final hasChildren = item.children != null && item.children!.isNotEmpty;
    final isChildActive = hasChildren && item.children!.any((c) => widget.currentRoute == c.route);
    final isExpanded = _expandedGroups[item.title] ?? isChildActive;

    if (_isSidebarCollapsed) {
      if (hasChildren) {
        return PopupMenuButton<String>(
          tooltip: item.title,
          position: PopupMenuPosition.over,
          color: AppColors.surface,
          offset: const Offset(60, 0),
          itemBuilder: (context) => item.children!.map((child) => PopupMenuItem(
            value: child.route,
            child: Row(children: [
              Icon(child.icon, size: 16, color: widget.currentRoute == child.route ? AppColors.primary : AppColors.textLight),
              const SizedBox(width: 8),
              Text(child.title, style: TextStyle(color: widget.currentRoute == child.route ? AppColors.primary : AppColors.textDark, fontSize: 13)),
            ]),
          )).toList(),
          onSelected: (route) => context.go(route),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Icon(item.icon, color: isChildActive ? AppColors.primary : AppColors.textLight, size: 22),
          ),
        );
      }
      return Tooltip(
        message: item.title,
        preferBelow: false,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => context.go(item.route),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: isActive ? AppColors.primaryOverlay(opacity: 0.12) : null,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(item.icon, color: isActive ? AppColors.primary : AppColors.textLight, size: 22),
          ),
        ),
      );
    }

    if (hasChildren) {
      return Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => setState(() => _expandedGroups[item.title] = !isExpanded),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: isChildActive ? AppColors.primaryOverlay(opacity: 0.08) : null,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(item.icon, color: isChildActive ? AppColors.primary : AppColors.textLight, size: 20),
                  const SizedBox(width: 12),
                  Expanded(child: Text(item.title, style: TextStyle(color: isChildActive ? AppColors.primary : AppColors.textDark, fontSize: 14))),
                  Icon(isExpanded ? Icons.expand_less : Icons.expand_more, color: AppColors.textLight, size: 18),
                ],
              ),
            ),
          ),
          if (isExpanded)
            ...item.children!.map((child) {
              final childActive = widget.currentRoute == child.route;
              return Padding(
                padding: const EdgeInsets.only(left: 20),
                child: ListTile(
                  dense: true,
                  visualDensity: const VisualDensity(vertical: -2),
                  leading: Icon(child.icon, size: 16, color: childActive ? AppColors.primary : AppColors.textLight),
                  title: Text(child.title, style: TextStyle(color: childActive ? AppColors.primary : AppColors.textMedium, fontSize: 13)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  selectedTileColor: AppColors.primaryOverlay(opacity: 0.08),
                  selected: childActive,
                  onTap: () => context.go(child.route),
                ),
              );
            }),
        ],
      );
    }

    return ListTile(
      dense: true,
      leading: Icon(item.icon, color: isActive ? AppColors.primary : AppColors.textLight, size: 20),
      title: Text(item.title, style: TextStyle(
        color: isActive ? AppColors.primary : AppColors.textDark,
        fontSize: 14,
        fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
      )),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      selectedTileColor: AppColors.primaryOverlay(opacity: 0.08),
      selected: isActive,
      onTap: () => context.go(item.route),
    );
  }

  Widget _buildTopBar() {
    return Container(
      height: 56,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Text(
            widget.role == 'student' ? 'Student Portal' : widget.role == 'admin' ? 'Admin Portal' : widget.role == 'hod' ? 'HOD Portal' : 'Faculty Portal',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: AppColors.textMedium),
            onPressed: () => context.go('/${widget.role}/notifications'),
          ),
          const SizedBox(width: 8),
          _buildProfileMenu(),
        ],
      ),
    );
  }
}

