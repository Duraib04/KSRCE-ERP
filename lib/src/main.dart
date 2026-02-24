import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/presentation/pages/home_page.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/shared/widgets/dashboard_shell.dart';

// Student pages
import 'features/student/presentation/pages/student_dashboard_page.dart';
import 'features/student/presentation/pages/student_profile_page.dart';
import 'features/student/presentation/pages/student_courses_page.dart';
import 'features/student/presentation/pages/student_timetable_page.dart';
import 'features/student/presentation/pages/student_syllabus_page.dart';
import 'features/student/presentation/pages/student_attendance_page.dart';
import 'features/student/presentation/pages/student_results_page.dart';
import 'features/student/presentation/pages/student_assignments_page.dart';
import 'features/student/presentation/pages/student_exams_page.dart';
import 'features/student/presentation/pages/student_fees_page.dart';
import 'features/student/presentation/pages/student_library_page.dart';
import 'features/student/presentation/pages/student_notifications_page.dart';
import 'features/student/presentation/pages/student_complaints_page.dart';
import 'features/student/presentation/pages/student_leave_page.dart';
import 'features/student/presentation/pages/student_certificates_page.dart';
import 'features/student/presentation/pages/student_placements_page.dart';
import 'features/student/presentation/pages/student_events_page.dart';
import 'features/student/presentation/pages/student_settings_page.dart';

// Faculty pages
import 'features/faculty/presentation/pages/faculty_dashboard_page.dart';
import 'features/faculty/presentation/pages/faculty_profile_page.dart';
import 'features/faculty/presentation/pages/faculty_courses_page.dart';
import 'features/faculty/presentation/pages/faculty_timetable_page.dart';
import 'features/faculty/presentation/pages/faculty_syllabus_page.dart';
import 'features/faculty/presentation/pages/faculty_attendance_page.dart';
import 'features/faculty/presentation/pages/faculty_assignments_page.dart';
import 'features/faculty/presentation/pages/faculty_grades_page.dart';
import 'features/faculty/presentation/pages/faculty_students_page.dart';
import 'features/faculty/presentation/pages/faculty_exams_page.dart';
import 'features/faculty/presentation/pages/faculty_leave_page.dart';
import 'features/faculty/presentation/pages/faculty_research_page.dart';
import 'features/faculty/presentation/pages/faculty_notifications_page.dart';
import 'features/faculty/presentation/pages/faculty_complaints_page.dart';
import 'features/faculty/presentation/pages/faculty_reports_page.dart';
import 'features/faculty/presentation/pages/faculty_events_page.dart';
import 'features/faculty/presentation/pages/faculty_settings_page.dart';

void main() {
  runApp(const KsrceErpApp());
}

class KsrceErpApp extends StatelessWidget {
  const KsrceErpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'KSRCE ERP',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}

Widget _studentShell(String route, Widget child) {
  return DashboardShell(role: 'student', currentRoute: route, child: child);
}

Widget _facultyShell(String route, Widget child) {
  return DashboardShell(role: 'faculty', currentRoute: route, child: child);
}

final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (c, s) => const HomePage()),
    GoRoute(path: '/login', builder: (c, s) => const LoginPage()),
    
    // Student routes
    GoRoute(path: '/student/dashboard', builder: (c, s) => _studentShell('/student/dashboard', const StudentDashboardPage())),
    GoRoute(path: '/student/profile', builder: (c, s) => _studentShell('/student/profile', const StudentProfilePage())),
    GoRoute(path: '/student/courses', builder: (c, s) => _studentShell('/student/courses', const StudentCoursesPage())),
    GoRoute(path: '/student/timetable', builder: (c, s) => _studentShell('/student/timetable', const StudentTimetablePage())),
    GoRoute(path: '/student/syllabus', builder: (c, s) => _studentShell('/student/syllabus', const StudentSyllabusPage())),
    GoRoute(path: '/student/attendance', builder: (c, s) => _studentShell('/student/attendance', const StudentAttendancePage())),
    GoRoute(path: '/student/results', builder: (c, s) => _studentShell('/student/results', const StudentResultsPage())),
    GoRoute(path: '/student/assignments', builder: (c, s) => _studentShell('/student/assignments', const StudentAssignmentsPage())),
    GoRoute(path: '/student/exams', builder: (c, s) => _studentShell('/student/exams', const StudentExamsPage())),
    GoRoute(path: '/student/fees', builder: (c, s) => _studentShell('/student/fees', const StudentFeesPage())),
    GoRoute(path: '/student/library', builder: (c, s) => _studentShell('/student/library', const StudentLibraryPage())),
    GoRoute(path: '/student/notifications', builder: (c, s) => _studentShell('/student/notifications', const StudentNotificationsPage())),
    GoRoute(path: '/student/complaints', builder: (c, s) => _studentShell('/student/complaints', const StudentComplaintsPage())),
    GoRoute(path: '/student/leave', builder: (c, s) => _studentShell('/student/leave', const StudentLeavePage())),
    GoRoute(path: '/student/certificates', builder: (c, s) => _studentShell('/student/certificates', const StudentCertificatesPage())),
    GoRoute(path: '/student/placements', builder: (c, s) => _studentShell('/student/placements', const StudentPlacementsPage())),
    GoRoute(path: '/student/events', builder: (c, s) => _studentShell('/student/events', const StudentEventsPage())),
    GoRoute(path: '/student/settings', builder: (c, s) => _studentShell('/student/settings', const StudentSettingsPage())),

    // Faculty routes
    GoRoute(path: '/faculty/dashboard', builder: (c, s) => _facultyShell('/faculty/dashboard', const FacultyDashboardPage())),
    GoRoute(path: '/faculty/profile', builder: (c, s) => _facultyShell('/faculty/profile', const FacultyProfilePage())),
    GoRoute(path: '/faculty/courses', builder: (c, s) => _facultyShell('/faculty/courses', const FacultyCoursesPage())),
    GoRoute(path: '/faculty/timetable', builder: (c, s) => _facultyShell('/faculty/timetable', const FacultyTimetablePage())),
    GoRoute(path: '/faculty/syllabus', builder: (c, s) => _facultyShell('/faculty/syllabus', const FacultySyllabusPage())),
    GoRoute(path: '/faculty/attendance', builder: (c, s) => _facultyShell('/faculty/attendance', const FacultyAttendancePage())),
    GoRoute(path: '/faculty/assignments', builder: (c, s) => _facultyShell('/faculty/assignments', const FacultyAssignmentsPage())),
    GoRoute(path: '/faculty/grades', builder: (c, s) => _facultyShell('/faculty/grades', const FacultyGradesPage())),
    GoRoute(path: '/faculty/students', builder: (c, s) => _facultyShell('/faculty/students', const FacultyStudentsPage())),
    GoRoute(path: '/faculty/exams', builder: (c, s) => _facultyShell('/faculty/exams', const FacultyExamsPage())),
    GoRoute(path: '/faculty/leave', builder: (c, s) => _facultyShell('/faculty/leave', const FacultyLeavePage())),
    GoRoute(path: '/faculty/research', builder: (c, s) => _facultyShell('/faculty/research', const FacultyResearchPage())),
    GoRoute(path: '/faculty/notifications', builder: (c, s) => _facultyShell('/faculty/notifications', const FacultyNotificationsPage())),
    GoRoute(path: '/faculty/complaints', builder: (c, s) => _facultyShell('/faculty/complaints', const FacultyComplaintsPage())),
    GoRoute(path: '/faculty/reports', builder: (c, s) => _facultyShell('/faculty/reports', const FacultyReportsPage())),
    GoRoute(path: '/faculty/events', builder: (c, s) => _facultyShell('/faculty/events', const FacultyEventsPage())),
    GoRoute(path: '/faculty/settings', builder: (c, s) => _facultyShell('/faculty/settings', const FacultySettingsPage())),
  ],
);
