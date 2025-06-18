import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:testflutter/models/TaskModel.dart';
import 'package:testflutter/services/storage/ApiService.dart';
import '../config/api_config.dart';
import 'dio_service.dart';

class TaskApiService extends DioService {
  @override
  String get baseUrl => ApiConfig.baseUrl;

  final ApiService apiService = ApiService();

  // 1. Lấy danh sách task (Read) từ Current User
  Future<List<TaskModel>> getAllTaskByCurrentUser() async {
    try {
      Response? response = await apiService.getData(baseUrl + ApiConfig.task);
      log("đang lấy task");
      if (response != null && response.statusCode == 200) {
        final List<dynamic> jsonData = response.data;
        List<TaskModel> listTask = jsonData.map((item) {
          return TaskModel.fromJson(Map<String, dynamic>.from(item));
        }).toList();
        return listTask;
      } else {
        log("Lấy danh sách task thất bại!");
        return [];
      }
    } catch (e) {
      log("Lỗi khi lấy danh sách tas: $e");
      return [];
    }
  }

  //2 Lấy tin nhắn mới nhất để hiển thị ở page các tin nhắn
  Future<List<TaskModel>> getAllTaskByProjectId(int projectId) async {
    try {
      Response? response = await apiService.getData(
          baseUrl + ApiConfig.task + "/project/" + projectId.toString());

      if (response != null && response.statusCode == 200) {
        final List<dynamic> jsonData = response.data;
        List<TaskModel> listTask = jsonData.map((item) {
          return TaskModel.fromJson(Map<String, dynamic>.from(item));
        }).toList();
        return listTask;
      } else {
        log("Lấy danh sách task thất bại!");
        return [];
      }
    } catch (e) {
      log("Lỗi khi lấy danh sách task: $e");
      return [];
    }
  }

  Future<TaskModel> getTaskById(int taskId) async {
    try {
      Response? response = await apiService
          .getData(baseUrl + ApiConfig.task + "/id/" + taskId.toString());

      if (response != null && response.statusCode == 200) {
        return TaskModel.fromJson(Map<String, dynamic>.from(response.data));
      } else {
        log("Lấy task thất bại!");
        throw Exception("Lấy task thất bại!");
      }
    } catch (e) {
      log("Lỗi khi lấy task: $e");
      throw e;
    }
  }
}
