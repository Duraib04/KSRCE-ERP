import '../domain/models.dart';

abstract class FacultyRepository {
  /// Fetch a single faculty member by ID
  Future<Faculty> getFacultyById(String id);

  /// Fetch all faculty members (with optional pagination)
  Future<List<Faculty>> getAllFaculty({
    int page = 1,
    int pageSize = 20,
  });

  /// Search faculty by name or email
  Future<List<Faculty>> searchFaculty(String query);

  /// Get faculty by department
  Future<List<Faculty>> getFacultyByDepartment(String department);

  /// Get faculty by designation
  Future<List<Faculty>> getFacultyByDesignation(String designation);

  /// Create a new faculty member
  Future<Faculty> createFaculty(Faculty faculty);

  /// Update faculty information
  Future<Faculty> updateFaculty(String id, Faculty faculty);

  /// Delete a faculty member
  Future<void> deleteFaculty(String id);

  /// Get courses taught by faculty
  Future<List<String>> getFacultyCourses(String facultyId);

  /// Get faculty teaching schedule
  Future<Map<String, dynamic>> getFacultySchedule(String facultyId);

  /// Get faculty performance metrics
  Future<Map<String, dynamic>> getFacultyMetrics(String facultyId);
}
