import 'dart:io';
import 'package:dio/dio.dart';

class CloudinaryService {
  final String cloudName = 'dum3nr0mj';
  final String uploadPreset = 'Ruprup';

  Future<String?> uploadImage(File imageFile) async {
    final url = 'https://api.cloudinary.com/v1_1/$cloudName/image/upload';
    FormData formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(imageFile.path),
      'upload_preset': uploadPreset,
    });
    try {
      final response = await Dio().post(url, data: formData);
      if (response.statusCode == 200) {
        return response.data['secure_url']; //  URL hình ảnh Cloudinary
      } else {
        print("Upload thất bại: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Lỗi khi upload ảnh: $e");
      return null;
    }
  }
}
