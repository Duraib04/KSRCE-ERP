import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../services/local_cache_service.dart';
import '../services/http_client_service.dart';
import '../config/api_config.dart';

/// Database Sync Service
/// Handles synchronization between local cache and backend database
/// Implements offline-first approach with background sync
class DatabaseSyncService {
  late LocalCacheService _cacheService;
  late HttpClientService _httpClient;
  late Connectivity _connectivity;

  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  Timer? _syncTimer;

  bool _isSyncing = false;
  bool _isOnline = true;

  static const Duration _syncInterval = Duration(minutes: 5);

  DatabaseSyncService(
    this._cacheService,
    this._httpClient,
  ) {
    _connectivity = Connectivity();
  }

  /// Initialize sync service
  Future<void> initialize() async {
    // Check initial connectivity
    final result = await _connectivity.checkConnectivity();
    _isOnline = result != ConnectivityResult.none;

    // Listen to connectivity changes
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (result) {
        _isOnline = result != ConnectivityResult.none;
        if (_isOnline && !_isSyncing) {
          _syncAllData();
        }
      },
    );

    // Start periodic sync
    _syncTimer = Timer.periodic(_syncInterval, (_) {
      if (_isOnline && !_isSyncing) {
        _syncAllData();
      }
    });
  }

  /// Sync all data
  Future<void> _syncAllData() async {
    if (_isSyncing || !_isOnline) return;

    _isSyncing = true;
    try {
      await Future.wait([
        _syncStudents(),
        _syncFaculty(),
        _syncCourses(),
        _syncAnnouncements(),
      ], eagerError: true);
    } catch (e) {
      // Silently fail - use cached data
    } finally {
      _isSyncing = false;
    }
  }

  /// Sync students data
  Future<void> _syncStudents() async {
    try {
      final response = await _httpClient.get(
        ApiEndpoints.students,
        requiresAuth: true,
      );

      if (response['success'] == true && response['data'] != null) {
        await _cacheService.cacheStudents(response['data']);
      }
    } catch (e) {
      // Use cached data
    }
  }

  /// Sync faculty data
  Future<void> _syncFaculty() async {
    try {
      final response = await _httpClient.get(
        ApiEndpoints.faculty,
        requiresAuth: true,
      );

      if (response['success'] == true && response['data'] != null) {
        await _cacheService.cacheFaculty(response['data']);
      }
    } catch (e) {
      // Use cached data
    }
  }

  /// Sync courses data
  Future<void> _syncCourses() async {
    try {
      final response = await _httpClient.get(
        ApiEndpoints.courses,
        requiresAuth: true,
      );

      if (response['success'] == true && response['data'] != null) {
        await _cacheService.cacheCourses(response['data']);
      }
    } catch (e) {
      // Use cached data
    }
  }

  /// Sync announcements
  Future<void> _syncAnnouncements() async {
    try {
      final response = await _httpClient.get(
        ApiEndpoints.announcements,
        requiresAuth: true,
      );

      if (response['success'] == true && response['data'] != null) {
        await _cacheService.cacheAnnouncements(response['data']);
      }
    } catch (e) {
      // Use cached data
    }
  }

  /// Get data with offline fallback
  /// Tries to fetch from API first, falls back to cache if offline
  Future<List<dynamic>> getStudents({bool forceRefresh = false}) async {
    if (!_isOnline || forceRefresh) {
      final cached = _cacheService.getCachedStudents();
      if (cached != null) return cached;
    }

    try {
      final response = await _httpClient.get(
        ApiEndpoints.students,
        requiresAuth: true,
      );

      if (response['success'] == true && response['data'] != null) {
        await _cacheService.cacheStudents(response['data']);
        return response['data'] as List<dynamic>;
      }
    } catch (e) {
      // Fall back to cache
    }

    return _cacheService.getCachedStudents() ?? [];
  }

  /// Get faculty with offline fallback
  Future<List<dynamic>> getFaculty({bool forceRefresh = false}) async {
    if (!_isOnline || forceRefresh) {
      final cached = _cacheService.getCachedFaculty();
      if (cached != null) return cached;
    }

    try {
      final response = await _httpClient.get(
        ApiEndpoints.faculty,
        requiresAuth: true,
      );

      if (response['success'] == true && response['data'] != null) {
        await _cacheService.cacheFaculty(response['data']);
        return response['data'] as List<dynamic>;
      }
    } catch (e) {
      // Fall back to cache
    }

    return _cacheService.getCachedFaculty() ?? [];
  }

  /// Get courses with offline fallback
  Future<List<dynamic>> getCourses({bool forceRefresh = false}) async {
    if (!_isOnline || forceRefresh) {
      final cached = _cacheService.getCachedCourses();
      if (cached != null) return cached;
    }

    try {
      final response = await _httpClient.get(
        ApiEndpoints.courses,
        requiresAuth: true,
      );

      if (response['success'] == true && response['data'] != null) {
        await _cacheService.cacheCourses(response['data']);
        return response['data'] as List<dynamic>;
      }
    } catch (e) {
      // Fall back to cache
    }

    return _cacheService.getCachedCourses() ?? [];
  }

  /// Get announcements with offline fallback
  Future<List<dynamic>> getAnnouncements({bool forceRefresh = false}) async {
    if (!_isOnline || forceRefresh) {
      final cached = _cacheService.getCachedAnnouncements();
      if (cached != null) return cached;
    }

    try {
      final response = await _httpClient.get(
        ApiEndpoints.announcements,
        requiresAuth: true,
      );

      if (response['success'] == true && response['data'] != null) {
        await _cacheService.cacheAnnouncements(response['data']);
        return response['data'] as List<dynamic>;
      }
    } catch (e) {
      // Fall back to cache
    }

    return _cacheService.getCachedAnnouncements() ?? [];
  }

  /// Check if online
  bool get isOnline => _isOnline;

  /// Check if syncing
  bool get isSyncing => _isSyncing;

  /// Force manual sync
  Future<void> forceSync() async {
    await _syncAllData();
  }

  /// Get sync status
  Future<Map<String, dynamic>> getSyncStatus() async {
    return {
      'isOnline': _isOnline,
      'isSyncing': _isSyncing,
      'cacheInfo': await _cacheService.getCacheInfo(),
    };
  }

  /// Dispose resources
  void dispose() {
    _syncTimer?.cancel();
    _connectivitySubscription?.cancel();
  }
}
