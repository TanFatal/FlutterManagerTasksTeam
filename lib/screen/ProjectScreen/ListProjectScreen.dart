// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:testflutter/Widget/project/ProjectWidget%20copy.dart';
import 'package:testflutter/models/ChannelModel.dart';
import 'package:testflutter/models/ProjectModel.dart';
import 'package:testflutter/models/UserSession.dart';
import 'package:testflutter/services/channel_api_service.dart';
import 'package:testflutter/services/projectService.dart';

// import 'package:ruprup/widgets/search/SearchWidget.dart';

class ListProjectScreen extends StatefulWidget {
  const ListProjectScreen({super.key});

  @override
  State<ListProjectScreen> createState() => _ListProjectScreenState();
}

class _ListProjectScreenState extends State<ListProjectScreen> {
  List<ChannelModel> channels = []; // Danh sách các kênh
  List<ProjectModel> projects = [];
  String? _selectedGroupId = 'All'; // Biến để lưu trữ nhóm được chọn
  //List<Map<String, String>> _groups = []; // Danh sách nhóm với id và tên

  @override
  void initState() {
    super.initState();
    _fetchGroups();
  }

  Future<void> _fetchGroups() async {
    try {
      channels = await ChannelApiService()
          .getChannelByUserId(UserSession.currentUser?.id);
      setState(() {});
      if (mounted) {
        _fetchProjects(null); // Lấy tất cả dự án khi khởi tạo
      }
    } catch (e) {
      // ignore: avoid_print
      print("Error fetching groups: $e");
    }
  }

  void _fetchProjects(int? channelId) async {
    try {
      List<ProjectModel> fetchedProjects = channelId == null
          ? await ProjectService().getAllProjectByCurrentUser()
          : await ProjectService().getAllProjectOfChannelId(channelId);

      setState(() {
        projects = fetchedProjects;
      });
    } catch (e) {
      print("Error fetching projects: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Projects'),
          // actions: [
          //   IconButton(
          //     icon: const Icon(Icons.calendar_month, size: 30),
          //     onPressed: () {
          //       Navigator.of(context).push(
          //         MaterialPageRoute(
          //           builder: (_) =>
          //         ),
          //       );
          //     },
          //   ),
          // ],
        ),
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 56),
          child: Column(children: [
            // CustomSearchField(),
            // const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // Màu nền dropdown
                    borderRadius:
                        BorderRadius.circular(16.0), // Bo tròn dropdown
                    border: Border.all(
                      color: Colors.grey.shade300, // Đường viền của dropdown
                      width: 1.0,
                    ),
                  ),
                  child: DropdownButton<String>(
                    value: _selectedGroupId,
                    hint: const Text('All group'),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedGroupId = newValue!;
                        _fetchProjects(newValue == 'All'
                            ? null
                            : int.parse(newValue)); // Đổi sang `channelId`
                      });
                    },
                    items: [
                      DropdownMenuItem(
                          value: "All", child: Text("All Channels")),
                      ...channels.map((channel) => DropdownMenuItem<String>(
                            value:
                                channel.channelId.toString(), // Sửa lỗi ở đây
                            child: Text(channel.channelName),
                          ))
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 15),
            projects.isEmpty
                ? Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.dashboard_outlined,
                            size: 80,
                            color: Colors.blue,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No projects available!',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Create your first project and start collaborating.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: projects.length,
                      itemBuilder: (context, index) {
                        final project = projects[index];
                        return ProjectWidget(project: project);
                      },
                    ),
                  )
          ]),
        ));
  }
}
