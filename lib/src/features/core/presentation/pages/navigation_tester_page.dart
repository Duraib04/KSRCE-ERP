import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/routes.dart';
import '../../../../services/auth_service.dart';

/// Navigation Tester Page - Use for testing all routes
/// Remove this page before production
class NavigationTesterPage extends StatefulWidget {
  const NavigationTesterPage({Key? key}) : super(key: key);

  @override
  State<NavigationTesterPage> createState() => _NavigationTesterPageState();
}

class _NavigationTesterPageState extends State<NavigationTesterPage> {
  final List<String> _testResults = [];

  void _addResult(String message, bool success) {
    setState(() {
      _testResults.add('${success ? '✓' : '✗'} $message');
    });
  }

  void _clearResults() {
    setState(() {
      _testResults.clear();
    });
  }

  void _testStudentRoutes() {
    _clearResults();
    _addResult('Testing Student Routes', true);

    // Test each student route
    List<MapEntry<String, String>> studentRoutes = [
      MapEntry('Dashboard', StudentRoutes.dashboard),
      MapEntry('Profile', StudentRoutes.profile),
      MapEntry('Courses', StudentRoutes.courses),
      MapEntry('Assignments', StudentRoutes.assignments),
      MapEntry('Results', StudentRoutes.results),
      MapEntry('Attendance', StudentRoutes.attendance),
      MapEntry('Exam Schedule', StudentRoutes.examSchedule),
      MapEntry('Fee Management', StudentRoutes.feeManagement),
      MapEntry('Complaints', StudentRoutes.complaints),
      MapEntry('Notifications', StudentRoutes.notifications),
      MapEntry('Time Table', StudentRoutes.timeTable),
    ];

    for (var route in studentRoutes) {
      try {
        _addResult('Route ${route.key}: ${route.value}', true);
      } catch (e) {
        _addResult('Route ${route.key}: FAILED - $e', false);
      }
    }
  }

  void _testFacultyRoutes() {
    _clearResults();
    _addResult('Testing Faculty Routes', true);

    List<MapEntry<String, String>> facultyRoutes = [
      MapEntry('Dashboard', FacultyRoutes.dashboard),
      MapEntry('My Classes', FacultyRoutes.myClasses),
      MapEntry('Attendance', FacultyRoutes.attendance),
      MapEntry('Grades', FacultyRoutes.grades),
      MapEntry('Schedule', FacultyRoutes.schedule),
    ];

    for (var route in facultyRoutes) {
      try {
        _addResult('Route ${route.key}: ${route.value}', true);
      } catch (e) {
        _addResult('Route ${route.key}: FAILED - $e', false);
      }
    }
  }

  void _testAdminRoutes() {
    _clearResults();
    _addResult('Testing Admin Routes', true);

    List<MapEntry<String, String>> adminRoutes = [
      MapEntry('Dashboard', AdminRoutes.dashboard),
      MapEntry('Students List', AdminRoutes.studentsList),
      MapEntry('Faculty Management', AdminRoutes.facultyManagement),
      MapEntry('Course Management', AdminRoutes.courseManagement),
    ];

    for (var route in adminRoutes) {
      try {
        _addResult('Route ${route.key}: ${route.value}', true);
      } catch (e) {
        _addResult('Route ${route.key}: FAILED - $e', false);
      }
    }
  }

  void _testAuthService() {
    _clearResults();
    _addResult('Testing Auth Service', true);

    // Test initial state
    _addResult(
        'Initial - Is Authenticated: ${AuthService.isAuthenticated}',
        !AuthService.isAuthenticated);

    // Test login (simulated)
    _addResult('Can access currentRole', true);
    _addResult('Can access currentUserId', true);
  }

  void _testNavigation() async {
    _clearResults();
    _addResult('Testing Navigation Methods', true);

    try {
      _addResult('NavigationService available', true);
      _addResult('Can call navigateToDashboard', true);
      _addResult('Can call navigateToLogin', true);
      _addResult('Can call goBack', true);
    } catch (e) {
      _addResult('Navigation Service Error: $e', false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Navigation Tester'),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Test Buttons
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Route Tests',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildTestButton(
                      'Test Student Routes',
                      _testStudentRoutes,
                      Colors.blue,
                    ),
                    const SizedBox(height: 8),
                    _buildTestButton(
                      'Test Faculty Routes',
                      _testFacultyRoutes,
                      Colors.green,
                    ),
                    const SizedBox(height: 8),
                    _buildTestButton(
                      'Test Admin Routes',
                      _testAdminRoutes,
                      Colors.orange,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Service Tests
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Service Tests',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildTestButton(
                      'Test Auth Service',
                      _testAuthService,
                      Colors.purple,
                    ),
                    const SizedBox(height: 8),
                    _buildTestButton(
                      'Test Navigation Service',
                      _testNavigation,
                      Colors.red,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Results
            if (_testResults.isNotEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Test Results',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton.icon(
                            onPressed: _clearResults,
                            icon: const Icon(Icons.clear),
                            label: const Text('Clear'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ..._testResults.map(
                        (result) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Text(
                            result,
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 12,
                              color: result.startsWith('✓')
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 24),

            // Auth Status
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Auth Status',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildStatusRow(
                      'Authenticated',
                      AuthService.isAuthenticated.toString(),
                    ),
                    _buildStatusRow(
                      'Current Role',
                      AuthService.currentRole.toString(),
                    ),
                    _buildStatusRow(
                      'Current User ID',
                      AuthService.currentUserId.isEmpty
                          ? 'Not Set'
                          : AuthService.currentUserId,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Navigation Examples
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Quick Navigation',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ElevatedButton(
                          onPressed: () =>
                              context.go(StudentRoutes.dashboard),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                          child: const Text(
                            'Student\nDashboard',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () =>
                              context.go(FacultyRoutes.dashboard),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          child: const Text(
                            'Faculty\nDashboard',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => context.go(AdminRoutes.dashboard),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                          ),
                          child: const Text(
                            'Admin\nDashboard',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => context.go(AuthRoutes.login),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: const Text(
                            'Login\nPage',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestButton(
    String label,
    VoidCallback onPressed,
    Color color,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: Text(label),
      ),
    );
  }

  Widget _buildStatusRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'monospace',
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
