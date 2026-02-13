import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'src/config/routes.dart';
import 'src/core/theme/app_theme.dart';
import 'src/features/home/presentation/pages/home_page.dart';
import 'src/features/auth/presentation/pages/login_page.dart';
import 'src/features/core/presentation/pages/error_page.dart';
import 'src/features/student/presentation/pages/student_dashboard.dart';
import 'src/features/student/presentation/pages/profile_page.dart';
import 'src/features/student/presentation/pages/courses_page.dart';
import 'src/features/student/presentation/pages/assignments_page.dart';
import 'src/features/student/presentation/pages/results_page.dart';
import 'src/features/student/presentation/pages/attendance_page.dart';
import 'src/features/student/presentation/pages/complaints_page.dart';
import 'src/features/student/presentation/pages/notifications_page.dart';
import 'src/features/student/presentation/pages/time_table_page.dart';
import 'src/features/faculty/presentation/pages/faculty_dashboard.dart';
import 'src/features/faculty/presentation/pages/my_classes_page.dart';
import 'src/features/faculty/presentation/pages/attendance_management_page.dart';
import 'src/features/faculty/presentation/pages/grades_management_page.dart';
import 'src/features/faculty/presentation/pages/schedule_page.dart';
import 'src/features/admin/presentation/pages/admin_dashboard.dart';
import 'src/features/admin/presentation/pages/students_list_page.dart';
import 'src/features/admin/presentation/pages/faculty_management_page.dart';
import 'src/features/admin/presentation/pages/administration_dashboard_page.dart';
import 'src/services/auth_service.dart';

void main() {
  runApp(const KsrceErpApp());
}

/// The main application widget.
class KsrceErpApp extends StatelessWidget {
  const KsrceErpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'KSRCE ERP',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}

/// App router configuration using go_router.
final GoRouter _router = GoRouter(
  initialLocation: AuthService.isAuthenticated ? _getInitialRoute() : HomeRoutes.home,
  redirect: (context, state) {
    final isHome = state.matchedLocation == HomeRoutes.home;
    final isLoggingIn = state.matchedLocation == AuthRoutes.login;
    final isAuthenticated = AuthService.isAuthenticated;

    // If authenticated and on home or login page, send to appropriate dashboard
    if (isAuthenticated && (isHome || isLoggingIn)) {
      return _getInitialRoute();
    }

    // If not authenticated and trying to access protected routes, send to home
    if (!isAuthenticated && !isHome && !isLoggingIn) {
      return HomeRoutes.home;
    }

    return null;
  },
  routes: [
    // Home Route
    GoRoute(
      path: HomeRoutes.home,
      builder: (context, state) => const HomePage(),
    ),

    // Auth Routes
    GoRoute(
      path: AuthRoutes.login,
      builder: (context, state) => const LoginPage(),
    ),

    // Error Route
    GoRoute(
      path: '/error',
      builder: (context, state) => const ErrorPage(),
    ),

    // Student Routes
    GoRoute(
      path: StudentRoutes.dashboard,
      builder: (context, state) => StudentDashboard(
        userId: AuthService.currentUserId,
      ),
      routes: [
        GoRoute(
          path: 'profile',
          builder: (context, state) => StudentProfilePage(
            userId: AuthService.currentUserId,
          ),
        ),
        GoRoute(
          path: 'courses',
          builder: (context, state) => StudentCoursesPage(
            userId: AuthService.currentUserId,
          ),
        ),
        GoRoute(
          path: 'assignments',
          builder: (context, state) => StudentAssignmentsPage(
            userId: AuthService.currentUserId,
          ),
        ),
        GoRoute(
          path: 'results',
          builder: (context, state) => StudentResultsPage(
            userId: AuthService.currentUserId,
          ),
        ),
        GoRoute(
          path: 'attendance',
          builder: (context, state) => StudentAttendancePage(
            userId: AuthService.currentUserId,
          ),
        ),
        GoRoute(
          path: 'complaints',
          builder: (context, state) => StudentComplaintsPage(
            userId: AuthService.currentUserId,
          ),
        ),
        GoRoute(
          path: 'notifications',
          builder: (context, state) => StudentNotificationsPage(
            userId: AuthService.currentUserId,
          ),
        ),
        GoRoute(
          path: 'time-table',
          builder: (context, state) => StudentTimeTablePage(
            userId: AuthService.currentUserId,
          ),
        ),
      ],
    ),

    // Faculty Routes
    GoRoute(
      path: FacultyRoutes.dashboard,
      builder: (context, state) => FacultyDashboard(
        userId: AuthService.currentUserId,
      ),
      routes: [
        GoRoute(
          path: 'my-classes',
          builder: (context, state) => FacultyMyClassesPage(
            userId: AuthService.currentUserId,
          ),
        ),
        GoRoute(
          path: 'attendance-management',
          builder: (context, state) => FacultyAttendanceManagementPage(
            userId: AuthService.currentUserId,
          ),
        ),
        GoRoute(
          path: 'grades-management',
          builder: (context, state) => FacultyGradesManagementPage(
            userId: AuthService.currentUserId,
          ),
        ),
        GoRoute(
          path: 'schedule',
          builder: (context, state) => FacultySchedulePage(
            userId: AuthService.currentUserId,
          ),
        ),
      ],
    ),

    // Admin Routes
    GoRoute(
      path: AdminRoutes.dashboard,
      builder: (context, state) => AdminDashboard(
        userId: AuthService.currentUserId,
      ),
      routes: [
        GoRoute(
          path: 'students',
          builder: (context, state) => StudentsListPage(
            userId: AuthService.currentUserId,
          ),
        ),
        GoRoute(
          path: 'faculty',
          builder: (context, state) => FacultyManagementPage(
            userId: AuthService.currentUserId,
          ),
        ),
        GoRoute(
          path: 'admin',
          builder: (context, state) => AdministrationDashboardPage(
            userId: AuthService.currentUserId,
          ),
        ),
      ],
    ),
  ],
  errorBuilder: (context, state) => ErrorPage(
    error: state.error?.message,
    statusCode: 404,
  ),
);

String _getInitialRoute() {
  switch (AuthService.currentRole) {
    case UserRole.student:
      return StudentRoutes.dashboard;
    case UserRole.faculty:
      return FacultyRoutes.dashboard;
    case UserRole.admin:
      return AdminRoutes.dashboard;
    case UserRole.guest:
      return AuthRoutes.login;
  }
}

