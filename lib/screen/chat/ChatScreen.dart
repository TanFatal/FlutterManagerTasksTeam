// // ignore_for_file: file_names

// import 'dart:io';
// import 'dart:math';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_chat_ui/flutter_chat_ui.dart';
// import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
// import 'package:image_picker/image_picker.dart';
// import 'package:ruprup/screens/MainScreen.dart';
// import 'package:ruprup/services/chat_service.dart';
// import 'package:ruprup/services/image_service.dart';
// import 'package:ruprup/services/user_service.dart';
// import 'package:ruprup/widgets/avatar/InitialsAvatar.dart';
// import 'package:testflutter/screen/MainScreen.dart';


// class ChatScreen extends StatefulWidget {
//   const ChatScreen({super.key});
//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   Color getColorFromCreatedAt(DateTime createdAt) {
//     // Danh sách 7 màu sắc cầu vồng
//     final List<Color> rainbowColors = [
//       Colors.red.shade300,
//       Colors.orange.shade300,
//       Colors.yellow.shade700,
//       Colors.green.shade300,
//       Colors.blue.shade300,
//       Colors.indigo.shade300,
//       Colors.purple.shade300,
//     ];

//     // Chuyển `createdAt` thành chỉ số trong khoảng từ 0 đến 6
//     final index = createdAt.millisecondsSinceEpoch % rainbowColors.length;
//     return rainbowColors[index];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.blue,
//         foregroundColor: Colors.black,
//         leading: IconButton(
//           onPressed: () {
//             Navigator.of(context).push(
//               MaterialPageRoute(
//                 builder: (_) =>const Mainscreen (),
//               ),
//             );
//           },
//           icon: const Icon(Icons.arrow_back_ios_new, color: Colors.blue),
//         ),
//         title: Row(
//           children: [
//             // CircleAvatar(
//             //   backgroundImage: NetworkImage('${widget.roomChat.imageUrl}'),
//             //   radius: 20,
//             // ),
//             widget.roomChat.type == 'direct' ?
//               PersonalInitialsAvatar(name: nameRoomDirect)
//             :CircleAvatar(
//               radius: 25,
//               backgroundColor: widget.roomChat.imageUrl == null
//                   ? getColorFromCreatedAt(DateTime.fromMillisecondsSinceEpoch(
//                       widget.roomChat.createAt))
//                   : Colors.transparent,
//               backgroundImage: widget.roomChat.imageUrl != null
//                   ? NetworkImage(widget.roomChat.imageUrl!)
//                   : null,
//               child: widget.roomChat.imageUrl == null
//                   ? const Icon(Icons.groups, color: Colors.white, size: 30)
//                   : null,
//             ),
//             const SizedBox(width: 20),
//             Text(
//               nameRoomDirect,
//               style: const TextStyle(fontSize: 20),
//             ),
//           ],
//         ),
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Colors.white, Colors.white70, Colors.blue],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//         ),
//         // actions: [
//         //   IconButton(
//         //     icon: const Icon(Icons.more_horiz),
//         //     onPressed: () {
//         //       ScaffoldMessenger.of(context).showSnackBar(
//         //         const SnackBar(content: Text('Setting')),
//         //       );
//         //     },
//         //   ),
//         // ],
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: Chat(
//               messages: _messages,
//               onSendPressed: (types.PartialText message) {
//                 _handleSendPressed(message);
//               },
//               user: _currentUser,
//               showUserAvatars: true,
//               showUserNames: true,
//               // avatarBuilder: (userId) {
//               //   final messageUser = _messages
//               //       .firstWhere((message) => message.author.id == userId);
//               //   return CircleAvatar(
//               //     backgroundImage: NetworkImage(messageUser.author.avatarUrl ??
//               //         'https://example.com/default-avatar.png'),
//               //   );
//               // },
//               avatarBuilder: (types.User user) {
//                 final userModel = userMap[user.id];

//                 return PersonalInitialsAvatar(name: userModel!.fullname);
//               },
//               nameBuilder: (types.User user) {
//                 // Kiểm tra nếu có userModel cho userId hiện tại
//                 final userModel = userMap[user.id];

//                 // Nếu tìm thấy userModel, hiển thị fullname
//                 if (userModel != null) {
//                   return Text(
//                     userModel.fullname,
//                     style: const TextStyle(
//                       fontWeight: FontWeight.bold,
//                       color: Colors.grey,
//                     ),
//                   );
//                 } else {
//                   // Nếu không tìm thấy userModel, hiển thị 'Unknown'
//                   return const Text(
//                     'Unknown User',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       color: Colors.grey,
//                     ),
//                   );
//                 }
//               },
//               theme: DefaultChatTheme(
//                 inputBackgroundColor: Colors.blue.shade100,
//                 inputTextColor: Colors.black,
//                 sendButtonIcon: const Icon(Icons.send, color: Colors.blue),
//                 primaryColor: Colors.blue,
//                 messageInsetsHorizontal: 15,
//                 messageInsetsVertical: 15,
//               ),
//               customBottomWidget: CustomMessageInput(
//                   onSendPressed: (message) =>
//                       _handleSendPressed(types.PartialText(text: message))),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

// class CustomMessageInput extends StatefulWidget {
//   final Function(String) onSendPressed;

//   const CustomMessageInput({super.key, required this.onSendPressed});

//   @override
//   // ignore: library_private_types_in_public_api
//   _CustomMessageInputState createState() => _CustomMessageInputState();
// }

// class _CustomMessageInputState extends State<CustomMessageInput> {
//   final TextEditingController _controller = TextEditingController();
//   final ImagePicker _picker = ImagePicker();
//   final ImageService imageService = ImageService();

//   void _sendMessage() {
//     if (_controller.text.isNotEmpty) {
//       widget.onSendPressed(_controller.text);
//       _controller.clear();
//     }
//   }

//   Future<void> _pickImage() async {
//     final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       File imageFile = File(pickedFile.path);

//       // Gửi ảnh lên Firebase Storage và lấy URL
//       String imageUrl =
//           await imageService.uploadImageToFirebaseStorage(imageFile, false);
//       // ignore: avoid_print
//       print(imageUrl);

//       widget.onSendPressed(imageUrl); // Gửi đường dẫn hình ảnh
//     }
//   }

//   Future<void> _pickFile() async {
//     try {
//       FilePickerResult? result = await FilePicker.platform.pickFiles();
//       if (result != null) {
//         final file = result.files.single;
//         // ignore: avoid_print
//         print('File picked: ${file.name}');
//         // Gửi file hoặc làm gì đó với file đã chọn
//       }
//     } catch (e) {
//       // ignore: avoid_print
//       print('Error picking file: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(30),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.3),
//               blurRadius: 9,
//               spreadRadius: 5,
//               offset: const Offset(0, 3),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             IconButton(
//               icon: const Icon(Icons.attach_file, color: Colors.blue),
//               onPressed: _pickFile,
//             ),
//             IconButton(
//               icon: const Icon(Icons.image, color: Colors.blue),
//               onPressed: _pickImage,
//             ),
//             Expanded(
//               child: TextField(
//                 controller: _controller,
//                 decoration: const InputDecoration(
//                   hintText: 'Type a message...',
//                   hintStyle: TextStyle(color: Colors.grey),
//                   border: InputBorder.none,
//                   contentPadding:
//                       EdgeInsets.symmetric(vertical: 12, horizontal: 20),
//                 ),
//                 style: const TextStyle(fontSize: 16),
//                 onSubmitted: (value) => _sendMessage(),
//               ),
//             ),
//             IconButton(
//               icon: const Icon(Icons.send, color: Colors.blue),
//               onPressed: _sendMessage,
//               padding: const EdgeInsets.all(8.0),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
