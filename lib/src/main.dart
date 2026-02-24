import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'core/data_service.dart';
import 'features/auth/presentation/pages/home_page.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/shared/widgets/dashboard_shell.dart';

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

import 'features/admin/presentation/pages/admin_dashboard_page.dart';
import 'features/admin/presentation/pages/admin_user_management_page.dart';
import 'features/admin/presentation/pages/admin_reports_page.dart';
import 'features/admin/presentation/pages/admin_notifications_page.dart';
import 'features/admin/presentation/pages/admin_settings_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dataService = DataService();
  await dataService.loadAllData();
  runApp(KsrceErpApp(dataService: dataService));
}

class KsrceErpApp extends StatelessWidget {
  final DataService dataService;
  const KsrceErpApp({super.key, required this.dataService});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: dataService,
      child: MaterialApp.router(
        title: 'KSRCE ERP',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark,
        routerConfig: _router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

Widget _s(String route, Widget child) =>
    DashboardShell(role: 'student', currentRoute: route, child: child);
Widget _f(String route, Widget child) =>
    DashboardShell(role: 'faculty', currentRoute: route, child: child);
Widget _a(String route, Widget child) =>
    DashboardShell(role: 'admin', currentRoute: route, child: child);

final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (c, s) => const HomePage()),
    GoRoute(path: '/login', builder: (c, s) => const LoginPage()),
    // Student routes
    GoRoute(path: '/student/dashboard', builder: (c, s) => _s('/student/dashboard', const StudentDashboardPage())),
    GoRoute(path: '/student/profile', builder: (c, s) => _s('/student/profile', const StudentProfilePage())),
    GoRoute(path: '/student/courses', builder: (c, s) => _s('/student/courses', const StudentCoursesPage())),
    GoRoute(path: '/student/timetable', builder: (c, s) => _s('/student/timetable', const StudentTimetablePage())),
    GoRoute(path: '/student/syllabus', builder: (c, s) => _s('/student/syllabus', const StudentSyllabusPage())),
    GoRoute(path: '/student/attendance', builder: (c, s) => _s('/student/attendance', const StudentAttendancePage())),
    GoRoute(path: '/student/results', builder: (c, s) => _s('/student/results', const StudentResultsPage())),
    GoRoute(path: '/student/assignments', builder: (c, s) => _s('/student/assignments', const StudentAssignmentsPage())),
    GoRoute(path: '/student/exams', builder: (c, s) => _s('/student/exams', const StudentExamsPage())),
    GoRoute(path: '/student/fees', builder: (c, s) => _s('/student/fees', const StudentFeesPage())),
    GoRoute(path: '/student/library', builder: (c, s) => _s('/student/library', const StudentLibraryPage())),
    GoRoute(path: '/student/notifications', builder: (c, s) => _s('/student/notifications', const StudentNotificationsPage())),
    GoRoute(path: '/student/complaints', builder: (c, s) => _s('/student/complaints', const StudentComplaintsPage())),
    GoRoute(path: '/student/leave', builder: (c, s) => _s('/student/leave', const StudentLeavePage())),
    GoRoute(path: '/student/certificates', builder: (c, s) => _s('/student/certificates', const StudentCertificatesPage())),
    GoRoute(path: '/student/placements', builder: (c, s) => _s('/student/placements', const StudentPlacementsPage())),
    GoRoute(path: '/student/events', builder: (c, s) => _s('/student/events', const StudentEventsPage())),
    GoRoute(path: '/student/settings', builder: (c, s) => _s('/student/settings', const StudentSettingsPage())),
    // Faculty routes
    GoRoute(path: '/faculty/dashboard', builder: (c, s) => _f('/faculty/dashboard', const FacultyDashboardPage())),
    GoRoute(path: '/faculty/profile', builder: (c, s) => _f('/faculty/profile', const FacultyProfilePage())),
    GoRoute(path: '/faculty/courses', builder: (c, s) => _f('/faculty/courses', const FacultyCoursesPage())),
    GoRoute(path: '/faculty/timetable', builder: (c, s) => _f('/faculty/timetable', const FacultyTimetablePage())),
    GoRoute(path: '/faculty/syllabus', builder: (c, s) => _f('/faculty/syllabus', const FacultySyllabusPage())),
    GoRoute(path: '/faculty/attendance', builder: (c, s) => _f('/faculty/attendance', const FacultyAttendancePage())),
    GoRoute(path: '/faculty/assignments', builder: (c, s) => _f('/faculty/assignments', const FacultyAssignmentsPage())),
    GoRoute(path: '/faculty/grades', builder: (c, s) => _f('/faculty/grades', const FacultyGradesPage())),
    GoRoute(path: '/faculty/students', builder: (c, s) => _f('/faculty/students', const FacultyStudentsPage())),
    GoRoute(path: '/faculty/exams', builder: (c, s) => _f('/faculty/exams', const FacultyExamsPage())),
    GoRoute(path: '/faculty/leave', builder: (c, s) => _f('/faculty/leave', const FacultyLeavePage())),
    GoRoute(path: '/faculty/research', builder: (c, s) => _f('/faculty/research', const FacultyResearchPage())),
    GoRoute(path: '/faculty/notifications', builder: (c, s) => _f('/faculty/notifications', const FacultyNotificationsPage())),
    GoRoute(path: '/faculty/complaints', builder: (c, s) => _f('/faculty/complaints', const FacultyComplaintsPage())),
    GoRoute(path: '/faculty/reports', builder: (c, s) => _f('/faculty/reports', const FacultyReportsPage())),
    GoRoute(path: '/faculty/events', builder: (c, s) => _f('/faculty/events', const FacultyEventsPage())),
    GoRoute(path: '/faculty/settings', builder: (c, s) => _f('/faculty/settings', const FacultySettingsPage())),
    // Admin routes
    GoRoute(path: '/admin/dashboard', builder: (c, s) => _a('/admin/dashboard', const AdminDashboardPage())),
    GoRoute(path: '/admin/users', builder: (c, s) => _a('/admin/users', const AdminUserManagementPage())),
    GoRoute(path: '/admin/reports', builder: (c, s) => _a('/admin/reports', const AdminReportsPage())),
    GoRoute(path: '/admin/notifications', builder: (c, s) => _a('/admin/notifications', const AdminNotificationsPage())),
    GoRoute(path: '/admin/settings', builder: (c, s) => _a('/admin/settings', const AdminSettingsPage())),
  ],
);
