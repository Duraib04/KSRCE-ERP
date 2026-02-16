import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import '../security/jwt_token_manager.dart';

/// Enum for user roles with permissions
enum UserRole {
  student,
  faculty,
  admin,
  guest,
}

/// Extension to get role name
extension UserRoleExtension on UserRole {
  String get name {
    return toString().split('.').last;
  }

  /// Get allowed routes for this role
  List<String> get allowedRoutes {
    switch (this) {
      case UserRole.student:
        return [
          '/dashboard/student',
          '/dashboard/student/profile',
          '/dashboard/student/courses',
          '/dashboard/student/assignments',
          '/dashboard/student/results',
          '/dashboard/student/attendance',
          '/dashboard/student/complaints',
          '/dashboard/student/notifications',
          '/dashboard/student/time-table',
        ];
      case UserRole.faculty:
        return [
          '/dashboard/faculty',
          '/dashboard/faculty/my-classes',
          '/dashboard/faculty/attendance-management',
          '/dashboard/faculty/grades-management',
          '/dashboard/faculty/schedule',
        ];
      case UserRole.admin:
        return [
          '/dashboard/admin',
          '/dashboard/admin/students',
          '/dashboard/admin/faculty',
          '/dashboard/admin/administration',
        ];
      case UserRole.guest:
        return ['/login', '/'];
    }
  }

  /// Check if this role can access a specific route
  bool canAccessRoute(String route) {
    return allowedRoutes.any((allowedRoute) => route.startsWith(allowedRoute));
  }
}

/// Route Guard for preventing unauthorized navigation
class RouteGuard {
  // Note: These constants are for future use when storing in SharedPreferences
  // not currently used in the current implementation
  // static const String _tokenKey = 'auth_token';
  // static const String _roleKey = 'user_role';
  // static const String _userIdKey = 'user_id';

  /// Validate route access based on authentication token and role
  static bool canAccessRoute(String requestedRoute, {required String? authToken}) {
    // Public routes that don't require authentication
    const publicRoutes = ['/', '/login', '/error'];
    
    if (publicRoutes.contains(requestedRoute)) {
      return true;
    }

    // If no token, deny access to protected routes
    if (authToken == null || authToken.isEmpty) {
      debugPrint('❌ Access denied: No authentication token');
      return false;
    }

    // Validate token
    if (!JWTTokenManager.validateToken(authToken)) {
      debugPrint('❌ Access denied: Invalid or expired token');
      return false;
    }

    // Extract user role from token
    final userRole = JWTTokenManager.getUserRoleFromToken(authToken);
    if (userRole == null) {
      debugPrint('❌ Access denied: No user role in token');
      return false;
    }

    // Get UserRole enum from string
    UserRole role = UserRole.guest;
    try {
      role = UserRole.values.firstWhere(
        (r) => r.name == userRole.toLowerCase(),
        orElse: () => UserRole.guest,
      );
    } catch (_) {}

    // Check if role can access the route
    final canAccess = role.canAccessRoute(requestedRoute);
    
    if (!canAccess) {
      debugPrint('❌ Access denied: Role $userRole cannot access $requestedRoute');
    } else {
      debugPrint('✅ Access granted: Role $userRole can access $requestedRoute');
    }

    return canAccess;
  }

  /// Generate authorization header with hashed token
  static Map<String, String> generateAuthHeaders(String token) {
    final hashedToken = JWTTokenManager.hashString(token);
    return {
      'Authorization': 'Bearer $token',
      'X-Token-Hash': hashedToken,
      'X-Request-Time': DateTime.now().millisecondsSinceEpoch.toString(),
    };
  }

  /// Verify authorization headers
  static bool verifyAuthHeaders(Map<String, String> headers, String token) {
    final authHeader = headers['Authorization'];
    final tokenHash = headers['X-Token-Hash'];

    if (authHeader == null || tokenHash == null) {
      debugPrint('❌ Missing authorization headers');
      return false;
    }

    if (!authHeader.startsWith('Bearer ')) {
      debugPrint('❌ Invalid authorization header format');
      return false;
    }

    final hashedToken = JWTTokenManager.hashString(token);
    if (tokenHash != hashedToken) {
      debugPrint('❌ Token hash mismatch');
      return false;
    }

    debugPrint('✅ Auth headers verified');
    return true;
  }

  /// Get user role from token
  static UserRole getUserRole(String token) {
    final roleString = JWTTokenManager.getUserRoleFromToken(token);
    if (roleString == null) return UserRole.guest;

    try {
      return UserRole.values.firstWhere(
        (r) => r.name == roleString.toLowerCase(),
        orElse: () => UserRole.guest,
      );
    } catch (_) {
      return UserRole.guest;
    }
  }

  /// Check if token is valid
  static bool isTokenValid(String? token) {
    if (token == null || token.isEmpty) return false;
    return JWTTokenManager.validateToken(token);
  }
}

/// GoRouter redirect callback for route protection
Future<String?> authenticationRedirect(GoRouterState state) async {
  // Paths that don't need authentication
  final publicPaths = ['/', '/login', '/error'];
  
  if (publicPaths.contains(state.matchedLocation)) {
    return null; // Allow access
  }

  // Get token from somewhere (you need to implement token storage)
  final token = _retrieveToken();

  // Check if user is authenticated
  if (!RouteGuard.isTokenValid(token)) {
    debugPrint('🔒 Redirecting to login - authentication required');
    return '/login';
  }

  // Verify route access
  if (!RouteGuard.canAccessRoute(state.matchedLocation, authToken: token)) {
    debugPrint('⛔ Redirecting to error - access denied');
    return '/error';
  }

  return null; // Allow navigation
}

// Helper method to retrieve stored token (implement based on your storage)
String? _retrieveToken() {
  // TODO: Implement actual token retrieval from secure storage
  // This should read from SharedPreferences or your browser storage service
  return null;
}
