import 'business_exception.dart';

class ValidationException extends BusinessException {
  const ValidationException({
    required super.message,
    required super.code,
  });

  factory ValidationException.invalidEmail() {
    return const ValidationException(
      message: 'Email không hợp lệ',
      code: 'VAL001',
    );
  }

  factory ValidationException.invalidPassword() {
    return const ValidationException(
      message: 'Mật khẩu phải có ít nhất 6 ký tự',
      code: 'VAL002',
    );
  }

  factory ValidationException.requiredField(String fieldName) {
    return ValidationException(
      message: '$fieldName không được để trống',
      code: 'VAL003',
    );
  }

  factory ValidationException.invalidPhone() {
    return const ValidationException(
      message: 'Số điện thoại không hợp lệ',
      code: 'VAL004',
    );
  }

  factory ValidationException.invalidDate() {
    return const ValidationException(
      message: 'Ngày tháng không hợp lệ',
      code: 'VAL005',
    );
  }

  factory ValidationException.maxLength(String fieldName, int maxLength) {
    return ValidationException(
      message: '$fieldName không được vượt quá $maxLength ký tự',
      code: 'VAL006',
    );
  }

  factory ValidationException.minLength(String fieldName, int minLength) {
    return ValidationException(
      message: '$fieldName phải có ít nhất $minLength ký tự',
      code: 'VAL007',
    );
  }

  factory ValidationException.invalidFormat(String fieldName) {
    return ValidationException(
      message: 'Định dạng $fieldName không hợp lệ',
      code: 'VAL008',
    );
  }
}
