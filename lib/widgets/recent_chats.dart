import 'package:chat_box/view/chat_screen.dart';
import 'package:chat_box/constants/app_colors.dart';
import 'package:chat_box/constants/app_icons.dart';
import 'package:chat_box/services/my_service/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RecentChats extends StatelessWidget {
  final String currentUserId;

  const RecentChats({super.key, required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    ///Media query initialization
    final mq = MediaQuery.of(context).size;

    final stream = FirebaseFirestore.instance
        .collection("chats")
        .where("participants", arrayContains: currentUserId)
        .orderBy("lastMessageTime", descending: true)
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No chats found"));
        }

        final chats = snapshot.data!.docs;

        return ListView.builder(
          itemCount: chats.length,
          itemBuilder: (context, index) {
            final chat = chats[index];
            final participants = List<String>.from(chat['participants']);

            final otherUserId = participants.firstWhere(
              (id) => id != currentUserId,
            );

            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection("users")
                  .doc(otherUserId)
                  .get(),
              builder: (context, userSnapshot) {
                if (!userSnapshot.hasData) return const SizedBox();

                final userData =
                    userSnapshot.data!.data() as Map<String, dynamic>;

                return Padding(
                  padding: EdgeInsets.all(mq.height * .02),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: userData['photoUrl'] != null
                          ? NetworkImage(userData['photoUrl'])
                          : null,
                      child: userData['photoUrl'] == null
                          ? Icon(AppIcons.cupertinoPersonIcon)
                          : null,
                    ),
                    title: Text(userData['name'] ?? "Unknown"),
                    subtitle: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("chats")
                          .doc(ChatService.chatId(currentUserId, otherUserId))
                          .collection("messages")
                          .orderBy("timestamp", descending: true)
                          .limit(1)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Text("No messages yet");
                        }

                        final lastMessage = snapshot.data!.docs.first;
                        return Text(
                          lastMessage["text"],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: AppColors.greyColor),
                        );
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatScreen(
                            currentUserId: currentUserId,
                            otherUserId: otherUserId,
                          ),
                        ),
                      );
                      //FocusScope.of(context).unfocus();
                    },
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
