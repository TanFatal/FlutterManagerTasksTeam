import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final String? path;
  final int? statusCode;
  final dynamic data;

  ApiException({
    required this.message,
    this.path,
    this.statusCode,
    this.data,
  });

  factory ApiException.fromDioError(
    DioException error, {
    String? message,
    String? path,
  }) {
    return ApiException(
      message: message ?? error.message ?? 'Lỗi không xác định',
      path: path ?? error.requestOptions.path,
      statusCode: error.response?.statusCode,
      data: error.response?.data,
    );
  }

  @override
  String toString() {
    final buffer = StringBuffer(message);
    if (path != null) buffer.write(' (Path: $path)');
    if (statusCode != null) buffer.write(' [Status: $statusCode]');
    if (data != null) buffer.write('\nData: $data');
    return buffer.toString();
  }
}
