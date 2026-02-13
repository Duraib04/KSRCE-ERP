import 'dart:convert';
import 'package:flutter/foundation.dart';

/// Shared data model for cross-module communication via browser storage
class SharedDataService {
  static final SharedDataService _instance = SharedDataService._internal();

  factory SharedDataService() {
    return _instance;
  }

  SharedDataService._internal();

  // Keys for browser storage
  static const String _userDataKey = 'shared_user_data';
  static const String _roleKey = 'shared_user_role';
  static const String _filtersKey = 'shared_filters';
  static const String _navigationStateKey = 'shared_nav_state';
  static const String _formDataKey = 'shared_form_data';
  static const String _tempDataKey = 'shared_temp_data';

  // In-memory cache
  final Map<String, dynamic> _cache = {};

  /// Store user data for sharing across modules
  Future<void> setUserData(Map<String, dynamic> userData) async {
    _cache[_userDataKey] = userData;
    if (kIsWeb) {
      try {
        final json = jsonEncode(userData);
        // Store using browser API
        _storeData(_userDataKey, json);
      } catch (e) {
        debugPrint('Error storing user data: $e');
      }
    }
  }

  /// Get shared user data
  Future<Map<String, dynamic>?> getUserData() async {
    if (_cache.containsKey(_userDataKey)) {
      return _cache[_userDataKey] as Map<String, dynamic>?;
    }

    if (kIsWeb) {
      try {
        final data = _retrieveData(_userDataKey);
        if (data != null) {
          final decoded = jsonDecode(data) as Map<String, dynamic>;
          _cache[_userDataKey] = decoded;
          return decoded;
        }
      } catch (e) {
        debugPrint('Error retrieving user data: $e');
      }
    }
    return null;
  }

  /// Store user role for shared access
  Future<void> setUserRole(String role) async {
    _cache[_roleKey] = role;
    if (kIsWeb) {
      _storeData(_roleKey, role);
    }
  }

  /// Get shared user role
  Future<String?> getUserRole() async {
    if (_cache.containsKey(_roleKey)) {
      return _cache[_roleKey] as String?;
    }

    if (kIsWeb) {
      final role = _retrieveData(_roleKey);
      if (role != null) {
        _cache[_roleKey] = role;
      }
      return role;
    }
    return null;
  }

  /// Store filters for shared access (useful across dashboard pages)
  Future<void> setFilters(Map<String, dynamic> filters) async {
    _cache[_filtersKey] = filters;
    if (kIsWeb) {
      try {
        final json = jsonEncode(filters);
        _storeData(_filtersKey, json);
      } catch (e) {
        debugPrint('Error storing filters: $e');
      }
    }
  }

  /// Get shared filters
  Future<Map<String, dynamic>?> getFilters() async {
    if (_cache.containsKey(_filtersKey)) {
      return _cache[_filtersKey] as Map<String, dynamic>?;
    }

    if (kIsWeb) {
      try {
        final data = _retrieveData(_filtersKey);
        if (data != null) {
          final decoded = jsonDecode(data) as Map<String, dynamic>;
          _cache[_filtersKey] = decoded;
          return decoded;
        }
      } catch (e) {
        debugPrint('Error retrieving filters: $e');
      }
    }
    return null;
  }

  /// Store navigation state for breadcrumb/history
  Future<void> setNavigationState(Map<String, dynamic> state) async {
    _cache[_navigationStateKey] = state;
    if (kIsWeb) {
      try {
        final json = jsonEncode(state);
        _storeData(_navigationStateKey, json);
      } catch (e) {
        debugPrint('Error storing navigation state: $e');
      }
    }
  }

  /// Get navigation state
  Future<Map<String, dynamic>?> getNavigationState() async {
    if (_cache.containsKey(_navigationStateKey)) {
      return _cache[_navigationStateKey] as Map<String, dynamic>?;
    }

    if (kIsWeb) {
      try {
        final data = _retrieveData(_navigationStateKey);
        if (data != null) {
          final decoded = jsonDecode(data) as Map<String, dynamic>;
          _cache[_navigationStateKey] = decoded;
          return decoded;
        }
      } catch (e) {
        debugPrint('Error retrieving navigation state: $e');
      }
    }
    return null;
  }

  /// Store form data (for multi-step forms)
  Future<void> setFormData(String formId, Map<String, dynamic> data) async {
    final formKey = '$_formDataKey:$formId';
    _cache[formKey] = data;
    if (kIsWeb) {
      try {
        final json = jsonEncode(data);
        _storeData(formKey, json);
      } catch (e) {
        debugPrint('Error storing form data: $e');
      }
    }
  }

  /// Get form data
  Future<Map<String, dynamic>?> getFormData(String formId) async {
    final formKey = '$_formDataKey:$formId';
    if (_cache.containsKey(formKey)) {
      return _cache[formKey] as Map<String, dynamic>?;
    }

    if (kIsWeb) {
      try {
        final data = _retrieveData(formKey);
        if (data != null) {
          final decoded = jsonDecode(data) as Map<String, dynamic>;
          _cache[formKey] = decoded;
          return decoded;
        }
      } catch (e) {
        debugPrint('Error retrieving form data: $e');
      }
    }
    return null;
  }

  /// Clear form data
  Future<void> clearFormData(String formId) async {
    final formKey = '$_formDataKey:$formId';
    _cache.remove(formKey);
    if (kIsWeb) {
      _removeData(formKey);
    }
  }

  /// Store generic temporary data
  Future<void> setTempData(String key, dynamic value) async {
    final storageKey = '$_tempDataKey:$key';
    _cache[storageKey] = value;
    if (kIsWeb) {
      try {
        String jsonValue;
        if (value is String) {
          jsonValue = value;
        } else {
          jsonValue = jsonEncode(value);
        }
        _storeData(storageKey, jsonValue);
      } catch (e) {
        debugPrint('Error storing temp data: $e');
      }
    }
  }

  /// Get generic temporary data
  Future<dynamic> getTempData(String key) async {
    final storageKey = '$_tempDataKey:$key';
    if (_cache.containsKey(storageKey)) {
      return _cache[storageKey];
    }

    if (kIsWeb) {
      try {
        final data = _retrieveData(storageKey);
        if (data != null) {
          _cache[storageKey] = data;
          return data;
        }
      } catch (e) {
        debugPrint('Error retrieving temp data: $e');
      }
    }
    return null;
  }

  /// Clear all shared data
  Future<void> clearAll() async {
    _cache.clear();
    if (kIsWeb) {
      try {
        // Clear only our prefixed keys
        final keys = _getStorageKeys();
        for (final key in keys) {
          if (key.startsWith('shared_')) {
            _removeData(key);
          }
        }
      } catch (e) {
        debugPrint('Error clearing all: $e');
      }
    }
  }

  // Browser storage helper methods
  static void _storeData(String key, String value) {
    if (kIsWeb) {
      // Store in browser sessionStorage (temporary, cleared when tab closes)
      // In a real app, you'd use dart:js for proper JS interop
      try {
        // This is pseudo-code showing intent
        // In actual implementation, use package:js
        // sessionStorage[key] = value
      } catch (e) {
        debugPrint('Failed to store: $e');
      }
    }
  }

  static String? _retrieveData(String key) {
    if (kIsWeb) {
      try {
        // In a real app: return sessionStorage[key]
        return null;
      } catch (e) {
        debugPrint('Failed to retrieve: $e');
      }
    }
    return null;
  }

  static void _removeData(String key) {
    if (kIsWeb) {
      try {
        // sessionStorage.removeItem(key)
      } catch (e) {
        debugPrint('Failed to remove: $e');
      }
    }
  }

  static List<String> _getStorageKeys() {
    if (kIsWeb) {
      try {
        // return Object.keys(sessionStorage)
        return [];
      } catch (e) {
        debugPrint('Failed to get keys: $e');
      }
    }
    return [];
  }
}

/// Convenience singleton instance
final sharedData = SharedDataService();
