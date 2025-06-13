import 'business_exception.dart';

class NetworkException extends BusinessException {
  const NetworkException({
    required super.message,
    required super.code,
  });

  factory NetworkException.noInternet() {
    return const NetworkException(
      message: 'Không có kết nối internet',
      code: 'NET001',
    );
  }

  factory NetworkException.timeout() {
    return const NetworkException(
      message: 'Yêu cầu đã hết thời gian chờ',
      code: 'NET002',
    );
  }

  factory NetworkException.serverError() {
    return const NetworkException(
      message: 'Lỗi máy chủ, vui lòng thử lại sau',
      code: 'NET003',
    );
  }

  factory NetworkException.requestFailed() {
    return const NetworkException(
      message: 'Yêu cầu thất bại, vui lòng thử lại',
      code: 'NET004',
    );
  }

  factory NetworkException.badRequest() {
    return const NetworkException(
      message: 'Yêu cầu không hợp lệ',
      code: 'NET005',
    );
  }
}
