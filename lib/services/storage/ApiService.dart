import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:testflutter/config/api_config.dart';
import 'package:testflutter/services/storage/storage_service.dart';

class ApiService {
  static final Dio dio = Dio(BaseOptions(
    baseUrl: ApiConfig.baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ))
    ..interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await StorageService.getAccessToken(); // giả sử bạn có hàm này
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) async {
        log("DIO ERROR: ${e.message}");

        // Nếu là lỗi 401 thì thử refresh token
        if (e.response?.statusCode == 401) {
          final refreshToken = await StorageService.getRefreshToken();

          if (refreshToken != null) {
            try {
              final refreshResponse = await dio.post(
                '/auth/refresh',
                options: Options(
                  headers: {
                    'Authorization': 'Bearer $refreshToken',
                  },
                ),
              );

              final newAccessToken = refreshResponse.data['accessToken'];
              final newRefreshToken = refreshResponse.data['refreshToken'] ?? refreshToken;

              // Lưu lại token mới
              await StorageService.saveTokens(newAccessToken, newRefreshToken);

              // Gửi lại request cũ
              final retryRequest = e.requestOptions;
              retryRequest.headers['Authorization'] = 'Bearer $newAccessToken';

              final response = await dio.fetch(retryRequest);
              return handler.resolve(response);
            } catch (refreshError) {
              log("REFRESH TOKEN FAILED: $refreshError");
              await StorageService.clearTokens();
              // Optionally navigate to login screen here
              return handler.next(e);
            }
          }
        }

        return handler.next(e);
      },
    ));
  Future<Response?> postData(String endpoint, Map<String, dynamic> data) async {
    try {
      Response response = await dio.post(endpoint, data: data);
      log("end point của login" + endpoint);
      return response;
    } catch (e) {
      print("Lỗi POST: $e");
      return null;
    }
  }

  Future<Response?> putData(String endpoint, Map<String, dynamic> data) async {
    try {
      Response response = await dio.put(endpoint, data: data);

      return response;
    } catch (e) {
      print("Lỗi PUT: $e");
      return null;
    }
  }

  Future<Response?> deleteData(
      String endpoint, Map<String, dynamic> data) async {
    try {
      Response response = await dio.delete(endpoint);

      return response;
    } catch (e) {
      print("Lỗi DELETE: $e");
      return null;
    }
  }

  Future<Response?> getData(String endpoint) async {
    try {
      Response response = await dio.get(endpoint);
      return response;
    } catch (e) {
      return null;
    }
  }
}
