// Home Routes
class HomeRoutes {
  static const String home = '/';
}

// Student Routes
class StudentRoutes {
  static const String dashboard = '/student-dashboard';
  static const String profile = '$dashboard/profile';
  static const String courses = '$dashboard/courses';
  static const String assignments = '$dashboard/assignments';
  static const String results = '$dashboard/results';
  static const String attendance = '$dashboard/attendance';
  static const String examSchedule = '$dashboard/exam-schedule';
  static const String feeManagement = '$dashboard/fee-management';
  static const String complaints = '$dashboard/complaints';
  static const String notifications = '$dashboard/notifications';
  static const String timeTable = '$dashboard/time-table';
}

// Faculty Routes
class FacultyRoutes {
  static const String dashboard = '/faculty-dashboard';
  static const String myClasses = '$dashboard/my-classes';
  static const String classDetail = '$dashboard/class';
  static const String attendance = '$dashboard/attendance-management';
  static const String grades = '$dashboard/grades-management';
  static const String schedule = '$dashboard/schedule';
  static const String notices = '$dashboard/notices';
  static const String profile = '$dashboard/profile';
  static const String features = '$dashboard/features';
  static const String featureDetail = '$features';
}

// Admin Routes
class AdminRoutes {
  static const String dashboard = '/admin-dashboard';
  static const String studentsList = '$dashboard/students';
  static const String facultyManagement = '$dashboard/faculty';
  static const String courseManagement = '$dashboard/courses';
  static const String systemSettings = '$dashboard/settings';
}

// Auth Routes
class AuthRoutes {
  static const String login = '/login';
  static const String facultyLogin = '/faculty-login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
}
