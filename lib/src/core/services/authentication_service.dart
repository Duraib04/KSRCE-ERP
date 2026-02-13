import 'package:shared_preferences/shared_preferences.dart';

import '../config/api_config.dart';
import 'api_exceptions.dart';
import 'http_client_service.dart';

/// Authentication Service
/// Handles user authentication, token management, and session persistence
class AuthenticationService {
  late HttpClientService _httpClient;
  late SharedPreferences _preferences;

  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';
  static const String _userRoleKey = 'user_role';
  static const String _expiresAtKey = 'token_expires_at';

  AuthenticationService(this._httpClient, this._preferences);

  /// Get stored authentication token
  String? getToken() {
    return _preferences.getString(_tokenKey);
  }

  /// Get stored user ID
  String? getUserId() {
    return _preferences.getString(_userIdKey);
  }

  /// Get stored user role
  String? getUserRole() {
    return _preferences.getString(_userRoleKey);
  }

  /// Check if user is authenticated
  bool get isAuthenticated {
    final token = getToken();
    if (token == null || token.isEmpty) return false;

    final expiresAtStr = _preferences.getString(_expiresAtKey);
    if (expiresAtStr == null) return true; // Assume valid if no expiry info

    try {
      final expiresAt = DateTime.parse(expiresAtStr);
      return DateTime.now().isBefore(expiresAt);
    } catch (e) {
      return true; // Assume valid if parsing fails
    }
  }

  /// Login user with credentials
  Future<void> login(String userId, String password) async {
    try {
      final response = await _httpClient.post(
        ApiEndpoints.login,
        body: {
          'userId': userId,
          'password': password,
        },
        requiresAuth: false,
      );

      if (response['success'] == true && response['data'] != null) {
        await _saveAuthData(response['data']);
      } else {
        throw AuthenticationException(
          message: response['message'] ?? 'Login failed',
        );
      }
    } catch (e) {
      if (e is ApiException) {
        throw AuthenticationException(
          message: e.message,
          statusCode: e.statusCode,
        );
      }
      rethrow;
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      await _httpClient.post(
        ApiEndpoints.logout,
        requiresAuth: true,
      );
    } catch (e) {
      // Continue logout even if API call fails
    } finally {
      await _clearAuthData();
    }
  }

  /// Refresh authentication token
  Future<void> refreshToken() async {
    try {
      final refreshToken = _preferences.getString(_refreshTokenKey);
      if (refreshToken == null || refreshToken.isEmpty) {
        throw AuthenticationException(
          message: 'No refresh token available',
        );
      }

      final response = await _httpClient.post(
        ApiEndpoints.refreshToken,
        body: {'refreshToken': refreshToken},
        requiresAuth: false,
      );

      if (response['success'] == true && response['data'] != null) {
        await _saveAuthData(response['data']);
      } else {
        throw AuthenticationException(
          message: 'Token refresh failed',
        );
      }
    } catch (e) {
      await _clearAuthData();
      if (e is AuthenticationException) {
        rethrow;
      }
      rethrow;
    }
  }

  /// Verify if stored token is still valid
  Future<bool> verifyToken() async {
    try {
      final token = getToken();
      if (token == null || token.isEmpty) return false;

      final response = await _httpClient.post(
        ApiEndpoints.verifyToken,
        body: {'token': token},
        requiresAuth: false,
      );

      return response['success'] == true;
    } catch (e) {
      return false;
    }
  }

  /// Save authentication data to local storage
  Future<void> _saveAuthData(Map<String, dynamic> authData) async {
    try {
      final token = authData['accessToken'] as String?;
      final refreshToken = authData['refreshToken'] as String?;
      final userId = authData['userId'] as String?;
      final userRole = authData['userRole'] as String?;
      final expiresAtStr = authData['expiresAt'] as String?;

      if (token != null) {
        await _preferences.setString(_tokenKey, token);
        _httpClient.setAuthToken(token);
      }

      if (refreshToken != null) {
        await _preferences.setString(_refreshTokenKey, refreshToken);
      }

      if (userId != null) {
        await _preferences.setString(_userIdKey, userId);
      }

      if (userRole != null) {
        await _preferences.setString(_userRoleKey, userRole);
      }

      if (expiresAtStr != null) {
        await _preferences.setString(_expiresAtKey, expiresAtStr);
      }
    } catch (e) {
      throw ApiException(
        message: 'Failed to save authentication data',
        originalException: e is Exception ? e : Exception(e.toString()),
      );
    }
  }

  /// Clear authentication data
  Future<void> _clearAuthData() async {
    try {
      await _preferences.remove(_tokenKey);
      await _preferences.remove(_refreshTokenKey);
      await _preferences.remove(_userIdKey);
      await _preferences.remove(_userRoleKey);
      await _preferences.remove(_expiresAtKey);
      _httpClient.clearAuthToken();
    } catch (e) {
      throw ApiException(
        message: 'Failed to clear authentication data',
        originalException: e is Exception ? e : Exception(e.toString()),
      );
    }
  }
}
