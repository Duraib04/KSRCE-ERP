import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  /// Simulates a login API call.
  Future<LoginResult> login(String userId, String password, bool rememberMe) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // In a real app, you would make an HTTP request here.
    // This is placeholder logic to mimic the React component's behavior.
    if (userId.startsWith('S') && password == "demo123") {
      if (rememberMe) {
        await _saveRememberedUser(userId);
      } else {
        await _clearRememberedUser();
      }
      return const LoginResult(success: true);
    } else if (userId.startsWith('ADM') && password == "admin123") {
      if (rememberMe) {
        await _saveRememberedUser(userId);
      } else {
        await _clearRememberedUser();
      }
      return const LoginResult(success: true);
    }
    else {
      // Simulate a failed login with lockout mechanism
      return const LoginResult(
        success: false,
        message: "Invalid credentials provided.",
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
