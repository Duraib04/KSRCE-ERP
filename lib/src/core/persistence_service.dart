import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Handles data persistence via Firebase Realtime Database (cloud, shared
/// across ALL browsers/devices) with localStorage as a fast local cache.
///
/// Write path:  mutation → save to Firebase RTDB + localStorage.
/// Read path:   load from Firebase RTDB (fallback to localStorage if offline).
class PersistenceService {
  static const String _rtdbUrl =
      'https://ksrce-erp-default-rtdb.firebaseio.com';
  static const String _localKey = 'ksrce_erp_data';
  static const String _versionKey = 'ksrce_erp_version';
  static const int _currentVersion = 2;

  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ──────────────────── CLOUD (Firebase RTDB REST) ────────────────────

  /// Save all data to Firebase Realtime Database (cloud).
  static Future<bool> saveToCloud(
      Map<String, dynamic> data) async {
    try {
      final resp = await http
          .put(
            Uri.parse('$_rtdbUrl/erp_data.json'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(data),
          )
          .timeout(const Duration(seconds: 10));
      return resp.statusCode == 200;
    } catch (e) {
      debugPrint('Cloud save failed: $e');
      return false;
    }
  }

  /// Load all data from Firebase Realtime Database.
  /// Returns null on failure (offline / first run).
  static Future<Map<String, dynamic>?> loadFromCloud() async {
    try {
      final resp = await http
          .get(Uri.parse('$_rtdbUrl/erp_data.json'))
          .timeout(const Duration(seconds: 10));
      if (resp.statusCode == 200 && resp.body != 'null') {
        return Map<String, dynamic>.from(json.decode(resp.body));
      }
    } catch (e) {
      debugPrint('Cloud load failed: $e');
    }
    return null;
  }

  /// Delete all cloud data (for "Reset Database").
  static Future<void> clearCloud() async {
    try {
      await http
          .delete(Uri.parse('$_rtdbUrl/erp_data.json'))
          .timeout(const Duration(seconds: 10));
    } catch (e) {
      debugPrint('Cloud clear failed: $e');
    }
  }

  // ──────────────────── LOCAL CACHE (SharedPreferences) ───────────────

  /// Returns true if localStorage has cached data.
  static bool hasLocalData() {
    return _prefs?.containsKey(_localKey) ?? false;
  }

  /// Save to local cache (fast, synchronous-feeling).
  static Future<void> saveLocal(Map<String, dynamic> data) async {
    if (_prefs == null) await init();
    await _prefs!.setString(_localKey, json.encode(data));
    await _prefs!.setInt(_versionKey, _currentVersion);
  }

  /// Load from local cache.
  static Map<String, dynamic>? loadLocal() {
    if (_prefs == null) return null;
    final s = _prefs!.getString(_localKey);
    if (s == null) return null;
    try {
      return Map<String, dynamic>.from(json.decode(s));
    } catch (_) {
      return null;
    }
  }

  /// Clear all local + cloud data.
  static Future<void> clearAll() async {
    if (_prefs == null) await init();
    await _prefs!.remove(_localKey);
    await _prefs!.remove(_versionKey);
    await clearCloud();
  }

  // ──────────────────── UNIFIED API ──────────────────────────────────

  /// Save data to BOTH cloud and local cache.
  static Future<void> saveAll(Map<String, dynamic> data) async {
    // Save locally first (instant)
    await saveLocal(data);
    // Then push to cloud (async, non-blocking)
    saveToCloud(data);
  }

  /// Load data: try cloud first (shared, up-to-date), then local cache.
  static Future<Map<String, dynamic>?> loadAll() async {
    // Try cloud first — this is the shared source of truth
    final cloud = await loadFromCloud();
    if (cloud != null) {
      // Update local cache with cloud data
      await saveLocal(cloud);
      return cloud;
    }
    // Fallback to local cache if offline
    return loadLocal();
  }
}
