import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/presentation/pages/login_page.dart';

// TODO: Import and create a real dashboard page

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
      path: '/dashboard',
      // TODO: Create a real dashboard page for authenticated users
      builder: (context, state) => Scaffold(
        appBar: AppBar(title: const Text('Dashboard')),
        body: const Center(
          child: Text("Welcome to the Dashboard!"),
        ),
      ),
    ),
  ],
  // In a real app, a redirect would be placed here to handle auth state.
  // For example, if the user is already logged in, redirect from '/' to '/dashboard'.
);
