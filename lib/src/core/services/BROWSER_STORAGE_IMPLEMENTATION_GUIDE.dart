/// IMPLEMENTATION GUIDE: Browser Storage with JavaScript Interop
///
/// Current State: The SharedDataService and BrowserStorage are set up with
/// in-memory caching and browser API integration structure.
///
/// To fully enable browser-based temporary data storage, follow these steps:
///
/// STEP 1: Add the 'js' package to pubspec.yaml
/// ============================================
/// dependencies:
///   js: ^0.6.7
///
/// STEP 2: Update BrowserStorage with JS interop
/// ============================================
/// Replace the _callJS method with actual JS interop:
///
/// ```dart
/// import 'package:js/js.dart';
/// import 'package:js/js_util.dart';
///
/// @JS('window.sessionStorage')
/// class SessionStorage {
///   external String? getItem(String key);
///   external void setItem(String key, String value);
///   external void removeItem(String key);
///   external void clear();
///   external int get length;
///   external String? key(int index);
/// }
/// ```
///
/// STEP 3: Update SharedDataService methods
/// ========================================
/// Replace _storeData, _retrieveData, _removeData with:
///
/// ```dart
/// static void _storeData(String key, String value) {
///   if (kIsWeb) {
///     try {
///       sessionStorage.setItem(key, value);
///     } catch (e) {
///       debugPrint('Error storing: $e');
///     }
///   }
/// }
///
/// static String? _retrieveData(String key) {
///   if (kIsWeb) {
///     try {
///       return sessionStorage.getItem(key);
///     } catch (e) {
///       debugPrint('Error retrieving: $e');
///     }
///   }
///   return null;
/// }
///
/// static void _removeData(String key) {
///   if (kIsWeb) {
///     try {
///       sessionStorage.removeItem(key);
///     } catch (e) {
///       debugPrint('Error removing: $e');
///     }
///   }
/// }
///
/// static List<String> _getStorageKeys() {
///   if (kIsWeb) {
///     try {
///       final keys = <String>[];
///       for (int i = 0; i < sessionStorage.length; i++) {
///         final key = sessionStorage.key(i);
///         if (key != null) {
///           keys.add(key);
///         }
///       }
///       return keys;
///     } catch (e) {
///       debugPrint('Error getting keys: $e');
///     }
///   }
///   return [];
/// }
/// ```
///
/// STEP 4: Alternative - Use localStorage for persistence
/// ======================================================
/// For data that should persist across browser sessions:
///
/// ```dart
/// @JS('window.localStorage')
/// class LocalStorage {
///   external String? getItem(String key);
///   external void setItem(String key, String value);
///   external void removeItem(String key);
///   external void clear();
/// }
/// ```
///
/// Choose sessionStorage (temporary) or localStorage (persistent) based on needs:
/// - sessionStorage: Cleared when tab closes (ideal for temp form data, filters)
/// - localStorage: Persists across browser sessions (ideal for preferences, tokens)
///
/// STEP 5: Usage across app
/// =======================
/// Then use it anywhere:
///
/// ```dart
/// // In any page/module
/// import 'package:ksrce_erp/src/core/services/shared_data_service.dart';
///
/// class MyPage extends StatefulWidget {
///   @override
///   State<MyPage> createState() => _MyPageState();
/// }
///
/// class _MyPageState extends State<MyPage> {
///   @override
///   void initState() {
///     super.initState();
///     _loadSharedData();
///   }
///
///   Future<void> _loadSharedData() async {
///     final userRole = await sharedData.getUserRole();
///     final filters = await sharedData.getFilters();
///     setState(() {
///       // Update UI with retrieved data
///     });
///   }
///
///   Future<void> _saveData() async {
///     await sharedData.setUserRole('Faculty');
///     await sharedData.setFilters({
///       'search': 'exam',
///       'department': 'CSE',
///     });
///
///     // Data is now available in browser storage and other modules
///   }
///
///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       body: Center(
///         child: ElevatedButton(
///           onPressed: _saveData,
///           child: const Text('Save to Browser Storage'),
///         ),
///       ),
///     );
///   }
/// }
/// ```
///
/// ADVANTAGES OF THIS APPROACH:
/// ===========================
/// 1. ✅ No external backend needed for temporary data
/// 2. ✅ Faster than API calls for cross-module communication
/// 3. ✅ Works offline while tab is open
/// 4. ✅ Automatic cleanup (sessionStorage clears on close)
/// 5. ✅ Type-safe Dart API wrapping browser storage
/// 6. ✅ Can store complex objects as JSON
/// 7. ✅ Singleton pattern ensures single source of truth
///
/// USE CASES:
/// =========
/// ✓ Multi-step form data persistence
/// ✓ Maintaining filters across pages
/// ✓ User preferences (theme, language, etc.)
/// ✓ Navigation history/breadcrumbs
/// ✓ Temporary selected items
/// ✓ Form draft auto-save
/// ✓ Recent searches
/// ✓ Page-specific states during navigation
///
/// CURRENT LIMITATIONS (before JS interop):
/// =======================================
/// - Data only persists in memory during current app session
/// - Not available in browser DevTools Storage tab
/// - Doesn't survive page reload
///
/// After implementing JS interop:
/// ============================
/// All limitations removed - full browser storage integration enabled!
///
/// SECURITY NOTES:
/// ==============
/// ⚠️ sessionStorage/localStorage is accessible to JavaScript
/// ⚠️ Do NOT store sensitive data (passwords, tokens) without encryption
/// ⚠️ Consider using Secure HttpOnly cookies for auth tokens
/// ⚠️ Always sanitize data retrieved from storage

void main() {}
