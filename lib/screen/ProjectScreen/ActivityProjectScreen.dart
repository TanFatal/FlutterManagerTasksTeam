// ignore_for_file: file_names

import 'package:flutter/material.dart';

import 'package:table_calendar/table_calendar.dart';
import 'package:testflutter/Widget/project/ActivityWidget%20copy.dart';
import 'package:testflutter/models/ActivityLogModel.dart';
import 'package:testflutter/models/ProjectModel.dart';
import 'package:testflutter/services/activityService.dart';

class ActivityProjectScreen extends StatefulWidget {
  final int projectId;
  const ActivityProjectScreen({super.key, required this.projectId});

  @override
  State<ActivityProjectScreen> createState() => _ActivityProjectScreenState();
}

class _ActivityProjectScreenState extends State<ActivityProjectScreen> {
  //late DateTime _selectedDay;
  //late DateTime _focusedDay;
  //CalendarFormat _calendarFormat = CalendarFormat.week;
  List<ActivityLog> activityLog = [];
  @override
  void initState() {
    super.initState();
  }

  void fetchActivityLog(int projectId) async {
    final data =
        await ActivityApiService().getAllActivityByProjectId(projectId);
    if (mounted) {
      setState(() {
        activityLog = data;
      });

      if (activityLog.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Không có dự án nào được tìm thấy!")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.blue)),
        backgroundColor: Colors.white,
        title: const Text('Activities',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 24)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              // child: TableCalendar(
              //   firstDay: DateTime.utc(2020, 1, 1),
              //   lastDay: DateTime.utc(2025, 12, 31),
              //   focusedDay: _focusedDay,
              //   selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              //   onDaySelected: (selectedDay, focusedDay) {
              //     setState(() {
              //       //_selectedDay = selectedDay;
              //       //_focusedDay = focusedDay;
              //       //_fetchActivitiesForDate(_selectedDay);
              //     });
              //   },
              //   onPageChanged: (focusedDay) {
              //     _focusedDay = focusedDay;
              //   },
              //   calendarFormat: _calendarFormat,
              //   onFormatChanged: (format) {
              //     setState(() {
              //       _calendarFormat = format;
              //     });
              //   },
              //   headerStyle: const HeaderStyle(
              //     formatButtonVisible: true,
              //     titleCentered: true,
              //     formatButtonTextStyle: TextStyle(
              //       color: Colors.blue,
              //       fontWeight: FontWeight.bold,
              //     ),
              //     leftChevronIcon: Icon(Icons.chevron_left, color: Colors.blue),
              //     rightChevronIcon:
              //         Icon(Icons.chevron_right, color: Colors.blue),
              //   ),
              //   calendarStyle: CalendarStyle(
              //     selectedDecoration: BoxDecoration(
              //       color: Colors.blue.withOpacity(0.8),
              //       shape: BoxShape.circle,
              //     ),
              //     todayDecoration: BoxDecoration(
              //         color: Colors.white,
              //         shape: BoxShape.circle,
              //         border: Border.all(width: 1, color: Colors.blue)),
              //     todayTextStyle: const TextStyle(color: Colors.blue),
              //     selectedTextStyle: const TextStyle(color: Colors.white),
              //   ),
              // ),
            ),
            const SizedBox(height: 20),
            if (activityLog.isEmpty)
              const Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.history_toggle_off, // Icon đại diện
                        size: 80, // Kích thước lớn hơn để thu hút sự chú ý
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16), // Khoảng cách giữa icon và văn bản
                      Text(
                        'No activities for this day!',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontWeight:
                              FontWeight.w500, // Văn bản đậm hơn một chút
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            Expanded(
              child: ListView.builder(
                itemCount: activityLog.length,
                itemBuilder: (context, index) {
                  final activity = activityLog[index];
                  return ActivityWidget(actLog: activity);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
