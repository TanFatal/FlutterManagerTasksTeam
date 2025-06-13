import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';

import '../config/api_config.dart';
import '../config/app_config.dart';
import '../exceptions/network_exception.dart';
import '../utils/api_exception.dart';
import '../utils/app_logger.dart';

abstract class DioService with DioMixin implements Dio {
  late final Dio _dio;

  String get baseUrl;

  @override
  BaseOptions get options => BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
        sendTimeout: const Duration(seconds: 60),
        headers: {
          'hdkl': ApiConfig.securityKey,
          'clientSecret': ApiConfig.clientSecret,
          'access-type': ApiConfig.accessType,
        },
        validateStatus: (status) {
          return status != null && status < 600; // Chấp nhận cả status 500
        },
      );

  void init() {
    _dio = Dio(options);
    _dio.httpClientAdapter = IOHttpClientAdapter();
    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          _logRequest(options);
          // Allow subclasses to modify request
          await modifyRequest(options);
          return handler.next(options);
        },
        onResponse: (response, handler) {
          _logResponse(response);
          // Allow subclasses to modify response
          modifyResponse(response);
          return handler.next(response);
        },
        onError: (error, handler) {
          _logError(error);
          // Allow subclasses to handle errors
          handleError(error);
          return handler.next(error);
        },
      ),
    );
  }

  // Override these methods to customize request/response handling
  modifyRequest(RequestOptions options) async {
    // Add token to headers
    // final token = await ApiConfig.getToken();
    // if (token != null && token.isNotEmpty) {
    //   options.headers['Authorization'] = 'Bearer $token';
  }

  void modifyResponse(Response response) {}

  void handleError(DioException error) {}

  void _logRequest(RequestOptions options) {
    AppLogger.api(
      options.method,
      options.path,
      data: options.data,
    );
  }

  void _logResponse(Response response) {
    AppLogger.api(
      'Response',
      response.requestOptions.path,
      data: response.data,
    );
  }

  void _logError(DioException error) {
    AppLogger.error(
      'DIO Error',
      error: error,
      stackTrace: error.stackTrace,
    );
  }

  Future<Response<T>> safeGet<T>(
    String path, {
    Map<String, dynamic>? params,
  }) async {
    try {
      return await _dio.get<T>(path, queryParameters: params);
    } on DioException catch (e, stackTrace) {
      _handleRequestError('GET', path, e, stackTrace, params: params);
      rethrow;
    }
  }

  Future<Response<T>> safePost<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? params,
  }) async {
    try {
      return await _dio.post<T>(path, data: data, queryParameters: params);
    } on DioException catch (e, stackTrace) {
      _handleRequestError('POST', path, e, stackTrace,
          data: data, params: params);
      rethrow;
    }
  }

  Future<Response<T>> safePut<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? params,
  }) async {
    try {
      return await _dio.put<T>(path, data: data, queryParameters: params);
    } on DioException catch (e, stackTrace) {
      _handleRequestError('PUT', path, e, stackTrace,
          data: data, params: params);
      rethrow;
    } catch (e, stackTrace) {
      _handleRequestError('PUT', path, e, stackTrace,
          data: data, params: params);
      rethrow;
    }
  }

  dynamic getResponseData(dynamic responseBody) {
    try {
      if (responseBody == null) {
        return null;
      }

      final responseData = responseBody is Response
          ? responseBody.data as Map<String, dynamic>
          : responseBody as Map<String, dynamic>;

      // Check for error code
      final code = responseData['code'] ?? 0;
      if (code == -1) {
        // If error code is not 0, throw exception with message
        throw ApiException(
          message: responseData['message'] ?? 'Lỗi không xác định',
        );
      }

      if (code == 1) {
        // If error code is not 0, throw exception with message
        throw ApiException(
          message: responseData['message'] ?? 'Không có dữ liệu',
        );
      }

      // Check if contains data field first
      if (responseData.containsKey('data')) {
        final data = responseData['data'];
        // If data is a list, return it directly
        if (data is List) {
          return data;
        }
        // If data is a map, check for pagination
        else if (data is Map) {
          // If contains totalRecord, it's paginated data
          if (data.containsKey('data')) {
            return data['data'];
          }
          // Return data directly if it's a map
          return data;
        } else if (data is String) {
          return jsonDecode(data);
        }
        // For other data types (primitives, etc.)
        return data;
      }
      // Otherwise return the whole response data
      return responseData;
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: 'Lỗi xử lý dữ liệu');
    }
  }

  Future<Response<T>> safeDelete<T>(
    String path, {
    Map<String, dynamic>? params,
  }) async {
    try {
      return await _dio.delete<T>(path, queryParameters: params);
    } on DioException catch (e, stackTrace) {
      _handleRequestError('DELETE', path, e, stackTrace, params: params);
      rethrow;
    } catch (e, stackTrace) {
      _handleRequestError('DELETE', path, e, stackTrace, params: params);
      rethrow;
    }
  }

  void _handleRequestError(
    String method,
    String path,
    Object error,
    StackTrace stackTrace, {
    dynamic data,
    Map<String, dynamic>? params,
  }) {
    AppLogger.error(
      '$method Request Error',
      error: error,
      stackTrace: stackTrace,
      data: {
        'path': path,
        if (data != null) 'body': data,
        if (params != null) 'params': params,
      },
    );

    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          throw NetworkException.timeout();
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          if (statusCode != null) {
            if (statusCode >= 500) {
              throw NetworkException.serverError();
            } else if (statusCode == 400) {
              throw NetworkException.badRequest();
            }
          }
          throw NetworkException.requestFailed();
        case DioExceptionType.connectionError:
          throw NetworkException.noInternet();
        case DioExceptionType.cancel:
        case DioExceptionType.badCertificate:
        case DioExceptionType.unknown:
        default:
          throw NetworkException.requestFailed();
      }
    } else {
      throw ApiException(message: AppConfig.unknownError);
    }
  }
}

// Default implementation
class DefaultDioService extends DioService {
  @override
  String get baseUrl => ApiConfig.baseUrl;

  DefaultDioService() {
    init();
  }
}
