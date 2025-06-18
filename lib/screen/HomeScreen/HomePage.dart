import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:testflutter/Widget/project/ChildProjectWidget.dart';
import 'package:testflutter/Widget/tasks/FastTaskWidget.dart';
import 'package:testflutter/models/ChannelModel.dart';
import 'package:testflutter/models/ProjectModel.dart';
import 'package:testflutter/models/TaskModel.dart';
import 'package:testflutter/models/UserSession.dart';
import 'package:testflutter/screen/AuthScreen/login.dart';
import 'package:testflutter/screen/ProfileCreen/ProfilePage.dart';
import 'package:testflutter/services/channel_api_service.dart';
import 'package:testflutter/services/projectService.dart';
import 'package:testflutter/services/storage/storage_service.dart';
import 'package:testflutter/services/taskService.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  List<ChannelModel> channels = [];
  List<TaskModel> tasks = [];
  List<ProjectModel> recentProjects = [];
  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning';
    } else if (hour < 18) {
      return 'Good afternoon';
    } else {
      return 'Good evening';
    }
  }

  // @override
  // void initState() {
  //   super.initState();
  //   _initializeData();
  // }
  @override
  void logout() async {
    await StorageService.clearTokens();
    if (context.mounted) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => LoginScreen()));
    }
  }

  @override
  void initState() {
    super.initState();
    _loadProjects();
    //_getAllChannel();
    _getAllTaskByUserId();
  }

  void _loadProjects() async {
    //
    final data = await ProjectService().getAllProjectByCurrentUser();
    if (mounted) {
      setState(() {
        recentProjects = data;
      });

      if (recentProjects.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Không có dự án nào được tìm thấy!")),
        );
      }
    }
  }

  // Future<List<ChannelModel>> _getAllChannel() async {
  //   if (UserSession.currentUser?.id != null) {
  //     final channelApiService = ChannelApiService();
  //     channels = await channelApiService
  //         .getChannelByUserId(UserSession.currentUser!.id);
  //     if (channels.isEmpty) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text("Không có nhóm nào được tìm thấy!")),
  //       );
  //     }
  //   }
  //   return channels;
  // }

  Future<List<TaskModel>> _getAllTaskByUserId() async {
    // Get access token properly with await
    final accessToken = await StorageService.getAccessToken();
    final refreshToken = await StorageService.getRefreshToken();

    log("=== BEFORE API CALL ===");
    log("Access Token: ${accessToken != null ? '${accessToken.substring(0, 20)}...' : 'No token found'}");
    log("Refresh Token: ${refreshToken != null ? '${refreshToken.substring(0, 20)}...' : 'No refresh token'}");
    log("========================");

    final data = await TaskApiService().getAllTaskByCurrentUser();

    log("=== AFTER API CALL ===");
    log("Tasks received: ${data.length} items");
    log("=======================");

    if (mounted) {
      setState(() {
        tasks = data;
      });

      if (tasks.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Không có task nào được tìm thấy!")),
        );
      }
    }

    return tasks;
  }

  @override
  Widget build(BuildContext context) {
    String greeting = getGreeting(); // lời chào
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "$greeting ${UserSession.currentUser?.fullname ?? ''} ",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            GestureDetector(
              onTap: () {
                // Hiển thị menu khi click vào ảnh
                showMenu(
                  context: context,
                  position: RelativeRect.fromLTRB(
                      100, 100, 0, 0), // Điều chỉnh vị trí
                  items: [
                    PopupMenuItem<String>(
                      value: 'info',
                      child: Text('Profile Info'),
                    ),
                    PopupMenuItem<String>(
                      value: 'logout',
                      child: Text('Logout'),
                    ),
                  ],
                  elevation: 8.0,
                ).then((value) {
                  if (value == 'info') {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) =>
                              const ProfilePage()), // Chuyển đến trang Profile chi tiết
                    );
                  } else if (value == 'logout') {
                    logout(); // Gọi hàm logout
                  }
                });
              },
              child: CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(
                  UserSession.currentUser?.urlImg.isNotEmpty == true
                      ? UserSession.currentUser!.urlImg
                      : 'https://i.pravatar.cc/150?img=3',
                ), // Hình ảnh thay thế nút ba chấm
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 64),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDateCard(),
              Text(
                'Recent Channels',
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _buildSearch(),
              _buildRecentProjectsSection(),
              // _buildMyProgressTasksSection(),
              _buildTaskList(),
            ],
          ),
        ),
      ),
    );
  }

  // Tạo Card hiển thị ngày tháng
  Widget _buildDateCard() {
    DateTime now = DateTime.now(); // lấy ngày hiện tại
    int currentDay = now.day;
    String currentMonth = DateFormat('MMMM').format(now);

    return GestureDetector(
      onTap: () {
        // Navigator.of(context).push(
        //   MaterialPageRoute(builder: (_) => const EventCalendarScreen()),
        // );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 20,
              offset: Offset(0, 5),
            ),
          ],
          //border: Border.all(width: 0.5, color: Colors.blue)
        ),
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Text(
                    '$currentDay',
                    style: const TextStyle(
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  Text(
                    currentMonth,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Up next',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Column(
                    //   children: meetingProvider.upcomingMeetings.isNotEmpty
                    //       ? meetingProvider.upcomingMeetings.map((meeting) {
                    //           return Padding(
                    //             padding: const EdgeInsets.only(bottom: 8.0),
                    //             child: Row(
                    //               children: [
                    //                 const Icon(Icons.event_outlined,
                    //                     color: Colors.black, size: 20),
                    //                 const SizedBox(width: 8),
                    //                 Expanded(
                    //                   child: Text(
                    //                     meeting.meetingTitle,
                    //                     style: const TextStyle(
                    //                         color: Colors.black, fontSize: 16),
                    //                     overflow: TextOverflow.ellipsis,
                    //                     maxLines: 2,
                    //                   ),
                    //                 ),
                    //               ],
                    //             ),
                    //           );
                    //         }).toList()
                    //       : [
                    //           const SizedBox(
                    //               height: 10), // Khoảng cách bên trên
                    //           const Column(
                    //             mainAxisAlignment: MainAxisAlignment.center,
                    //             children: [
                    //               Center(
                    //                 child: Icon(Icons.event_busy,
                    //                     color: Colors.grey, size: 35),
                    //               ),
                    //               SizedBox(height: 8),
                    //               Text(
                    //                 'No upcoming meetings',
                    //                 style: TextStyle(
                    //                     color: Colors.grey, fontSize: 15),
                    //               ),
                    //             ],
                    //           ),
                    //         ],
                    // )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearch() {
    return GestureDetector(
      // onTap: () {
      //   Navigator.of(context).push(
      //     MaterialPageRoute(builder: (_) => const SearchScreen()),
      //   );
      // },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey[100], // Màu nền nhẹ
          borderRadius: BorderRadius.circular(20), // Bo tròn các góc
        ),
        child: const Row(
          children: [
            Icon(
              Icons.search,
              color: Colors.blue, // Màu biểu tượng
              size: 24, // Kích thước biểu tượng
            ),
            SizedBox(width: 10), // Khoảng cách giữa biểu tượng và văn bản
            Text(
              'Search for people, projects, channels',
              style: TextStyle(
                color: Colors.grey, // Màu chữ
                fontSize: 14, // Kích thước chữ
              ),
            ),
          ],
        ),
      ),
    );
  }

//   // Tạo phần Recent Projects
  Widget _buildRecentProjectsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // const Text('Recent projects',
        //     style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
        // const SizedBox(height: 10),
        recentProjects.isEmpty
            // ? const Center(
            //     child: Text("Currently you have not active projects"))
            ? const SizedBox()
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  children: [
                    // const Text('Recent projects',
                    //     style: TextStyle(
                    //         fontSize: 19, fontWeight: FontWeight.bold)),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: recentProjects.map((project) {
                          return ChildProjectWidget(project: project);
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
      ],
    );
  }

  // Tạo phần My Progress tasks
  // Widget _buildMyProgressTasksSection() {
  //   final projectProvider = Provider.of<ProjectProvider>(context);

  //   // Danh sách dự án kèm tùy chọn mặc định "All"
  //   final projectList = [
  //     {'projectId': 'All', 'projectName': 'All projects'}, // Giá trị mặc định
  //     ...projectProvider.projects.map((project) => {
  //           'projectId': project.projectId,
  //           'projectName': project.projectName,
  //         }),
  //   ];

  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: [
  //       Text(
  //         'Tasks ($task)', // Hiển thị số lượng nhiệm vụ
  //         style: const TextStyle(
  //           fontSize: 19,
  //           fontWeight: FontWeight.bold,
  //         ),
  //       ),
  //       Container(
  //         decoration: BoxDecoration(
  //           color: Colors.white, // Màu nền dropdown
  //           borderRadius: BorderRadius.circular(16.0), // Bo tròn dropdown
  //           // border: Border.all(
  //           //   color: Colors.grey.shade300, // Đường viền của dropdown
  //           //   //width: 1.0,
  //           // ),
  //         ),
  //         child: DropdownButton<String>(
  //           value: _selectedProjectId, // Giá trị đã chọn
  //           alignment: Alignment.centerRight,
  //           onChanged: (String? newValue) {
  //             setState(() {
  //               _selectedProjectId = newValue!;
  //               Provider.of<Task>(context, listen: false)
  //                   .fetchTasksInProgressMe(currentUserId, _selectedProjectId);
  //               _loadTaskCount();
  //             });
  //           },
  //           dropdownColor: Colors.white, // Nền của dropdown
  //           underline: const SizedBox(), // Loại bỏ đường gạch chân
  //           borderRadius: BorderRadius.circular(16.0),
  //           items: projectList.map<DropdownMenuItem<String>>((project) {
  //             return DropdownMenuItem<String>(
  //               value: project['projectId'], // Giá trị của mỗi tùy chọn
  //               child: Container(
  //                 padding: const EdgeInsets.symmetric(horizontal: 4.0),
  //                 decoration: BoxDecoration(
  //                   color: Colors.transparent, // Nền trong suốt
  //                   borderRadius: BorderRadius.circular(12.0),
  //                 ),
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.start,
  //                   children: [
  //                     if (project['projectName'] != 'All projects')
  //                       const Icon(
  //                         Icons.dashboard_outlined,
  //                         color: Colors.blueAccent,
  //                       ),
  //                     const SizedBox(width: 8.0),
  //                     Text(
  //                       project['projectName']!,
  //                       style: const TextStyle(
  //                         color: Colors.black87,
  //                         fontWeight: FontWeight.w500,
  //                         fontSize: 13,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             );
  //           }).toList(),
  //         ),
  //       )
  //     ],
  //   );
  // }

  // Tạo danh sách Task
  Widget _buildTaskList() {
    if (tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.emoji_emotions_outlined,
              size: 80,
              color: Colors.blue,
            ),
            SizedBox(height: 16),
            Text(
              'You\'re free now!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'No tasks assigned to you.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    } else {
      return ListView.builder(
        itemCount: tasks.length,
        shrinkWrap: true, // 👈 Cho phép co lại trong Column
        physics:
            NeverScrollableScrollPhysics(), // 👈 Vô hiệu cuộn riêng của list
        itemBuilder: (context, index) {
          return FastTaskWidget(task: tasks[index]);
        },
      );
    }
  }
}
