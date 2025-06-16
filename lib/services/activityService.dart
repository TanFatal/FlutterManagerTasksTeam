import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:testflutter/models/ActivityLogModel.dart';
import 'package:testflutter/services/storage/ApiService.dart';
import 'package:testflutter/services/storage/storage_service.dart';
import '../config/api_config.dart';
import 'dio_service.dart';

class ActivityApiService extends DioService {
  @override
  String get baseUrl => ApiConfig.baseUrl;

  final ApiService apiService = ApiService();
  final StorageService secureStorage = StorageService();

  Future<List<ActivityLog>> getAllActivityByProjectId(int projectId) async {
    try {
      Response? response = await apiService.getData(
          baseUrl + ApiConfig.activityLog + "/" + projectId.toString());

      if (response != null && response.statusCode == 200) {
        final List<dynamic> jsonData = response.data;
        List<ActivityLog> activityLog = jsonData.map((item) {
          return ActivityLog.fromJson(Map<String, dynamic>.from(item));
        }).toList();
        return activityLog;
      } else {
        log("Lấy danh sách activityLog thất bại!");
        return [];
      }
    } catch (e) {
      log("Lỗi khi lấy danh sách log: $e");
      return [];
    }
  }
}
