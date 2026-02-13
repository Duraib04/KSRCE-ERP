/// Usage Examples: Browser Storage for Cross-Module Data Sharing
///
/// The SharedDataService provides a singleton instance for storing and retrieving
/// temporary data that persists across page navigations and module changes.
/// 
/// This is particularly useful for:
/// - Storing form data across multiple pages
/// - Sharing filters and search results between modules
/// - Passing user preferences/selected items without deep linking
/// - Maintaining navigation history/breadcrumbs
/// - Temporary user-related metadata

import 'package:flutter/material.dart';
import '../services/shared_data_service.dart';

/// EXAMPLE 1: Store and retrieve user role across modules
class RoleSharingExample {
  static Future<void> storeUserRole(String role) async {
    // In login page or dashboard
    await sharedData.setUserRole(role);
  }

  static Future<String?> getUserRoleInOtherModule() async {
    // In any other page/module
    final role = await sharedData.getUserRole();
    return role; // Can be 'Student', 'Faculty', or 'Admin'
  }
}

/// EXAMPLE 2: Share filters between dashboard pages
class FilterSharingExample {
  static Future<void> storeFilters() async {
    // In student dashboard list page
    final filters = {
      'semester': '5',
      'branch': 'CSE',
      'search_term': 'Data Structures',
      'sort_by': 'date',
    };
    await sharedData.setFilters(filters);
  }

  static Future<void> retrieveFiltersInOtherPage() async {
    // In another page of student dashboard
    final filters = await sharedData.getFilters();
    if (filters != null) {
      final semester = filters['semester'];
      final branch = filters['branch'];
      // Use these values to populate the page
    }
  }
}

/// EXAMPLE 3: Store form data for multi-step forms
class FormDataExample {
  static Future<void> saveFormStep1() async {
    // Page 1 of multi-step complaint form
    final data = {
      'title': 'Improvement needed in labs',
      'category': 'Infrastructure',
      'description': 'Lab equipment is outdated',
    };
    await sharedData.setFormData('complaint_form', data);
  }

  static Future<void> addToFormStep2() async {
    // Page 2 - retrieve previous data and add more
    final previousData = await sharedData.getFormData('complaint_form');
    if (previousData != null) {
      previousData['attachment_url'] = 'uploads/file.pdf';
      previousData['priority'] = 'High';
      await sharedData.setFormData('complaint_form', previousData);
    }
  }

  static Future<void> submitFormStep3() async {
    // Page 3 - get complete form data
    final completeData = await sharedData.getFormData('complaint_form');
    // Submit to API
    await sharedData.clearFormData('complaint_form');
  }
}

/// EXAMPLE 4: Store navigation state for breadcrumbs
class NavigationStateExample {
  static Future<void> trackNavigation() async {
    final navState = {
      'current_page': 'courses',
      'previous_page': 'dashboard',
      'breadcrumbs': ['Home', 'Student', 'Courses'],
      'course_id': 'CS101',
      'timestamp': DateTime.now().toIso8601String(),
    };
    await sharedData.setNavigationState(navState);
  }

  static Future<void> getBreadcrumbs() async {
    final state = await sharedData.getNavigationState();
    if (state != null) {
      final breadcrumbs = state['breadcrumbs'] as List;
      // Display breadcrumbs in app bar
    }
  }
}

/// EXAMPLE 5: Store arbitrary temporary data
class TempDataExample {
  static Future<void> storeSelectedCourse() async {
    // In courses list page - user selects a course
    final courseData = {
      'id': 'CS101',
      'name': 'Data Structures',
      'credits': 4,
      'professor': 'Dr. Smith',
    };
    await sharedData.setTempData('selected_course', courseData);
  }

  static Future<void> useSelectedCourseInOtherPage() async {
    // In another page that needs the selected course
    final course = await sharedData.getTempData('selected_course');
    if (course != null) {
      // Use course data
    }
  }

  static Future<void> storePageSettings() async {
    // Store page-specific preferences
    await sharedData.setTempData('table_page_size', 10);
    await sharedData.setTempData('theme_preference', 'dark');
  }
}

/// EXAMPLE 6: Real-world use case - Faculty managing grades across pages
class RealWorldFacultyGradeExample {
  // In grades list page
  static Future<void> selectStudentForGrading(String studentId) async {
    final studentData = {
      'id': studentId,
      'name': 'John Doe',
      'email': 'john@example.com',
      'selected_time': DateTime.now().toIso8601String(),
    };
    await sharedData.setTempData('selected_student', studentData);
  }

  // In grade entry page
  static Future<void> loadSelectedStudent() async {
    final student = await sharedData.getTempData('selected_student');
    if (student != null) {
      // Pre-populate student name and details
      // Automatically load their current grades
    }
  }

  // In grade submission confirmation page
  static Future<void> completeGradeSubmission(
    String studentId,
    Map<String, dynamic> grades,
  ) async {
    // Save grade data temporarily while confirming
    final gradeData = {
      'student_id': studentId,
      'grades': grades,
      'submitted_at': DateTime.now().toIso8601String(),
    };
    await sharedData.setFormData('grade_submission_$studentId', gradeData);

    // After API confirmation
    await sharedData.clearFormData('grade_submission_$studentId');
    
    // Clear selected student for next one
    // (or keep it if sequential grading)
  }
}

/// EXAMPLE 7: Clear data when needed
class DataCleanupExample {
  static Future<void> clearAllSharedData() async {
    // On logout
    await sharedData.clearAll();
  }

  static Future<void> clearSpecificFormData() async {
    // When user cancels a form
    await sharedData.clearFormData('complaint_form');
  }
}

/// Usage in widgets/pages:
/// 
/// ```dart
/// class MyPage extends StatefulWidget {
///   @override
///   State<MyPage> createState() => _MyPageState();
/// }
///
/// class _MyPageState extends State<MyPage> {
///   @override
///   void initState() {
///     super.initState();
///     _loadSharedData();
///   }
///
///   Future<void> _loadSharedData() async {
///     final role = await sharedData.getUserRole();
///     final filters = await sharedData.getFilters();
///     // Use the data
///   }
///
///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       body: Center(
///         child: ElevatedButton(
///           onPressed: () async {
///             await sharedData.setTempData('key', 'value');
///           },
///           child: const Text('Store Data'),
///         ),
///       ),
///     );
///   }
/// }
/// ```

void main() {}
