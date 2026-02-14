import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// Local Cache Service
/// Manages offline data storage using SharedPreferences
/// This enables offline-first approach for the application
class LocalCacheService {
  late SharedPreferences _preferences;

  static const String _studentsCacheKey = 'cached_students';
  static const String _facultyCacheKey = 'cached_faculty';
  static const String _coursesCacheKey = 'cached_courses';
  static const String _announcementsCacheKey = 'cached_announcements';
  static const String _userProfileCacheKey = 'cached_user_profile';
  static const String _lastSyncKey = 'last_sync_time';
  // ignore: unused_field
  static const String _cacheVersionKey = 'cache_version';

  // ignore: unused_field
  static const int _cacheVersion = 1;
  static const Duration _cacheDuration = Duration(hours: 24);

  LocalCacheService(this._preferences);

  /// Cache list of students
  Future<void> cacheStudents(List<dynamic> students) async {
    try {
      final jsonData = jsonEncode(students);
      await _preferences.setString(_studentsCacheKey, jsonData);
      await _updateLastSync();
    } catch (e) {
      throw Exception('Failed to cache students: $e');
    }
  }

  /// Get cached students
  List<dynamic>? getCachedStudents() {
    try {
      final jsonData = _preferences.getString(_studentsCacheKey);
      if (jsonData == null) return null;

      if (_isCacheExpired()) {
        clearStudentsCache();
        return null;
      }

      return jsonDecode(jsonData) as List<dynamic>;
    } catch (e) {
      clearStudentsCache();
      return null;
    }
  }

  /// Cache list of faculty
  Future<void> cacheFaculty(List<dynamic> faculty) async {
    try {
      final jsonData = jsonEncode(faculty);
      await _preferences.setString(_facultyCacheKey, jsonData);
      await _updateLastSync();
    } catch (e) {
      throw Exception('Failed to cache faculty: $e');
    }
  }

  /// Get cached faculty
  List<dynamic>? getCachedFaculty() {
    try {
      final jsonData = _preferences.getString(_facultyCacheKey);
      if (jsonData == null) return null;

      if (_isCacheExpired()) {
        clearFacultyCache();
        return null;
      }

      return jsonDecode(jsonData) as List<dynamic>;
    } catch (e) {
      clearFacultyCache();
      return null;
    }
  }

  /// Cache courses
  Future<void> cacheCourses(List<dynamic> courses) async {
    try {
      final jsonData = jsonEncode(courses);
      await _preferences.setString(_coursesCacheKey, jsonData);
      await _updateLastSync();
    } catch (e) {
      throw Exception('Failed to cache courses: $e');
    }
  }

  /// Get cached courses
  List<dynamic>? getCachedCourses() {
    try {
      final jsonData = _preferences.getString(_coursesCacheKey);
      if (jsonData == null) return null;

      if (_isCacheExpired()) {
        clearCoursesCache();
        return null;
      }

      return jsonDecode(jsonData) as List<dynamic>;
    } catch (e) {
      clearCoursesCache();
      return null;
    }
  }

  /// Cache announcements
  Future<void> cacheAnnouncements(List<dynamic> announcements) async {
    try {
      final jsonData = jsonEncode(announcements);
      await _preferences.setString(_announcementsCacheKey, jsonData);
      await _updateLastSync();
    } catch (e) {
      throw Exception('Failed to cache announcements: $e');
    }
  }

  /// Get cached announcements
  List<dynamic>? getCachedAnnouncements() {
    try {
      final jsonData = _preferences.getString(_announcementsCacheKey);
      if (jsonData == null) return null;

      return jsonDecode(jsonData) as List<dynamic>;
    } catch (e) {
      clearAnnouncementsCache();
      return null;
    }
  }

  /// Cache user profile
  Future<void> cacheUserProfile(Map<String, dynamic> profile) async {
    try {
      final jsonData = jsonEncode(profile);
      await _preferences.setString(_userProfileCacheKey, jsonData);
    } catch (e) {
      throw Exception('Failed to cache user profile: $e');
    }
  }

  /// Get cached user profile
  Map<String, dynamic>? getCachedUserProfile() {
    try {
      final jsonData = _preferences.getString(_userProfileCacheKey);
      if (jsonData == null) return null;

      return jsonDecode(jsonData) as Map<String, dynamic>;
    } catch (e) {
      clearUserProfileCache();
      return null;
    }
  }

  /// Get last sync time
  DateTime? getLastSyncTime() {
    try {
      final timeStr = _preferences.getString(_lastSyncKey);
      if (timeStr == null) return null;
      return DateTime.parse(timeStr);
    } catch (e) {
      return null;
    }
  }

  /// Check if cache has expired
  bool _isCacheExpired() {
    final lastSync = getLastSyncTime();
    if (lastSync == null) return true;

    return DateTime.now().difference(lastSync).compareTo(_cacheDuration) > 0;
  }

  /// Update last sync time
  Future<void> _updateLastSync() async {
    try {
      await _preferences.setString(_lastSyncKey, DateTime.now().toIso8601String());
    } catch (e) {
      // Silently fail
    }
  }

  /// Clear all caches
  Future<void> clearAllCache() async {
    try {
      await Future.wait([
        clearStudentsCache(),
        clearFacultyCache(),
        clearCoursesCache(),
        clearAnnouncementsCache(),
        clearUserProfileCache(),
      ]);
    } catch (e) {
      throw Exception('Failed to clear all cache: $e');
    }
  }

  /// Clear specific caches
  Future<void> clearStudentsCache() async {
    await _preferences.remove(_studentsCacheKey);
  }

  Future<void> clearFacultyCache() async {
    await _preferences.remove(_facultyCacheKey);
  }

  Future<void> clearCoursesCache() async {
    await _preferences.remove(_coursesCacheKey);
  }

  Future<void> clearAnnouncementsCache() async {
    await _preferences.remove(_announcementsCacheKey);
  }

  Future<void> clearUserProfileCache() async {
    await _preferences.remove(_userProfileCacheKey);
  }

  /// Get cache size info
  Future<Map<String, dynamic>> getCacheInfo() async {
    final lastSync = getLastSyncTime();
    final cacheSize = _calculateCacheSize();

    return {
      'lastSync': lastSync,
      'cacheSize': cacheSize,
      'cacheExpired': _isCacheExpired(),
      'hasStudents': getCachedStudents() != null,
      'hasFaculty': getCachedFaculty() != null,
      'hasCourses': getCachedCourses() != null,
      'hasAnnouncements': getCachedAnnouncements() != null,
    };
  }

  /// Calculate total cache size in bytes
  int _calculateCacheSize() {
    int size = 0;

    final students = _preferences.getString(_studentsCacheKey) ?? '';
    final faculty = _preferences.getString(_facultyCacheKey) ?? '';
    final courses = _preferences.getString(_coursesCacheKey) ?? '';
    final announcements = _preferences.getString(_announcementsCacheKey) ?? '';
    final profile = _preferences.getString(_userProfileCacheKey) ?? '';

    size = students.length + faculty.length + courses.length + announcements.length + profile.length;

    return size;
  }
}
