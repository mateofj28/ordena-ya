import 'dart:developer' as developer;

class Logger {
  static const String _tag = 'OrdenaYa';

  static void info(String message, [String? tag]) {
    developer.log(
      message,
      name: tag ?? _tag,
      level: 800,
    );
  }

  static void warning(String message, [String? tag]) {
    developer.log(
      message,
      name: tag ?? _tag,
      level: 900,
    );
  }

  static void error(String message, [String? tag, Object? error]) {
    developer.log(
      message,
      name: tag ?? _tag,
      level: 1000,
      error: error,
    );
  }

  static void debug(String message, [String? tag]) {
    developer.log(
      message,
      name: tag ?? _tag,
      level: 700,
    );
  }
}