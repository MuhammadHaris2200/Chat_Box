import 'package:chat_box/constants/app_colors.dart';
import 'package:chat_box/constants/app_icons.dart';
import 'package:chat_box/contacts_bottom_sheet.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<HomeScreen> {
  ///Page controller jis se hum pages ko controll krte ha
  final PageController _pageController = PageController();

  ///Current index
  int _currentIndex = 0;

  ///ye vo func ha jb page view k icons click
  ///honge tw index ki value chage hoti rhegi
  void _onIconTap(int index) {
    setState(() => _currentIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  ///Ye func message icon k liye ha qk jb message
  ///icon pe click hoga tw current user ko apne vo
  ///users show honge jin se chats ki ha us ne
  ///or ye call jb hoga tw (_onIconTap) ki value 0 hojaegi
  void _onMessagesTap() {
    _onIconTap(0);

    ///ye func press hone pe bottom sheet show hogi
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => ContactsBottomSheet(),
    );
  }

  @override
  ///dispose func takay textfield page
  ///se navigate hone k bd dipose hojae
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      ///Text field in app bar
      appBar: AppBar(
        title: const Text("Home"),
        centerTitle: true,
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search users...",
                prefixIcon: Icon(AppIcons.materialSearchIcon),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: AppColors.greyColor,
              ),
            ),
          ),
        ),
      ),

      ///Page view in body jis ma kaha ha k jese
      ///hi page view change ho tw current index
      ///ki value i k equal krdo
      body: PageView(
        controller: _pageController,
        onPageChanged: (i) => setState(() => _currentIndex = i),
        children: const [
          ///Page view k 4 pages
          Center(child: Text("Messages Page")),
          Center(child: Text("Calls Page")),
          Center(child: Text("Contacts Page")),
          Center(child: Text("Settings Page")),
        ],
      ),

      ///Bottom navigation bar
      bottomNavigationBar: BottomNavigationBar(
        ///Current index ki value jo zero ha
        currentIndex: _currentIndex,

        ///or on tap pe kaha k agr index ki value
        ///zero ha tw (_onMessagesTap) func show
        ///kro varna (_onIconTap) func
        onTap: (index) {
          if (index == 0) {
            _onMessagesTap();
          } else {
            _onIconTap(index);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return HomeScreen();
                },
              ),
            );
          }
        },
        selectedItemColor: AppColors.blueColor,
        unselectedItemColor: AppColors.greyColor,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.message), label: "Messages"),
          BottomNavigationBarItem(icon: Icon(Icons.call), label: "Calls"),
          BottomNavigationBarItem(
            icon: Icon(Icons.contacts),
            label: "Contacts",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
