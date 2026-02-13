/// Security and feature flags for the KSRCE ERP application.
///
/// These flags control various security and feature behaviors throughout the app.

/// Enable demo authentication for testing purposes.
/// When true, allows login with demo credentials (S20210001, FAC001, ADM001).
/// Should be false in production.
const bool kEnableDemoAuth = bool.fromEnvironment('ENABLE_DEMO_AUTH', defaultValue: true);
