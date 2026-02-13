import 'environment_config.dart';

/// API Configuration and Constants
class ApiConfig {
  /// Base URL for the API backend
  /// Update this to point to your backend server
  /// Example: http://localhost:3000 or https://api.example.com
  static const String baseUrl = EnvironmentConfig.apiBaseUrl;

  /// Default connection timeout in milliseconds
  static const Duration connectionTimeout =
      Duration(milliseconds: EnvironmentConfig.apiTimeoutMs);

  /// Default receive timeout in milliseconds
  static const Duration receiveTimeout =
      Duration(milliseconds: EnvironmentConfig.apiTimeoutMs);

  /// Current API version
  static const String apiVersion = 'v1';

  /// Database Configuration (for reference)
  /// MySQL Database:
  /// - Host: localhost
  /// - Port: 3306
  /// - User: root
  /// - Password: 2021
  /// - Database: ksrce_erp
}

/// API Endpoints
class ApiEndpoints {
  // Auth endpoints
  static const String login = '/api/${ApiConfig.apiVersion}/auth/login';
  static const String logout = '/api/${ApiConfig.apiVersion}/auth/logout';
  static const String register = '/api/${ApiConfig.apiVersion}/auth/register';
  static const String refreshToken = '/api/${ApiConfig.apiVersion}/auth/refresh';
  static const String verifyToken = '/api/${ApiConfig.apiVersion}/auth/verify';

  // Student endpoints
  static const String students = '/api/${ApiConfig.apiVersion}/students';
  static String studentById(String id) => '/api/${ApiConfig.apiVersion}/students/$id';
  static const String studentSearch = '/api/${ApiConfig.apiVersion}/students/search';
  static const String studentDashboard = '/api/${ApiConfig.apiVersion}/students/dashboard';
  static const String studentAttendance = '/api/${ApiConfig.apiVersion}/students/attendance';
  static const String studentGrades = '/api/${ApiConfig.apiVersion}/students/grades';
  static const String studentCourses = '/api/${ApiConfig.apiVersion}/students/courses';

  // Faculty endpoints
  static const String faculty = '/api/${ApiConfig.apiVersion}/faculty';
  static String facultyById(String id) => '/api/${ApiConfig.apiVersion}/faculty/$id';
  static const String facultySearch = '/api/${ApiConfig.apiVersion}/faculty/search';
  static const String facultyDashboard = '/api/${ApiConfig.apiVersion}/faculty/dashboard';
  static const String facultySchedule = '/api/${ApiConfig.apiVersion}/faculty/schedule';
  static const String facultyMetrics = '/api/${ApiConfig.apiVersion}/faculty/metrics';

  // Admin endpoints
  static const String adminDashboard = '/api/${ApiConfig.apiVersion}/admin/dashboard';
  static const String users = '/api/${ApiConfig.apiVersion}/admin/users';
  static const String systemSettings = '/api/${ApiConfig.apiVersion}/admin/settings';

  // Course endpoints
  static const String courses = '/api/${ApiConfig.apiVersion}/courses';
  static String courseById(String id) => '/api/${ApiConfig.apiVersion}/courses/$id';

  // Announcement endpoints
  static const String announcements = '/api/${ApiConfig.apiVersion}/announcements';
}

/// HTTP Response Headers
class ApiHeaders {
  static const String contentType = 'application/json';
  static const String authorization = 'Authorization';
  static const String bearerPrefix = 'Bearer';
}

/// HTTP Status Codes
class ApiStatusCode {
  static const int success = 200;
  static const int created = 201;
  static const int badRequest = 400;
  static const int unauthorized = 401;
  static const int forbidden = 403;
  static const int notFound = 404;
  static const int conflict = 409;
  static const int serverError = 500;
  static const int serviceUnavailable = 503;
}
