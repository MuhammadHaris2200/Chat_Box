import 'package:chat_box/constants/app_colors.dart';
import 'package:chat_box/constants/app_icons.dart';
import 'package:chat_box/view/friend_screen.dart';
import 'package:chat_box/view/homeScreen.dart';
import 'package:chat_box/view/profile_screen.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  //real screens jo hum bottom van bar k 
  //icons pe call krvaenge vo yaha call hogi
  final List<Widget> _screens = [
    const HomeScreen(),
    FriendsScreen(),
    const ProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackColor,
      body: _screens[_selectedIndex],
      
      bottomNavigationBar: BottomNavigationBar(
  backgroundColor: AppColors.blackColor,
  currentIndex: _selectedIndex,
  selectedItemColor: AppColors.greenColor,
  unselectedItemColor: AppColors.greyColor,
  showUnselectedLabels: true,
  type: BottomNavigationBarType.fixed,

  onTap: (index) {
    setState(() {
      _selectedIndex = index;
    });
  },

  items: const [
    BottomNavigationBarItem(
      icon: Icon(AppIcons.materialHomeoutlined),
      activeIcon: Icon(AppIcons.materialHomeoutlined),
      label: "Home",
    ),
    BottomNavigationBarItem(
      icon: Icon(AppIcons.materailChatBubbleOutlined),
      activeIcon: Icon(AppIcons.materialChatBubble),
      label: "Chat",
    ),
    BottomNavigationBarItem(
      icon: Icon(AppIcons.materialPersonOutlined),
      activeIcon: Icon(AppIcons.materialPersonIcon),
      label: "Profile",
    ),
  ],
),
    );
  }
}
