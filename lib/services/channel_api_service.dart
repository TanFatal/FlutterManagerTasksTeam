import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:testflutter/models/ChannelModel.dart';
import 'package:testflutter/services/storage/ApiService.dart';
import 'package:testflutter/services/storage/storage_service.dart';
import '../config/api_config.dart';
import 'dio_service.dart';

class ChannelApiService extends DioService {
  @override
  String get baseUrl => ApiConfig.baseUrl;

  final ApiService apiService = ApiService();
  final StorageService secureStorage = StorageService();

  // ChannelApiService() {
  //   init();
  // }
  Future<ChannelModel?> createChannel(String nameModel) async {
    Response? response = await apiService
        .postData(baseUrl + ApiConfig.channel, {"name": nameModel});

    if (response != null && response.statusCode == 200) {
      // Chuyển đổi response.body thành JSON
      final Map<String, dynamic> jsonData = response.data;

      // Chuyển đổi JSON thành ChannelModel
      ChannelModel newChannel = ChannelModel.fromJson(jsonData);
      return newChannel;
    } else {
      log("Tạo channel thất bại!");
      return null; // Trả về null thay vì false để đảm bảo kiểu dữ liệu nhất quán
    }
  }

  // 2. Lấy danh sách tất cả các kênh (Read) từ Current User
  Future<List<ChannelModel>> getChannelByUserId(param0) async {
    try {
      Response? response =
          await apiService.getData(baseUrl + ApiConfig.channel);

      if (response != null && response.statusCode == 200) {
        final List<dynamic> jsonData = response.data;
        List<ChannelModel> channels = jsonData.map((item) {

        return ChannelModel.fromJson(Map<String, dynamic>.from(item));
        }).toList();
        return channels;
      } else {
        log("Lấy danh sách kênh thất bại!");
        return [];
      }
    } catch (e) {
      log("Lỗi khi lấy danh sách kênh: $e");
      return [];
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
