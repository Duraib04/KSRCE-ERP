import '../domain/models.dart';

abstract class StudentRepository {
  /// Fetch a single student by ID
  Future<Student> getStudentById(String id);

  /// Fetch all students (with optional pagination)
  Future<List<Student>> getAllStudents({
    int page = 1,
    int pageSize = 20,
  });

  /// Search students by name or email
  Future<List<Student>> searchStudents(String query);

  /// Get students by department
  Future<List<Student>> getStudentsByDepartment(String department);

  /// Get students by semester
  Future<List<Student>> getStudentsBySemester(String semester);

  /// Create a new student
  Future<Student> createStudent(Student student);

  /// Update student information
  Future<Student> updateStudent(String id, Student student);

  /// Delete a student
  Future<void> deleteStudent(String id);

  /// Get student attendance data
  Future<Map<String, dynamic>> getStudentAttendance(String studentId);

  /// Get student grades
  Future<Map<String, dynamic>> getStudentGrades(String studentId);

  /// Get courses enrolled by student
  Future<List<String>> getStudentCourses(String studentId);
}
