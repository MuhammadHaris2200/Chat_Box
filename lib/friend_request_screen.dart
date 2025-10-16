import 'package:chat_box/constants/app_colors.dart';
import 'package:chat_box/constants/app_icons.dart';
import 'package:chat_box/services/my_service/friend_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FriendRequestScreen extends StatelessWidget {
  final _service = FriendService();
  FriendRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Friend Requests"), centerTitle: true),
      body: StreamBuilder<QuerySnapshot>(
        stream: _service.getIncomingRequests(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final request = snapshot.data?.docs ?? [];
          if (request.isEmpty) {
            return Center(child: Text("No friends request"));
          }

          return ListView.builder(
            itemCount: request.length,
            itemBuilder: (context, index) {
              final doc = request[index];
              final data = doc.data() as Map<String, dynamic>;
              final senderId = data['senderId'];

              return ListTile(
                title: Text("Request from $senderId"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () async {
                        await _service.acceptFriendRequest(doc.id, senderId);
                      },
                      icon: Icon(
                        AppIcons.materialCheck,
                        color: AppColors.greenColor,
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        await _service.rejectFriendRequest(doc.id);
                      },
                      icon: Icon(
                        AppIcons.materialClose,
                        color: AppColors.redColor,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
