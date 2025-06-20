import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:testflutter/config/clouddinaryConfig.dart';
import 'package:testflutter/models/UserSession.dart';
import 'package:testflutter/services/auth_api_service.dart';

class AvatarPreviewPage extends StatefulWidget {
  final File imageFile;
  const AvatarPreviewPage({super.key, required this.imageFile});

  @override
  State<AvatarPreviewPage> createState() => _AvatarPreviewPageState();
}

class _AvatarPreviewPageState extends State<AvatarPreviewPage> {
  final cloudinary = CloudinaryService();
  bool isUploading = false;

  Future<void> _saveAvatar() async {
    setState(() => isUploading = true);

    final url = await cloudinary.uploadImage(widget.imageFile);
    if (url != null) {
      final updatedUser = UserSession.currentUser!.copyWith(urlImg: url);
      UserSession.currentUser = updatedUser;
      log(UserSession.currentUser.toString());
      AuthApiService().ChangeAvatar(url);

      if (mounted) {
        Navigator.pop(context, true); // Quay lại và báo "đã lưu"
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi khi upload ảnh")),
      );
    }

    setState(() => isUploading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Xem trước ảnh đại diện")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 80,
            backgroundImage: FileImage(widget.imageFile),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: isUploading ? null : _saveAvatar,
            icon: Icon(Icons.save),
            label: isUploading ? Text("Đang lưu...") : Text("Lưu"),
          ),
        ],
      ),
    );
  }
}
