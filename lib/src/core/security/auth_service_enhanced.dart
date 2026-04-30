import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/data/auth_service.dart' as original_auth;
import 'jwt_token_manager.dart';
import 'session_manager.dart';

// Re-export the LoginResult class
export '../../features/auth/data/auth_service.dart' show LoginResult;

/// Enhanced authentication service with JWT token support and session management.
///
/// This service wraps the basic [AuthService] and adds:
/// - JWT token generation and validation
/// - Session management with token caching
/// - User state persistence
/// - Logout functionality
class AuthService {
  static const String _currentUserKey = 'auth_current_user_id';
  static const String _currentTokenKey = 'auth_current_token';
  static const String _userRoleKey = 'auth_user_role';

  // Private instance of the original auth service
  static final _authService = original_auth.AuthService();

  // Cached values
  static String? _currentUserId;
  static String? _currentToken;
  static String? _currentUserRole;
  static bool _initialized = false;

  /// Initializes the authentication system by restoring the previous session if available.
  /// 
  /// Call this in main() before running the app.
  static Future<void> initialize() async {
    if (_initialized) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      // Requirement: on web refresh, force user to log in again.
      if (kIsWeb) {
        await prefs.remove(_currentUserKey);
        await prefs.remove(_currentTokenKey);
        await prefs.remove(_userRoleKey);
        _currentUserId = null;
        _currentToken = null;
        _currentUserRole = null;
      } else {
        _currentUserId = _readStringPreference(prefs, _currentUserKey);
        _currentToken = prefs.getString(_currentTokenKey);
        _currentUserRole = _readStringPreference(prefs, _userRoleKey);
      }

      // Validate token if it exists
      if (_currentToken != null) {
        final payload = JWTTokenManager.validateToken(_currentToken!);
        if (payload == null) {
          // Token is invalid or expired, clear session
          await logout();
        }
      }
    } catch (e) {
      debugPrint('Error initializing auth service: $e');
      await logout();
    }

    _initialized = true;
  }

  /// Performs login with enhanced security features.
  ///
  /// Returns a [LoginResult] indicating success or failure.
  /// On success, generates JWT token and caches session.
  static Future<original_auth.LoginResult> login(
    String userId,
    String password,
    bool rememberMe,
  ) async {
    try {
      final result = await _authService.login(userId, password, rememberMe);

      if (result.success) {
        await _handleSuccessfulLogin(userId, rememberMe);
      }

      return result;
    } catch (e) {
      debugPrint('Login error: $e');
      return original_auth.LoginResult(
        success: false,
        message: 'An unexpected error occurred. Please try again.',
      );
    }
  }

  /// Logs out the current user and clears all session data.
  static Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_currentUserKey);
      await prefs.remove(_currentTokenKey);
      await prefs.remove(_userRoleKey);

      _currentUserId = null;
      _currentToken = null;
      _currentUserRole = null;
      // Stop inactivity tracking when user logs out.
      SessionManager.instance.stop();
    } catch (e) {
      debugPrint('Logout error: $e');
    }
  }

  /// Refreshes the current user's session token.
  ///
  /// Returns true if refresh was successful, false otherwise.
  static Future<bool> refreshSession() async {
    if (_currentToken == null) return false;

    try {
      final newToken = JWTTokenManager.refreshToken(_currentToken!);
      if (newToken == null) {
        await logout();
        return false;
      }

      _currentToken = newToken;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_currentTokenKey, newToken);
      return true;
    } catch (e) {
      debugPrint('Session refresh error: $e');
      return false;
    }
  }

  /// Gets the current user's ID, safely converted to String.
  ///
  /// Returns null if no user is logged in.
  static String? get currentUserId {
    if (_currentUserId == null) return null;
    // Ensure it's always a String, in case of type mismatch from persistence
    if (_currentUserId is String) return _currentUserId;
    return _currentUserId?.toString();
  }

  /// Gets the current user's role (student, faculty, admin), safely converted to String.
  ///
  /// Returns null if no user is logged in.
  static String? get currentUserRole {
    if (_currentUserRole == null) return null;
    // Ensure it's always a String, in case of type mismatch from persistence
    if (_currentUserRole is String) return _currentUserRole;
    return _currentUserRole?.toString();
  }

  /// Gets the current user's JWT token.
  ///
  /// Returns null if no user is logged in.
  static String? get currentToken => _currentToken;

  /// Checks if a user is currently logged in.
  static bool get isAuthenticated => _currentUserId != null && _currentToken != null;

  /// Checks if the current session is still valid.
  static bool get hasValidSession {
    if (_currentToken == null) return false;
    final payload = JWTTokenManager.validateToken(_currentToken!);
    return payload != null;
  }

  /// Gets the remaining time for the current session.
  static Duration? getRemainingSessionTime() {
    if (_currentToken == null) return null;
    final payload = JWTTokenManager.validateToken(_currentToken!);
    if (payload == null) return null;

    final exp = payload['exp'] as int?;
    if (exp == null) return null;

    final expiresAt = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
    final remaining = expiresAt.difference(DateTime.now());
    return remaining.isNegative ? Duration.zero : remaining;
  }

  static Future<void> _handleSuccessfulLogin(
    String userId,
    bool rememberMe,
  ) async {
    try {
      // Determine user role from ID
      final userRole = _determineUserRole(userId);

      // Generate JWT token
      final token = JWTTokenManager.generateToken(
        userId: userId,
        userRole: userRole,
        additionalClaims: {
          'login_time': DateTime.now().toIso8601String(),
        },
      );

      // Cache in memory
      _currentUserId = userId;
      _currentToken = token;
      _currentUserRole = userRole;

      // Persist to storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_currentUserKey, userId);
      await prefs.setString(_currentTokenKey, token);
      await prefs.setString(_userRoleKey, userRole);
      // Start inactivity tracking after successful login.
      SessionManager.instance.start();
    } catch (e) {
      debugPrint('Error handling successful login: $e');
      await logout();
    }
  }

  static String _determineUserRole(String userId) {
    final prefix = userId.replaceAll(RegExp(r'\d+$'), '').toUpperCase();
    if (prefix == 'S') {
      return 'student';
    } else if (prefix == 'FAC') {
      return 'faculty';
    } else if (prefix == 'ADM') {
      return 'admin';
    }
    return 'guest';
  }

  static String? _readStringPreference(SharedPreferences prefs, String key) {
    try {
      final value = prefs.get(key);
      if (value == null) return null;
      if (value is String) return value;
      return value.toString();
    } catch (_) {
      return prefs.getString(key);
    }
  }
}
