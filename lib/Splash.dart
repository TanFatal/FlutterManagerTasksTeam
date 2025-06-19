import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:testflutter/config/api_config.dart';
import 'package:testflutter/screen/AuthScreen/login.dart';
import 'package:testflutter/screen/MainScreen.dart';
import 'package:testflutter/services/auth_api_service.dart';
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
    try {
      log("=== SPLASH SCREEN CHECK ===");

      // Kiểm tra refreshToken trước
      final refreshToken = await StorageService.getRefreshToken();
      log("Refresh Token: ${refreshToken != null ? 'Found' : 'Not found'}");

      if (refreshToken == null) {
        _navigateToLogin();
        return;
      }

      // Có refreshToken → Dùng để lấy accessToken mới
      log("🔄 Using refresh token to get new access token...");
      try {
        final newAccessToken =
            await AuthApiService().RefreshLogin(refreshToken);

        if (newAccessToken != null) {
          // Lưu token mới
          await StorageService.saveTokens(newAccessToken, refreshToken);
          log("✅ Access token refreshed successfully");

          // Khởi tạo user session
          await JwtAndSession().initUserSession();

          // Vào main screen
          _navigateToMain();
          return;
        } else {
          log("❌ Refresh token failed - redirecting to login");
          await StorageService.clearTokens();
          _navigateToLogin();
          return;
        }
      } catch (refreshError) {
        log("❌ Refresh token error: $refreshError");
        await StorageService.clearTokens();
        _navigateToLogin();
        return;
      }
    } catch (e) {
      log("❌ Error in splash: $e");
      await StorageService.clearTokens();
      _navigateToLogin();
    }
  }

  void _navigateToLogin() {
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  void _navigateToMain() {
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Mainscreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
