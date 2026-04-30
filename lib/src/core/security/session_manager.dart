import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../config/session_config.dart';
import 'auth_service_enhanced.dart';

// Web-only imports guarded by kIsWeb checks where needed
// ignore: uri_does_not_exist
import 'dart:html' as html;

/// Manages client-side session inactivity, pre-logout warning, cross-tab sync
/// and last-path persistence for post-login redirect.
class SessionManager {
  static final SessionManager instance = SessionManager._();

  SessionManager._();

  GlobalKey<NavigatorState>? _navigatorKey;

  Timer? _timeoutTimer;
  Timer? _warningTimer;
  int _timeoutMinutes = SessionConfig.inactivityTimeoutMinutes;
  int _warningSeconds = SessionConfig.warningDurationSeconds;

  bool _running = false;
  bool _initialized = false;

  // BroadcastChannel for cross-tab sync (web only)
  html.BroadcastChannel? _channel;

  void initialize({required GlobalKey<NavigatorState> navigatorKey}) {
    if (_initialized) return;
    _initialized = true;
    _navigatorKey = navigatorKey;
    if (kIsWeb) {
      try {
        _channel = html.BroadcastChannel(SessionConfig.broadcastChannel);
        _channel?.onMessage.listen((ev) {
          final data = ev.data;
          if (data == 'logout') {
            handleRemoteLogout();
          } else if (data == 'keepalive') {
            resetTimer();
          }
        });
      } catch (e) {
        // ignore: avoid_print
        print('BroadcastChannel not available: $e');
      }
    }
  }

  /// Start session tracking for current authenticated user
  void start() {
    stop();
    _running = true;
    _scheduleTimers();
  }

  void stop() {
    _running = false;
    _timeoutTimer?.cancel();
    _warningTimer?.cancel();
  }

  void resetTimer() {
    if (!_running) return;
    _timeoutTimer?.cancel();
    _warningTimer?.cancel();
    _scheduleTimers();
    _broadcast('keepalive');
  }

  void _scheduleTimers() {
    final total = Duration(minutes: _timeoutMinutes);
    final warningBefore = Duration(seconds: _warningSeconds);

    if (total <= warningBefore) {
      // If misconfigured, fallback to single timer
      _timeoutTimer = Timer(total, _performLogout);
      return;
    }

    _warningTimer = Timer(total - warningBefore, _showWarningDialog);
    _timeoutTimer = Timer(total, _performLogout);
  }

  void _showWarningDialog() {
    final ctx = _navigatorKey?.currentState?.overlay?.context;
    if (ctx == null) return;

    final remaining = _warningSeconds;
    showDialog(
      context: ctx,
      barrierDismissible: false,
      builder: (context) {
        return SessionTimeoutDialog(
          seconds: remaining,
          onStayLoggedIn: () {
            Navigator.of(context).pop();
            resetTimer();
          },
          onLogoutNow: () {
            Navigator.of(context).pop();
            _performLogout();
          },
        );
      },
    );
  }

  void _performLogout() async {
    stop();
    _broadcast('logout');
    await AuthService.logout();
    // After logout, navigate to login page
    try {
      final context = _navigatorKey?.currentContext;
      if (context != null) {
        GoRouter.of(context).go('/login');
      }
    } catch (_) {
      // fallback: use GoRouter in app to redirect on next build
    }
  }

  void handleRemoteLogout() async {
    stop();
    await AuthService.logout();
  }

  void _broadcast(String message) {
    if (!kIsWeb) return;
    try {
      _channel?.postMessage(message);
    } catch (_) {}
  }

  /// Persist last path to sessionStorage (web only) for post-login redirect
  void persistLastPath(String path) {
    if (!kIsWeb) return;
    try {
      html.window.sessionStorage[SessionConfig.lastPathKey] = path;
    } catch (_) {}
  }

  /// Read last path from sessionStorage (web only)
  String? readLastPath() {
    if (!kIsWeb) return null;
    try {
      return html.window.sessionStorage[SessionConfig.lastPathKey];
    } catch (_) {
      return null;
    }
  }

  /// Clear last path (web only)
  void clearLastPath() {
    if (!kIsWeb) return;
    try {
      html.window.sessionStorage.remove(SessionConfig.lastPathKey);
    } catch (_) {}
  }
}

/// Small dialog widget used by the SessionManager to warn the user.
class SessionTimeoutDialog extends StatefulWidget {
  final int seconds;
  final VoidCallback onStayLoggedIn;
  final VoidCallback onLogoutNow;

  const SessionTimeoutDialog({super.key, required this.seconds, required this.onStayLoggedIn, required this.onLogoutNow});

  @override
  State<SessionTimeoutDialog> createState() => _SessionTimeoutDialogState();
}

class _SessionTimeoutDialogState extends State<SessionTimeoutDialog> {
  late int _remaining;
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _remaining = widget.seconds;
    _ticker = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() {
        _remaining -= 1;
      });
      if (_remaining <= 0) {
        _ticker?.cancel();
        widget.onLogoutNow();
      }
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Session Expiring'),
      content: Text('You will be logged out in $_remaining seconds due to inactivity.'),
      actions: [
        TextButton(onPressed: widget.onLogoutNow, child: const Text('Log out now')),
        ElevatedButton(onPressed: widget.onStayLoggedIn, child: const Text('Stay signed in')),
      ],
    );
  }
}
