import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:testflutter/Widget/GroupWidget.dart';
import 'package:testflutter/models/ChannelModel.dart';
import 'package:testflutter/models/UserSession.dart';
import 'package:testflutter/screen/ChannelScreen/AddGroupScreen.dart';
import 'package:testflutter/screen/ChannelScreen/EventCalendarScreen.dart';
import 'package:testflutter/services/channel_api_service.dart';

class ChannelPage extends StatefulWidget {
  const ChannelPage({super.key});

  @override
  State<ChannelPage> createState() => _ChannelPage();
}

class _ChannelPage extends State<ChannelPage> {
  List<ChannelModel> channels = [];

  Future<List<ChannelModel>> _getAllChannel(dynamic serSession) async {
    if (UserSession.currentUser?.id != null) {
      final channelApiService = ChannelApiService();
      channels = await channelApiService
          .getChannelByUserId(UserSession.currentUser!.id);
      if (channels.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Không có nhóm nào được tìm thấy!")),
        );
      }
    }
    return channels;
  }

  @override
  void initState() {
    super.initState();
    //_channelsFuture = _getAllChannel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Groups'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month, size: 30),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const EventCalendarScreen(),
                ),
              );
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 36),
        child: Stack(
          children: [
            FutureBuilder<List<ChannelModel>>(
              future: _getAllChannel(UserSession.currentUser?.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Đã xảy ra lỗi!'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                      child: Text('Không có nhóm nào được tìm thấy!'));
                } else {
                  final channels = snapshot.data!;
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                      childAspectRatio: 1.3,
                    ),
                    itemCount: channels.length,
                    itemBuilder: (context, index) {
                      final channel = channels[index];
                      return GroupWidget(channel: channel);
                    },
                  );
                }
              },
            ),
            Positioned(
              bottom: 40,
              right: 30,
              child: Container(
                width: 55,
                height: 55,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8.0,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Material(
                    color: Colors.blue,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const AddGroupScreen(),
                          ),
                        );
                      },
                      child: const SizedBox(
                        width: 60,
                        height: 60,
                        child: Icon(Icons.add, size: 30, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
