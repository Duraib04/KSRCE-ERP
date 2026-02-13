import '../domain/models.dart';
import 'faculty_repository.dart';

class FacultyService implements FacultyRepository {
  /// Mock data for demonstration purposes
  static final List<Faculty> _mockFaculty = [
    Faculty(
      id: 'FAC001',
      name: 'Dr. Rajesh Kumar',
      email: 'rajesh.kumar@ksrce.edu',
      phone: '+91-9876543200',
      department: 'Computer Science',
      designation: 'Professor',
      teachingCourses: ['CS201', 'CS301', 'CS401'],
      yearsOfExperience: 12,
      profileImageUrl: 'https://via.placeholder.com/150',
      joinDate: DateTime(2012, 6, 1),
      status: 'active',
      rating: 4.8,
    ),
    Faculty(
      id: 'FAC002',
      name: 'Dr. Meera Sharma',
      email: 'meera.sharma@ksrce.edu',
      phone: '+91-9876543201',
      department: 'Electronics',
      designation: 'Associate Professor',
      teachingCourses: ['EC201', 'EC202', 'EC301'],
      yearsOfExperience: 10,
      profileImageUrl: 'https://via.placeholder.com/150',
      joinDate: DateTime(2014, 8, 15),
      status: 'active',
      rating: 4.6,
    ),
    Faculty(
      id: 'FAC003',
      name: 'Dr. Vikram Singh',
      email: 'vikram.singh@ksrce.edu',
      phone: '+91-9876543202',
      department: 'Mechanical',
      designation: 'Assistant Professor',
      teachingCourses: ['ME201', 'ME202', 'ME203'],
      yearsOfExperience: 5,
      profileImageUrl: 'https://via.placeholder.com/150',
      joinDate: DateTime(2019, 7, 1),
      status: 'active',
      rating: 4.4,
    ),
  ];

  @override
  Future<Faculty> getFacultyById(String id) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      return _mockFaculty.firstWhere((faculty) => faculty.id == id);
    } catch (e) {
      throw Exception('Faculty member with ID $id not found');
    }
  }

  @override
  Future<List<Faculty>> getAllFaculty({
    int page = 1,
    int pageSize = 20,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    final startIndex = (page - 1) * pageSize;
    final endIndex = startIndex + pageSize;

    if (startIndex >= _mockFaculty.length) {
      return [];
    }

    return _mockFaculty.sublist(
      startIndex,
      endIndex > _mockFaculty.length ? _mockFaculty.length : endIndex,
    );
  }

  @override
  Future<List<Faculty>> searchFaculty(String query) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    final lowerQuery = query.toLowerCase();
    return _mockFaculty
        .where(
          (faculty) =>
              faculty.name.toLowerCase().contains(lowerQuery) ||
              faculty.email.toLowerCase().contains(lowerQuery) ||
              faculty.id.toLowerCase().contains(lowerQuery),
        )
        .toList();
  }

  @override
  Future<List<Faculty>> getFacultyByDepartment(String department) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    return _mockFaculty
        .where((faculty) => faculty.department.toLowerCase() == department.toLowerCase())
        .toList();
  }

  @override
  Future<List<Faculty>> getFacultyByDesignation(String designation) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    return _mockFaculty
        .where((faculty) => faculty.designation.toLowerCase() == designation.toLowerCase())
        .toList();
  }

  @override
  Future<Faculty> createFaculty(Faculty faculty) async {
    // Simulate network delay and validation
    await Future.delayed(const Duration(milliseconds: 500));

    if (faculty.id.isEmpty || faculty.name.isEmpty) {
      throw Exception('Faculty ID and name are required');
    }

    _mockFaculty.add(faculty);
    return faculty;
  }

  @override
  Future<Faculty> updateFaculty(String id, Faculty faculty) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final index = _mockFaculty.indexWhere((f) => f.id == id);
      if (index == -1) {
        throw Exception('Faculty member with ID $id not found');
      }

      _mockFaculty[index] = faculty.copyWith(id: id);
      return _mockFaculty[index];
    } catch (e) {
      throw Exception('Failed to update faculty: $e');
    }
  }

  @override
  Future<void> deleteFaculty(String id) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      _mockFaculty.removeWhere((faculty) => faculty.id == id);
    } catch (e) {
      throw Exception('Failed to delete faculty: $e');
    }
  }

  @override
  Future<List<String>> getFacultyCourses(String facultyId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final faculty = await getFacultyById(facultyId);
      return faculty.teachingCourses;
    } catch (e) {
      throw Exception('Failed to fetch courses: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getFacultySchedule(String facultyId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final faculty = await getFacultyById(facultyId);
      return {
        'facultyId': faculty.id,
        'schedule': {
          'Monday': ['9:00 AM - 10:00 AM', '11:00 AM - 12:00 PM'],
          'Tuesday': ['10:00 AM - 11:00 AM', '2:00 PM - 3:00 PM'],
          'Wednesday': ['9:00 AM - 10:00 AM', '3:00 PM - 4:00 PM'],
          'Thursday': ['10:00 AM - 11:00 AM'],
          'Friday': ['9:00 AM - 10:00 AM', '11:00 AM - 12:00 PM'],
        },
        'officehours': '4:00 PM - 5:00 PM (Monday - Friday)',
      };
    } catch (e) {
      throw Exception('Failed to fetch schedule: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getFacultyMetrics(String facultyId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final faculty = await getFacultyById(facultyId);
      return {
        'facultyId': faculty.id,
        'studentRating': faculty.rating,
        'classesHeld': 45,
        'averageAttendance': 92,
        'publications': 8,
        'yearsOfExperience': faculty.yearsOfExperience,
        'lastUpdated': DateTime.now(),
      };
    } catch (e) {
      throw Exception('Failed to fetch metrics: $e');
    }
  }
}
