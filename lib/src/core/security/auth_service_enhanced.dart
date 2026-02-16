import 'package:flutter/foundation.dart';
import 'jwt_token_manager.dart';
import 'route_guard.dart';
import '../services/browser_storage_service.dart';

enum UserRoleAuth {
  student,
  faculty,
  admin,
  guest,
}

/// Enhanced Authentication Service with JWT token support
class AuthService {
  static final AuthService _instance = AuthService._internal();

  factory AuthService() {
    return _instance;
  }

  AuthService._internal();

  // Authentication state
  static UserRoleAuth _currentRole = UserRoleAuth.guest;
  static String _currentUserId = '';
  static bool _isAuthenticated = false;
  static String _authToken = ''; // JWT token
  static String _tokenHash = ''; // Hashed token for verification
  static DateTime? _tokenExpiresAt;
  
  static final BrowserStorage _storage = BrowserStorage();

  // Storage keys
  static const String _authKeyRole = 'auth_role';
  static const String _authKeyUserId = 'auth_user_id';
  static const String _authKeyStatus = 'auth_status';
  static const String _authKeyToken = 'auth_token';
  static const String _authKeyTokenHash = 'auth_token_hash';
  static const String _authKeyTokenExpiry = 'auth_token_expiry';

  // Getters
  static UserRoleAuth get currentRole => _currentRole;
  static String get currentUserId => _currentUserId;
  static bool get isAuthenticated => _isAuthenticated && !isTokenExpired;
  static String get authToken => _authToken;
  static String get tokenHash => _tokenHash;
  static bool get isTokenExpired {
    if (_tokenExpiresAt == null) return true;
    return DateTime.now().isAfter(_tokenExpiresAt!);
  }

  /// Initialize authentication system on app startup
  static Future<void> initialize() async {
    await restoreAuthState();
    
    // Check for token refresh if needed
    if (_isAuthenticated && !isTokenExpired) {
      _refreshTokenIfNeeded();
    }
  }

  /// Restore authentication state from secure storage on app startup
  static Future<void> restoreAuthState() async {
    try {
      final authStatus = await _storage.getBool(_authKeyStatus);
      if (authStatus != true) {
        _isAuthenticated = false;
        return;
      }

      // Restore basic auth info
      final roleString = await _storage.getString(_authKeyRole);
      final userId = await _storage.getString(_authKeyUserId);
      final token = await _storage.getString(_authKeyToken);
      final tokenHash = await _storage.getString(_authKeyTokenHash);
      final expiryStr = await _storage.getString(_authKeyTokenExpiry);

      if (roleString != null && userId != null && token != null) {
        // Validate token before restoring
        if (!JWTTokenManager.validateToken(token)) {
          debugPrint('❌ Stored token is invalid or expired');
          await logout();
          return;
        }

        // Restore role
        _currentRole = UserRoleAuth.values.firstWhere(
          (role) => role.toString().split('.').last == roleString,
          orElse: () => UserRoleAuth.guest,
        );
        _currentUserId = userId;
        _authToken = token;
        _tokenHash = tokenHash ?? '';

        if (expiryStr != null) {
          _tokenExpiresAt = DateTime.parse(expiryStr);
        }

        _isAuthenticated = true;
        debugPrint('✅ Auth state restored: role=$_currentRole, userId=$_currentUserId');
      }
    } catch (e) {
      debugPrint('❌ Error restoring auth state: $e');
      _isAuthenticated = false;
      await logout();
    }
  }

  /// Login with credentials - generates JWT token
  static Future<bool> login({
    required String userId,
    required String password,
    required UserRoleAuth role,
  }) async {
    try {
      // Simulate API call (in real app, verify credentials with backend)
      await Future.delayed(const Duration(milliseconds: 800));

      // Validate credentials (mock)
      if (!_validateCredentials(userId, password, role)) {
        debugPrint('❌ Invalid credentials');
        return false;
      }

      // Generate JWT token
      final token = JWTTokenManager.generateToken(
        userId: userId,
        userRole: role.toString().split('.').last,
        additionalClaims: {
          'login_time': DateTime.now().toIso8601String(),
          'ip_address': '0.0.0.0', // In real app, capture actual IP
        },
      );

      // Set authentication state
      _currentRole = role;
      _currentUserId = userId;
      _authToken = token.token;
      _tokenHash = JWTTokenManager.hashString(token.token);
      _tokenExpiresAt = token.expiresAt;
      _isAuthenticated = true;

      // Store in secure storage for persistence
      await _storeAuthData(role, userId, token);

      debugPrint('✅ Login successful: userId=$userId, role=$role');
      return true;
    } catch (e) {
      debugPrint('❌ Login error: $e');
      return false;
    }
  }

  /// Logout - clears authentication data
  static Future<void> logout() async {
    try {
      _isAuthenticated = false;
      _currentRole = UserRoleAuth.guest;
      _currentUserId = '';
      _authToken = '';
      _tokenHash = '';
      _tokenExpiresAt = null;

      // Clear from secure storage
      await _clearAuthData();
      debugPrint('✅ Logout successful');
    } catch (e) {
      debugPrint('❌ Logout error: $e');
    }
  }

  /// Verify current authentication token
  static bool verifyToken() {
    if (_authToken.isEmpty) return false;
    return JWTTokenManager.validateToken(_authToken);
  }

  /// Get authorization headers for API requests
  static Map<String, String> getAuthHeaders() {
    return RouteGuard.generateAuthHeaders(_authToken);
  }

  /// Check if user has specific role
  static bool hasRole(UserRoleAuth role) {
    return _isAuthenticated && _currentRole == role;
  }

  /// Check if user can access a route
  static bool canAccessRoute(String route) {
    return RouteGuard.canAccessRoute(route, authToken: _authToken);
  }

  /// Refresh token if it's expiring soon
  static Future<void> _refreshTokenIfNeeded() async {
    if (_authToken.isEmpty) return;

    final newToken = JWTTokenManager.refreshTokenIfNeeded(_authToken);
    if (newToken != null) {
      _authToken = newToken.token;
      _tokenHash = JWTTokenManager.hashString(newToken.token);
      _tokenExpiresAt = newToken.expiresAt;

      // Update storage
      await _storage.setString(_authKeyToken, _authToken);
      await _storage.setString(_authKeyTokenHash, _tokenHash);
      await _storage.setString(_authKeyTokenExpiry, _tokenExpiresAt.toString());
      
      debugPrint('✅ Token refreshed');
    }
  }

  /// Mock credential validation
  static bool _validateCredentials(String userId, String password, UserRoleAuth role) {
    // Mock validation - student
    if (userId.startsWith('S') && password == 'demo123') return true;
    // Mock validation - faculty
    if (userId.startsWith('FAC') && password == 'demo123') return true;
    // Mock validation - admin
    if (userId.startsWith('ADM') && password == 'admin123') return true;
    return false;
  }

  /// Store authentication data in secure storage
  static Future<void> _storeAuthData(UserRoleAuth role, String userId, JWTToken token) async {
    try {
      await _storage.setBool(_authKeyStatus, true);
      await _storage.setString(_authKeyRole, role.toString().split('.').last);
      await _storage.setString(_authKeyUserId, userId);
      await _storage.setString(_authKeyToken, token.token);
      await _storage.setString(_authKeyTokenHash, JWTTokenManager.hashString(token.token));
      await _storage.setString(_authKeyTokenExpiry, token.expiresAt.toIso8601String());
      debugPrint('✅ Auth data stored securely');
    } catch (e) {
      debugPrint('❌ Error storing auth data: $e');
    }
  }

  /// Clear authentication data from storage
  static Future<void> _clearAuthData() async {
    try {
      await _storage.remove(_authKeyStatus);
      await _storage.remove(_authKeyRole);
      await _storage.remove(_authKeyUserId);
      await _storage.remove(_authKeyToken);
      await _storage.remove(_authKeyTokenHash);
      await _storage.remove(_authKeyTokenExpiry);
      debugPrint('✅ Auth data cleared');
    } catch (e) {
      debugPrint('❌ Error clearing auth data: $e');
    }
  }
}
