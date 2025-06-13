import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:testflutter/models/ChannelModel.dart';
import 'package:testflutter/models/MessageModel.dart';
import 'package:testflutter/models/RoomChatModel.dart';
import 'package:testflutter/models/LastMessageModel.dart';
import 'package:testflutter/models/RoomChatPreView.dart';
import 'package:testflutter/services/storage/ApiService.dart';
import 'package:testflutter/services/storage/storage_service.dart';
import '../config/api_config.dart';
import 'dio_service.dart';

class RoomChatApiService extends DioService {
  @override
  String get baseUrl => ApiConfig.baseUrl;

  final ApiService apiService = ApiService();
  final StorageService secureStorage = StorageService();

  // 2. Lấy danh sách tất cả các kênh (Read) từ Current User
  Future<List<RoomChatModel>> getAllRoomChatByCurrentUser(param0) async {
    try {
      Response? response =
          await apiService.getData(baseUrl + ApiConfig.roomChat);

      if (response != null && response.statusCode == 200) {
        final List<dynamic> jsonData = response.data;
        List<RoomChatModel> roomChats = jsonData.map((item) {
          return RoomChatModel.fromJson(Map<String, dynamic>.from(item));
        }).toList();
        return roomChats;
      } else {
        log("Lấy danh sách phòng chat thất bại!");
        return [];
      }
    } catch (e) {
      log("Lỗi khi lấy danh sách phòng chat: $e");
      return [];
    }
  }

  //2 Lấy tin nhắn mới nhất để hiển thị ở page các tin nhắn
  Future<LastMessageModel?> getLastMassageByRoomChat(int roomChatId) async {
    try {
      Response? response = await apiService
          .getData(baseUrl + ApiConfig.lastMessage + "/" + '$roomChatId');

      if (response != null && response.statusCode == 200) {
        final Map<String, dynamic> jsonData = response.data;
        log("a");
        // Chuyển đổi JSON thành ChannelModel
        LastMessageModel roomChatPreviewModel =
            LastMessageModel.fromJson(jsonData);
        log("b");
        return roomChatPreviewModel;
      } else {
        log("Lấy lastMessage thất bại!");
        return null;
      }
    } catch (e) {
      log("Lỗi khi lấy lastMessage: $e");
      return null;
    }
  }

  // 3. Cập nhật một nhóm (Update)
  // Future<void> updateGroup(Channel channel) async {
  //   try {

  //   } catch (e) {
  //     print("Lỗi khi cập nhật channel: $e");
  //   }
  // }

  // Future<void> deleteChannel(String channelId) async {

  // }

  // Hàm lấy tất cả các group mà người dùng hiện tại đang tham gia
  // Future<List<Channel>> getChannelsForCurrentUser(String currentUserId) async {

  // }

  // Future<List<ChannelModel>> searchChannels(
  //     String keyword, String currentUserId) async {

  // }

  // Future<void> addMemberToChannel(String channelId, List<int> membersToAdd) async {

  // }
}
