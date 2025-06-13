abstract class BusinessException implements Exception {
  /// Mô tả chi tiết về lỗi
  final String message;

  /// Mã lỗi tương ứng, có thể dùng để phân loại lỗi
  final String code;

  const BusinessException({
    required this.message,
    required this.code,
  });

  @override
  String toString() => 'code: $code\nmessage: $message';
}
