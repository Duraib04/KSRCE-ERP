import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../config/routes.dart';
import '../services/auth_service.dart';

class NavigationService {
  static final NavigationService _instance = NavigationService._internal();

  factory NavigationService() {
    return _instance;
  }

  NavigationService._internal();

  // Navigate to dashboard based on user role
  static void navigateToDashboard(BuildContext context) {
    final role = AuthService.currentRole;
    switch (role) {
      case UserRole.student:
        context.go(StudentRoutes.dashboard);
        break;
      case UserRole.faculty:
        context.go(FacultyRoutes.dashboard);
        break;
      case UserRole.admin:
        context.go(AdminRoutes.dashboard);
        break;
      case UserRole.guest:
        context.go(AuthRoutes.login);
        break;
    }
  }

  // Navigate to login
  static void navigateToLogin(BuildContext context) {
    context.go(AuthRoutes.login);
  }

  // Navigate back
  static void goBack(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  // Replace navigation (navigate and clear previous routes)
  static void replaceAll(BuildContext context, String route) {
    context.go(route);
  }
}
