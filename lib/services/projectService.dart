import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:testflutter/models/ChannelModel.dart';
import 'package:testflutter/models/ProjectModel.dart';
import 'package:testflutter/models/user.dart';
import 'package:testflutter/services/storage/ApiService.dart';
import 'package:testflutter/services/storage/storage_service.dart';
import '../config/api_config.dart';

class ProjectService {
  String get baseUrl => ApiConfig.baseUrl;

  final ApiService apiService = ApiService();
  final StorageService secureStorage = StorageService();

  // ChannelApiService() {
  //   init();
  // }
  Future<ProjectModel?> createProject(int channelId, String name,
      String description, DateTime endDate, List<int> members) async {
    final requestData = {
      "name": name,
      "description": description,
      "endDate": endDate.toIso8601String().split('.')[0],
      "listUser": members
    };

    final endpoint =
        baseUrl + ApiConfig.project + "/channelID/" + channelId.toString();

    // Debug logging
    print('=== API REQUEST DEBUG ===');
    print('Endpoint: $endpoint');
    print('Request Data: $requestData');
    print('========================');

    Response? response = await apiService.postData(endpoint, requestData);

    print('Response Status Code: ${response?.statusCode}');
    print('Response Data: ${response?.data}');

    if (response != null && response.statusCode == 200) {
      // Chuyển đổi response.body thành JSON
      final Map<String, dynamic> jsonData = response.data;

      // Chuyển đổi JSON thành ProjectModel
      ProjectModel newProject = ProjectModel.fromJson(jsonData);
      print('Project created successfully!');
      return newProject;
    } else {
      log("Tạo Project thất bại! Status: ${response?.statusCode}");
      log("Error Response: ${response?.data}");
      return null; // Trả về null thay vì false để đảm bảo kiểu dữ liệu nhất quán
    }
  }

  // 2. Lấy danh sách tất cả các kênh (Read) từ Current User
  Future<List<ProjectModel>> getAllProjectByCurrentUser() async {
    try {
      Response? response =
          await apiService.getData(baseUrl + ApiConfig.project);

      if (response != null && response.statusCode == 200) {
        final List<dynamic> jsonData = response.data;
        List<ProjectModel> project = jsonData.map((item) {
          return ProjectModel.fromJson(Map<String, dynamic>.from(item));
        }).toList();
        return project;
      } else {
        log("Lấy danh sách kênh thất bại!");
        return [];
      }
    } catch (e) {
      log("Lỗi khi lấy danh sách kênh: $e");
      return [];
    }
  }

  //3 Lấy danh sách các members của một project
  Future<List<User>> getAllMemberOfProjectId(int projectId) async {
    try {
      Response? response = await apiService.getData(
          baseUrl + ApiConfig.project + "/members/" + projectId.toString());

      if (response != null && response.statusCode == 200) {
        final List<dynamic> jsonData = response.data;
        List<User> listUser = jsonData.map((item) {
          return User.fromJson(Map<String, dynamic>.from(item));
        }).toList();
        return listUser;
      } else {
        log("Lấy danh sách user của project thất bại!");
        return [];
      }
    } catch (e) {
      log("Lỗi khi lấy danh sách User của Project: $e");
      return [];
    }
  }

  //4. Lấy danh sách các project của một channel
  Future<List<ProjectModel>> getAllProjectOfChannelId(int channelId) async {
    try {
      Response? response = await apiService.getData(
          baseUrl + ApiConfig.project + "/find/" + channelId.toString());

      if (response != null && response.statusCode == 200) {
        final List<dynamic> jsonData = response.data;
        List<ProjectModel> listUser = jsonData.map((item) {
          return ProjectModel.fromJson(Map<String, dynamic>.from(item));
        }).toList();
        return listUser;
      } else {
        log("Lấy danh sách project của channel thất bại!");
        return [];
      }
    } catch (e) {
      log("Lỗi khi lấy danh sách project của channel thất bại: $e");
      return [];
    }
  }
}
