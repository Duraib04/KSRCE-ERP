import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Handles localStorage persistence for all app data.
/// On first run, data is seeded from assets/data/*.json.
/// Every mutation saves the full dataset to localStorage so
/// changes survive a browser refresh.
class PersistenceService {
  static const String _storageKey = 'ksrce_erp_data';
  static const String _versionKey = 'ksrce_erp_version';
  static const int _currentVersion = 1;

  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Returns true if we have persisted data from a previous session.
  static bool hasPersistedData() {
    return _prefs?.containsKey(_storageKey) ?? false;
  }

  /// Save all data collections to localStorage as a single JSON blob.
  static Future<void> saveAll(Map<String, List<Map<String, dynamic>>> data) async {
    if (_prefs == null) await init();
    final jsonStr = json.encode(data);
    await _prefs!.setString(_storageKey, jsonStr);
    await _prefs!.setInt(_versionKey, _currentVersion);
  }

  /// Load all data from localStorage.
  /// Returns null if no persisted data exists.
  static Map<String, List<Map<String, dynamic>>>? loadAll() {
    if (_prefs == null) return null;
    final jsonStr = _prefs!.getString(_storageKey);
    if (jsonStr == null) return null;
    try {
      final Map<String, dynamic> raw = json.decode(jsonStr);
      final result = <String, List<Map<String, dynamic>>>{};
      for (final entry in raw.entries) {
        final list = (entry.value as List<dynamic>)
            .map((e) => Map<String, dynamic>.from(e as Map))
            .toList();
        result[entry.key] = list;
      }
      return result;
    } catch (e) {
      return null;
    }
  }

  /// Clear all persisted data (for "Reset Database" feature).
  static Future<void> clearAll() async {
    if (_prefs == null) await init();
    await _prefs!.remove(_storageKey);
    await _prefs!.remove(_versionKey);
  }
}
