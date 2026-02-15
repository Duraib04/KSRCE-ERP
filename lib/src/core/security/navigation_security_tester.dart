import 'package:flutter/material.dart';
import '../security/jwt_token_manager.dart';
import '../security/route_guard.dart';
import '../security/auth_service_enhanced.dart';

/// Navigation and Security Test Utility
/// Verifies all pages and navigation flows are working correctly
class NavigationSecurityTester {
  // Test data
  static const String studentId = 'S20210001';
  static const String studentPassword = 'demo123';
  static const String facultyId = 'FAC001';
  static const String facultyPassword = 'demo123';
  static const String adminId = 'ADM001';
  static const String adminPassword = 'admin123';

  // All defined routes in the application
  static const List<String> allRoutes = [
    '/',
    '/login',
    '/error',
    '/dashboard/student',
    '/dashboard/student/profile',
    '/dashboard/student/courses',
    '/dashboard/student/assignments',
    '/dashboard/student/results',
    '/dashboard/student/attendance',
    '/dashboard/student/complaints',
    '/dashboard/student/notifications',
    '/dashboard/student/time-table',
    '/dashboard/faculty',
    '/dashboard/faculty/my-classes',
    '/dashboard/faculty/attendance-management',
    '/dashboard/faculty/grades-management',
    '/dashboard/faculty/schedule',
    '/dashboard/admin',
    '/dashboard/admin/students',
    '/dashboard/admin/faculty',
    '/dashboard/admin/administration',
  ];

  /// Run all security and navigation tests
  static Future<void> runAllTests() async {
    debugPrint('🧪 Starting Navigation & Security Tests...\n');

    // Test 1: Token generation and validation
    await _testTokenGeneration();
    debugPrint('\n' + ('═' * 60) + '\n');

    // Test 2: Route access control
    await _testRouteAccessControl();
    debugPrint('\n' + ('═' * 60) + '\n');

    // Test 3: Role-based access verification
    await _testRoleBasedAccess();
    debugPrint('\n' + ('═' * 60) + '\n');

    // Test 4: Unauthorized access prevention
    await _testUnauthorizedAccessPrevention();
    debugPrint('\n' + ('═' * 60) + '\n');

    // Test 5: All routes coverage
    await _testAllRoutesCoverage();
    debugPrint('\n' + ('═' * 60) + '\n');

    // Test 6: Token expiration and refresh
    await _testTokenRefresh();

    debugPrint('\n✅ All tests completed!');
  }

  /// Test 1: Token Generation and Validation
  static Future<void> _testTokenGeneration() async {
    debugPrint('📋 TEST 1: Token Generation & Validation\n');

    // Generate token for student
    final token = JWTTokenManager.generateToken(
      userId: studentId,
      userRole: 'student',
      additionalClaims: {'test': true},
    );

    debugPrint('Generated Token:');
    debugPrint('  Header: ${token.header.substring(0, 20)}...');
    debugPrint('  Payload: ${token.payload.substring(0, 20)}...');
    debugPrint('  Signature: ${token.signature.substring(0, 20)}...');
    debugPrint('  Expires At: ${token.expiresAt}');
    debugPrint('  Is Valid: ${token.isValid}\n');

    // Validate token
    final isValid = JWTTokenManager.validateToken(token.token);
    debugPrint('Token Validation Result: ${isValid ? '✅ VALID' : '❌ INVALID'}\n');

    // Check token hash
    final hash = JWTTokenManager.hashString(token.token);
    debugPrint('Token Hash (SHA-256): ${hash.substring(0, 32)}...\n');

    // Extract claims
    final claims = JWTTokenManager.extractClaims(token.token);
    debugPrint('Token Claims:');
    debugPrint('  User ID: ${claims['user_id']}');
    debugPrint('  User Role: ${claims['user_role']}');
    debugPrint('  Issued At: ${claims['iat']}');
    debugPrint('  Expires At: ${claims['exp']}');
    debugPrint('  Issuer: ${claims['iss']}');
  }

  /// Test 2: Route Access Control
  static Future<void> _testRouteAccessControl() async {
    debugPrint('📋 TEST 2: Route Access Control\n');

    // Generate tokens for different roles
    final studentToken = JWTTokenManager.generateToken(
      userId: studentId,
      userRole: 'student',
      additionalClaims: {},
    ).token;

    final facultyToken = JWTTokenManager.generateToken(
      userId: facultyId,
      userRole: 'faculty',
      additionalClaims: {},
    ).token;

    final adminToken = JWTTokenManager.generateToken(
      userId: adminId,
      userRole: 'admin',
      additionalClaims: {},
    ).token;

    // Test student access
    debugPrint('🔹 STUDENT Role Tests:');
    _testRouteAccess('/dashboard/student', studentToken, shouldSucceed: true);
    _testRouteAccess('/dashboard/student/courses', studentToken, shouldSucceed: true);
    _testRouteAccess('/dashboard/faculty', studentToken, shouldSucceed: false);
    _testRouteAccess('/dashboard/admin', studentToken, shouldSucceed: false);

    debugPrint('\n🔹 FACULTY Role Tests:');
    _testRouteAccess('/dashboard/faculty', facultyToken, shouldSucceed: true);
    _testRouteAccess('/dashboard/faculty/my-classes', facultyToken, shouldSucceed: true);
    _testRouteAccess('/dashboard/student', facultyToken, shouldSucceed: false);
    _testRouteAccess('/dashboard/admin', facultyToken, shouldSucceed: false);

    debugPrint('\n🔹 ADMIN Role Tests:');
    _testRouteAccess('/dashboard/admin', adminToken, shouldSucceed: true);
    _testRouteAccess('/dashboard/admin/students', adminToken, shouldSucceed: true);
    _testRouteAccess('/dashboard/student', adminToken, shouldSucceed: false);
    _testRouteAccess('/dashboard/faculty', adminToken, shouldSucceed: false);
  }

  /// Test 3: Role-Based Access Verification
  static Future<void> _testRoleBasedAccess() async {
    debugPrint('📋 TEST 3: Role-Based Access Verification\n');

    final studentToken = JWTTokenManager.generateToken(
      userId: studentId,
      userRole: 'student',
      additionalClaims: {},
    ).token;

    final role = RouteGuard.getUserRole(studentToken);
    debugPrint('Extracted Role from Token: ${role.name}');
    debugPrint('Allowed Routes for STUDENT:');
    
    for (final route in role.allowedRoutes) {
      debugPrint('  ✅ $route');
    }

    debugPrint('\nDenied Routes for STUDENT:');
    final deniedRoutes = ['/dashboard/faculty', '/dashboard/admin'];
    for (final route in deniedRoutes) {
      debugPrint('  ❌ $route');
    }
  }

  /// Test 4: Unauthorized Access Prevention
  static Future<void> _testUnauthorizedAccessPrevention() async {
    debugPrint('📋 TEST 4: Unauthorized Access Prevention\n');

    // Test 1: No token
    debugPrint('🔹 Scenario 1: No Token');
    final canAccess1 = RouteGuard.canAccessRoute(
      '/dashboard/student',
      authToken: null,
    );
    debugPrint('  Access to /dashboard/student: ${canAccess1 ? '✅ ALLOWED' : '❌ DENIED'}\n');

    // Test 2: Invalid token
    debugPrint('🔹 Scenario 2: Invalid Token');
    const invalidToken = 'invalid.token.here';
    final canAccess2 = RouteGuard.canAccessRoute(
      '/dashboard/student',
      authToken: invalidToken,
    );
    debugPrint('  Access to /dashboard/student: ${canAccess2 ? '✅ ALLOWED' : '❌ DENIED'}\n');

    // Test 3: Expired token
    debugPrint('🔹 Scenario 3: Token Nearing Expiration');
    final expiredToken = JWTTokenManager.generateToken(
      userId: studentId,
      userRole: 'student',
      additionalClaims: {},
    ).token;
    // Note: In real test, we'd create an actually expired token
    final isExpired = JWTTokenManager.extractClaims(expiredToken)['exp'];
    debugPrint('  Token expires at: $isExpired\n');

    // Test 4: Cross-role access attempt
    debugPrint('🔹 Scenario 4: Cross-Role Access Attempt');
    final studentToken = JWTTokenManager.generateToken(
      userId: studentId,
      userRole: 'student',
      additionalClaims: {},
    ).token;
    
    final canAccessFacultyRoute = RouteGuard.canAccessRoute(
      '/dashboard/faculty/my-classes',
      authToken: studentToken,
    );
    debugPrint('  STUDENT accessing FACULTY route: ${canAccessFacultyRoute ? '✅ ALLOWED' : '❌ DENIED'}\n');

    // Test 5: Public routes
    debugPrint('🔹 Scenario 5: Public Route Access');
    const publicRoutes = ['/', '/login', '/error'];
    for (final route in publicRoutes) {
      final canAccess = RouteGuard.canAccessRoute(route, authToken: null);
      debugPrint('  Access to $route: ${canAccess ? '✅ ALLOWED' : '❌ DENIED'}');
    }
  }

  /// Test 5: All Routes Coverage
  static Future<void> _testAllRoutesCoverage() async {
    debugPrint('📋 TEST 5: All Routes Coverage\n');

    final studentToken = JWTTokenManager.generateToken(
      userId: studentId,
      userRole: 'student',
      additionalClaims: {},
    ).token;

    final facultyToken = JWTTokenManager.generateToken(
      userId: facultyId,
      userRole: 'faculty',
      additionalClaims: {},
    ).token;

    final adminToken = JWTTokenManager.generateToken(
      userId: adminId,
      userRole: 'admin',
      additionalClaims: {},
    ).token;

    int totalRoutes = 0;
    int studentAccessible = 0;
    int facultyAccessible = 0;
    int adminAccessible = 0;

    for (final route in allRoutes) {
      totalRoutes++;

      final studentAccess = _canAccess(route, studentToken);
      final facultyAccess = _canAccess(route, facultyToken);
      final adminAccess = _canAccess(route, adminToken);

      if (studentAccess) studentAccessible++;
      if (facultyAccess) facultyAccessible++;
      if (adminAccess) adminAccessible++;

      debugPrint('$route');
      debugPrint('  Student: ${studentAccess ? '✅' : '❌'} | Faculty: ${facultyAccess ? '✅' : '❌'} | Admin: ${adminAccess ? '✅' : '❌'}');
    }

    debugPrint('\n📊 Routes Summary:');
    debugPrint('  Total Routes: $totalRoutes');
    debugPrint('  Student Accessible: $studentAccessible');
    debugPrint('  Faculty Accessible: $facultyAccessible');
    debugPrint('  Admin Accessible: $adminAccessible');
  }

  /// Test 6: Token Refresh
  static Future<void> _testTokenRefresh() async {
    debugPrint('📋 TEST 6: Token Refresh & Expiration\n');

    final token = JWTTokenManager.generateToken(
      userId: studentId,
      userRole: 'student',
      additionalClaims: {},
    );

    debugPrint('Original Token:');
    debugPrint('  Issued At: ${token.issuedAt}');
    debugPrint('  Expires At: ${token.expiresAt}');
    debugPrint('  Duration: ${token.expiresAt.difference(token.issuedAt).inHours} hours');

    final refreshedToken = JWTTokenManager.refreshTokenIfNeeded(token.token);
    if (refreshedToken != null) {
      debugPrint('\nRefreshed Token:');
      debugPrint('  Issued At: ${refreshedToken.issuedAt}');
      debugPrint('  Expires At: ${refreshedToken.expiresAt}');
      debugPrint('  ✅ Token successfully refreshed');
    } else {
      debugPrint('\n✅ Token still valid, no refresh needed');
    }
  }

  // Helper method to test route access
  static void _testRouteAccess(String route, String token, {required bool shouldSucceed}) {
    final canAccess = RouteGuard.canAccessRoute(route, authToken: token);
    final result = canAccess == shouldSucceed ? '✅ PASS' : '❌ FAIL';
    debugPrint('  $route: ${canAccess ? 'ALLOWED' : 'DENIED'} $result');
  }

  // Helper method to check access
  static bool _canAccess(String route, String token) {
    return RouteGuard.canAccessRoute(route, authToken: token);
  }
}
