import 'package:chat_box/services/my_service/friend_service.dart';
import 'package:chat_box/view/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ContactsTab extends StatelessWidget {
  const ContactsTab({super.key});
  @override
  Widget build(BuildContext context) {
    final service = FriendService();
    final currentUid = FirebaseAuth.instance.currentUser!.uid;

    return StreamBuilder<List<QueryDocumentSnapshot>>(
      stream: service.contactsStream(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final docs = snap.data ?? [];
        if (docs.isEmpty) return const Center(child: Text("No contacts"));

        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, i) {
            final doc = docs[i];
            final data = doc.data() as Map<String, dynamic>;
            final members = List<String>.from(data['members'] ?? []);
            final friendId = members.firstWhere(
              (id) => id != currentUid,
              orElse: () => '',
            );

            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(friendId)
                  .get(),
              builder: (context, userSnap) {
                if (!userSnap.hasData)
                  // ignore: curly_braces_in_flow_control_structures
                  return const ListTile(title: Text("Loading..."));
                final userData =
                    userSnap.data!.data() as Map<String, dynamic>? ?? {};
                final name = userData['name'] ?? 'Unknown';
                final photo = userData['photoUrl'] ?? "";

                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: (photo != null && photo.isNotEmpty)
                        ? NetworkImage(photo)
                        : null,
                    child: (photo == null || photo.isEmpty)
                        ? Text(name.isNotEmpty ? name[0] : '?')
                        : null,
                  ),
                  title: Text(name),
                  subtitle: Text("Tap to chat"),
                  onTap: () {
                    //open chat with friendId
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) {
                          return ChatScreen(
                            currentUserId: currentUid,
                            otherUserId: friendId,
                          );
                        },
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
