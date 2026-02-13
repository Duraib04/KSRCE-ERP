import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/config/security_flags.dart';

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
  static const String _failedAttemptsKey = 'auth_failed_attempts';
  static const String _lockoutUntilKey = 'auth_lockout_until_ms';
  static const int _maxAttempts = 3;
  static const int _lockoutSeconds = 30;

  /// Simulates a login API call.
  Future<LoginResult> login(String userId, String password, bool rememberMe) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    final prefs = await SharedPreferences.getInstance();
    final nowMs = DateTime.now().millisecondsSinceEpoch;
    final lockoutUntilMs = prefs.getInt(_lockoutUntilKey);
    if (lockoutUntilMs != null && lockoutUntilMs > nowMs) {
      final remainingSeconds = ((lockoutUntilMs - nowMs) / 1000).ceil();
      return LoginResult(
        success: false,
        message: 'Too many attempts. Try again later.',
        lockDuration: remainingSeconds,
        remainingAttempts: 0,
      );
    }

    if (lockoutUntilMs != null && lockoutUntilMs <= nowMs) {
      await _clearLockState(prefs);
    }

    final normalizedUserId = userId.trim();
    final allowDemo = kEnableDemoAuth || kDebugMode;

    // In a real app, you would make an HTTP request here.
    // This is placeholder logic to mimic the React component''s behavior.
    if (allowDemo && normalizedUserId.startsWith(''S'') && password == "demo123") {
      await _handleSuccessfulLogin(normalizedUserId, rememberMe, prefs);
      return const LoginResult(success: true);
    } else if (allowDemo && normalizedUserId.startsWith(''FAC'') && password == "demo123") {
      await _handleSuccessfulLogin(normalizedUserId, rememberMe, prefs);
      return const LoginResult(success: true);
    } else if (allowDemo && normalizedUserId.startsWith(''ADM'') && password == "admin123") {
      await _handleSuccessfulLogin(normalizedUserId, rememberMe, prefs);
      return const LoginResult(success: true);
    } else {
      return _handleFailedLogin(prefs);
    }
  }

  /// Retrieves the remembered user ID from local storage.
  Future<String?> getRememberedUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_rememberedUserKey);
  }

  Future<void> _handleSuccessfulLogin(
    String userId,
    bool rememberMe,
    SharedPreferences prefs,
  ) async {
    await _clearLockState(prefs);
    if (rememberMe) {
      await prefs.setString(_rememberedUserKey, userId);
    } else {
      await prefs.remove(_rememberedUserKey);
    }
  }

  Future<LoginResult> _handleFailedLogin(SharedPreferences prefs) async {
    final attempts = (prefs.getInt(_failedAttemptsKey) ?? 0) + 1;
    final remainingAttempts = _maxAttempts - attempts;

    if (remainingAttempts <= 0) {
      final lockoutUntilMs = DateTime.now().millisecondsSinceEpoch + (_lockoutSeconds * 1000);
      await prefs.setInt(_lockoutUntilKey, lockoutUntilMs);
      await prefs.remove(_failedAttemptsKey);
      return const LoginResult(
        success: false,
        message: ''Too many attempts. Try again later.'',
        lockDuration: _lockoutSeconds,
        remainingAttempts: 0,
      );
    }

    await prefs.setInt(_failedAttemptsKey, attempts);
    return LoginResult(
      success: false,
      message: ''Invalid credentials provided.'',
      remainingAttempts: remainingAttempts,
    );
  }

  Future<void> _clearLockState(SharedPreferences prefs) async {
    await prefs.remove(_failedAttemptsKey);
    await prefs.remove(_lockoutUntilKey);
  }
}
