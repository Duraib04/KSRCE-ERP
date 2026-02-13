import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'src/core/theme/app_theme.dart';
import 'src/features/auth/presentation/pages/login_page.dart';
import 'src/features/student/presentation/pages/student_dashboard.dart';
import 'src/features/faculty/presentation/pages/faculty_dashboard.dart';
import 'src/features/admin/presentation/pages/admin_dashboard.dart';

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
      themeMode: ThemeMode.system, // Or .light, .dark
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}

/// App router configuration using go_router.
final GoRouter _router = GoRouter(
  initialLocation: '/', // Start at the login page
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/dashboard/student',
      builder: (context, state) {
        final userId = state.extra as String? ?? 'Student';
        return StudentDashboard(userId: userId);
      },
    ),
    GoRoute(
      path: '/dashboard/faculty',
      builder: (context, state) {
        final userId = state.extra as String? ?? 'Faculty';
        return FacultyDashboard(userId: userId);
      },
    ),
    GoRoute(
      path: '/dashboard/admin',
      builder: (context, state) {
        final userId = state.extra as String? ?? 'Admin';
        return AdminDashboard(userId: userId);
      },
    ),
  ],
  // In a real app, a redirect would be placed here to handle auth state.
  // For example, if the user is already logged in, redirect from '/' to '/dashboard'.
);

