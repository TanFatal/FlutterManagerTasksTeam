import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:testflutter/config/clouddinaryConfig.dart';
import 'package:testflutter/models/UserSession.dart';
import 'package:testflutter/screen/ProfileCreen/AvatarPreview.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(flex: 1, child: _TopPortion()),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        UserSession.currentUser?.fullname ?? "User Name",
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        UserSession.currentUser?.email ?? "",
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w300,
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FloatingActionButton.extended(
                        onPressed: () {},
                        heroTag: 'profile',
                        elevation: 0,
                        backgroundColor: Color(0xFFA8F94B),
                        label: const Text("Change Profile"),
                        icon: const Icon(Icons.edit_outlined),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const _ProfileInfoRow(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileInfoRow extends StatelessWidget {
  const _ProfileInfoRow();

  final List<ProfileInfoItem> _items = const [
    ProfileInfoItem("Channel", 900),
    ProfileInfoItem("Project", 120),
    ProfileInfoItem("Tasks", 200),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      constraints: const BoxConstraints(maxWidth: 400),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _items
            .map(
              (item) => Expanded(
                child: Row(
                  children: [
                    if (_items.indexOf(item) != 0) const VerticalDivider(),
                    Expanded(child: _singleItem(context, item)),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _singleItem(BuildContext context, ProfileInfoItem item) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              item.value.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          Text(item.title, style: Theme.of(context).textTheme.bodySmall),
        ],
      );
}

class ProfileInfoItem {
  final String title;
  final int value;
  const ProfileInfoItem(this.title, this.value);
}

class _TopPortion extends StatefulWidget {
  @override
  State<_TopPortion> createState() => _TopPortionState();
}

class _TopPortionState extends State<_TopPortion> {
  final ImagePicker _picker = ImagePicker();
  final cloudinary = CloudinaryService();

  get newUrl => null;
  void _changeAvatar() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    final File image = File(pickedFile.path);

    // Mở trang preview
    final isSaved = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AvatarPreviewPage(imageFile: image),
      ),
    );

    if (isSaved == true) {
      setState(() {}); // Cập nhật giao diện nếu đã lưu thành công
    }
  }

  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Stack(
          children: [
            // Container làm nền
            Container(
              width: double.infinity,
              height: 200, // Điều chỉnh chiều cao nếu cần
              margin: const EdgeInsets.only(bottom: 50),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xff0043ba), Color(0xff006df1)],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),
            ),

            // IconButton nằm trên
            Positioned(
              left: 10, // Điều chỉnh vị trí icon
              top: 30,
              child: Container(
                padding: EdgeInsets.all(
                    8), // Điều chỉnh khoảng cách giữa icon và border
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color.fromARGB(
                      255, 202, 163, 163), // Màu nền của icon
                  border: Border.all(
                    color: const Color.fromARGB(255, 22, 22, 22), // Màu viền
                    width: 2, // Độ dày viền
                  ),
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new,
                      color: Color.fromARGB(255, 14, 12, 12)),
                  onPressed: () {
                    Navigator.pop(context); // Quay lại khi nhấn nút
                  },
                ),
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: 150,
            height: 150,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        UserSession.currentUser?.urlImg.isNotEmpty == true
                            ? UserSession.currentUser!.urlImg
                            : 'https://i.pravatar.cc/150?img=3',
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      // TODO: Thêm xử lý khi người dùng bấm vào để chọn ảnh mới
                      print("Đổi ảnh đại diện");
                      _changeAvatar();
                      // Ví dụ: gọi showModalBottomSheet hoặc mở ImagePicker
                    },
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      child: Container(
                        margin: const EdgeInsets.all(4.0),
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 120, 181, 122),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt, // Biểu tượng "thay đổi"
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
