import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:testflutter/models/ActivityLogModel.dart';
import 'package:testflutter/models/MessageModel.dart';
import 'package:testflutter/services/storage/ApiService.dart';
import 'package:testflutter/services/storage/storage_service.dart';
import '../config/api_config.dart';

class MessageApiService {
  String get baseUrl => ApiConfig.baseUrl;

  final ApiService apiService = ApiService();
  final StorageService secureStorage = StorageService();

  Future<List<MessageModel>> getAllMessageByRoomChat(int roomChatId) async {
    try {
      Response? response = await apiService
          .getData(baseUrl + ApiConfig.message + "/" + roomChatId.toString());

      if (response != null && response.statusCode == 200) {
        final List<dynamic> jsonData = response.data;
        List<MessageModel> messages = jsonData.map((item) {
          return MessageModel.fromJson(Map<String, dynamic>.from(item));
        }).toList();
        return messages;
      } else {
        log("Lấy danh sách messages thất bại!");
        return [];
      }
    } catch (e) {
      log("Lỗi khi lấy danh sách messages: $e");
      return [];
    }
  }

  Future<String> sendMessageToRoomChatId(
      int roomChatId, String content, String type) async {
    try {
      Response? response = await apiService.postData(
          baseUrl + ApiConfig.message + "/" + roomChatId.toString() + "/send",
          {"content": content, "type": type});

      if (response != null && response.statusCode == 200) {
        return "Gửi tin nhắn thành công!";
      } else {
        //log("Lấy danh sách messages thất bại!");
        return "gửi tin nhắn thất bại";
      }
    } catch (e) {
      //log("Lỗi khi lấy danh sách messages: $e");
      return "Thất bại khi gửi tin nhắn";
    }
  }
}
