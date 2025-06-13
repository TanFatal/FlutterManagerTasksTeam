import 'business_exception.dart';

class AppException extends BusinessException {
  const AppException({
    required super.message,
    required super.code,
  });

  factory AppException.unexpectedError() {
    return const AppException(
      message: 'Đã xảy ra lỗi không mong muốn',
      code: 'APP001',
    );
  }

  factory AppException.featureNotAvailable() {
    return const AppException(
      message: 'Tính năng này chưa được hỗ trợ',
      code: 'APP002',
    );
  }

  factory AppException.maintenanceMode() {
    return const AppException(
      message: 'Hệ thống đang bảo trì, vui lòng thử lại sau',
      code: 'APP003',
    );
  }

  factory AppException.versionNotSupported() {
    return const AppException(
      message: 'Phiên bản ứng dụng không được hỗ trợ, vui lòng cập nhật',
      code: 'APP004',
    );
  }

  factory AppException.configurationError() {
    return const AppException(
      message: 'Lỗi cấu hình ứng dụng',
      code: 'APP005',
    );
  }

  factory AppException.resourceNotAvailable() {
    return const AppException(
      message: 'Tài nguyên không khả dụng',
      code: 'APP006',
    );
  }
}
