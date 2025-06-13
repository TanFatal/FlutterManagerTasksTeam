// ignore_for_file: file_names

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:testflutter/Widget/chat/ChattingUsers.dart';
import 'package:testflutter/models/RoomChatModel.dart';
import 'package:testflutter/models/LastMessageModel.dart';
import 'package:testflutter/models/RoomChatPreView.dart';
import 'package:testflutter/models/UserSession.dart';
import 'package:testflutter/services/roomChat_api_service.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPage();
}

class _ChatPage extends State<ChatPage>
    with AutomaticKeepAliveClientMixin<ChatPage> {
  final RoomChatApiService _roomChatService = RoomChatApiService();
  late Future<List<RoomChatPreviewModel>> _previewFuture;

  @override
  void initState() {
    super.initState();
    _previewFuture = _loadPreviews();
  }

  Future<List<RoomChatPreviewModel>> _loadPreviews() async {
    final rooms = await _roomChatService
        .getAllRoomChatByCurrentUser(UserSession.currentUser!.id);

    log(UserSession.currentUser!.id.toString());
    List<RoomChatPreviewModel> result = [];
    log(rooms.toString());

    for (final room in rooms) {
      final lastMsg =
          await _roomChatService.getLastMassageByRoomChat(room.roomChatId!);

      result.add(RoomChatPreviewModel(
        lastMessage: lastMsg ??
            LastMessageModel.initial(), // Truyền một đối tượng rỗng nếu null
        roomChat: room,
      ));
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("CHAT",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<List<RoomChatPreviewModel>>(
        future: _previewFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final previews = snapshot.data ?? [];
          if (previews.isEmpty) {
            return const Center(child: Text("No conversations."));
          }
          previews.sort((a, b) => b.lastMessage.message.timestamp
              .compareTo(a.lastMessage.message.timestamp));

          return ListView.builder(
            itemCount: previews.length,
            itemBuilder: (_, i) => ChattingUsersWidget(preview: previews[i]),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
