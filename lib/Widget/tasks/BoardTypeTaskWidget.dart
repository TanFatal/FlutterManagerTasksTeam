// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:testflutter/Widget/tasks/TypeTaskWidget.dart';
import 'package:testflutter/models/ProjectModel.dart';

class BoardTypeTaskWidget extends StatelessWidget {
  final ProjectModel project;

  const BoardTypeTaskWidget({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final taskTypes = [
      {
        'total': "TODO",
        'typeTask': 'toDo',
        'color': Colors.orangeAccent,
        'icon': Icons.task,
      },
      {
        'total': "inProgress",
        'typeTask': 'inProgress',
        'color': Colors.blueAccent,
        'icon': Icons.timeline,
      },
      {
        'total': "inReview",
        'typeTask': 'inReview',
        'color': Colors.redAccent,
        'icon': Icons.visibility,
      },
      {
        'total': "done",
        'typeTask': 'done',
        'color': Colors.greenAccent,
        'icon': Icons.check_box_rounded,
      },
    ];
    return GridView.count(
      shrinkWrap: true, // Cho phép GridView điều chỉnh kích thước theo nội dung
      physics:
          const NeverScrollableScrollPhysics(), // Ngăn cuộn nếu không cần thiết
      crossAxisCount: 2,
      childAspectRatio: 1.3,
      // children: taskTypes.map((task) {
      //   return TypeTaskWidget(
      //     total: task['total'] as int,
      //     typeTask: task['typeTask'].toString(),
      //     color: task['color'] as Color,
      //     icon: task['icon'] as IconData,
      //     project: project,
      //   );
      // }).toList(),
    );
  }
}
