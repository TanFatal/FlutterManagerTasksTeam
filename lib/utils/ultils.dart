import 'package:intl/intl.dart';

String formatCurrency(dynamic value) {
  if (value == null) return '0';

  // Convert to double for numerical formatting
  double numValue;

  if (value is int || value is double) {
    numValue = value.toDouble();
  } else if (value is String) {
    // Try to parse the string as a number
    try {
      numValue = double.parse(value);
    } catch (_) {
      return value; // Return original if it's not a number
    }
  } else {
    // Return a default for other types
    return value.toString();
  }

  // Format the number with thousands separator
  try {
    String value = numValue.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.');
    return "$valueđ".toString();
  } catch (_) {
    return "${0}đ".toString();
  }
}

String toInt(dynamic value) {
  if (value == null) return '';

  if (value is int) return value.toString();

  if (value is double) return value.toInt().toString();

  if (value is String) {
    try {
      return int.parse(value).toString();
    } catch (_) {
      // Try parsing as double first then convert to int
      try {
        return double.parse(value).toInt().toString();
      } catch (_) {
        return '';
      }
    }
  }

  // For any other type or failed conversion
  return '';
}

int toIntInt(dynamic value) {
  if (value == null) return 0;

  if (value is int) return value;

  if (value is double) return value.toInt();

  if (value is String) {
    try {
      return int.parse(value);
    } catch (_) {
      // Try parsing as double first then convert to int
      try {
        return double.parse(value).toInt();
      } catch (_) {
        return 0;
      }
    }
  }

  // For any other type or failed conversion
  return 0;
}

// Add these helper methods at the bottom of the file outside any class
int safeConvertInt(dynamic value, int defaultValue) {
  if (value == null) return defaultValue;
  if (value is int) return value;
  if (value is String) return int.tryParse(value) ?? defaultValue;
  if (value is double) return value.toInt();
  return defaultValue;
}

double safeConvertDouble(dynamic value, double defaultValue) {
  if (value == null) return defaultValue;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? defaultValue;
  return defaultValue;
}

String safeConvertString(dynamic value, String defaultValue) {
  if (value == null) return defaultValue;
  return value.toString();
}

DateTime safeConvertDateTime(dynamic value, DateTime defaultValue) {
  if (value == null) return defaultValue;
  if (value is DateTime) return value;
  if (value is String) {
    try {
      return DateTime.parse(value);
    } catch (e) {
      return defaultValue;
    }
  }
  return defaultValue;
}

bool safeConvertBool(dynamic value, bool defaultValue) {
  if (value == null) return defaultValue;
  if (value is bool) return value;
  if (value is int) return value == 1;
  if (value is String) return value.toLowerCase() == 'true';
  return defaultValue;
}

List<T> safeConvertList<T>(dynamic value,
    T Function(Map<String, dynamic>) fromJson, List<T> defaultValue) {
  if (value == null) return defaultValue;
  if (value is List) {
    return value.map((item) => fromJson(item as Map<String, dynamic>)).toList();
  }
  return defaultValue;
}

String convertDate(dynamic value, {String pattern = 'dd/MM/yyyy'}) {
  if (value == null || (value is String && value.isEmpty)) return '';

  try {
    DateTime dateTime;

    if (value is DateTime) {
      dateTime = value;
    } else if (value is String) {
      dateTime = DateTime.parse(value);
    } else {
      return '';
    }

    // Use intl package's DateFormat for proper formatting
    return DateFormat(pattern).format(dateTime);
  } catch (e) {
    return '';
  }
}

//Chuyển tiếng Việt có dấu sang không dấu, sử dụng replaceAll với regex
String removeVietnameseDiacritics(String? input) {
  if (input == null) return '';
  return input
      .replaceAll(RegExp(r'[àáạảãâầấậẩẫăằắặẳẵ]'), 'a')
      .replaceAll(RegExp(r'[èéẹẻẽêềếệểễ]'), 'e')
      .replaceAll(RegExp(r'[ìíịỉĩ]'), 'i')
      .replaceAll(RegExp(r'[òóọỏõôồốộổỗơờớợởỡ]'), 'o')
      .replaceAll(RegExp(r'[ùúụủũưừứựửữ]'), 'u')
      .replaceAll(RegExp(r'[ỳýỵỷỹ]'), 'y')
      .replaceAll(RegExp(r'[đ]'), 'd');
}
