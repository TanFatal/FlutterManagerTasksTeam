class AppConfig {
  // Server URLs
  // App configuration
  static const String appName = 'Vinachem Shop';
  static const String appVersion = '1.0.0';

  // Timeouts (in milliseconds)
  static const int timeout = 30000;
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;
  static const int sendTimeout = 30000;

  // Error Messages
  static const String serverError = 'Server error occurred';
  static const String unknownError = 'An unknown error occurred';
  static const String connectionError = 'Connection error occurred';
  static const String invalidResponse = 'Invalid response from server';
}
