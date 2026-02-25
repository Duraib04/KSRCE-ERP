import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DataService extends ChangeNotifier {
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;
  DataService._internal();

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  List<Map<String, dynamic>> _students = [];
  List<Map<String, dynamic>> _users = [];
  List<Map<String, dynamic>> _courses = [];
  List<Map<String, dynamic>> _attendance = [];
  List<Map<String, dynamic>> _assignments = [];
  List<Map<String, dynamic>> _results = [];
  List<Map<String, dynamic>> _timetable = [];
  List<Map<String, dynamic>> _notifications = [];
  List<Map<String, dynamic>> _complaints = [];
  List<Map<String, dynamic>> _departments = [];
  List<Map<String, dynamic>> _faculty = [];
  List<Map<String, dynamic>> _classes = [];
  List<Map<String, dynamic>> _mentorAssignments = [];

  // Logged in user info
  String? _currentUserId;
  String? _currentRole;
  Map<String, dynamic>? _currentStudent;
  Map<String, dynamic>? _currentFaculty;

  // Getters
  List<Map<String, dynamic>> get students => _students;
  List<Map<String, dynamic>> get users => _users;
  List<Map<String, dynamic>> get courses => _courses;
  List<Map<String, dynamic>> get attendance => _attendance;
  List<Map<String, dynamic>> get assignments => _assignments;
  List<Map<String, dynamic>> get results => _results;
  List<Map<String, dynamic>> get timetable => _timetable;
  List<Map<String, dynamic>> get notifications => _notifications;
  List<Map<String, dynamic>> get complaints => _complaints;
  List<Map<String, dynamic>> get departments => _departments;
  List<Map<String, dynamic>> get faculty => _faculty;
  List<Map<String, dynamic>> get classes => _classes;
  List<Map<String, dynamic>> get mentorAssignments => _mentorAssignments;
  String? get currentUserId => _currentUserId;
  String? get currentRole => _currentRole;
  Map<String, dynamic>? get currentStudent => _currentStudent;
  Map<String, dynamic>? get currentFaculty => _currentFaculty;

  Future<void> loadAllData() async {
    if (_isLoaded) return;
    try {
      final futures = await Future.wait([
        _loadJson('assets/data/students.json'),      // 0
        _loadJson('assets/data/users.json'),          // 1
        _loadJson('assets/data/courses.json'),        // 2
        _loadJson('assets/data/attendance.json'),     // 3
        _loadJson('assets/data/assignments.json'),    // 4
        _loadJson('assets/data/results.json'),        // 5
        _loadJson('assets/data/timetable.json'),      // 6
        _loadJson('assets/data/notifications.json'),  // 7
        _loadJson('assets/data/complaints.json'),     // 8
        _loadJson('assets/data/departments.json'),    // 9
        _loadJson('assets/data/faculty.json'),        // 10
        _loadJson('assets/data/classes.json'),        // 11
        _loadJson('assets/data/mentor_assignments.json'), // 12
      ]);
      _students = futures[0];
      _users = futures[1];
      _courses = futures[2];
      _attendance = futures[3];
      _assignments = futures[4];
      _results = futures[5];
      _timetable = futures[6];
      _notifications = futures[7];
      _complaints = futures[8];
      _departments = futures[9];
      _faculty = futures[10];
      _classes = futures[11];
      _mentorAssignments = futures[12];
      _isLoaded = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading data: $e');
    }
  }

  Future<List<Map<String, dynamic>>> _loadJson(String path) async {
    try {
      final jsonString = await rootBundle.loadString(path);
      final List<dynamic> data = json.decode(jsonString);
      return data.cast<Map<String, dynamic>>();
    } catch (e) {
      debugPrint('Error loading $path: $e');
      return [];
    }
  }

  // ─── AUTH ───────────────────────────────────────────────
  bool login(String userId, String password) {
    for (final user in _users) {
      if (user['id'] == userId && user['password'] == password) {
        _currentUserId = userId;
        final role = user['role'] as String? ?? '';
        if (userId.startsWith('STU')) {
          _currentRole = 'student';
          _currentStudent = _students.firstWhere(
            (s) => s['studentId'] == userId,
            orElse: () => <String, dynamic>{},
          );
        } else if (role == 'hod') {
          _currentRole = 'hod';
          _currentFaculty = _faculty.firstWhere(
            (f) => f['facultyId'] == userId,
            orElse: () => <String, dynamic>{},
          );
        } else if (userId.startsWith('FAC')) {
          _currentRole = 'faculty';
          _currentFaculty = _faculty.firstWhere(
            (f) => f['facultyId'] == userId,
            orElse: () => <String, dynamic>{},
          );
        } else if (userId.startsWith('ADM')) {
          _currentRole = 'admin';
        }
        notifyListeners();
        return true;
      }
    }
    return false;
  }

  void logout() {
    _currentUserId = null;
    _currentRole = null;
    _currentStudent = null;
    _currentFaculty = null;
    notifyListeners();
  }

  // ─── STUDENT QUERIES ────────────────────────────────────
  List<Map<String, dynamic>> getStudentCourses(String studentId) {
    final student = _students.firstWhere(
      (s) => s['studentId'] == studentId,
      orElse: () => <String, dynamic>{},
    );
    final enrolled = (student['enrolledCourses'] as List<dynamic>?)?.cast<String>() ?? [];
    if (enrolled.isEmpty) {
      // Fallback: return courses matching student's department
      final dept = student['departmentId'] ?? student['department'] ?? '';
      return _courses.where((c) => c['departmentId'] == dept || c['department'] == dept).toList();
    }
    return _courses.where((c) => enrolled.contains(c['courseId'])).toList();
  }

  List<Map<String, dynamic>> getStudentAttendance() => _attendance;
  List<Map<String, dynamic>> getStudentAssignments() => _assignments;
  List<Map<String, dynamic>> getStudentResults() => _results;

  List<Map<String, dynamic>> getTimetableForDay(String day) {
    return _timetable.where((t) => t['day'] == day).toList();
  }

  List<Map<String, dynamic>> getUnreadNotifications() {
    return _notifications.where((n) => n['isRead'] == false).toList();
  }

  int get unreadNotificationCount => getUnreadNotifications().length;

  void markNotificationRead(String notifId) {
    final idx = _notifications.indexWhere((n) => n['notificationId'] == notifId);
    if (idx != -1) {
      _notifications[idx]['isRead'] = true;
      notifyListeners();
    }
  }

  void addComplaint(Map<String, dynamic> complaint) {
    complaint['complaintId'] = 'CMP${(_complaints.length + 1).toString().padLeft(3, '0')}';
    complaint['submittedDate'] = DateTime.now().toIso8601String().substring(0, 10);
    complaint['status'] = 'pending';
    _complaints.add(complaint);
    notifyListeners();
  }

  double get overallAttendancePercentage {
    if (_attendance.isEmpty) return 0;
    int totalPresent = 0, totalClasses = 0;
    for (final a in _attendance) {
      totalPresent += (a['attendedClasses'] as int? ?? 0);
      totalClasses += (a['totalClasses'] as int? ?? 0);
    }
    return totalClasses > 0 ? (totalPresent / totalClasses * 100) : 0;
  }

  double get currentCGPA {
    if (_currentStudent != null && _currentStudent!['cgpa'] != null) {
      return (_currentStudent!['cgpa'] as num).toDouble();
    }
    return 0.0;
  }

  int get pendingAssignmentsCount {
    return _assignments.where((a) => a['status'] == 'pending').length;
  }

  // Get mentor info for current student
  Map<String, dynamic>? getStudentMentor(String studentId) {
    final student = _students.firstWhere(
      (s) => s['studentId'] == studentId,
      orElse: () => <String, dynamic>{},
    );
    final mentorId = student['mentorId'] as String?;
    if (mentorId == null) return null;
    return _faculty.firstWhere(
      (f) => f['facultyId'] == mentorId,
      orElse: () => <String, dynamic>{},
    );
  }

  // Get class adviser info for current student
  Map<String, dynamic>? getStudentClassAdviser(String studentId) {
    final student = _students.firstWhere(
      (s) => s['studentId'] == studentId,
      orElse: () => <String, dynamic>{},
    );
    final adviserId = student['classAdviserId'] as String?;
    if (adviserId == null) return null;
    return _faculty.firstWhere(
      (f) => f['facultyId'] == adviserId,
      orElse: () => <String, dynamic>{},
    );
  }

  // ─── FACULTY QUERIES ────────────────────────────────────
  List<Map<String, dynamic>> getFacultyCourses(String facultyId) {
    return _courses.where((c) => c['facultyId'] == facultyId).toList();
  }

  List<Map<String, dynamic>> getMentees(String facultyId) {
    final fac = _faculty.firstWhere(
      (f) => f['facultyId'] == facultyId,
      orElse: () => <String, dynamic>{},
    );
    final menteeIds = (fac['menteeIds'] as List<dynamic>?)?.cast<String>() ?? [];
    return _students.where((s) => menteeIds.contains(s['studentId'])).toList();
  }

  Map<String, dynamic>? getAdviserClass(String facultyId) {
    final fac = _faculty.firstWhere(
      (f) => f['facultyId'] == facultyId,
      orElse: () => <String, dynamic>{},
    );
    if (fac['isClassAdviser'] != true) return null;
    final adviserFor = fac['adviserFor'] as Map<String, dynamic>?;
    if (adviserFor == null) return null;
    return _classes.firstWhere(
      (c) => c['departmentId'] == adviserFor['departmentId']
          && c['year'] == adviserFor['year']
          && c['section'] == adviserFor['section'],
      orElse: () => <String, dynamic>{},
    );
  }

  List<Map<String, dynamic>> getCourseStudents(String courseId) {
    return _students.where((s) {
      final enrolled = (s['enrolledCourses'] as List<dynamic>?)?.cast<String>() ?? [];
      return enrolled.contains(courseId);
    }).toList();
  }

  bool isFacultyClassAdviser(String facultyId) {
    final fac = _faculty.firstWhere(
      (f) => f['facultyId'] == facultyId,
      orElse: () => <String, dynamic>{},
    );
    return fac['isClassAdviser'] == true;
  }

  // ─── HOD QUERIES ────────────────────────────────────────
  Map<String, dynamic>? getHODDepartment(String facultyId) {
    final fac = _faculty.firstWhere(
      (f) => f['facultyId'] == facultyId,
      orElse: () => <String, dynamic>{},
    );
    final deptId = fac['departmentId'] as String?;
    if (deptId == null) return null;
    return _departments.firstWhere(
      (d) => d['departmentId'] == deptId,
      orElse: () => <String, dynamic>{},
    );
  }

  List<Map<String, dynamic>> getDepartmentFaculty(String departmentId) {
    return _faculty.where((f) => f['departmentId'] == departmentId).toList();
  }

  List<Map<String, dynamic>> getDepartmentStudents(String departmentId) {
    return _students.where((s) => s['departmentId'] == departmentId).toList();
  }

  List<Map<String, dynamic>> getDepartmentClasses(String departmentId) {
    return _classes.where((c) => c['departmentId'] == departmentId).toList();
  }

  List<Map<String, dynamic>> getDepartmentCourses(String departmentId) {
    return _courses.where((c) => c['departmentId'] == departmentId).toList();
  }

  List<Map<String, dynamic>> getDepartmentMentorAssignments(String departmentId) {
    return _mentorAssignments.where((m) => m['departmentId'] == departmentId).toList();
  }

  // ─── HOD ACTIONS ────────────────────────────────────────
  void assignClassAdviser(String classId, String facultyId) {
    // Update class
    final classIdx = _classes.indexWhere((c) => c['classId'] == classId);
    if (classIdx == -1) return;
    final oldAdviserId = _classes[classIdx]['classAdviserId'] as String?;
    _classes[classIdx]['classAdviserId'] = facultyId;

    // Remove old adviser flag
    if (oldAdviserId != null) {
      final oldIdx = _faculty.indexWhere((f) => f['facultyId'] == oldAdviserId);
      if (oldIdx != -1) {
        _faculty[oldIdx]['isClassAdviser'] = false;
        _faculty[oldIdx]['adviserFor'] = null;
      }
    }

    // Set new adviser
    final facIdx = _faculty.indexWhere((f) => f['facultyId'] == facultyId);
    if (facIdx != -1) {
      _faculty[facIdx]['isClassAdviser'] = true;
      _faculty[facIdx]['adviserFor'] = {
        'departmentId': _classes[classIdx]['departmentId'],
        'year': _classes[classIdx]['year'],
        'section': _classes[classIdx]['section'],
      };
    }

    // Update students in this class
    final studentIds = (_classes[classIdx]['studentIds'] as List<dynamic>?)?.cast<String>() ?? [];
    for (final sId in studentIds) {
      final sIdx = _students.indexWhere((s) => s['studentId'] == sId);
      if (sIdx != -1) {
        _students[sIdx]['classAdviserId'] = facultyId;
      }
    }

    notifyListeners();
  }

  void assignMentor(String facultyId, List<String> studentIds, String departmentId, int year, String section) {
    // Remove old mentor assignment for this faculty
    _mentorAssignments.removeWhere((m) => m['mentorId'] == facultyId);

    // Get faculty name
    final fac = _faculty.firstWhere(
      (f) => f['facultyId'] == facultyId,
      orElse: () => <String, dynamic>{},
    );
    final facName = fac['name'] as String? ?? '';

    // Create new assignment
    _mentorAssignments.add({
      'mentorId': facultyId,
      'mentorName': facName,
      'departmentId': departmentId,
      'year': year,
      'section': section,
      'menteeIds': studentIds,
    });

    // Update faculty
    final facIdx = _faculty.indexWhere((f) => f['facultyId'] == facultyId);
    if (facIdx != -1) {
      _faculty[facIdx]['menteeIds'] = studentIds;
    }

    // Update students
    for (final sId in studentIds) {
      final sIdx = _students.indexWhere((s) => s['studentId'] == sId);
      if (sIdx != -1) {
        _students[sIdx]['mentorId'] = facultyId;
      }
    }

    notifyListeners();
  }

  // ─── ADMIN ACTIONS ──────────────────────────────────────
  void addDepartment(Map<String, dynamic> dept) {
    dept['departmentId'] = 'DEPT_${dept['departmentCode']}';
    _departments.add(dept);
    notifyListeners();
  }

  void addFaculty(Map<String, dynamic> fac) {
    final id = 'FAC${(_faculty.length + 1).toString().padLeft(3, '0')}';
    fac['facultyId'] = id;
    fac['isHOD'] = false;
    fac['isClassAdviser'] = false;
    fac['adviserFor'] = null;
    fac['menteeIds'] = <String>[];
    fac['courseIds'] = <String>[];
    _faculty.add(fac);

    // Create user account
    _users.add({
      'id': id,
      'password': 'ksrce@${id.toLowerCase()}',
      'role': 'faculty',
      'label': 'Faculty - ${fac['name']}',
    });

    notifyListeners();
  }

  void addStudent(Map<String, dynamic> student) {
    final id = 'STU${(_students.length + 1).toString().padLeft(3, '0')}';
    student['studentId'] = id;
    student['enrolledCourses'] = <String>[];
    student['mentorId'] = null;
    student['classAdviserId'] = null;
    _students.add(student);

    // Create user account
    _users.add({
      'id': id,
      'password': 'ksrce@${id.toLowerCase()}',
      'role': 'student',
      'label': 'Student - ${student['name']}',
    });

    // Add to class if exists
    final classId = '${(student['departmentId'] as String? ?? '').replaceAll('DEPT_', '')}_${student['year']}_${student['section']}';
    final classIdx = _classes.indexWhere((c) => c['classId'] == classId);
    if (classIdx != -1) {
      (_classes[classIdx]['studentIds'] as List<dynamic>).add(id);
      // Set class adviser
      student['classAdviserId'] = _classes[classIdx]['classAdviserId'];
    }

    notifyListeners();
  }

  void assignHOD(String departmentId, String facultyId) {
    // Remove old HOD
    final deptIdx = _departments.indexWhere((d) => d['departmentId'] == departmentId);
    if (deptIdx == -1) return;
    final oldHodId = _departments[deptIdx]['hodId'] as String?;
    if (oldHodId != null) {
      final oldIdx = _faculty.indexWhere((f) => f['facultyId'] == oldHodId);
      if (oldIdx != -1) _faculty[oldIdx]['isHOD'] = false;
      // Revert user role to faculty
      final oldUserIdx = _users.indexWhere((u) => u['id'] == oldHodId);
      if (oldUserIdx != -1) _users[oldUserIdx]['role'] = 'faculty';
    }

    // Set new HOD
    _departments[deptIdx]['hodId'] = facultyId;
    final facIdx = _faculty.indexWhere((f) => f['facultyId'] == facultyId);
    if (facIdx != -1) _faculty[facIdx]['isHOD'] = true;
    // Update user role
    final userIdx = _users.indexWhere((u) => u['id'] == facultyId);
    if (userIdx != -1) _users[userIdx]['role'] = 'hod';

    notifyListeners();
  }

  void addCourse(Map<String, dynamic> course) {
    final id = course['courseCode'] as String? ?? 'CRS${(_courses.length + 1).toString().padLeft(3, '0')}';
    course['courseId'] = id;
    course['totalClasses'] = 0;
    course['attendedClasses'] = 0;

    // Set faculty name from faculty list
    final facultyId = course['facultyId'] as String?;
    if (facultyId != null) {
      final fac = _faculty.firstWhere(
        (f) => f['facultyId'] == facultyId,
        orElse: () => <String, dynamic>{},
      );
      course['facultyName'] = fac['name'] ?? '';
      // Add to faculty's courseIds
      final facIdx = _faculty.indexWhere((f) => f['facultyId'] == facultyId);
      if (facIdx != -1) {
        final courseIds = ((_faculty[facIdx]['courseIds'] as List<dynamic>?)?.cast<String>() ?? []).toList();
        if (!courseIds.contains(id)) {
          courseIds.add(id);
          _faculty[facIdx]['courseIds'] = courseIds;
        }
      }
    }

    _courses.add(course);
    notifyListeners();
  }

  void enrollStudentInCourse(String studentId, String courseId) {
    final sIdx = _students.indexWhere((s) => s['studentId'] == studentId);
    if (sIdx == -1) return;
    final enrolled = ((_students[sIdx]['enrolledCourses'] as List<dynamic>?)?.cast<String>() ?? []).toList();
    if (!enrolled.contains(courseId)) {
      enrolled.add(courseId);
      _students[sIdx]['enrolledCourses'] = enrolled;
      notifyListeners();
    }
  }

  void bulkEnrollClass(String classId, List<String> courseIds) {
    final classEntry = _classes.firstWhere(
      (c) => c['classId'] == classId,
      orElse: () => <String, dynamic>{},
    );
    final studentIds = (classEntry['studentIds'] as List<dynamic>?)?.cast<String>() ?? [];
    for (final sId in studentIds) {
      for (final cId in courseIds) {
        enrollStudentInCourse(sId, cId);
      }
    }
    // Update class courseIds
    final classIdx = _classes.indexWhere((c) => c['classId'] == classId);
    if (classIdx != -1) {
      _classes[classIdx]['courseIds'] = courseIds;
    }
    notifyListeners();
  }

  void addClass(Map<String, dynamic> classEntry) {
    _classes.add(classEntry);
    notifyListeners();
  }

  // ─── UTILITY ────────────────────────────────────────────
  String getDepartmentName(String departmentId) {
    final dept = _departments.firstWhere(
      (d) => d['departmentId'] == departmentId,
      orElse: () => <String, dynamic>{},
    );
    return dept['departmentName'] as String? ?? departmentId;
  }

  String getDepartmentCode(String departmentId) {
    final dept = _departments.firstWhere(
      (d) => d['departmentId'] == departmentId,
      orElse: () => <String, dynamic>{},
    );
    return dept['departmentCode'] as String? ?? '';
  }

  String getFacultyName(String facultyId) {
    final fac = _faculty.firstWhere(
      (f) => f['facultyId'] == facultyId,
      orElse: () => <String, dynamic>{},
    );
    return fac['name'] as String? ?? facultyId;
  }

  Map<String, dynamic>? getFacultyById(String facultyId) {
    try {
      return _faculty.firstWhere((f) => f['facultyId'] == facultyId);
    } catch (_) {
      return null;
    }
  }

  Map<String, dynamic>? getStudentById(String studentId) {
    try {
      return _students.firstWhere((s) => s['studentId'] == studentId);
    } catch (_) {
      return null;
    }
  }
}
