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
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.0),
                    border: Border.all(
                      color: Colors.blue.shade300,
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: DropdownButton<String>(
                    value: _selectedGroupId,
                    hint: const Text(
                      'Select Channel',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.blue,
                      size: 28,
                    ),
                    iconSize: 28,
                    elevation: 8,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    underline: Container(), // Remove default underline
                    isExpanded: true,
                    dropdownColor: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedGroupId = newValue!;
                        _fetchProjects(
                            newValue == 'All' ? null : int.parse(newValue));
                      });
                    },
                    items: [
                      DropdownMenuItem(
                        value: "All",
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.select_all_rounded,
                                color: Colors.blue.shade600,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                "All Channels",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      ...channels.map((channel) => DropdownMenuItem<String>(
                            value: channel.channelId.toString(),
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.tag_rounded,
                                    color: Colors.blue.shade400,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      channel.channelName,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
