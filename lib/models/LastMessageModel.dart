import 'package:testflutter/models/MessageModel.dart';
import 'package:testflutter/models/RoomChatModel.dart';

class LastMessageModel {
  final MessageModel message;
  final String senderName;

  const LastMessageModel({
    required this.message,
    required this.senderName,
  });

  factory LastMessageModel.fromJson(Map<String, dynamic> json) {
    return LastMessageModel(
      message: MessageModel.fromJson(json['message']),
      senderName: json['senderName'] ?? '',
    );
  }
  factory LastMessageModel.initial() => LastMessageModel(
        message: MessageModel.initial(),
        senderName: '',
      );
}
