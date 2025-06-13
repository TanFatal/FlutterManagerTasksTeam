import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:testflutter/config/api_config.dart';
import 'package:testflutter/screen/AuthScreen/login.dart';
import 'package:testflutter/screen/MainScreen.dart';
import 'package:testflutter/services/storage/ApiService.dart';
import 'package:testflutter/services/storage/jwtSession.dart';
import 'package:testflutter/services/storage/storage_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final token = await StorageService.getAccessToken();
    log("Token: $token");
    if (token != null) {
      try {
        // Nếu có token, khởi tạo phiên người dùng
        await JwtAndSession().initUserSession();
        // Gọi API kiểm tra token (ví dụ /api/user/me hoặc bất kỳ API cần auth)
        final response =
            await ApiService().getData(ApiConfig.baseUrl + ApiConfig.channel);
        if (response!.statusCode == 200) {
          // Nếu hợp lệ, vào Home
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const Mainscreen()),
          );
          return;
        }
      } catch (e) {
        // Token hết hạn, xử lý sau
      }
    }

    // Nếu không có token hoặc lỗi → quay về login
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
