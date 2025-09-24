import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  void _onIconTap(int idx) {
    setState(() => _currentIndex = idx);
    _pageController.animateToPage(
      idx,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // call when message icon tapped
  void _onMessagesTap() {
    _onIconTap(0);
    _showContactsBottomSheet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home")),
      body: Column(
        children: [
          // Icons row
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Icons.message),
                  color: _currentIndex == 0 ? Colors.blue : Colors.grey,
                  onPressed: _onMessagesTap,
                ),
                IconButton(
                  icon: Icon(Icons.call),
                  color: _currentIndex == 1 ? Colors.blue : Colors.grey,
                  onPressed: () => _onIconTap(1),
                ),
                IconButton(
                  icon: Icon(Icons.contacts),
                  color: _currentIndex == 2 ? Colors.blue : Colors.grey,
                  onPressed: () => _onIconTap(2),
                ),
                IconButton(
                  icon: Icon(Icons.settings),
                  color: _currentIndex == 3 ? Colors.blue : Colors.grey,
                  onPressed: () => _onIconTap(3),
                ),
              ],
            ),
          ),

          // PageView
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (i) => setState(() => _currentIndex = i),
              children: [
                Center(
                  child: Text(
                    "Messages page (tap message icon to open contacts)",
                  ),
                ), // 0
                Center(child: Text("Calls page")),
                Center(child: Text("Contacts page")),
                Center(child: Text("Settings page")),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // we'll define _showContactsBottomSheet() below
  void _showContactsBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return FractionallySizedBox(heightFactor: 0.85, child: Container());
      },
    );
  }
}
