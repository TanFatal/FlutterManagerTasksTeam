import 'package:flutter/material.dart';
import 'package:testflutter/screen/ChannelScreen/ChannelPage.dart';
import 'package:testflutter/screen/HomeScreen/HomePage.dart';
import 'package:testflutter/screen/ProjectScreen/ListProjectScreen.dart';
import 'package:testflutter/screen/ProjectScreen/ProjectPage.dart';
import 'package:testflutter/screen/chat/ChatPage.dart';

class Mainscreen extends StatefulWidget {
  const Mainscreen({super.key});

  @override
  State<Mainscreen> createState() => _Mainscreen();
}

final List<Widget> _screens = [
  HomePage(),
  ListProjectScreen(),
  ChannelPage(),
  ChatPage(),
];

class _Mainscreen extends State<Mainscreen> {
  String? profileData;

  // Hàm để xác định lời chào

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        animationDuration: const Duration(seconds: 1),
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: _navBarItems,
      ),
    );
  }
}

var _navBarItems = [
  const NavigationDestination(
    icon: Icon(Icons.home_outlined),
    selectedIcon: Icon(Icons.home_rounded),
    label: 'Home',
  ),
  const NavigationDestination(
    icon: Icon(Icons.dashboard_outlined),
    selectedIcon: Icon(Icons.dashboard_rounded),
    label: 'Project',
  ),
  const NavigationDestination(
    icon: Icon(Icons.groups_outlined),
    selectedIcon: Icon(Icons.groups_rounded),
    label: 'Channel',
  ),
  const NavigationDestination(
    icon: Icon(Icons.chat_bubble_outline),
    selectedIcon: Icon(Icons.chat_bubble_rounded),
    label: 'Chat',
  ),
];
