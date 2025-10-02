import 'package:chat_box/constants/app_colors.dart';
import 'package:chat_box/constants/app_icons.dart';
import 'package:chat_box/search_results.dart';
import 'package:chat_box/widgets/chats_bottom_sheet.dart';
import 'package:chat_box/widgets/search_bar_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ///Page controller for control page view icons
  final PageController _pageController = PageController();

  ///current index of page view is equal to 0
  int _currentIndex = 0;

  ///controller for searching current users
  final TextEditingController _searchController = TextEditingController();

  ///initially empty
  String searchQuery = '';

  ///Current user
  String get currentUserId => FirebaseAuth.instance.currentUser!.uid;

  ///jb page view k icons pe tap krenge tw is func se
  ///value change hogi jis se icons bhi change honge
  void _onIconTap(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  ///Page view k message icon pe tap krne se ye
  ///func call hoga jis se recent chat show hojaegi
  void _onMessagesTap() {
    _onIconTap(0);

    showModalBottomSheet(
      context: context,
      shape: StadiumBorder(),
      isScrollControlled: true,
      builder: (context) => ChatsBottomSheet(currentUserId: currentUserId),
    );
  }

  ///dispose func ma controllers ko call
  ///kiya ha takay memory leak na ho
  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ///Media query initialization
    final mq = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Home"),
          centerTitle: true,
          automaticallyImplyLeading: false,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(mq.height * .07),

            ///custom widget (search bar widget)
            child: SearchBarWidget(
              controller: _searchController,
              onChanged: (v) => setState(() => searchQuery = v.trim()),
            ),
          ),
        ),

        body: searchQuery.isEmpty
            ? PageView(
                controller: _pageController,
                onPageChanged: (value) {
                  setState(() {
                    _currentIndex = value;
                  });
                },
                children: const [
                  Center(child: Text("Messages Page")),
                  Center(child: Text("Calls Page")),
                  Center(child: Text("Contacts Page")),
                  Center(child: Text("Settings Page")),
                ],
              )
            ///custom widget for users search
            : SearchResultsList(
                searchQuery: searchQuery,
                currentUserId: currentUserId,
              ),

        ///bottom navigation bar
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            if (index == 0) {
              _onMessagesTap();
            } else {
              _onIconTap(index);
            }
          },
          selectedItemColor: AppColors.blueColor,
          unselectedItemColor: AppColors.blackColor,
          items: [
            BottomNavigationBarItem(
              icon: Icon(AppIcons.materialMessageIcon),
              label: "Messages",
            ),
            BottomNavigationBarItem(
              icon: Icon(AppIcons.cupertinoCallIcon),
              label: "Calls",
            ),
            BottomNavigationBarItem(
              icon: Icon(AppIcons.cupertinoContacts),
              label: "Contacts",
            ),
            BottomNavigationBarItem(
              icon: Icon(AppIcons.cupertinoSettings),
              label: "Settings",
            ),
          ],
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }
}
