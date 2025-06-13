import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:testflutter/models/UserSession.dart';
import 'package:testflutter/models/user.dart';
import 'package:testflutter/services/auth_api_service.dart';
import 'package:testflutter/services/storage/storage_service.dart';

class JwtAndSession {
  final AuthApiService authService = AuthApiService();
  Map<String, dynamic> decodeJWT(String token) {
    final parts = token.split('.');
    if (parts.length != 3) throw Exception('Invalid JWT');
    final normalized = base64Url.normalize(parts[1]);
    final decoded = utf8.decode(base64Url.decode(normalized));
    return json.decode(decoded);
  }

  Future<void> initUserSession() async {
    final token = await StorageService.getAccessToken();
    if (token == null) return;
    final payload = decodeJWT(token);
    final userId = payload['id']; // Sửa lỗi bằng cách chuyển đổi thành String
    if (userId == null) return;
    //đã lấy được ID của token

    try {
      Response? res = await authService.getData('users/id/$userId');

      if (res != null && res.statusCode == 200) {
        UserSession.currentUser = User.fromJson(res.data);

        print(
            "User đã lưu vào session: ${UserSession.currentUser?.toString()}");
      } else {
        print("Lỗi lấy dữ liệu user: ${res?.data}");
      }
    } catch (e) {
      print("Lỗi lấy thông tin user: $e");
    }
  }
}
