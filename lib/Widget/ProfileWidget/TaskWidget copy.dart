import 'package:flutter/material.dart';

class TaskIndivi extends StatelessWidget {
  final Color color;
  final String typeTask;
  final String numberTask;

  const TaskIndivi({
    super.key,
    required this.typeTask,
    required this.numberTask,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    // Tính toán màu sắc nhạt hơn từ màu chính
    Color backgroundColor = color.withOpacity(0.1); // Màu nền nhạt
    Color progressBackgroundColor = color.withOpacity(0.2); // Màu nền vòng tròn
    Color textColor = color.withOpacity(0.8); // Màu chữ chính

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: backgroundColor, // Sử dụng màu nền nhạt
        borderRadius: BorderRadius.circular(15.0), // Bo góc
      ),
      height: 200,
      width: 160,
      //height: 250, // Chiều rộng của widget
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [],
          ),
          const SizedBox(height: 10.0),
          Text(
            typeTask,
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: textColor, // Màu chữ loại task
            ),
          ),
          //SizedBox(height: 10.0),
          Text(
            "$numberTask task",
            style: TextStyle(
              fontSize: 16.0,
              color: color.withOpacity(0.6), // Màu chữ nhạt hơn
            ),
          ),
        ],
      ),
    );
  }
}
