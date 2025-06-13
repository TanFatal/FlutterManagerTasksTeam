import 'package:intl/intl.dart';

class DateExtensions {
  static DateTime? parseDateSafe(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) {
      final formats = [
        "yyyy-MM-ddTHH:mm:ss",
        "yyyy-MM-dd HH:mm:ss",
        "yyyy-MM-dd",
        "dd/MM/yyyy HH:mm:ss",
        "dd/MM/yyyy",
        "MM/dd/yyyy HH:mm:ss",
        "MM/dd/yyyy",
      ];

      for (var format in formats) {
        try {
          return DateFormat(format).parse(value);
        } catch (_) {
          // If parsing fails, try the next format
        }
      }

      // If all formats fail, try parsing ISO 8601
      try {
        return DateTime.parse(value);
      } catch (_) {
        // If ISO 8601 parsing fails, return null
        return null;
      }
    }
    return null;
  }
}
