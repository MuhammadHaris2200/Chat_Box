import 'package:chat_box/services/my_service/friend_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class IncomingRequestsTab extends StatelessWidget {
  const IncomingRequestsTab({super.key});
  @override
  Widget build(BuildContext context) {
    final service = FriendService();

    return StreamBuilder<List<QueryDocumentSnapshot>>(
      stream: service.incomingRequestsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final docs = snapshot.data ?? [];
        if (docs.isEmpty) {
          return const Center(child: Text("No incoming requests"));
        }

        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, i) {
            final doc = docs[i];
            final data = doc.data() as Map<String, dynamic>;
            final senderName = data['senderName'] ?? 'Unknown';
            final message = data['message'] ?? '';

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  child: Text(
                    senderName.isNotEmpty ? senderName[0].toUpperCase() : '?',
                  ),
                ),
                title: Text(
                  senderName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  message.isEmpty ? 'sent you a friend request' : message,
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.check, color: Colors.green),
                      onPressed: () async {
                        try {
                          await service.acceptRequest(doc.id);
                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(
                              const SnackBar(content: Text('Request accepted')),
                            );
                        } catch (e) {
                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(
                              SnackBar(content: Text('Error: $e')),
                            );
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: () async {
                        try {
                          await service.rejectRequest(doc.id);
                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(
                              const SnackBar(content: Text('Request rejected')),
                            );
                        } catch (e) {
                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(
                              SnackBar(content: Text('Error: $e')),
                            );
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
