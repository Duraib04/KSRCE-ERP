import '../domain/models.dart';
import 'student_repository.dart';

class StudentService implements StudentRepository {
  /// Mock data for demonstration purposes
  static final List<Student> _mockStudents = [
    Student(
      id: 'S20210001',
      name: 'Rahul Kumar',
      email: 'rahul.kumar@ksrce.edu',
      phone: '+91-9876543210',
      department: 'Computer Science',
      semester: '3',
      gpa: 3.85,
      attendancePercentage: 92,
      enrolledCourses: ['CS201', 'CS202', 'CS203', 'CS204', 'CS205'],
      profileImageUrl: 'https://via.placeholder.com/150',
      enrollmentDate: DateTime(2021, 7, 15),
      status: 'active',
    ),
    Student(
      id: 'S20210002',
      name: 'Priya Singh',
      email: 'priya.singh@ksrce.edu',
      phone: '+91-9876543211',
      department: 'Electronics',
      semester: '3',
      gpa: 3.92,
      attendancePercentage: 95,
      enrolledCourses: ['EC201', 'EC202', 'EC203', 'EC204'],
      profileImageUrl: 'https://via.placeholder.com/150',
      enrollmentDate: DateTime(2021, 7, 15),
      status: 'active',
    ),
    Student(
      id: 'S20210003',
      name: 'Arjun Patel',
      email: 'arjun.patel@ksrce.edu',
      phone: '+91-9876543212',
      department: 'Mechanical',
      semester: '3',
      gpa: 3.45,
      attendancePercentage: 88,
      enrolledCourses: ['ME201', 'ME202', 'ME203', 'ME204', 'ME205'],
      profileImageUrl: 'https://via.placeholder.com/150',
      enrollmentDate: DateTime(2021, 7, 15),
      status: 'active',
    ),
  ];

  @override
  Future<Student> getStudentById(String id) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      return _mockStudents.firstWhere((student) => student.id == id);
    } catch (e) {
      throw Exception('Student with ID $id not found');
    }
  }

  @override
  Future<List<Student>> getAllStudents({
    int page = 1,
    int pageSize = 20,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    final startIndex = (page - 1) * pageSize;
    final endIndex = startIndex + pageSize;

    if (startIndex >= _mockStudents.length) {
      return [];
    }

    return _mockStudents.sublist(
      startIndex,
      endIndex > _mockStudents.length ? _mockStudents.length : endIndex,
    );
  }

  @override
  Future<List<Student>> searchStudents(String query) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    final lowerQuery = query.toLowerCase();
    return _mockStudents
        .where(
          (student) =>
              student.name.toLowerCase().contains(lowerQuery) ||
              student.email.toLowerCase().contains(lowerQuery) ||
              student.id.toLowerCase().contains(lowerQuery),
        )
        .toList();
  }

  @override
  Future<List<Student>> getStudentsByDepartment(String department) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    return _mockStudents
        .where((student) => student.department.toLowerCase() == department.toLowerCase())
        .toList();
  }

  @override
  Future<List<Student>> getStudentsBySemester(String semester) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    return _mockStudents
        .where((student) => student.semester == semester)
        .toList();
  }

  @override
  Future<Student> createStudent(Student student) async {
    // Simulate network delay and validation
    await Future.delayed(const Duration(milliseconds: 500));

    if (student.id.isEmpty || student.name.isEmpty) {
      throw Exception('Student ID and name are required');
    }

    _mockStudents.add(student);
    return student;
  }

  @override
  Future<Student> updateStudent(String id, Student student) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final index = _mockStudents.indexWhere((s) => s.id == id);
      if (index == -1) {
        throw Exception('Student with ID $id not found');
      }

      _mockStudents[index] = student.copyWith(id: id);
      return _mockStudents[index];
    } catch (e) {
      throw Exception('Failed to update student: $e');
    }
  }

  @override
  Future<void> deleteStudent(String id) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      _mockStudents.removeWhere((student) => student.id == id);
    } catch (e) {
      throw Exception('Failed to delete student: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getStudentAttendance(String studentId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final student = await getStudentById(studentId);
      return {
        'studentId': student.id,
        'totalClasses': 45,
        'classesAttended': 41,
        'percentage': student.attendancePercentage,
        'lastUpdated': DateTime.now(),
      };
    } catch (e) {
      throw Exception('Failed to fetch attendance data: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getStudentGrades(String studentId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final student = await getStudentById(studentId);
      return {
        'studentId': student.id,
        'semester': student.semester,
        'gpa': student.gpa,
        'grades': {
          'CS201': 'A+',
          'CS202': 'A',
          'CS203': 'A+',
          'CS204': 'A',
          'CS205': 'A-',
        },
        'lastUpdated': DateTime.now(),
      };
    } catch (e) {
      throw Exception('Failed to fetch grades: $e');
    }
  }

  @override
  Future<List<String>> getStudentCourses(String studentId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final student = await getStudentById(studentId);
      return student.enrolledCourses;
    } catch (e) {
      throw Exception('Failed to fetch courses: $e');
    }
  }
}
