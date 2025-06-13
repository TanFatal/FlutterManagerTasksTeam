import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:testflutter/services/storage/ApiService.dart';
import 'package:testflutter/services/storage/storage_service.dart';
import '../config/api_config.dart';
import 'dio_service.dart';

class AuthApiService extends DioService {
  @override
  String get baseUrl => ApiConfig.baseUrl;
  final ApiService apiService = ApiService();
  final StorageService secureStorage = StorageService();

  AuthApiService() {
    init();
  }

  Future<bool> loginUser(String email, String password) async {
    var response = await apiService.postData(baseUrl + ApiConfig.emailLogin, {
      'username': email,
      'password': password,
    });
    if (response != null && response.statusCode == 200) {
      String accCessToken = response.data['accessToken'];
      String refreshToken = response.data['refreshToken'];
      await StorageService.saveTokens(accCessToken, refreshToken);
      log("accessToken: $accCessToken /n" +
          " và /n"
              "refreshToken: $refreshToken");
      return true;
    } else {
      log("Đăng nhập thất bại");

      return false;
    }
  }

  Future<String> signUp(String email, String password, String fullname) async {
    var response =
        await apiService.postData(baseUrl + ApiConfig.emailRegister, {
      'email': email,
      'password': password,
      'fullName': fullname,
    });

    if (response != null && response.statusCode == 200) {
      String res = response.data['resuilt'];
      return res;
    } else if (response != null) {
      String res = response.data['resuilt'];
      return res;
    } else {
      return "Đăng ký thất bại";
    }
  }

  Future<Response?> getData(String endpoint) async {
    try {
      final response = await apiService.getData(baseUrl + "/" + endpoint);
      return response;
    } catch (e) {
      log("Lỗi GET: $e");
      return null;
    }
  }

  Future<void> logout() async {
    await StorageService.clearTokens();
    print("Đã đăng xuất và xóa token");
  }
}
