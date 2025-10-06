import 'package:chat_box/constants/app_icons.dart';
import 'package:chat_box/view/chat_screen.dart';
import 'package:chat_box/services/my_service/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

///custom widget
class SearchResultsList extends StatelessWidget {
  final String searchQuery;
  final String currentUserId;

  const SearchResultsList({
    super.key,
    required this.searchQuery,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    ///Media query initialization
    final mq = MediaQuery.of(context).size;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("users").snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Text("No users found");
        }

        final users = snapshot.data!.docs.where((doc) {
          final name = (doc['name'] ?? "").toString().toLowerCase();
          return name.contains(searchQuery.toLowerCase()) &&
              doc.id != currentUserId;
        }).toList();

        if (users.isEmpty) {
          return const Center(child: Text("No users found"));
        }

        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];

            return Padding(
              padding: EdgeInsets.all(mq.height * .01),
              child: ListTile(
                leading: const CircleAvatar(
                  radius: 30,
                  child: Icon(AppIcons.cupertinoPersonIcon),
                ),
                title: Padding(
                  padding: EdgeInsets.only(top: mq.height * .020),
                  child: Text(
                    user["name"],
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                subtitle: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("chats")
                      .doc(ChatService.chatId(currentUserId, user.id))
                      .collection("messages")
                      .orderBy("timestamp", descending: true)
                      .limit(1)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Text("");
                    }

                    final lastMessage = snapshot.data!.docs.first;
                    return Text(
                      lastMessage['text'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    );
                  },
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatScreen(
                        currentUserId: currentUserId,
                        otherUserId: user.id,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
