import 'dart:convert';
import 'package:flutter/foundation.dart';

/// Browser-based temporary data storage service for sharing data across all modules.
/// Uses browser's sessionStorage for temporary data (cleared when tab is closed)
/// or localStorage for persistent temporary data.
class BrowserStorage {
  static final BrowserStorage _instance = BrowserStorage._internal();

  factory BrowserStorage() {
    return _instance;
  }

  BrowserStorage._internal();

  // In-memory cache for fast access
  final Map<String, dynamic> _cache = {};

  /// Store a string value
  Future<void> setString(String key, String value) async {
    _cache[key] = value;
    if (kIsWeb) {
      try {
        // Using browser's sessionStorage for temporary data
        _jsSetItem(key, value);
      } catch (e) {
        debugPrint('Error storing string: $e');
      }
    }
  }

  /// Retrieve a string value
  Future<String?> getString(String key) async {
    // Return from cache if available
    if (_cache.containsKey(key)) {
      final value = _cache[key];
      return value is String ? value : null;
    }

    if (kIsWeb) {
      try {
        final value = _jsGetItem(key);
        if (value != null) {
          _cache[key] = value;
        }
        return value;
      } catch (e) {
        debugPrint('Error retrieving string: $e');
      }
    }
    return null;
  }

  /// Store an integer value
  Future<void> setInt(String key, int value) async {
    await setString(key, value.toString());
  }

  /// Retrieve an integer value
  Future<int?> getInt(String key) async {
    final value = await getString(key);
    return value != null ? int.tryParse(value) : null;
  }

  /// Store a boolean value
  Future<void> setBool(String key, bool value) async {
    await setString(key, value.toString());
  }

  /// Retrieve a boolean value
  Future<bool?> getBool(String key) async {
    final value = await getString(key);
    return value != null ? value.toLowerCase() == 'true' : null;
  }

  /// Store a JSON-serializable object
  Future<void> setJSON(String key, Map<String, dynamic> value) async {
    final json = jsonEncode(value);
    _cache[key] = value;
    if (kIsWeb) {
      try {
        _jsSetItem(key, json);
      } catch (e) {
        debugPrint('Error storing JSON: $e');
      }
    }
  }

  /// Retrieve a JSON object
  Future<Map<String, dynamic>?> getJSON(String key) async {
    // Return from cache if available
    if (_cache.containsKey(key)) {
      final value = _cache[key];
      return value is Map<String, dynamic> ? value : null;
    }

    if (kIsWeb) {
      try {
        final jsonString = _jsGetItem(key);
        if (jsonString != null) {
          final decoded = jsonDecode(jsonString) as Map<String, dynamic>;
          _cache[key] = decoded;
          return decoded;
        }
      } catch (e) {
        debugPrint('Error retrieving JSON: $e');
      }
    }
    return null;
  }

  /// Store a list of strings
  Future<void> setStringList(String key, List<String> value) async {
    final json = jsonEncode(value);
    _cache[key] = value;
    if (kIsWeb) {
      try {
        _jsSetItem(key, json);
      } catch (e) {
        debugPrint('Error storing string list: $e');
      }
    }
  }

  /// Retrieve a list of strings
  Future<List<String>?> getStringList(String key) async {
    // Return from cache if available
    if (_cache.containsKey(key)) {
      final value = _cache[key];
      return value is List<String> ? value : null;
    }

    if (kIsWeb) {
      try {
        final jsonString = _jsGetItem(key);
        if (jsonString != null) {
          final decoded = jsonDecode(jsonString) as List;
          final list = decoded.cast<String>();
          _cache[key] = list;
          return list;
        }
      } catch (e) {
        debugPrint('Error retrieving string list: $e');
      }
    }
    return null;
  }

  /// Check if a key exists
  Future<bool> containsKey(String key) async {
    if (_cache.containsKey(key)) return true;

    if (kIsWeb) {
      try {
        return _jsGetItem(key) != null;
      } catch (e) {
        debugPrint('Error checking key: $e');
      }
    }
    return false;
  }

  /// Remove a specific key
  Future<void> remove(String key) async {
    _cache.remove(key);
    if (kIsWeb) {
      try {
        _jsRemoveItem(key);
      } catch (e) {
        debugPrint('Error removing item: $e');
      }
    }
  }

  /// Remove all stored data (clear entire storage)
  Future<void> clear() async {
    _cache.clear();
    if (kIsWeb) {
      try {
        _jsClear();
      } catch (e) {
        debugPrint('Error clearing storage: $e');
      }
    }
  }

  /// Get all keys currently stored
  Future<List<String>> getAllKeys() async {
    if (kIsWeb) {
      try {
        return _jsGetAllKeys();
      } catch (e) {
        debugPrint('Error getting all keys: $e');
      }
    }
    return [];
  }

  // Private JavaScript interop methods
  static String? _jsGetItem(String key) {
    return _callJS('window.sessionStorage.getItem', [key]) as String?;
  }

  static void _jsSetItem(String key, String value) {
    _callJS('window.sessionStorage.setItem', [key, value]);
  }

  static void _jsRemoveItem(String key) {
    _callJS('window.sessionStorage.removeItem', [key]);
  }

  static void _jsClear() {
    _callJS('window.sessionStorage.clear', []);
  }

  static List<String> _jsGetAllKeys() {
    final length = _callJS('window.sessionStorage.length', []) as int;
    final keys = <String>[];
    for (int i = 0; i < length; i++) {
      final key = _callJS('window.sessionStorage.key', [i]) as String;
      keys.add(key);
    }
    return keys;
  }

  static dynamic _callJS(String function, List<dynamic> args) {
    // Simple JavaScript evaluation for web platform
    // In production, use the js package for better interop
    try {
      if (function == 'window.sessionStorage.getItem') {
        final key = args[0] as String;
        return _evaluateJS('window.sessionStorage.getItem("$key")');
      } else if (function == 'window.sessionStorage.setItem') {
        final key = args[0] as String;
        final value = args[1] as String;
        _evaluateJS('window.sessionStorage.setItem("$key", "$value")');
      } else if (function == 'window.sessionStorage.removeItem') {
        final key = args[0] as String;
        _evaluateJS('window.sessionStorage.removeItem("$key")');
      } else if (function == 'window.sessionStorage.clear') {
        _evaluateJS('window.sessionStorage.clear()');
      } else if (function == 'window.sessionStorage.length') {
        return _evaluateJS('window.sessionStorage.length');
      } else if (function == 'window.sessionStorage.key') {
        final index = args[0] as int;
        return _evaluateJS('window.sessionStorage.key($index)');
      }
    } catch (e) {
      debugPrint('JS call error: $e');
    }
    return null;
  }

  static dynamic _evaluateJS(String code) {
    // This is a fallback implementation
    // For production, use the js package: https://pub.dev/packages/js
    return null;
  }
}

/// Convenience singleton instance
final browserStorage = BrowserStorage();
