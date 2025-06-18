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

  Future<String?> RefreshLogin(String refreshToken) async {
    var response = await apiService.postData(baseUrl + ApiConfig.refreshToken, {
      'username': refreshToken,
    });
    if (response != null && response.statusCode == 200) {
      String accCessToken = response.data['accessToken'];
      await StorageService.saveTokens(accCessToken, refreshToken);
      log("accessToken: $accCessToken /n" +
          " và /n"
              "refreshToken: $refreshToken");
      return accCessToken;
    } else {
      log("Đăng nhập thất bại");
      return null;
    }
  }

  Future<String> ChangeAvatar(String url) async {
    var response =
        await apiService.postData(baseUrl + ApiConfig.users + "/changeAvatar", {
      'url': url,
    });
    if (response != null && response.statusCode == 200) {
      String accCessToken = response.data['profilePictureUrl'];
      return accCessToken;
    } else {
      log("Thây đổi ảnh thất bại");
      return "Thây đổi ảnh thất bại";
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

  Future<Response?> getCurrentUser(String endpoint) async {
    try {
      final response = await apiService.getData(baseUrl + "/" + endpoint);
      return response;
    } catch (e) {
      log("Lỗi GET: $e");
      return null;
    }
  }

  Future<Response?> forgotPassWord(String email) async {
    try {
      var response =
          await apiService.putData(baseUrl + ApiConfig.forgotPassWord, {
        'email': email,
      });
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

  Future<String> getUserNameById(int userId) async {
    try {
      Response? response = await apiService
          .getData(baseUrl + ApiConfig.users + "/id/" + userId.toString());
      if (response != null && response.statusCode == 200) {
        return response.data['fullname'];
      } else {
        log("Lấy tên người dùng thất bại!");
        return "Unknown User";
      }
    } catch (e) {
      log("Lỗi khi lấy tên người dùng: $e");
      return "Unknown User";
    }
  }
}
