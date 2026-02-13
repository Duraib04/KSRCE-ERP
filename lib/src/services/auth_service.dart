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

  // Getters
  static UserRole get currentRole => _currentRole;
  static String get currentUserId => _currentUserId;
  static bool get isAuthenticated => _isAuthenticated;

  // Login method
  static Future<bool> login(String email, String password, UserRole role) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));

    _isAuthenticated = true;
    _currentRole = role;
    _currentUserId = _generateUserId(role);
    return true;
  }

  // Logout method
  static void logout() {
    _isAuthenticated = false;
    _currentRole = UserRole.guest;
    _currentUserId = '';
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
}
