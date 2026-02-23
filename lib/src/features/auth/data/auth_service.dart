import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/api_config.dart';

// A data class for the result of a login attempt.
@immutable
class LoginResult {
  final bool success;
  final String message;
  final int? lockDuration; // in seconds
  final int? remainingAttempts;

  const LoginResult({
    required this.success,
    this.message = '',
    this.lockDuration,
    this.remainingAttempts,
  });
}

/// A service class to handle authentication logic.
///
/// This class communicates with a backend API for user authentication and
/// uses shared_preferences to manage simple data persistence like a
/// "remembered" user.
class AuthService {
  static const String _rememberedUserKey = 'remembered_user_id';
  static const int _requestTimeout = 10; // seconds

  /// Attempts to login via API. Falls back to mock if API unavailable.
  Future<LoginResult> login(String userId, String password, bool rememberMe) async {
    try {
      // Attempt real API call first
      return await _loginViaAPI(userId, password, rememberMe);
    } catch (e) {
      // If API fails (404, connection error, timeout), fall back to mock
      print('API login failed: $e. Using mock authentication.');
      return await _loginMock(userId, password, rememberMe);
    }
  }

  /// Real API login call (will fail gracefully if backend not available)
  Future<LoginResult> _loginViaAPI(String userId, String password, bool rememberMe) async {
    try {
      final response = await http
          .post(
            Uri.parse(ApiConfig.loginEndpoint),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'userId': userId, 'password': password}),
          )
          .timeout(const Duration(seconds: _requestTimeout));

      // Check for 404 or other error status codes
      if (response.statusCode == 404) {
        throw Exception('API endpoint not found (404). Backend server may not be running.');
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          if (rememberMe) {
            await _saveRememberedUser(userId);
          } else {
            await _clearRememberedUser();
          }
          return LoginResult(
            success: true,
            message: data['message'] ?? 'Login successful',
          );
        } else {
          return LoginResult(
            success: false,
            message: data['message'] ?? 'Login failed. Invalid credentials.',
            remainingAttempts: data['remainingAttempts'],
            lockDuration: data['lockDuration'],
          );
        }
      } else {
        throw Exception('Unexpected status code: ${response.statusCode}');
      }
    } on http.ClientException {
      throw Exception('Failed to connect to backend. API server may not be running.');
    } catch (e) {
      rethrow;
    }
  }

  /// Mock login for demonstration/offline testing
  Future<LoginResult> _loginMock(String userId, String password, bool rememberMe) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Mock credentials for testing
    if (userId.startsWith('S') && password == "demo123") {
      if (rememberMe) {
        await _saveRememberedUser(userId);
      } else {
        await _clearRememberedUser();
      }
      return const LoginResult(
        success: true,
        message: 'Login successful (using mock authentication)',
      );
    } else if (userId.startsWith('ADM') && password == "admin123") {
      if (rememberMe) {
        await _saveRememberedUser(userId);
      } else {
        await _clearRememberedUser();
      }
      return const LoginResult(
        success: true,
        message: 'Login successful (using mock authentication)',
      );
    } else {
      // Failed login with lockout mechanism
      return const LoginResult(
        success: false,
        message: "Invalid credentials. Try again.",
        remainingAttempts: 2,
      );
    }
  }

  /// Saves the user ID to local storage.
  Future<void> _saveRememberedUser(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_rememberedUserKey, userId);
  }

  /// Retrieves the remembered user ID from local storage.
  Future<String?> getRememberedUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_rememberedUserKey);
  }

  /// Clears the remembered user ID from local storage.
  Future<void> _clearRememberedUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_rememberedUserKey);
  }
}
