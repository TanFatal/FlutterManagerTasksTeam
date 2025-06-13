import 'package:testflutter/models/LastMessageModel.dart';
import 'package:testflutter/models/MessageModel.dart';
import 'package:testflutter/models/RoomChatModel.dart';

class RoomChatPreviewModel {
  final LastMessageModel lastMessage;
  final RoomChatModel roomChat;

  const RoomChatPreviewModel({
    required this.lastMessage,
    required this.roomChat,
  });

 
}
