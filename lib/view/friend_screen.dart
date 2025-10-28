import 'package:chat_box/view/contacts_tab.dart';
import 'package:chat_box/view/incoming_request_tab.dart';
import 'package:chat_box/view/send_request_tab';
import 'package:flutter/material.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});
  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Friends'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Incoming'),
            Tab(text: 'Contacts'),
            Tab(text: "Send Request",)
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [ContactsTab(), IncomingRequestsTab(), SentRequestsTab()],
      ),
    );
  }
}
