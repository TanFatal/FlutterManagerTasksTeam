// ignore_for_file: file_names

import 'dart:developer';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:testflutter/models/RoomChatPreView.dart';
import 'package:testflutter/models/UserSession.dart';
import 'package:testflutter/screen/chat/ChatScreen.dart';

class ChattingUsersWidget extends StatefulWidget {
  final RoomChatPreviewModel preview;
  final VoidCallback? onReturn;
  const ChattingUsersWidget({super.key, required this.preview, this.onReturn});

  @override
  // ignore: library_private_types_in_public_api
  _ChattingUsersWidgetState createState() => _ChattingUsersWidgetState();
}

class _ChattingUsersWidgetState extends State<ChattingUsersWidget> {
  Color getColorFromCreatedAt(DateTime createdAt) {
    // Danh sách 7 màu sắc cầu vồng
    final List<Color> rainbowColors = [
      Colors.red.shade300,
      Colors.orange.shade300,
      Colors.yellow.shade700,
      Colors.green.shade300,
      Colors.blue.shade300,
      Colors.indigo.shade300,
      Colors.purple.shade300,
    ];

    // Chuyển `createdAt` thành chỉ số trong khoảng từ 0 đến 6
    final index = createdAt.millisecondsSinceEpoch % rainbowColors.length;
    return rainbowColors[index];
  }

  // Check if URL is valid for image loading
  bool _isValidImageUrl(String? url) {
    if (url == null || url.isEmpty) return false;

    try {
      final uri = Uri.tryParse(url);
      if (uri == null || !uri.hasAbsolutePath) return false;

      // Check if it's a valid HTTP/HTTPS URL
      if (!url.startsWith('http://') && !url.startsWith('https://')) {
        return false;
      }

      return true;
    } catch (e) {
      log('Invalid URL: $url, Error: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final room = widget.preview.roomChat;
    final msg = widget.preview.lastMessage.message;
    final senderName = widget.preview.lastMessage.senderName;

    final isCurrentUser = UserSession.currentUser!.id == msg.senderId;

    String roomName = room.nameRoom;
    final parts = roomName.split('_');
    if (parts.length == 2 && UserSession.currentUser != null) {
      roomName =
          (parts[0] == UserSession.currentUser?.fullname) ? parts[1] : parts[0];
    }

    // Hiển thị nội dung tin nhắn hoặc thông báo "Không có tin nhắn"
    final content = msg.content.isNotEmpty
        ? (msg.type == 'img' ||
                (msg.content.startsWith('http') &&
                    (msg.content.contains('.jpg') ||
                        msg.content.contains('.jpeg') ||
                        msg.content.contains('.png') ||
                        msg.content.contains('.gif') ||
                        msg.content.contains('cloudinary.com')))
            ? 'Sent an image'
            : msg.content)
        : '';

    final prefix = isCurrentUser ? 'You: ' : '$senderName: ';
    final time = DateFormat('HH:mm').format(msg.timestamp);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      leading: CircleAvatar(
        radius: 26,
        backgroundColor:
            _isValidImageUrl(room.urlImages) ? Colors.transparent : Colors.blue,
        backgroundImage: _isValidImageUrl(room.urlImages)
            ? NetworkImage(room.urlImages!)
            : null,
        onBackgroundImageError: _isValidImageUrl(room.urlImages)
            ? (exception, stackTrace) {
                log('Failed to load image: ${room.urlImages}');
                // Fallback will be handled by child widget
              }
            : null,
        child: !_isValidImageUrl(room.urlImages)
            ? const Icon(Icons.groups, color: Colors.white)
            : null,
      ),
      title:
          Text(roomName, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text('$prefix$content',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.grey)),
      trailing:
          Text(time, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              roomChatPreview: widget.preview,
            ),
          ),
        );

        // Call refresh callback when returning from ChatScreen
        if (widget.onReturn != null) {
          widget.onReturn!();
        }
      },
    );
  }
}
