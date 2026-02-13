/// Environment configuration via --dart-define flags.
class EnvironmentConfig {
  /// Base URL for API calls.
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000',
  );

  /// Environment name (development, staging, production).
  static const String flutterEnv = String.fromEnvironment(
    'FLUTTER_ENV',
    defaultValue: 'development',
  );

  /// API timeout in milliseconds.
  static const int apiTimeoutMs = int.fromEnvironment(
    'API_TIMEOUT',
    defaultValue: 30000,
  );

  /// Feature flags.
  static const bool enableOfflineMode = bool.fromEnvironment(
    'ENABLE_OFFLINE_MODE',
    defaultValue: true,
  );

  static const bool enableBackgroundSync = bool.fromEnvironment(
    'ENABLE_BACKGROUND_SYNC',
    defaultValue: true,
  );

  static const int cacheExpiryHours = int.fromEnvironment(
    'CACHE_EXPIRY_HOURS',
    defaultValue: 24,
  );

  static bool get isProduction => flutterEnv.toLowerCase() == 'production';
}
