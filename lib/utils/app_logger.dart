import 'package:flutter/foundation.dart';

class AppLogger {
  static bool _debugMode = false;

  static void setDebugMode(bool enabled) {
    _debugMode = enabled;
  }

  static void api(String method, String path, {dynamic data}) {
    if (_debugMode) {
      debugPrint('┌─────────────────────────────────────────────────');
      debugPrint('│ 🌐 API Call: $method $path');
      if (data != null) debugPrint('│ Data: $data');
      debugPrint('└─────────────────────────────────────────────────');
    }
  }

  static void socket(String event, {dynamic data}) {
    if (_debugMode) {
      debugPrint('┌─────────────────────────────────────────────────');
      debugPrint('│ 🔌 Socket Event: $event');
      if (data != null) debugPrint('│ Data: $data');
      debugPrint('└─────────────────────────────────────────────────');
    }
  }

  static void error(String message,
      {dynamic error, StackTrace? stackTrace, dynamic data}) {
    if (_debugMode) {
      debugPrint('[ERROR] ${DateTime.now()}: $message');
      if (error != null) debugPrint('Error details: $error');
      if (stackTrace != null) debugPrint('Stack trace:\n$stackTrace');
      if (data != null) debugPrint('Additional data: $data');
    }
  }

  static void info(String message, {dynamic data}) {
    if (_debugMode) {
      debugPrint('[INFO] ${DateTime.now()}: $message');
      if (data != null) debugPrint('Data: $data');
    }
  }

  static void debug(String message, {dynamic data}) {
    if (_debugMode) {
      debugPrint('[DEBUG] ${DateTime.now()}: $message');
      if (data != null) debugPrint('Data: $data');
    }
  }
}
