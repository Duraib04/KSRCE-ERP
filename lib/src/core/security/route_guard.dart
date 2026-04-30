import 'package:go_router/go_router.dart';

import 'auth_service_enhanced.dart';
import 'session_manager.dart';

/// Route guard that handles authentication-based redirects.
///
/// This ensures:
/// - Unauthenticated users cannot access protected routes
/// - Authenticated users are redirected away from login page
/// - User roles have access to appropriate dashboards only
class RouteGuard {
  /// Authentication redirect function for GoRouter.
  ///
  /// Redirects:
  /// - Non-authenticated users to /login
  /// - Authenticated users away from /login and /
  /// - Users to their appropriate dashboard based on role
  static String? authenticationRedirect(
    GoRouterState state,
  ) {
    // List of public routes that don't require authentication
    const publicRoutes = <String>['/login', '/', '/forgot-password',
      '/login/student', '/login/faculty', '/login/admin'];

    final isAuthenticated = AuthService.isAuthenticated;
    final isGoingToPublicRoute = publicRoutes.contains(state.matchedLocation);

    // If user is not authenticated and trying to access protected route,
    // persist current path so login can return user to the same page.
    if (!isAuthenticated && !isGoingToPublicRoute) {
      SessionManager.instance.persistLastPath(state.matchedLocation);
      return '/login';
    }

    // If user is authenticated but trying to access login, redirect to dashboard
    if (isAuthenticated && isGoingToPublicRoute) {
      final last = SessionManager.instance.readLastPath();
      if (last != null && last.isNotEmpty) {
        SessionManager.instance.clearLastPath();
        return last;
      }
      return _getDashboardForRole(AuthService.currentUserRole);
    }

    // Role-based access control: prevent cross-role access
    if (isAuthenticated && !isGoingToPublicRoute) {
      final userRoleRaw = AuthService.currentUserRole;
      // Safely convert role to String to handle any type mismatches
      final userRole = userRoleRaw == null ? null : (userRoleRaw is String ? userRoleRaw : userRoleRaw.toString()).toLowerCase().trim();
      final path = state.matchedLocation;

      // Student can only access /dashboard/student/*
      if (userRole == 'student' && !path.startsWith('/dashboard/student')) {
        return '/dashboard/student';
      }
      // Faculty can only access /dashboard/faculty/*
      if (userRole == 'faculty' && !path.startsWith('/dashboard/faculty')) {
        return '/dashboard/faculty';
      }
      // Admin can only access /dashboard/admin/*
      if (userRole == 'admin' && !path.startsWith('/dashboard/admin')) {
        return '/dashboard/admin';
      }

      // Validate session is still valid
      if (!AuthService.hasValidSession) {
        AuthService.logout();
        return '/login';
      }
    }

    // No redirect needed
    return null;
  }

  /// Checks if a user has access to a specific role.
  ///
  /// Can be used in route guards for role-based access control.
  static bool hasRole(String requiredRole) {
    if (!AuthService.isAuthenticated) return false;
    final userRole = AuthService.currentUserRole;
    return userRole == requiredRole;
  }

  /// Checks if a user has access to any of the specified roles.
  static bool hasAnyRole(List<String> requiredRoles) {
    if (!AuthService.isAuthenticated) return false;
    final userRole = AuthService.currentUserRole;
    return requiredRoles.contains(userRole);
  }

  /// Checks if the current session is valid.
  ///
  /// Returns false if:
  /// - User is not authenticated
  /// - Session token is invalid
  /// - Session has expired
  static bool isSessionValid() {
    return AuthService.hasValidSession;
  }

  /// Determines the appropriate dashboard route based on user role.
  static String _getDashboardForRole(String? role) {
    // Safely convert role to String to handle any type mismatches
    final normalizedRole = role == null ? null : (role is String ? role : role.toString()).toLowerCase().trim();
    
    return switch (normalizedRole) {
      'student' => '/dashboard/student',
      'faculty' => '/dashboard/faculty',
      'admin' => '/dashboard/admin',
      _ => '/login',
    };
  }

  /// Validates that a route is accessible for the current user.
  ///
  /// Returns true if the route is accessible, false otherwise.
  static bool isRouteAccessible(String route, {List<String>? allowedRoles}) {
    if (!AuthService.isAuthenticated) {
      return route == '/login' || route == '/';
    }

    if (!AuthService.hasValidSession) {
      return false;
    }

    if (allowedRoles != null && allowedRoles.isNotEmpty) {
      return hasAnyRole(allowedRoles);
    }

    return true;
  }

  /// Handles forced logout due to session expiration.
  static void handleSessionExpired() {
    AuthService.logout();
  }

  /// Creates a redirect route with error message.
  static String redirectWithError(String toRoute, String errorMessage) {
    // This could be enhanced to pass error state through GoRouter
    return toRoute;
  }
}
