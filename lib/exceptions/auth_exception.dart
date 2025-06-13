import 'business_exception.dart';

class AuthException extends BusinessException {
  const AuthException({
    required super.message,
    required super.code,
  });

  factory AuthException.invalidCredentials() {
    return const AuthException(
      message: 'Email hoặc mật khẩu không chính xác',
      code: 'AUTH001',
    );
  }

  factory AuthException.accountLocked() {
    return const AuthException(
      message: 'Tài khoản đã bị khóa',
      code: 'AUTH002',
    );
  }

  factory AuthException.sessionExpired() {
    return const AuthException(
      message: 'Phiên đăng nhập đã hết hạn',
      code: 'AUTH003',
    );
  }

  factory AuthException.unauthorized() {
    return const AuthException(
      message: 'Bạn không có quyền thực hiện hành động này',
      code: 'AUTH004',
    );
  }

  factory AuthException.registrationFailed() {
    return const AuthException(
      message: 'Đăng ký tài khoản thất bại',
      code: 'AUTH005',
    );
  }
}
