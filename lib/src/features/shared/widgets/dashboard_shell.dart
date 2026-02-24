import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavItem {
  final String title;
  final IconData icon;
  final String route;
  final List<NavItem>? children;
  NavItem({required this.title, required this.icon, required this.route, this.children});
}

class DashboardShell extends StatefulWidget {
  final Widget child;
  final String role; // 'student' or 'faculty'
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
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF0A1628), Color(0xFF0D1F3C)],
            ),
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
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFF0D1F3C), Color(0xFF0A1628)],
                      ),
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
      backgroundColor: const Color(0xFF111D35),
      title: Text(
        widget.role == 'student' ? 'Student Portal' : 'Faculty Portal',
        style: const TextStyle(color: Colors.white, fontSize: 18),
      ),
      iconTheme: const IconThemeData(color: Colors.white),
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
        backgroundColor: Color(0xFF1565C0),
        child: Icon(Icons.person, size: 18, color: Colors.white),
      ),
      color: const Color(0xFF111D35),
      itemBuilder: (context) => [
        PopupMenuItem(value: 'profile', child: Row(children: [
          Icon(Icons.person_outline, color: Colors.white70, size: 18),
          const SizedBox(width: 8),
          const Text('Profile', style: TextStyle(color: Colors.white)),
        ])),
        PopupMenuItem(value: 'settings', child: Row(children: [
          Icon(Icons.settings_outlined, color: Colors.white70, size: 18),
          const SizedBox(width: 8),
          const Text('Settings', style: TextStyle(color: Colors.white)),
        ])),
        const PopupMenuDivider(),
        PopupMenuItem(value: 'logout', child: Row(children: [
          Icon(Icons.logout, color: Colors.red.shade300, size: 18),
          const SizedBox(width: 8),
          Text('Logout', style: TextStyle(color: Colors.red.shade300)),
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
      backgroundColor: const Color(0xFF111D35),
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xFF1565C0), Color(0xFF0D47A1)]),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const CircleAvatar(radius: 30, backgroundColor: Colors.white24, child: Icon(Icons.person, size: 30, color: Colors.white)),
                const SizedBox(height: 10),
                Text(widget.role == 'student' ? 'Student Name' : 'Faculty Name', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                Text(widget.role == 'student' ? 'S20210001' : 'FAC001', style: const TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: _navItems.map((item) => _buildDrawerItem(item)).toList(),
            ),
          ),
          const Divider(color: Color(0xFF1E3055)),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red.shade300),
            title: Text('Logout', style: TextStyle(color: Colors.red.shade300)),
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
        leading: Icon(item.icon, color: Colors.white70, size: 20),
        title: Text(item.title, style: const TextStyle(color: Colors.white, fontSize: 14)),
        iconColor: Colors.white54,
        collapsedIconColor: Colors.white54,
        children: item.children!.map((child) => ListTile(
          contentPadding: const EdgeInsets.only(left: 56),
          leading: Icon(child.icon, color: widget.currentRoute == child.route ? const Color(0xFF42A5F5) : Colors.white54, size: 18),
          title: Text(child.title, style: TextStyle(
            color: widget.currentRoute == child.route ? const Color(0xFF42A5F5) : Colors.white70,
            fontSize: 13,
          )),
          selected: widget.currentRoute == child.route,
          onTap: () { Navigator.pop(context); context.go(child.route); },
        )).toList(),
      );
    }
    return ListTile(
      leading: Icon(item.icon, color: widget.currentRoute == item.route ? const Color(0xFF42A5F5) : Colors.white70, size: 20),
      title: Text(item.title, style: TextStyle(
        color: widget.currentRoute == item.route ? const Color(0xFF42A5F5) : Colors.white,
        fontSize: 14,
        fontWeight: widget.currentRoute == item.route ? FontWeight.w600 : FontWeight.normal,
      )),
      selected: widget.currentRoute == item.route,
      selectedTileColor: const Color(0xFF1565C0).withOpacity(0.15),
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
        color: Color(0xFF111D35),
        border: Border(right: BorderSide(color: Color(0xFF1E3055))),
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
                    decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0xFFD4A843), width: 1.5)),
                    child: const Icon(Icons.school, size: 18, color: Color(0xFFD4A843)),
                  ),
                  const SizedBox(width: 10),
                  const Text('KSRCE ERP', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                ],
                const Spacer(),
                IconButton(
                  icon: Icon(_isSidebarCollapsed ? Icons.menu : Icons.menu_open, color: Colors.white70, size: 20),
                  onPressed: () => setState(() => _isSidebarCollapsed = !_isSidebarCollapsed),
                ),
              ],
            ),
          ),
          const Divider(color: Color(0xFF1E3055), height: 1),
          // Nav Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              children: _navItems.map((item) => _buildSidebarItem(item)).toList(),
            ),
          ),
          const Divider(color: Color(0xFF1E3055), height: 1),
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
          color: const Color(0xFF111D35),
          offset: const Offset(60, 0),
          itemBuilder: (context) => item.children!.map((child) => PopupMenuItem(
            value: child.route,
            child: Row(children: [
              Icon(child.icon, size: 16, color: widget.currentRoute == child.route ? const Color(0xFF42A5F5) : Colors.white70),
              const SizedBox(width: 8),
              Text(child.title, style: TextStyle(color: widget.currentRoute == child.route ? const Color(0xFF42A5F5) : Colors.white, fontSize: 13)),
            ]),
          )).toList(),
          onSelected: (route) => context.go(route),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Icon(item.icon, color: isChildActive ? const Color(0xFF42A5F5) : Colors.white70, size: 22),
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
              color: isActive ? const Color(0xFF1565C0).withOpacity(0.2) : null,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(item.icon, color: isActive ? const Color(0xFF42A5F5) : Colors.white70, size: 22),
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
                color: isChildActive ? const Color(0xFF1565C0).withOpacity(0.1) : null,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(item.icon, color: isChildActive ? const Color(0xFF42A5F5) : Colors.white70, size: 20),
                  const SizedBox(width: 12),
                  Expanded(child: Text(item.title, style: TextStyle(color: isChildActive ? const Color(0xFF42A5F5) : Colors.white, fontSize: 14))),
                  Icon(isExpanded ? Icons.expand_less : Icons.expand_more, color: Colors.white54, size: 18),
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
                  leading: Icon(child.icon, size: 16, color: childActive ? const Color(0xFF42A5F5) : Colors.white54),
                  title: Text(child.title, style: TextStyle(color: childActive ? const Color(0xFF42A5F5) : Colors.white70, fontSize: 13)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  selectedTileColor: const Color(0xFF1565C0).withOpacity(0.15),
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
      leading: Icon(item.icon, color: isActive ? const Color(0xFF42A5F5) : Colors.white70, size: 20),
      title: Text(item.title, style: TextStyle(
        color: isActive ? const Color(0xFF42A5F5) : Colors.white,
        fontSize: 14,
        fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
      )),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      selectedTileColor: const Color(0xFF1565C0).withOpacity(0.15),
      selected: isActive,
      onTap: () => context.go(item.route),
    );
  }

  Widget _buildTopBar() {
    return Container(
      height: 56,
      decoration: const BoxDecoration(
        color: Color(0xFF111D35),
        border: Border(bottom: BorderSide(color: Color(0xFF1E3055))),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Text(
            widget.role == 'student' ? 'Student Portal' : 'Faculty Portal',
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white70),
            onPressed: () => context.go('/${widget.role}/notifications'),
          ),
          const SizedBox(width: 8),
          _buildProfileMenu(),
        ],
      ),
    );
  }
}
