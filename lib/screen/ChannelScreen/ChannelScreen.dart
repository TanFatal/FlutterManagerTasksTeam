// ignore_for_file: file_names, use_build_context_synchronously, sort_child_properties_last, avoid_print, unnecessary_to_list_in_spreads, curly_braces_in_flow_control_structures

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:testflutter/models/ChannelModel.dart';
import 'package:testflutter/models/ProjectModel.dart';
import 'package:testflutter/models/UserSession.dart';
import 'package:testflutter/models/user.dart';
import 'package:testflutter/screen/ChannelScreen/InformationGroupScreen.dart';
import 'package:testflutter/services/channel_api_service.dart';
import 'package:testflutter/services/projectService.dart';
import 'package:intl/intl.dart';

class ChannelScreen extends StatefulWidget {
  final ChannelModel channel;
  const ChannelScreen({super.key, required this.channel});

  @override
  State<ChannelScreen> createState() => _ChannelScreen();
}

class _ChannelScreen extends State<ChannelScreen> {
  //final MeetingService _meetingService = MeetingService();

  final TextEditingController _nameProjectController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // New state variables for date and member selection
  DateTime? _selectedEndDate;
  List<User> _channelMembers = [];
  List<User> _selectedMembers = [];
  bool _isLoadingMembers = false;

  final ChannelApiService _channelApiService = ChannelApiService();
  final ProjectService _projectService = ProjectService();

  @override
  void initState() {
    super.initState();
    _loadChannelMembers();
  }

  // Load members of the channel
  Future<void> _loadChannelMembers() async {
    setState(() {
      _isLoadingMembers = true;
    });

    try {
      final members = await _channelApiService
          .getAllMemberOfChannel(widget.channel.channelId);
      setState(() {
        _channelMembers = members;
        _isLoadingMembers = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingMembers = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading members: $e')),
      );
    }
  }

  // Show date and time picker
  Future<void> _selectEndDate() async {
    // First pick date
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate != null) {
      // Then pick time
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        final DateTime selectedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        setState(() {
          _selectedEndDate = selectedDateTime;
        });
      }
    }
  }

  // Show member selection dialog
  Future<void> _showMemberSelectionDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Select Members'),
              content: SizedBox(
                width: double.maxFinite,
                height: 300,
                child: _isLoadingMembers
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: _channelMembers.length,
                        itemBuilder: (context, index) {
                          final member = _channelMembers[index];
                          final isSelected = _selectedMembers.contains(member);

                          return CheckboxListTile(
                            title: Text(member.fullname ?? 'Unknown'),
                            subtitle: Text(member.email ?? ''),
                            value: isSelected,
                            onChanged: (bool? value) {
                              setDialogState(() {
                                if (value == true) {
                                  _selectedMembers.add(member);
                                } else {
                                  _selectedMembers.remove(member);
                                }
                              });
                              setState(() {}); // Update parent state
                            },
                          );
                        },
                      ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Done'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Create project with selected data
  Future<void> _createProject() async {
    if (_nameProjectController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a project name")),
      );
      return;
    }

    if (_selectedEndDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select an end date and time")),
      );
      return;
    }

    if (_selectedMembers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select at least one member")),
      );
      return;
    }

    try {
      final memberIds = _selectedMembers.map((member) => member.id).toList();

      final project = await _projectService.createProject(
        widget.channel.channelId,
        _nameProjectController.text,
        _descriptionController.text,
        _selectedEndDate!,
        memberIds,
      );

      if (project != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Project created successfully!")),
        );

        // Clear form
        _nameProjectController.clear();
        _descriptionController.clear();
        setState(() {
          _selectedEndDate = null;
          _selectedMembers.clear();
        });

        Navigator.of(context).pop(); // Close dialog
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to create project")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error creating project: $e")),
      );
    }
  }

  void _showCreateProjectBottomSheet(
      BuildContext context, ChannelModel channel) async {
    if (channel.adminId == UserSession.currentUser?.id) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        ),
        builder: (BuildContext context) {
          return Container(
            height: 600, // Increased height for additional fields
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 16,
              right: 16,
              top: 16,
            ),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(15)),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'New Project',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    controller: _nameProjectController,
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: Colors.blue),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide:
                            const BorderSide(color: Colors.blue, width: 2),
                      ),
                      hintText: 'Name Project',
                      hintStyle: const TextStyle(color: Colors.grey),
                      suffixIcon: const Icon(Icons.star_outline,
                          color: Colors.blueAccent),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 20.0),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: Colors.blue),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide:
                            const BorderSide(color: Colors.blue, width: 2),
                      ),
                      hintText: 'Description',
                      hintStyle: const TextStyle(color: Colors.grey),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 20.0),
                    ),
                    maxLines: 5,
                  ),
                  const SizedBox(height: 16),

                  // End Date Selection
                  InkWell(
                    onTap: _selectEndDate,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 20.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue),
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _selectedEndDate == null
                                ? 'Select End Date & Time'
                                : DateFormat('dd/MM/yyyy HH:mm')
                                    .format(_selectedEndDate!),
                            style: TextStyle(
                              color: _selectedEndDate == null
                                  ? Colors.grey
                                  : Colors.black,
                              fontSize: 16,
                            ),
                          ),
                          const Icon(Icons.calendar_today,
                              color: Colors.blueAccent),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Member Selection
                  InkWell(
                    onTap: _showMemberSelectionDialog,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 20.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue),
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              _selectedMembers.isEmpty
                                  ? 'Select Members'
                                  : '${_selectedMembers.length} member(s) selected',
                              style: TextStyle(
                                color: _selectedMembers.isEmpty
                                    ? Colors.grey
                                    : Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const Icon(Icons.people, color: Colors.blueAccent),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  ElevatedButton(
                    onPressed: _createProject,
                    child: const Text('Create New Project'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue, // Màu chữ
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } else {
      // Nếu không phải admin, bạn có thể hiển thị thông báo hoặc không cho phép tạo dự án
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'You do not have permission to create projects in this group.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Số lượng tab
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios),
            color: Colors.blue,
          ),
          title: Text("ádasdasd",
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.blue)),
          actions: [
            PopupMenuButton<String>(
              color: Colors.white,
              icon: const Icon(Icons.videocam_outlined, color: Colors.blue),
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'instant',
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.video_call_outlined),
                      SizedBox(width: 10),
                      Text('Create an instant meeting'),
                    ],
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'schedule',
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.schedule),
                      SizedBox(width: 10),
                      Text('Schedule a meeting'),
                    ],
                  ),
                ),
              ],
            ),
            IconButton(
                onPressed: () {
                  _showCreateProjectBottomSheet(context, widget.channel);
                },
                icon: const Icon(
                  Icons.star_outline,
                  color: Colors.blue,
                )),
            IconButton(
              color: Colors.blue,
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (_) =>
                          InformationChannel(channel: widget.channel)),
                );
              },
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: "Meets"), // Tab cho các bài đăng
              Tab(text: "Files"), // Tab cho lưu tài liệu
            ],
            indicatorColor: Colors.blue, // Màu của thanh trượt
            labelColor: Colors.blue, // Màu của văn bản đã chọn
            unselectedLabelColor: Colors.black, // Màu văn bản chưa chọn
            dividerColor: Colors.transparent,
          ),
        ),
        body: TabBarView(
          children: [
            // Nội dung của tab Bài Đăng
            MeetingsTab(channel: widget.channel),
            // Nội dung của tab Tài Liệu
            FilesTab(channel: widget.channel),
          ],
        ),
      ),
    );
  }
}

class MeetingsTab extends StatefulWidget {
  final ChannelModel channel;
  const MeetingsTab({super.key, required this.channel});

  @override
  State<MeetingsTab> createState() => _MeetingsTabState();
}

class _MeetingsTabState extends State<MeetingsTab> {
  @override
  Widget build(BuildContext context) {
    //final MeetingService meetingService = MeetingService();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [],
      ),
    );
  }
}

class FilesTab extends StatefulWidget {
  final ChannelModel channel;
  const FilesTab({super.key, required this.channel});

  @override
  State<FilesTab> createState() => _FilesTabState();
}

class _FilesTabState extends State<FilesTab> {
  String currentFolderId = "Home";

  void _showCreateFolderDialog() {
    String folderName = '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text("Create folder"),
          content: TextField(
            onChanged: (value) {
              folderName = value;
            },
            decoration: const InputDecoration(
              labelText: "Name folder",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                if (folderName.isNotEmpty) {
                  //await _createFolder(folderName);
                  setState(() {}); // Làm mới UI
                }
                Navigator.pop(context);
              },
              child: const Text("Create"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Thanh điều hướng folder (Breadcrumb)
          Row(
            children: [
              TextButton(
                child: const Text('Home',
                    style: TextStyle(fontSize: 16, color: Colors.grey)),
                onPressed: () {
                  setState(() {
                    //listFolderNavi = [];
                    currentFolderId = 'Home';
                    print('current: $currentFolderId');
                  });
                },
              ),
              const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
            ],
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FloatingActionButton.extended(
                      backgroundColor: Colors.white,
                      heroTag: "create_folder_fab",
                      onPressed: _showCreateFolderDialog,
                      label: const Text(
                        "Create folder",
                        style: TextStyle(color: Colors.blue),
                      ),
                      icon: const Icon(Icons.create_new_folder,
                          color: Colors.blue),
                    ),
                    const SizedBox(height: 8.0),
                    FloatingActionButton.extended(
                      backgroundColor: Colors.white,
                      heroTag: "upload_file_fab",
                      onPressed: () => {},
                      label: const Text("Upload file",
                          style: TextStyle(color: Colors.blue)),
                      icon: const Icon(Icons.upload_file, color: Colors.blue),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
