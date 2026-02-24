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

  // Logged in user info
  String? _currentUserId;
  String? _currentRole;
  Map<String, dynamic>? _currentStudent;

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
  String? get currentUserId => _currentUserId;
  String? get currentRole => _currentRole;
  Map<String, dynamic>? get currentStudent => _currentStudent;

  Future<void> loadAllData() async {
    if (_isLoaded) return;
    try {
      final futures = await Future.wait([
        _loadJson('assets/data/students.json'),
        _loadJson('assets/data/users.json'),
        _loadJson('assets/data/courses.json'),
        _loadJson('assets/data/attendance.json'),
        _loadJson('assets/data/assignments.json'),
        _loadJson('assets/data/results.json'),
        _loadJson('assets/data/timetable.json'),
        _loadJson('assets/data/notifications.json'),
        _loadJson('assets/data/complaints.json'),
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

  // Auth methods
  bool login(String userId, String password) {
    for (final user in _users) {
      if (user['id'] == userId && user['password'] == password) {
        _currentUserId = userId;
        if (userId.startsWith('STU')) {
          _currentRole = 'student';
          _currentStudent = _students.firstWhere(
            (s) => s['studentId'] == userId,
            orElse: () => <String, dynamic>{},
          );
        } else if (userId.startsWith('FAC')) {
          _currentRole = 'faculty';
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
    notifyListeners();
  }

  // Data query helpers
  List<Map<String, dynamic>> getStudentCourses(String studentId) {
    // For demo, return all courses for CSE department
    return _courses.where((c) => c['department'] == 'Computer Science').toList();
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

  // Add new complaint
  void addComplaint(Map<String, dynamic> complaint) {
    complaint['complaintId'] = 'CMP${(_complaints.length + 1).toString().padLeft(3, '0')}';
    complaint['submittedDate'] = DateTime.now().toIso8601String().substring(0, 10);
    complaint['status'] = 'pending';
    _complaints.add(complaint);
    notifyListeners();
  }

  // Get overall attendance percentage
  double get overallAttendancePercentage {
    if (_attendance.isEmpty) return 0;
    int totalPresent = 0, totalClasses = 0;
    for (final a in _attendance) {
      totalPresent += (a['attendedClasses'] as int? ?? 0);
      totalClasses += (a['totalClasses'] as int? ?? 0);
    }
    return totalClasses > 0 ? (totalPresent / totalClasses * 100) : 0;
  }

  // Get CGPA
  double get currentCGPA {
    if (_currentStudent != null && _currentStudent!['cgpa'] != null) {
      return (_currentStudent!['cgpa'] as num).toDouble();
    }
    return 8.5;
  }

  // Faculty helpers
  List<Map<String, dynamic>> getFacultyCourses(String facultyId) {
    return _courses.where((c) => c['facultyId'] == facultyId).toList();
  }

  int get pendingAssignmentsCount {
    return _assignments.where((a) => a['status'] == 'pending').length;
  }
}
