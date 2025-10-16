import 'package:chat_box/services/my_service/friend_service.dart';
import 'package:flutter/material.dart';

class SendFriendRequestScreen extends StatefulWidget {
  const SendFriendRequestScreen({super.key});

  @override
  State<SendFriendRequestScreen> createState() =>
      _SendFriendRequestScreenState();
}

class _SendFriendRequestScreenState extends State<SendFriendRequestScreen> {
  final _emailController = TextEditingController();
  final _service = FriendService();

  bool _loading = false;

  void _sendRequest() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) return;

    setState(() {
      _loading = true;
    });
    try {
      await _service.sendFriendRequest(email);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Friend request sent!")));
      _emailController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$e")));
    }
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Send friend request"), centerTitle: true),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Enter user email"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text("Send request"),
            ),
          ],
        ),
      ),
    );
  }
}
