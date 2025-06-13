// ignore_for_file: avoid_print, file_names, use_build_context_synchronously, curly_braces_in_flow_control_structures

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:testflutter/models/ChannelModel.dart';
import 'package:testflutter/models/UserSession.dart';
import 'package:testflutter/screen/ChannelScreen/NewMemberWidget.dart';
import 'package:testflutter/services/channel_api_service.dart';

class AddGroupScreen extends StatefulWidget {
  const AddGroupScreen({super.key});

  @override
  State<AddGroupScreen> createState() => _AddGroupScreenState();
}

class _AddGroupScreenState extends State<AddGroupScreen> {
  final TextEditingController _groupNameController = TextEditingController();
  //chỉnh sửa sau
  // List<String> selectedUsers = []; // List này sẽ chứa user được chọn
  bool isLoading = false;
  ChannelModel channel = ChannelModel.initial();
  //List<Map<String, dynamic>> _friendResults = [];
  //File? _imageFile; // Biến để lưu tệp ảnh đã chọn
  //String? _imageUrl; // Biến để lưu URL của ảnh sau khi upload

  @override
  void initState() {
    super.initState();
    // _fetchFriendsOfCurrentUser();
  }

  // void _fetchFriendsOfCurrentUser() async {
  //   List<Map<String, dynamic>> results =
  //       await _friendService.getFriendsOfCurrentUser();
  //   setState(() {
  //     _friendResults = results;
  //   });
  // }

  // void _toggleSelection(String userId) {
  //   setState(() {
  //     if (selectedUsers.contains(userId)) {
  //       selectedUsers.remove(userId); // Bỏ chọn người dùng
  //     } else {
  //       selectedUsers.add(userId); // Chọn người dùng
  //     }
  //   });
  //   print(selectedUsers);
  // }

  Future<ChannelModel> _createGroup() async {
    if (_groupNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a group name")),
      );
      return channel;
    }

    if (UserSession.currentUser?.id != null) {
      final channelApiService = ChannelApiService();
      channel =
          (await channelApiService.createChannel(_groupNameController.text))!;
    }
    return channel;
  }

  // Future<void> _pickImage() async {
  //   final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
  //   if (pickedFile != null) {
  //     setState(() {
  //       _imageFile = File(pickedFile.path); // Lưu tệp ảnh đã chọn
  //     });

  //     // Upload ảnh lên Firebase Storage
  //     _imageUrl =
  //         await _imageService.uploadImageToFirebaseStorage(_imageFile!, true);

  //     // // Sau khi có URL ảnh, lưu vào Firestore (ví dụ như lưu vào tài liệu của group)
  //     // if (_imageUrl != null) {
  //     //   await FirebaseFirestore.instance.collection('groups').add({
  //     //     'imageUrl': _imageUrl,
  //     //     'nameRoom': _groupNameController.text,
  //     //     'createdAt': DateTime.now().millisecondsSinceEpoch,
  //     //     'userIds': selectedUsers,
  //     //   });
  //     // }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios,
                  size: 25, color: Colors.blue)),
          title: Column(
            children: [
              const Center(
                  child: Text("Create a group",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.blue))),
              Text("Numbers of member:",
                  style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          actions: [
            IconButton(
                onPressed: () {
                  _createGroup();
                },
                icon: const Icon(Icons.check, size: 25, color: Colors.blue))
          ],
        ),
        body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(32, 10, 32, 10),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Stack(children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.blue[50], // Đặt màu nền xanh nhạt
                            shape: BoxShape.circle, // Giữ nút hình tròn
                          ),
                          child: IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.image),
                            color: Colors.blue,
                            iconSize: 35,
                          ),
                          // child: _imageFile != null
                          //     ? ClipOval(
                          //         child: Image.file(_imageFile!,
                          //             width: 50, height: 50, fit: BoxFit.cover),
                          //       )
                          //     : IconButton(
                          //         onPressed: () {},
                          //         icon: const Icon(Icons.image),
                          //         color: Colors.blue,
                          //         iconSize: 35,
                          //       ),
                        ),
                        Positioned(
                          right: 0, // Vị trí góc phải
                          bottom: 0, // Vị trí góc dưới
                          child: GestureDetector(
                            onTap: () {
                              // _pickImage(); // Gọi hàm chọn ảnh
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.white, // Màu nền cho dấu cộng
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                color: Colors.blue,
                                Icons.add_circle, // Dấu cộng
                                size: 18, // Kích thước của dấu cộng
                              ),
                            ),
                          ),
                        ),
                      ]),
                      const SizedBox(
                          width:
                              30), // Khoảng cách giữa CircleAvatar và TextField
                      Expanded(
                        // Sử dụng Expanded để TextField chiếm phần không gian còn lại
                        child: Column(
                          children: [
                            TextFormField(
                              decoration: const InputDecoration(
                                hintText: 'Name your group',
                                hintStyle:
                                    TextStyle(color: Colors.grey, fontSize: 17),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide
                                      .none, // Remove default underline
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide
                                      .none, // Remove default underline on focus
                                ),
                              ),
                              controller: _groupNameController,
                            ),
                            // const DashedUnderline(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                // const CustomSearchField(),
                const SizedBox(
                  height: 20,
                ),
                // Expanded(
                //     child: ListView.builder(
                //         itemCount: _friendResults.length,
                //         itemBuilder: (context, index) {
                //           String nameUserChat =
                //               _friendResults[index]['fullname'];
                //           String idUserChat = _friendResults[index]['uid'];
                //           bool isSelected = selectedUsers.contains(idUserChat);
                //           return NewMemberWidget(
                //             name: nameUserChat,
                //             isSelected: isSelected,
                //             onSelected: () {
                //               _toggleSelection(
                //                   idUserChat); // Cập nhật trạng thái người dùng được chọn
                //             },
                //           );
                //         }))
              ],
            )));
  }
}
