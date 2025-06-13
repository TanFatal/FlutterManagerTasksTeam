import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:testflutter/models/user.dart';

class StorageService {
  static const _storage = FlutterSecureStorage();

  static Future<void> saveTokens(
      String accessToken, String refreshToken) async {
    await _storage.write(key: 'accessToken', value: accessToken);
    await _storage.write(key: 'refreshToken', value: refreshToken);
  }

  static Future<String?> getAccessToken() async {
    return await _storage.read(key: 'accessToken');
  }

  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: 'refreshToken');
  }

  static Future<void> clearTokens() async {
    await _storage.deleteAll();
  }
}
