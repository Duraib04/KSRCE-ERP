import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'persistence_service.dart';

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
  List<Map<String, dynamic>> _exams = [];
  List<Map<String, dynamic>> _fees = [];
  List<Map<String, dynamic>> _certificates = [];
  List<Map<String, dynamic>> _events = [];
  List<Map<String, dynamic>> _eventRegistrations = [];
  List<Map<String, dynamic>> _leave = [];
  List<Map<String, dynamic>> _leaveBalance = [];
  List<Map<String, dynamic>> _library = [];
  List<Map<String, dynamic>> _placements = [];
  List<Map<String, dynamic>> _placementApplications = [];
  List<Map<String, dynamic>> _syllabus = [];
  List<Map<String, dynamic>> _research = [];
  List<Map<String, dynamic>> _facultyTimetable = [];
  List<Map<String, dynamic>> _courseOutcomes = [];
  List<Map<String, dynamic>> _courseDiary = [];
  List<Map<String, dynamic>> _profileEditRequests = [];

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
  List<Map<String, dynamic>> get exams => _exams;
  List<Map<String, dynamic>> get fees => _fees;
  List<Map<String, dynamic>> get certificates => _certificates;
  List<Map<String, dynamic>> get events => _events;
  List<Map<String, dynamic>> get eventRegistrations => _eventRegistrations;
  List<Map<String, dynamic>> get leave => _leave;
  List<Map<String, dynamic>> get leaveBalance => _leaveBalance;
  List<Map<String, dynamic>> get library => _library;
  List<Map<String, dynamic>> get placements => _placements;
  List<Map<String, dynamic>> get placementApplications => _placementApplications;
  List<Map<String, dynamic>> get syllabus => _syllabus;
  List<Map<String, dynamic>> get research => _research;
  List<Map<String, dynamic>> get facultyTimetable => _facultyTimetable;
  List<Map<String, dynamic>> get courseOutcomes => _courseOutcomes;
  List<Map<String, dynamic>> get courseDiary => _courseDiary;
  List<Map<String, dynamic>> get profileEditRequests => _profileEditRequests;
  String? get currentUserId => _currentUserId;
  String? get currentRole => _currentRole;
  Map<String, dynamic>? get currentStudent => _currentStudent;
  Map<String, dynamic>? get currentFaculty => _currentFaculty;

  // Settings storage (persisted)
  Map<String, dynamic> _settings = {};
  Map<String, dynamic> get settings => _settings;

  Future<void> loadAllData() async {
    if (_isLoaded) return;
    try {
      // Initialize persistence
      await PersistenceService.init();

      // Check if we have persisted data from a previous session
      final persisted = PersistenceService.loadAll();
      if (persisted != null) {
        _students = persisted['students'] ?? [];
        _users = persisted['users'] ?? [];
        _courses = persisted['courses'] ?? [];
        _attendance = persisted['attendance'] ?? [];
        _assignments = persisted['assignments'] ?? [];
        _results = persisted['results'] ?? [];
        _timetable = persisted['timetable'] ?? [];
        _notifications = persisted['notifications'] ?? [];
        _complaints = persisted['complaints'] ?? [];
        _departments = persisted['departments'] ?? [];
        _faculty = persisted['faculty'] ?? [];
        _classes = persisted['classes'] ?? [];
        _mentorAssignments = persisted['mentorAssignments'] ?? [];
        _exams = persisted['exams'] ?? [];
        _fees = persisted['fees'] ?? [];
        _certificates = persisted['certificates'] ?? [];
        _events = persisted['events'] ?? [];
        _eventRegistrations = persisted['eventRegistrations'] ?? [];
        _leave = persisted['leave'] ?? [];
        _leaveBalance = persisted['leaveBalance'] ?? [];
        _library = persisted['library'] ?? [];
        _placements = persisted['placements'] ?? [];
        _placementApplications = persisted['placementApplications'] ?? [];
        _syllabus = persisted['syllabus'] ?? [];
        _research = persisted['research'] ?? [];
        _facultyTimetable = persisted['facultyTimetable'] ?? [];
        _courseOutcomes = persisted['courseOutcomes'] ?? [];
        _courseDiary = persisted['courseDiary'] ?? [];
        _profileEditRequests = persisted['profileEditRequests'] ?? [];
        _settings = (persisted['settings']?.isNotEmpty ?? false)
            ? persisted['settings']!.first
            : {};
      } else {
        // First run: seed from bundled JSON assets
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
        _loadJson('assets/data/exams.json'),               // 13
        _loadJson('assets/data/fees.json'),                 // 14
        _loadJson('assets/data/certificates.json'),         // 15
        _loadJson('assets/data/events.json'),               // 16
        _loadJson('assets/data/event_registrations.json'),  // 17
        _loadJson('assets/data/leave.json'),                // 18
        _loadJson('assets/data/leave_balance.json'),        // 19
        _loadJson('assets/data/library.json'),              // 20
        _loadJson('assets/data/placements.json'),           // 21
        _loadJson('assets/data/placement_applications.json'), // 22
        _loadJson('assets/data/syllabus.json'),             // 23
        _loadJson('assets/data/research.json'),             // 24
        _loadJson('assets/data/faculty_timetable.json'),    // 25
        _loadJson('assets/data/course_outcomes.json'),         // 26
        _loadJson('assets/data/course_diary.json'),             // 27
        _loadJson('assets/data/profile_edit_requests.json'),  // 28
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
      _exams = futures[13];
      _fees = futures[14];
      _certificates = futures[15];
      _events = futures[16];
      _eventRegistrations = futures[17];
      _leave = futures[18];
      _leaveBalance = futures[19];
      _library = futures[20];
      _placements = futures[21];
      _placementApplications = futures[22];
      _syllabus = futures[23];
      _research = futures[24];
      _facultyTimetable = futures[25];
      _courseOutcomes = futures[26];
      _courseDiary = futures[27];
      _profileEditRequests = futures[28];
        // Persist the seed data for future sessions
        await _persistAll();
      }
      // Apply changes from any pre-approved profile edit requests
      _applyAllPreApprovedChanges();
      _isLoaded = true;
      _skipPersist = true;
      notifyListeners();
      _skipPersist = false;
    } catch (e) {
      debugPrint('Error loading data: $e');
    }
  }

  /// Persist all data to localStorage after every mutation
  Future<void> _persistAll() async {
    try {
      await PersistenceService.saveAll({
        'students': _students,
        'users': _users,
        'courses': _courses,
        'attendance': _attendance,
        'assignments': _assignments,
        'results': _results,
        'timetable': _timetable,
        'notifications': _notifications,
        'complaints': _complaints,
        'departments': _departments,
        'faculty': _faculty,
        'classes': _classes,
        'mentorAssignments': _mentorAssignments,
        'exams': _exams,
        'fees': _fees,
        'certificates': _certificates,
        'events': _events,
        'eventRegistrations': _eventRegistrations,
        'leave': _leave,
        'leaveBalance': _leaveBalance,
        'library': _library,
        'placements': _placements,
        'placementApplications': _placementApplications,
        'syllabus': _syllabus,
        'research': _research,
        'facultyTimetable': _facultyTimetable,
        'courseOutcomes': _courseOutcomes,
        'courseDiary': _courseDiary,
        'profileEditRequests': _profileEditRequests,
        'settings': _settings.isNotEmpty ? [_settings] : [],
      });
    } catch (e) {
      debugPrint('Error persisting data: $e');
    }
  }

  /// Reset all data to defaults (clear localStorage, reload from assets)
  Future<void> resetAllData() async {
    await PersistenceService.clearAll();
    _isLoaded = false;
    _currentUserId = null;
    _currentRole = null;
    _currentStudent = null;
    _currentFaculty = null;
    _settings = {};
    await loadAllData();
  }

  /// Override notifyListeners to auto-persist data on every mutation.
  /// This ensures all changes survive browser refresh.
  bool _skipPersist = false;
  @override
  void notifyListeners() {
    super.notifyListeners();
    if (_isLoaded && !_skipPersist) {
      _persistAll();
    }
  }

  /// Apply changes from requests that were already approved in the JSON data
  void _applyAllPreApprovedChanges() {
    for (final req in _profileEditRequests) {
      if (req['status'] == 'approved') {
        _applyProfileChanges(req);
      }
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

  // ─── EXAM QUERIES ─────────────────────────────────────
  List<Map<String, dynamic>> getStudentExams(String studentId) {
    final student = getStudentById(studentId);
    if (student == null) return _exams;
    final enrolled = (student['enrolledCourses'] as List<dynamic>?)?.cast<String>() ?? [];
    final deptId = student['departmentId'] as String? ?? '';
    return _exams.where((e) => enrolled.contains(e['courseId']) || e['departmentId'] == deptId).toList();
  }

  List<Map<String, dynamic>> getFacultyExams(String facultyId) {
    return _exams.where((e) => e['facultyId'] == facultyId).toList();
  }

  // ─── FEE QUERIES ──────────────────────────────────────
  List<Map<String, dynamic>> getStudentFees(String studentId) {
    return _fees.where((f) => f['studentId'] == studentId).toList();
  }

  double getStudentTotalFees(String studentId) {
    return getStudentFees(studentId).fold(0.0, (sum, f) => sum + ((f['amount'] as num?)?.toDouble() ?? 0));
  }

  double getStudentPaidFees(String studentId) {
    return getStudentFees(studentId).fold(0.0, (sum, f) => sum + ((f['paid'] as num?)?.toDouble() ?? 0));
  }

  double getStudentPendingFees(String studentId) {
    return getStudentFees(studentId).fold(0.0, (sum, f) => sum + ((f['pending'] as num?)?.toDouble() ?? 0));
  }

  // ─── CERTIFICATE QUERIES ──────────────────────────────
  List<Map<String, dynamic>> getStudentCertificates(String studentId) {
    return _certificates.where((c) => c['studentId'] == studentId).toList();
  }

  void requestCertificate(String studentId, String type, int fee, int processingDays) {
    _certificates.add({
      'certId': 'CERT${(_certificates.length + 1).toString().padLeft(3, '0')}',
      'studentId': studentId,
      'type': type,
      'status': 'pending',
      'requestDate': DateTime.now().toIso8601String().substring(0, 10),
      'fee': fee,
      'processingDays': processingDays,
    });
    notifyListeners();
  }

  // ─── EVENT QUERIES ────────────────────────────────────
  List<Map<String, dynamic>> getUpcomingEvents() {
    return _events.where((e) => e['status'] == 'upcoming').toList();
  }

  List<Map<String, dynamic>> getCompletedEvents() {
    return _events.where((e) => e['status'] == 'completed').toList();
  }

  List<Map<String, dynamic>> getStudentRegisteredEvents(String studentId) {
    final regIds = _eventRegistrations
        .where((r) => r['studentId'] == studentId)
        .map((r) => r['eventId'] as String)
        .toSet();
    return _events.where((e) => regIds.contains(e['eventId'])).toList();
  }

  bool isStudentRegisteredForEvent(String studentId, String eventId) {
    return _eventRegistrations.any((r) => r['studentId'] == studentId && r['eventId'] == eventId);
  }

  void registerForEvent(String studentId, String eventId) {
    if (isStudentRegisteredForEvent(studentId, eventId)) return;
    _eventRegistrations.add({
      'registrationId': 'REG${(_eventRegistrations.length + 1).toString().padLeft(3, '0')}',
      'eventId': eventId,
      'studentId': studentId,
      'registeredDate': DateTime.now().toIso8601String().substring(0, 10),
    });
    final idx = _events.indexWhere((e) => e['eventId'] == eventId);
    if (idx != -1) {
      _events[idx]['registeredCount'] = ((_events[idx]['registeredCount'] as int?) ?? 0) + 1;
    }
    notifyListeners();
  }

  // ─── LEAVE QUERIES ────────────────────────────────────
  List<Map<String, dynamic>> getUserLeave(String userId) {
    return _leave.where((l) => l['userId'] == userId).toList();
  }

  List<Map<String, dynamic>> getUserLeaveBalance(String userId) {
    return _leaveBalance.where((l) => l['userId'] == userId).toList();
  }

  List<Map<String, dynamic>> getStudentLeaveRequests(String facultyId) {
    // Get mentees' leave requests for faculty to approve
    final mentees = getMentees(facultyId);
    final menteeIds = mentees.map((m) => m['studentId'] as String).toSet();
    return _leave.where((l) => menteeIds.contains(l['userId']) && l['status'] == 'pending').toList();
  }

  void applyLeave(Map<String, dynamic> leaveEntry) {
    leaveEntry['leaveId'] = 'LV${(_leave.length + 1).toString().padLeft(3, '0')}';
    leaveEntry['appliedDate'] = DateTime.now().toIso8601String().substring(0, 10);
    leaveEntry['status'] = 'pending';
    _leave.add(leaveEntry);
    notifyListeners();
  }

  // ─── LIBRARY QUERIES ──────────────────────────────────
  List<Map<String, dynamic>> getStudentLibrary(String studentId) {
    return _library.where((b) => b['studentId'] == studentId).toList();
  }

  List<Map<String, dynamic>> getStudentIssuedBooks(String studentId) {
    return _library.where((b) => b['studentId'] == studentId && b['status'] == 'issued').toList();
  }

  List<Map<String, dynamic>> getStudentReturnedBooks(String studentId) {
    return _library.where((b) => b['studentId'] == studentId && b['status'] == 'returned').toList();
  }

  int getStudentOverdueBooks(String studentId) {
    return _library.where((b) => b['studentId'] == studentId && b['status'] == 'overdue').length;
  }

  double getStudentLibraryFines(String studentId) {
    return _library.where((b) => b['studentId'] == studentId && b['fine'] != null)
        .fold(0.0, (sum, b) => sum + ((b['fine'] as num?)?.toDouble() ?? 0));
  }

  // ─── PLACEMENT QUERIES ────────────────────────────────
  List<Map<String, dynamic>> getUpcomingPlacements() {
    return _placements.where((p) => p['status'] == 'upcoming').toList();
  }

  List<Map<String, dynamic>> getCompletedPlacements() {
    return _placements.where((p) => p['status'] == 'completed').toList();
  }

  List<Map<String, dynamic>> getStudentPlacementApplications(String studentId) {
    return _placementApplications.where((a) => a['studentId'] == studentId).toList();
  }

  Map<String, dynamic>? getPlacementById(String placementId) {
    try {
      return _placements.firstWhere((p) => p['placementId'] == placementId);
    } catch (_) {
      return null;
    }
  }

  void applyForPlacement(String studentId, String placementId) {
    _placementApplications.add({
      'applicationId': 'APP${(_placementApplications.length + 1).toString().padLeft(3, '0')}',
      'placementId': placementId,
      'studentId': studentId,
      'status': 'applied',
      'appliedDate': DateTime.now().toIso8601String().substring(0, 10),
    });
    notifyListeners();
  }

  // ─── SYLLABUS QUERIES ─────────────────────────────────
  List<Map<String, dynamic>> getCourseSyllabus(String courseId) {
    return _syllabus.where((s) => s['courseId'] == courseId).toList();
  }

  List<Map<String, dynamic>> getFacultySyllabus(String facultyId) {
    return _syllabus.where((s) => s['facultyId'] == facultyId).toList();
  }

  double getSyllabusProgress(Map<String, dynamic> syllabusEntry) {
    final units = (syllabusEntry['units'] as List<dynamic>?) ?? [];
    if (units.isEmpty) return 0;
    int totalHours = 0, completedHours = 0;
    for (final u in units) {
      totalHours += (u['totalHours'] as int?) ?? 0;
      completedHours += (u['completedHours'] as int?) ?? 0;
    }
    return totalHours > 0 ? (completedHours / totalHours * 100) : 0;
  }

  // ─── COURSE OUTCOMES QUERIES ───────────────────────────
  Map<String, dynamic>? getCourseOutcomeDetails(String courseId) {
    try {
      return _courseOutcomes.firstWhere((c) => c['courseId'] == courseId);
    } catch (_) {
      return null;
    }
  }

  List<Map<String, dynamic>> getFacultyCourseOutcomes(String facultyId) {
    return _courseOutcomes.where((c) => c['facultyId'] == facultyId).toList();
  }

  List<Map<String, dynamic>> getCourseOutcomeCOs(String courseId) {
    final details = getCourseOutcomeDetails(courseId);
    if (details == null) return [];
    return ((details['courseOutcomes'] as List<dynamic>?) ?? []).cast<Map<String, dynamic>>();
  }

  List<Map<String, dynamic>> getCourseUnitCOMapping(String courseId) {
    final details = getCourseOutcomeDetails(courseId);
    if (details == null) return [];
    return ((details['unitCOMapping'] as List<dynamic>?) ?? []).cast<Map<String, dynamic>>();
  }

  void addCourseOutcomeEntry(Map<String, dynamic> entry) {
    final idx = _courseOutcomes.indexWhere((c) => c['courseId'] == entry['courseId']);
    if (idx >= 0) {
      _courseOutcomes[idx] = entry;
    } else {
      _courseOutcomes.add(entry);
    }
    notifyListeners();
  }

  void updateCourseOutcome(String courseId, String coId, Map<String, dynamic> updatedCO) {
    final details = getCourseOutcomeDetails(courseId);
    if (details == null) return;
    final cos = ((details['courseOutcomes'] as List<dynamic>?) ?? []);
    final idx = cos.indexWhere((c) => c['coId'] == coId);
    if (idx >= 0) {
      cos[idx] = updatedCO;
    } else {
      cos.add(updatedCO);
    }
    details['courseOutcomes'] = cos;
    details['lastUpdated'] = DateTime.now().toIso8601String().substring(0, 10);
    notifyListeners();
  }

  void addCOToUnit(String courseId, int unitNo, String coId) {
    final details = getCourseOutcomeDetails(courseId);
    if (details == null) return;
    final mappings = ((details['unitCOMapping'] as List<dynamic>?) ?? []);
    final unitIdx = mappings.indexWhere((m) => m['unitNo'] == unitNo);
    if (unitIdx >= 0) {
      final coList = List<String>.from((mappings[unitIdx]['coList'] as List<dynamic>?) ?? []);
      if (!coList.contains(coId)) {
        coList.add(coId);
        mappings[unitIdx]['coList'] = coList;
      }
    } else {
      mappings.add({'unitNo': unitNo, 'coList': [coId], 'poMapping': []});
    }
    details['lastUpdated'] = DateTime.now().toIso8601String().substring(0, 10);
    notifyListeners();
  }

  // ─── RESEARCH QUERIES ─────────────────────────────────

  // ─── COURSE DIARY / TIMETABLE LOG ─────────────────────
  List<Map<String, dynamic>> getFacultyDiary(String facultyId) {
    return _courseDiary.where((d) => d['facultyId'] == facultyId).toList()
      ..sort((a, b) {
        final cmp = (b['date'] ?? '').compareTo(a['date'] ?? '');
        if (cmp != 0) return cmp;
        return ((a['hour'] as int?) ?? 0).compareTo((b['hour'] as int?) ?? 0);
      });
  }

  List<Map<String, dynamic>> getCourseDiary(String courseId) {
    return _courseDiary.where((d) => d['courseId'] == courseId).toList()
      ..sort((a, b) {
        final cmp = (b['date'] ?? '').compareTo(a['date'] ?? '');
        if (cmp != 0) return cmp;
        return ((a['hour'] as int?) ?? 0).compareTo((b['hour'] as int?) ?? 0);
      });
  }

  List<Map<String, dynamic>> getDiaryByDate(String facultyId, String date) {
    return _courseDiary
        .where((d) => d['facultyId'] == facultyId && d['date'] == date)
        .toList()
      ..sort((a, b) => ((a['hour'] as int?) ?? 0).compareTo((b['hour'] as int?) ?? 0));
  }

  void addDiaryEntry(Map<String, dynamic> entry) {
    entry['diaryId'] = 'DRY${(_courseDiary.length + 1).toString().padLeft(3, '0')}';
    _courseDiary.add(Map<String, dynamic>.from(entry));
    notifyListeners();
  }

  void updateDiaryEntry(String diaryId, Map<String, dynamic> updated) {
    final idx = _courseDiary.indexWhere((d) => d['diaryId'] == diaryId);
    if (idx != -1) {
      _courseDiary[idx] = {..._courseDiary[idx], ...updated};
      notifyListeners();
    }
  }

  int getDiaryEntryCount(String facultyId, String courseId) {
    return _courseDiary
        .where((d) => d['facultyId'] == facultyId && d['courseId'] == courseId)
        .length;
  }

  List<String> getDiaryCoveredTopics(String courseId, int unitNo) {
    return _courseDiary
        .where((d) => d['courseId'] == courseId && d['unitNo'] == unitNo)
        .map((d) => d['topicCovered']?.toString() ?? '')
        .where((t) => t.isNotEmpty)
        .toList();
  }

  // ─── RESEARCH QUERIES (original) ──────────────────────
  List<Map<String, dynamic>> getFacultyResearch(String facultyId) {
    return _research.where((r) => r['facultyId'] == facultyId).toList();
  }

  List<Map<String, dynamic>> getFacultyPublications(String facultyId) {
    return _research.where((r) => r['facultyId'] == facultyId && (r['type'] == 'journal' || r['type'] == 'conference')).toList();
  }

  List<Map<String, dynamic>> getFacultyProjects(String facultyId) {
    return _research.where((r) => r['facultyId'] == facultyId && r['type'] == 'project').toList();
  }

  List<Map<String, dynamic>> getFacultyPhDScholars(String facultyId) {
    return _research.where((r) => r['facultyId'] == facultyId && r['type'] == 'phdScholar').toList();
  }

  int getFacultyTotalCitations(String facultyId) {
    return getFacultyResearch(facultyId).fold(0, (sum, r) => sum + ((r['citations'] as int?) ?? 0));
  }

  // ─── FACULTY TIMETABLE QUERIES ────────────────────────
  List<Map<String, dynamic>> getFacultyTimetableForDay(String facultyId, String day) {
    final entry = _facultyTimetable.where((t) => t['facultyId'] == facultyId && t['day'] == day).toList();
    if (entry.isEmpty) return [];
    final slots = (entry.first['slots'] as List<dynamic>?) ?? [];
    return slots.cast<Map<String, dynamic>>();
  }

  List<String> getFacultyTimetableDays(String facultyId) {
    return _facultyTimetable
        .where((t) => t['facultyId'] == facultyId)
        .map((t) => t['day'] as String)
        .toList();
  }

  int getFacultyWeeklyHours(String facultyId) {
    int total = 0;
    for (final t in _facultyTimetable.where((t) => t['facultyId'] == facultyId)) {
      total += ((t['slots'] as List<dynamic>?)?.length ?? 0);
    }
    return total;
  }

  // ─── FACULTY ATTENDANCE QUERIES ───────────────────────
  List<Map<String, dynamic>> getCourseAttendance(String courseId) {
    return _attendance.where((a) => a['courseId'] == courseId).toList();
  }

  // ─── PROFILE EDIT REQUEST WORKFLOW ────────────────────

  /// Get all edit requests submitted by a user
  List<Map<String, dynamic>> getMyEditRequests(String userId) {
    return _profileEditRequests.where((r) => r['requesterId'] == userId).toList()
      ..sort((a, b) => (b['submittedDate'] ?? '').compareTo(a['submittedDate'] ?? ''));
  }

  /// Get pending requests where this user is the current approver
  /// For mentor: status == 'pending_mentor' && mentorId matches
  /// For classAdviser: status == 'pending_classAdviser' && classAdviserId matches
  /// For hod: status == 'pending_hod' && hod of same dept
  /// For admin: status == 'pending_admin'
  List<Map<String, dynamic>> getPendingApprovals(String userId, String role) {
    return _profileEditRequests.where((r) {
      if (role == 'admin') return r['status'] == 'pending_admin';
      if (role == 'hod') {
        final hodDept = _faculty.firstWhere(
          (f) => f['facultyId'] == userId,
          orElse: () => <String, dynamic>{},
        )['departmentId'];
        // HOD approves faculty requests in their dept
        if (r['status'] == 'pending_hod' &&
            r['requesterRole'] == 'faculty' &&
            r['departmentId'] == hodDept) {
          return true;
        }
        // HOD can also be a mentor or class adviser for student requests
        if (r['requesterRole'] == 'student') {
          final chain = (r['approvalChain'] as List<dynamic>?) ?? [];
          for (final step in chain) {
            final s = step as Map<String, dynamic>;
            if (s['approverId'] == userId && s['status'] == 'pending') {
              if (s['role'] == 'mentor' && r['status'] == 'pending_mentor') return true;
              if (s['role'] == 'classAdviser' && r['status'] == 'pending_classAdviser') return true;
            }
          }
        }
        return false;
      }
      // Faculty as mentor or class adviser for student requests
      if (r['requesterRole'] != 'student') return false;
      final chain = (r['approvalChain'] as List<dynamic>?) ?? [];
      for (final step in chain) {
        final s = step as Map<String, dynamic>;
        if (s['approverId'] == userId && s['status'] == 'pending') {
          if (s['role'] == 'mentor' && r['status'] == 'pending_mentor') return true;
          if (s['role'] == 'classAdviser' && r['status'] == 'pending_classAdviser') return true;
        }
      }
      return false;
    }).toList()
      ..sort((a, b) => (b['submittedDate'] ?? '').compareTo(a['submittedDate'] ?? ''));
  }

  /// Get count of pending approvals for badge
  int getPendingApprovalCount(String userId, String role) {
    return getPendingApprovals(userId, role).length;
  }

  /// Submit a new profile edit request
  void submitProfileEditRequest(Map<String, dynamic> request) {
    request['requestId'] = 'PER${(_profileEditRequests.length + 1).toString().padLeft(3, '0')}';
    request['submittedDate'] = DateTime.now().toIso8601String().substring(0, 10);
    request['lastUpdated'] = request['submittedDate'];
    _profileEditRequests.add(Map<String, dynamic>.from(request));
    notifyListeners();
  }

  /// Approve a step in the chain and advance to next or finalize
  void approveEditRequest(String requestId, String approverId, String remarks) {
    final idx = _profileEditRequests.indexWhere((r) => r['requestId'] == requestId);
    if (idx == -1) return;
    final req = _profileEditRequests[idx];
    final chain = (req['approvalChain'] as List<dynamic>?) ?? [];
    final today = DateTime.now().toIso8601String().substring(0, 10);

    // Find current pending step and approve it
    for (int i = 0; i < chain.length; i++) {
      final step = chain[i] as Map<String, dynamic>;
      if (step['status'] == 'pending') {
        step['status'] = 'approved';
        step['date'] = today;
        step['remarks'] = remarks;
        step['approverId'] = approverId;

        // Find approver name
        final approver = _faculty.firstWhere(
          (f) => f['facultyId'] == approverId,
          orElse: () => <String, dynamic>{},
        );
        step['approverName'] = approver['name'] ?? approverId;

        // Check if there's a next step
        if (i + 1 < chain.length) {
          final nextStep = chain[i + 1] as Map<String, dynamic>;
          final nextRole = nextStep['role'] as String? ?? '';
          req['status'] = 'pending_$nextRole';
          req['currentApprover'] = nextRole;

          // Auto-fill next approver for student requests
          if (nextRole == 'classAdviser' && req['requesterRole'] == 'student') {
            final studentId = req['requesterId'] as String;
            final student = _students.firstWhere(
              (s) => s['studentId'] == studentId,
              orElse: () => <String, dynamic>{},
            );
            final caId = student['classAdviserId'] as String? ?? '';
            final ca = _faculty.firstWhere(
              (f) => f['facultyId'] == caId,
              orElse: () => <String, dynamic>{},
            );
            nextStep['approverId'] = caId;
            nextStep['approverName'] = ca['name'] ?? caId;
          }
        } else {
          // Final approval — apply changes
          _applyProfileChanges(req);
          req['status'] = 'approved';
        }
        break;
      }
    }
    req['lastUpdated'] = today;
    _profileEditRequests[idx] = req;
    notifyListeners();
  }

  /// Reject a request at any step
  void rejectEditRequest(String requestId, String approverId, String remarks) {
    final idx = _profileEditRequests.indexWhere((r) => r['requestId'] == requestId);
    if (idx == -1) return;
    final req = _profileEditRequests[idx];
    final chain = (req['approvalChain'] as List<dynamic>?) ?? [];
    final today = DateTime.now().toIso8601String().substring(0, 10);

    for (final step in chain) {
      final s = step as Map<String, dynamic>;
      if (s['status'] == 'pending') {
        s['status'] = 'rejected';
        s['date'] = today;
        s['remarks'] = remarks;
        s['approverId'] = approverId;
        final approver = _faculty.firstWhere(
          (f) => f['facultyId'] == approverId,
          orElse: () => <String, dynamic>{},
        );
        s['approverName'] = approver['name'] ?? approverId;
        break;
      }
    }
    req['status'] = 'rejected';
    req['lastUpdated'] = today;
    _profileEditRequests[idx] = req;
    notifyListeners();
  }

  /// Apply approved changes to the actual student/faculty record
  void _applyProfileChanges(Map<String, dynamic> req) {
    final changes = (req['changes'] as Map<String, dynamic>?) ?? {};
    if (req['requesterRole'] == 'student') {
      final idx = _students.indexWhere((s) => s['studentId'] == req['requesterId']);
      if (idx != -1) {
        for (final entry in changes.entries) {
          final newVal = (entry.value as Map<String, dynamic>)['new'];
          _students[idx][entry.key] = newVal;
        }
        // Update currentStudent if it's the same user
        if (_currentUserId == req['requesterId']) {
          _currentStudent = _students[idx];
        }
      }
    } else if (req['requesterRole'] == 'faculty') {
      final idx = _faculty.indexWhere((f) => f['facultyId'] == req['requesterId']);
      if (idx != -1) {
        for (final entry in changes.entries) {
          final newVal = (entry.value as Map<String, dynamic>)['new'];
          _faculty[idx][entry.key] = newVal;
        }
        if (_currentUserId == req['requesterId']) {
          _currentFaculty = _faculty[idx];
        }
      }
    }
  }

  /// Get the mentor and class adviser for a student
  Map<String, String> getStudentApprovalChain(String studentId) {
    final student = _students.firstWhere(
      (s) => s['studentId'] == studentId,
      orElse: () => <String, dynamic>{},
    );
    final mentorId = student['mentorId'] as String? ?? '';
    final mentor = _faculty.firstWhere(
      (f) => f['facultyId'] == mentorId,
      orElse: () => <String, dynamic>{},
    );
    final caId = student['classAdviserId'] as String? ?? '';
    final ca = _faculty.firstWhere(
      (f) => f['facultyId'] == caId,
      orElse: () => <String, dynamic>{},
    );
    return {
      'mentorId': mentorId,
      'mentorName': (mentor['name'] as String?) ?? mentorId,
      'classAdviserId': caId,
      'classAdviserName': (ca['name'] as String?) ?? caId,
    };
  }

  /// Get the HOD for a faculty's department
  Map<String, String> getFacultyApprovalChain(String facultyId) {
    final fac = _faculty.firstWhere(
      (f) => f['facultyId'] == facultyId,
      orElse: () => <String, dynamic>{},
    );
    final deptId = fac['departmentId'] as String? ?? '';
    final hod = _faculty.firstWhere(
      (f) => f['departmentId'] == deptId && f['isHOD'] == true,
      orElse: () => <String, dynamic>{},
    );
    return {
      'hodId': (hod['facultyId'] as String?) ?? '',
      'hodName': (hod['name'] as String?) ?? '',
    };
  }

  // ─── USER CRUD OPERATIONS ────────────────────────────
  void deleteStudent(String studentId) {
    _students.removeWhere((s) => s['studentId'] == studentId);
    _users.removeWhere((u) => u['id'] == studentId);
    // Remove from class lists
    for (final c in _classes) {
      final ids = (c['studentIds'] as List<dynamic>?) ?? [];
      ids.remove(studentId);
    }
    // Remove from mentor assignments
    for (final m in _mentorAssignments) {
      final ids = (m['menteeIds'] as List<dynamic>?) ?? [];
      ids.remove(studentId);
    }
    // Remove from faculty menteeIds
    for (final f in _faculty) {
      final ids = (f['menteeIds'] as List<dynamic>?) ?? [];
      ids.remove(studentId);
    }
    if (_currentUserId == studentId) logout();
    notifyListeners();
  }

  void deleteFaculty(String facultyId) {
    final fac = _faculty.firstWhere((f) => f['facultyId'] == facultyId, orElse: () => <String, dynamic>{});
    _faculty.removeWhere((f) => f['facultyId'] == facultyId);
    _users.removeWhere((u) => u['id'] == facultyId);
    // Remove HOD assignment
    if (fac['isHOD'] == true) {
      final deptIdx = _departments.indexWhere((d) => d['hodId'] == facultyId);
      if (deptIdx != -1) _departments[deptIdx]['hodId'] = null;
    }
    // Remove class adviser assignment
    for (final c in _classes) {
      if (c['classAdviserId'] == facultyId) c['classAdviserId'] = null;
    }
    // Remove mentor assignments
    _mentorAssignments.removeWhere((m) => m['mentorId'] == facultyId);
    // Clear students' references
    for (final s in _students) {
      if (s['mentorId'] == facultyId) s['mentorId'] = null;
      if (s['classAdviserId'] == facultyId) s['classAdviserId'] = null;
    }
    if (_currentUserId == facultyId) logout();
    notifyListeners();
  }

  void updateStudent(String studentId, Map<String, dynamic> updates) {
    final idx = _students.indexWhere((s) => s['studentId'] == studentId);
    if (idx != -1) {
      _students[idx].addAll(updates);
      if (_currentUserId == studentId) _currentStudent = _students[idx];
      notifyListeners();
    }
  }

  void updateFaculty(String facultyId, Map<String, dynamic> updates) {
    final idx = _faculty.indexWhere((f) => f['facultyId'] == facultyId);
    if (idx != -1) {
      _faculty[idx].addAll(updates);
      if (_currentUserId == facultyId) _currentFaculty = _faculty[idx];
      notifyListeners();
    }
  }

  // ─── UPLOADED FILES STORAGE ───────────────────────────
  final List<Map<String, dynamic>> _uploadedFiles = [];
  List<Map<String, dynamic>> get uploadedFiles => _uploadedFiles;

  void addUploadedFile(Map<String, dynamic> fileData) {
    fileData['fileId'] = 'FILE${(_uploadedFiles.length + 1).toString().padLeft(4, '0')}';
    fileData['uploadedAt'] = DateTime.now().toIso8601String();
    _uploadedFiles.add(fileData);
    notifyListeners();
  }

  List<Map<String, dynamic>> getUploadedFiles({String? userId, String? category}) {
    return _uploadedFiles.where((f) {
      if (userId != null && f['uploadedBy'] != userId) return false;
      if (category != null && f['category'] != category) return false;
      return true;
    }).toList()
      ..sort((a, b) => (b['uploadedAt'] ?? '').compareTo(a['uploadedAt'] ?? ''));
  }

  void deleteUploadedFile(String fileId) {
    _uploadedFiles.removeWhere((f) => f['fileId'] == fileId);
    notifyListeners();
  }

  // ─── FACULTY COMPLAINTS QUERIES ───────────────────────
  List<Map<String, dynamic>> getFacultyComplaints(String facultyId) {
    // Show complaints from students in faculty's courses or mentees
    final mentees = getMentees(facultyId);
    final menteeIds = mentees.map((m) => m['studentId'] as String).toSet();
    final courseStudentIds = <String>{};
    final facCourses = getFacultyCourses(facultyId);
    for (final c in facCourses) {
      final students = getCourseStudents(c['courseId'] as String);
      courseStudentIds.addAll(students.map((s) => s['studentId'] as String));
    }
    final allIds = menteeIds.union(courseStudentIds);
    return _complaints.where((c) => allIds.contains(c['studentId'])).toList();
  }

  // ─── STUDENT-FILTERED QUERIES ─────────────────────────
  /// Get attendance records for a specific student (by enrolled courses)
  List<Map<String, dynamic>> getStudentAttendanceFiltered(String studentId) {
    final student = getStudentById(studentId);
    if (student == null) return _attendance;
    final enrolled = (student['enrolledCourses'] as List<dynamic>?)?.cast<String>() ?? [];
    if (enrolled.isEmpty) {
      final deptId = student['departmentId'] ?? '';
      return _attendance.where((a) => a['departmentId'] == deptId || enrolled.contains(a['courseId'])).toList();
    }
    return _attendance.where((a) => enrolled.contains(a['courseId'])).toList();
  }

  /// Get assignments for a specific student (by enrolled courses)
  List<Map<String, dynamic>> getStudentAssignmentsFiltered(String studentId) {
    final student = getStudentById(studentId);
    if (student == null) return _assignments;
    final enrolled = (student['enrolledCourses'] as List<dynamic>?)?.cast<String>() ?? [];
    if (enrolled.isEmpty) return _assignments;
    return _assignments.where((a) => enrolled.contains(a['courseId'])).toList();
  }

  /// Get results for a specific student
  List<Map<String, dynamic>> getStudentResultsFiltered(String studentId) {
    final filtered = _results.where((r) => r['studentId'] == studentId).toList();
    if (filtered.isEmpty) return _results; // Fallback: show all if no per-student data
    return filtered;
  }

  /// Get timetable for a specific student's class/section
  List<Map<String, dynamic>> getStudentTimetableForDay(String studentId, String day) {
    final student = getStudentById(studentId);
    if (student == null) return getTimetableForDay(day);
    final deptId = student['departmentId'] ?? '';
    final year = student['year'];
    final section = student['section'];
    final filtered = _timetable.where((t) =>
      t['day'] == day &&
      (t['departmentId'] == deptId || true) && // Fallback if no dept match
      (year == null || t['year'] == year || t['year'] == null) &&
      (section == null || t['section'] == section || t['section'] == null)
    ).toList();
    return filtered.isNotEmpty ? filtered : getTimetableForDay(day);
  }

  /// Get notifications for a specific student (by recipient or global)
  List<Map<String, dynamic>> getStudentNotifications(String studentId) {
    return _notifications.where((n) =>
      n['recipientId'] == studentId ||
      n['recipientId'] == null ||
      n['recipientId'] == 'all' ||
      n['recipientRole'] == 'student' ||
      n['recipientRole'] == null
    ).toList();
  }

  // ─── ASSIGNMENT CRUD ──────────────────────────────────
  void addAssignment(Map<String, dynamic> assignment) {
    assignment['assignmentId'] = 'ASG${(_assignments.length + 1).toString().padLeft(3, '0')}';
    assignment['createdDate'] = DateTime.now().toIso8601String().substring(0, 10);
    if (assignment['status'] == null) assignment['status'] = 'pending';
    _assignments.add(Map<String, dynamic>.from(assignment));
    notifyListeners();
  }

  void updateAssignment(String assignmentId, Map<String, dynamic> updates) {
    final idx = _assignments.indexWhere((a) => a['assignmentId'] == assignmentId);
    if (idx != -1) {
      _assignments[idx].addAll(updates);
      notifyListeners();
    }
  }

  void deleteAssignment(String assignmentId) {
    _assignments.removeWhere((a) => a['assignmentId'] == assignmentId);
    notifyListeners();
  }

  void submitAssignment(String assignmentId, String studentId, String? fileUrl) {
    final idx = _assignments.indexWhere((a) => a['assignmentId'] == assignmentId);
    if (idx != -1) {
      _assignments[idx]['status'] = 'submitted';
      _assignments[idx]['submittedDate'] = DateTime.now().toIso8601String().substring(0, 10);
      _assignments[idx]['submittedBy'] = studentId;
      if (fileUrl != null) _assignments[idx]['fileUrl'] = fileUrl;
      notifyListeners();
    }
  }

  // ─── EXAM CRUD ────────────────────────────────────────
  void addExam(Map<String, dynamic> exam) {
    exam['examId'] = 'EXM${(_exams.length + 1).toString().padLeft(3, '0')}';
    _exams.add(Map<String, dynamic>.from(exam));
    notifyListeners();
  }

  void updateExam(String examId, Map<String, dynamic> updates) {
    final idx = _exams.indexWhere((e) => e['examId'] == examId);
    if (idx != -1) {
      _exams[idx].addAll(updates);
      notifyListeners();
    }
  }

  void deleteExam(String examId) {
    _exams.removeWhere((e) => e['examId'] == examId);
    notifyListeners();
  }

  // ─── NOTIFICATION CRUD ────────────────────────────────
  void addNotification(Map<String, dynamic> notification) {
    notification['notificationId'] = 'NTF${(_notifications.length + 1).toString().padLeft(3, '0')}';
    notification['timestamp'] = DateTime.now().toIso8601String();
    notification['isRead'] = false;
    _notifications.insert(0, Map<String, dynamic>.from(notification));
    notifyListeners();
  }

  void deleteNotification(String notifId) {
    _notifications.removeWhere((n) => n['notificationId'] == notifId);
    notifyListeners();
  }

  // ─── EVENT CRUD ───────────────────────────────────────
  void addEvent(Map<String, dynamic> event) {
    event['eventId'] = 'EVT${(_events.length + 1).toString().padLeft(3, '0')}';
    if (event['status'] == null) event['status'] = 'upcoming';
    event['registeredCount'] = 0;
    _events.add(Map<String, dynamic>.from(event));
    notifyListeners();
  }

  void updateEvent(String eventId, Map<String, dynamic> updates) {
    final idx = _events.indexWhere((e) => e['eventId'] == eventId);
    if (idx != -1) {
      _events[idx].addAll(updates);
      notifyListeners();
    }
  }

  void deleteEvent(String eventId) {
    _events.removeWhere((e) => e['eventId'] == eventId);
    _eventRegistrations.removeWhere((r) => r['eventId'] == eventId);
    notifyListeners();
  }

  // ─── FEE CRUD ─────────────────────────────────────────
  void addFee(Map<String, dynamic> fee) {
    fee['feeId'] = 'FEE${(_fees.length + 1).toString().padLeft(3, '0')}';
    _fees.add(Map<String, dynamic>.from(fee));
    notifyListeners();
  }

  void updateFee(String feeId, Map<String, dynamic> updates) {
    final idx = _fees.indexWhere((f) => f['feeId'] == feeId);
    if (idx != -1) {
      _fees[idx].addAll(updates);
      notifyListeners();
    }
  }

  void recordFeePayment(String feeId, double amount) {
    final idx = _fees.indexWhere((f) => f['feeId'] == feeId);
    if (idx != -1) {
      final current = ((_fees[idx]['paid'] as num?)?.toDouble() ?? 0);
      _fees[idx]['paid'] = current + amount;
      final total = ((_fees[idx]['amount'] as num?)?.toDouble() ?? 0);
      _fees[idx]['pending'] = total - (current + amount);
      if (_fees[idx]['pending'] <= 0) {
        _fees[idx]['status'] = 'paid';
        _fees[idx]['pending'] = 0;
      }
      _fees[idx]['lastPaymentDate'] = DateTime.now().toIso8601String().substring(0, 10);
      notifyListeners();
    }
  }

  // ─── TIMETABLE CRUD ──────────────────────────────────
  void addTimetableEntry(Map<String, dynamic> entry) {
    _timetable.add(Map<String, dynamic>.from(entry));
    notifyListeners();
  }

  void updateTimetableEntry(int index, Map<String, dynamic> updates) {
    if (index >= 0 && index < _timetable.length) {
      _timetable[index].addAll(updates);
      notifyListeners();
    }
  }

  void deleteTimetableEntry(int index) {
    if (index >= 0 && index < _timetable.length) {
      _timetable.removeAt(index);
      notifyListeners();
    }
  }

  // ─── RESULT CRUD ──────────────────────────────────────
  void addResult(Map<String, dynamic> result) {
    result['resultId'] = 'RES${(_results.length + 1).toString().padLeft(3, '0')}';
    _results.add(Map<String, dynamic>.from(result));
    notifyListeners();
  }

  void updateResult(String resultId, Map<String, dynamic> updates) {
    final idx = _results.indexWhere((r) => r['resultId'] == resultId);
    if (idx != -1) {
      _results[idx].addAll(updates);
      notifyListeners();
    }
  }

  // ─── LIBRARY CRUD ─────────────────────────────────────
  void addLibraryBook(Map<String, dynamic> book) {
    book['bookId'] = 'LIB${(_library.length + 1).toString().padLeft(3, '0')}';
    book['status'] = book['status'] ?? 'issued';
    book['issueDate'] = book['issueDate'] ?? DateTime.now().toIso8601String().substring(0, 10);
    _library.add(Map<String, dynamic>.from(book));
    notifyListeners();
  }

  void returnBook(String bookId) {
    final idx = _library.indexWhere((b) => b['bookId'] == bookId);
    if (idx != -1) {
      _library[idx]['status'] = 'returned';
      _library[idx]['returnDate'] = DateTime.now().toIso8601String().substring(0, 10);
      notifyListeners();
    }
  }

  // ─── PLACEMENT CRUD ──────────────────────────────────
  void addPlacement(Map<String, dynamic> placement) {
    placement['placementId'] = 'PLC${(_placements.length + 1).toString().padLeft(3, '0')}';
    if (placement['status'] == null) placement['status'] = 'upcoming';
    placement['registeredCount'] = 0;
    _placements.add(Map<String, dynamic>.from(placement));
    notifyListeners();
  }

  void updatePlacement(String placementId, Map<String, dynamic> updates) {
    final idx = _placements.indexWhere((p) => p['placementId'] == placementId);
    if (idx != -1) {
      _placements[idx].addAll(updates);
      notifyListeners();
    }
  }

  // ─── RESEARCH CRUD ────────────────────────────────────
  void addResearch(Map<String, dynamic> research) {
    research['researchId'] = 'RSH${(_research.length + 1).toString().padLeft(3, '0')}';
    _research.add(Map<String, dynamic>.from(research));
    notifyListeners();
  }

  void updateResearch(String researchId, Map<String, dynamic> updates) {
    final idx = _research.indexWhere((r) => r['researchId'] == researchId);
    if (idx != -1) {
      _research[idx].addAll(updates);
      notifyListeners();
    }
  }

  void deleteResearch(String researchId) {
    _research.removeWhere((r) => r['researchId'] == researchId);
    notifyListeners();
  }

  // ─── SYLLABUS CRUD ────────────────────────────────────
  void addSyllabus(Map<String, dynamic> syllabusEntry) {
    _syllabus.add(Map<String, dynamic>.from(syllabusEntry));
    notifyListeners();
  }

  void updateSyllabus(String courseId, Map<String, dynamic> updates) {
    final idx = _syllabus.indexWhere((s) => s['courseId'] == courseId);
    if (idx != -1) {
      _syllabus[idx].addAll(updates);
      notifyListeners();
    }
  }

  void updateSyllabusUnitProgress(String courseId, int unitNo, int completedHours) {
    final idx = _syllabus.indexWhere((s) => s['courseId'] == courseId);
    if (idx == -1) return;
    final units = (_syllabus[idx]['units'] as List<dynamic>?) ?? [];
    final unitIdx = units.indexWhere((u) => u['unitNo'] == unitNo);
    if (unitIdx >= 0) {
      (units[unitIdx] as Map<String, dynamic>)['completedHours'] = completedHours;
      notifyListeners();
    }
  }

  // ─── COMPLAINT UPDATE ─────────────────────────────────
  void updateComplaintStatus(String complaintId, String status, {String? resolvedBy, String? resolution}) {
    final idx = _complaints.indexWhere((c) => c['complaintId'] == complaintId);
    if (idx != -1) {
      _complaints[idx]['status'] = status;
      if (resolvedBy != null) _complaints[idx]['resolvedBy'] = resolvedBy;
      if (resolution != null) _complaints[idx]['resolution'] = resolution;
      if (status == 'resolved') {
        _complaints[idx]['resolvedDate'] = DateTime.now().toIso8601String().substring(0, 10);
      }
      notifyListeners();
    }
  }

  // ─── DEPARTMENT CRUD ──────────────────────────────────
  void updateDepartment(String departmentId, Map<String, dynamic> updates) {
    final idx = _departments.indexWhere((d) => d['departmentId'] == departmentId);
    if (idx != -1) {
      _departments[idx].addAll(updates);
      notifyListeners();
    }
  }

  void deleteDepartment(String departmentId) {
    _departments.removeWhere((d) => d['departmentId'] == departmentId);
    // Cascade: remove faculty, students, courses, classes in this dept
    _faculty.removeWhere((f) => f['departmentId'] == departmentId);
    _students.removeWhere((s) => s['departmentId'] == departmentId);
    _courses.removeWhere((c) => c['departmentId'] == departmentId);
    _classes.removeWhere((c) => c['departmentId'] == departmentId);
    notifyListeners();
  }

  // ─── COURSE UPDATE/DELETE ─────────────────────────────
  void updateCourse(String courseId, Map<String, dynamic> updates) {
    final idx = _courses.indexWhere((c) => c['courseId'] == courseId);
    if (idx != -1) {
      _courses[idx].addAll(updates);
      notifyListeners();
    }
  }

  void deleteCourse(String courseId) {
    _courses.removeWhere((c) => c['courseId'] == courseId);
    // Remove from student enrollments
    for (final s in _students) {
      final enrolled = (s['enrolledCourses'] as List<dynamic>?) ?? [];
      enrolled.remove(courseId);
    }
    // Remove from faculty courseIds
    for (final f in _faculty) {
      final courseIds = (f['courseIds'] as List<dynamic>?) ?? [];
      courseIds.remove(courseId);
    }
    notifyListeners();
  }

  // ─── CLASS DELETE ─────────────────────────────────────
  void deleteClass(String classId) {
    _classes.removeWhere((c) => c['classId'] == classId);
    notifyListeners();
  }

  // ─── LEAVE APPROVE/REJECT ─────────────────────────────
  void approveLeave(String leaveId, String approvedBy) {
    final idx = _leave.indexWhere((l) => l['leaveId'] == leaveId);
    if (idx != -1) {
      _leave[idx]['status'] = 'approved';
      _leave[idx]['approvedBy'] = approvedBy;
      _leave[idx]['approvedDate'] = DateTime.now().toIso8601String().substring(0, 10);
      // Deduct from leave balance
      final userId = _leave[idx]['userId'] as String? ?? '';
      final leaveType = _leave[idx]['leaveType'] as String? ?? '';
      final balIdx = _leaveBalance.indexWhere((b) => b['userId'] == userId && b['leaveType'] == leaveType);
      if (balIdx != -1) {
        final used = ((_leaveBalance[balIdx]['used'] as int?) ?? 0) + 1;
        _leaveBalance[balIdx]['used'] = used;
        _leaveBalance[balIdx]['remaining'] =
            ((_leaveBalance[balIdx]['total'] as int?) ?? 0) - used;
      }
      notifyListeners();
    }
  }

  void rejectLeave(String leaveId, String rejectedBy, String reason) {
    final idx = _leave.indexWhere((l) => l['leaveId'] == leaveId);
    if (idx != -1) {
      _leave[idx]['status'] = 'rejected';
      _leave[idx]['rejectedBy'] = rejectedBy;
      _leave[idx]['rejectionReason'] = reason;
      notifyListeners();
    }
  }

  // ─── FACULTY TIMETABLE CRUD ───────────────────────────
  void addFacultyTimetableEntry(String facultyId, String day, Map<String, dynamic> slot) {
    final idx = _facultyTimetable.indexWhere((t) => t['facultyId'] == facultyId && t['day'] == day);
    if (idx != -1) {
      final slots = ((_facultyTimetable[idx]['slots'] as List<dynamic>?) ?? []).toList();
      slots.add(slot);
      _facultyTimetable[idx]['slots'] = slots;
    } else {
      _facultyTimetable.add({
        'facultyId': facultyId,
        'day': day,
        'slots': [slot],
      });
    }
    notifyListeners();
  }

  // ─── ATTENDANCE CRUD (Faculty adding attendance) ──────
  void addAttendanceRecord(Map<String, dynamic> record) {
    _attendance.add(Map<String, dynamic>.from(record));
    notifyListeners();
  }

  void updateAttendanceRecord(String courseId, Map<String, dynamic> updates) {
    final idx = _attendance.indexWhere((a) => a['courseId'] == courseId);
    if (idx != -1) {
      _attendance[idx].addAll(updates);
      notifyListeners();
    }
  }

  void markAttendance(String courseId, String studentId, bool present) {
    // Find or create attendance record
    final idx = _attendance.indexWhere((a) => a['courseId'] == courseId && a['studentId'] == studentId);
    if (idx != -1) {
      _attendance[idx]['totalClasses'] = ((_attendance[idx]['totalClasses'] as int?) ?? 0) + 1;
      if (present) {
        _attendance[idx]['attendedClasses'] = ((_attendance[idx]['attendedClasses'] as int?) ?? 0) + 1;
      } else {
        _attendance[idx]['absentClasses'] = ((_attendance[idx]['absentClasses'] as int?) ?? 0) + 1;
      }
      notifyListeners();
    } else {
      _attendance.add({
        'courseId': courseId,
        'studentId': studentId,
        'totalClasses': 1,
        'attendedClasses': present ? 1 : 0,
        'absentClasses': present ? 0 : 1,
      });
      notifyListeners();
    }
  }

  // ─── SETTINGS PERSISTENCE ─────────────────────────────
  void updateSetting(String key, dynamic value) {
    _settings[key] = value;
    notifyListeners();
  }

  dynamic getSetting(String key, [dynamic defaultValue]) {
    return _settings[key] ?? defaultValue;
  }

  Map<String, dynamic> getUserSettings(String userId) {
    return (_settings[userId] as Map<String, dynamic>?) ?? {};
  }

  void updateUserSettings(String userId, Map<String, dynamic> userSettings) {
    _settings[userId] = userSettings;
    notifyListeners();
  }

  // ─── CHANGE PASSWORD ─────────────────────────────────
  bool changePassword(String userId, String oldPassword, String newPassword) {
    final idx = _users.indexWhere((u) => u['id'] == userId && u['password'] == oldPassword);
    if (idx == -1) return false;
    _users[idx]['password'] = newPassword;
    notifyListeners();
    return true;
  }

}
