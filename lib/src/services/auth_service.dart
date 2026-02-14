import 'package:flutter/foundation.dart';
import '../core/services/browser_storage_service.dart';

enum UserRole {
  student,
  faculty,
  admin,
  guest,
}

class AuthService {
  static final AuthService _instance = AuthService._internal();

  factory AuthService() {
    return _instance;
  }

  AuthService._internal();

  // Mock authentication state
  static UserRole _currentRole = UserRole.guest;
  static String _currentUserId = '';
  static bool _isAuthenticated = false;
  static final BrowserStorage _storage = BrowserStorage();

  // Storage keys
  static const String _authKeyRole = 'auth_role';
  static const String _authKeyUserId = 'auth_user_id';
  static const String _authKeyStatus = 'auth_status';

  // Getters
  static UserRole get currentRole => _currentRole;
  static String get currentUserId => _currentUserId;
  static bool get isAuthenticated => _isAuthenticated;

  /// Restore authentication state from browser storage on app startup
  static Future<void> restoreAuthState() async {
    try {
      // Get auth status from storage
      final authStatus = await _storage.getBool(_authKeyStatus);
      if (authStatus == true) {
        // Get user role
        final roleString = await _storage.getString(_authKeyRole);
        final userId = await _storage.getString(_authKeyUserId);

        if (roleString != null && userId != null) {
          // Parse and restore role
          _currentRole = UserRole.values.firstWhere(
            (role) => role.toString() == roleString,
            orElse: () => UserRole.guest,
          );
          _currentUserId = userId;
          _isAuthenticated = true;
          debugPrint('✅ Auth state restored: $_currentRole, $_currentUserId');
        }
      }
    } catch (e) {
      debugPrint('Error restoring auth state: $e');
      _isAuthenticated = false;
    }
  }

  // Login method - stores data in browser storage
  static Future<bool> login(String email, String password, UserRole role) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));

    _isAuthenticated = true;
    _currentRole = role;
    _currentUserId = _generateUserId(role);

    // Store in browser storage for persistence across app refreshes
    await _storeAuthDataInBrowser(role, _currentUserId);

    return true;
  }

  // Logout method - clears browser storage
  static Future<void> logout() async {
    _isAuthenticated = false;
    _currentRole = UserRole.guest;
    _currentUserId = '';

    // Clear auth data from browser storage
    await _clearAuthDataFromBrowser();
  }

  static String _generateUserId(UserRole role) {
    switch (role) {
      case UserRole.student:
        return 'S20210001';
      case UserRole.faculty:
        return 'F001';
      case UserRole.admin:
        return 'A001';
      case UserRole.guest:
        return '';
    }
  }

  /// Store authentication data in browser storage for persistence
  static Future<void> _storeAuthDataInBrowser(UserRole role, String userId) async {
    try {
      await _storage.setBool(_authKeyStatus, true);
      await _storage.setString(_authKeyRole, role.toString());
      await _storage.setString(_authKeyUserId, userId);
      debugPrint('✅ Auth data stored in browser storage');
    } catch (e) {
      debugPrint('Error storing auth data in browser: $e');
    }
  }

  /// Clear authentication data from browser storage on logout
  static Future<void> _clearAuthDataFromBrowser() async {
    try {
      await _storage.remove(_authKeyStatus);
      await _storage.remove(_authKeyRole);
      await _storage.remove(_authKeyUserId);
      debugPrint('✅ Auth data cleared from browser storage');
    } catch (e) {
      debugPrint('Error clearing auth data from browser: $e');
    }
  }

  // Utility methods to set user ID and role manually (for demo purposes)
  static void setUserId(String userId) {
    _currentUserId = userId;
  }

  static void setUserRole(String role) {
    switch (role.toLowerCase()) {
      case 'student':
        _currentRole = UserRole.student;
        break;
      case 'faculty':
        _currentRole = UserRole.faculty;
        break;
      case 'admin':
        _currentRole = UserRole.admin;
        break;
      default:
        _currentRole = UserRole.guest;
    }
  }
}

