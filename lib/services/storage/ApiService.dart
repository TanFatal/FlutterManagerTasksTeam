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
        final token =
            await StorageService.getAccessToken(); // giả sử bạn có hàm này
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) async {
        log("DIO ERROR: ${e.message}");

        // Nếu là lỗi 401 thì thử refresh token
        if (e.response?.statusCode == 401) {
          log("401 ERROR DETECTED - Attempting token refresh");
          final refreshToken = await StorageService.getRefreshToken();

          if (refreshToken != null) {
            try {
              // ⚠️ Tạo Dio instance riêng KHÔNG có interceptor để tránh infinite loop
              final refreshDio = Dio(BaseOptions(
                baseUrl: ApiConfig.baseUrl,
                connectTimeout: const Duration(seconds: 10),
                receiveTimeout: const Duration(seconds: 10),
              ));

              log("Calling refresh token API with token: ${refreshToken.substring(0, 10)}...");
              final refreshResponse = await refreshDio
                  .post('/auth/refresh', data: {"refreshToken": refreshToken});

              final newAccessToken = refreshResponse.data['accessToken'];
              final newRefreshToken =
                  refreshResponse.data['refreshToken'] ?? refreshToken;

              // Lưu lại token mới
              await StorageService.saveTokens(newAccessToken, newRefreshToken);
              log("✅ Token refresh successful! New token saved.");

              // Gửi lại request cũ với token mới
              final retryRequest = e.requestOptions;
              retryRequest.headers['Authorization'] = 'Bearer $newAccessToken';

              log("🔄 Retrying original request with new token...");
              final response = await dio.fetch(retryRequest);
              log("✅ Original request successful after token refresh!");
              return handler.resolve(response);
            } catch (refreshError) {
              log("❌ REFRESH TOKEN FAILED: $refreshError");
              await StorageService.clearTokens();
              log("🔐 Tokens cleared - user needs to login again");
              return handler.next(e);
            }
          } else {
            log("❌ No refresh token available - user needs to login");
            await StorageService.clearTokens();
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
