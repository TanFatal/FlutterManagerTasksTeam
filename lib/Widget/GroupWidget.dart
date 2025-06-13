import 'package:flutter/material.dart';
import 'package:testflutter/models/ChannelModel.dart';
import 'package:testflutter/screen/ChannelScreen/ChannelPage.dart';
import 'package:testflutter/screen/ChannelScreen/ChannelScreen.dart';

class GroupWidget extends StatelessWidget {
  final ChannelModel channel;

  const GroupWidget({
    super.key,
    required this.channel,
  });

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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChannelScreen(channel: channel),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white, // Đặt màu nền là trắng
          borderRadius: BorderRadius.circular(12.0), // Bo tròn các góc
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), // Màu sắc bóng
              spreadRadius: 2, // Độ lan tỏa của bóng
              blurRadius: 10, // Độ mờ của bóng
              offset: const Offset(0, 3), // Vị trí của bóng (x,y)
            ),
          ],
          //border: Border.all(width: 0.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: getColorFromCreatedAt(
                  DateTime.fromMillisecondsSinceEpoch(
                      channel.createAt.microsecondsSinceEpoch)),
              child: const Icon(
                Icons.groups,
                color: Colors.white,
              ),
              // Khi nào thêm trường urlPicture lưu trữ hình ảnh thì dùng
              //   children: [
              // channel.urlPicture == null
              //   ? CircleAvatar(
              //     radius: 25,
              //     backgroundColor: getColorFromCreatedAt(
              //       DateTime.fromMillisecondsSinceEpoch(
              //       channel.createAt.microsecondsSinceEpoch,
              //       ),
              //     ),
              //     child: const Icon(
              //       Icons.groups,
              //       color: Colors.white,
              //     ),
              //     )
              //   : CircleAvatar(
              //     radius: 25,
              //     backgroundImage: NetworkImage(channel.urlPicture!),
              //     backgroundColor: Colors.transparent,
              //     ),
              // ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Text(
                channel.channelName, // Sử dụng channelName từ đối tượng channel
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
