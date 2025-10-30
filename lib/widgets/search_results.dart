// import 'package:chat_box/constants/app_colors.dart';
// import 'package:chat_box/constants/app_icons.dart';
// import 'package:chat_box/services/my_service/friend_service.dart';
// import 'package:chat_box/view/chat_screen.dart';
// import 'package:chat_box/services/my_service/chat_service.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// ///custom widget
// class SearchResultsList extends StatelessWidget {
//   final String searchQuery;
//   final String currentUserId;

//   const SearchResultsList({
//     super.key,
//     required this.searchQuery,
//     required this.currentUserId,
//   });

//   @override
//   Widget build(BuildContext context) {
//     ///Media query initialization
//     final mq = MediaQuery.of(context).size;

//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance.collection("users").snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }
//         if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//           return const Text("No users found");
//         }

//         final users = snapshot.data!.docs.where((doc) {
//           final name = (doc['name'] ?? "").toString().toLowerCase();
//           return name.contains(searchQuery.toLowerCase()) &&
//               doc.id != currentUserId;
//         }).toList();

//         if (users.isEmpty) {
//           return const Center(child: Text("No users found"));
//         }

//         return ListView.builder(
//           itemCount: users.length,
//           itemBuilder: (context, index) {
//             final user = users[index];

//             return Padding(
//               padding: EdgeInsets.all(mq.height * .01),
//               child: ListTile(
//                 leading: const CircleAvatar(
//                   radius: 30,
//                   child: Icon(AppIcons.cupertinoPersonIcon),
//                 ),
//                 title: Padding(
//                   padding: EdgeInsets.only(top: mq.height * .020),
//                   child: Text(
//                     user["name"],
//                     style: const TextStyle(fontWeight: FontWeight.w500),
//                   ),
//                 ),
//                 subtitle: StreamBuilder(
//                   stream: FirebaseFirestore.instance
//                       .collection("chats")
//                       .doc(ChatService.chatId(currentUserId, user.id))
//                       .collection("messages")
//                       .orderBy("timestamp", descending: true)
//                       .limit(1)
//                       .snapshots(),
//                   builder: (context, snapshot) {
//                     if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                       return const Text("");
//                     }

//                     final lastMessage = snapshot.data!.docs.first;
//                     return Text(
//                       lastMessage['text'],
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     );
//                   },
//                 ),
//                 onTap: () async {
//                   final friendService = FriendService();

//                   final areFriends = await friendService.areFriends(
//                     currentUserId,
//                     user.id,
//                   );
//                   if (areFriends) {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) {
//                           return ChatScreen(
//                             currentUserId: currentUserId,
//                             otherUserId: user.id,
//                           );
//                         },
//                       ),
//                     );
//                   } else {
//                     ScaffoldMessenger.of(context)
//                       ..hideCurrentSnackBar()
//                       ..showSnackBar(
//                         SnackBar(
//                           content: Text("You can only chat with your friends."),
//                           backgroundColor: AppColors.blueColor,
//                           behavior: SnackBarBehavior.floating,
//                           action: SnackBarAction(
//                             label: "Send request",

//                             onPressed: () async {
//                               final senderDoc = await FirebaseFirestore.instance
//                                   .collection("users")
//                                   .doc(currentUserId)
//                                   .get();
//                               try {
//                                 await friendService.sendFriendRequest(
//                                   receiverId: user.id,
//                                   receiverName: user['name'],
//                                   senderName: senderDoc["name"],
//                                 );

//                                 ScaffoldMessenger.of(context)
//                                   ..hideCurrentSnackBar()
//                                   ..showSnackBar(
//                                     const SnackBar(
//                                       content: Text("Friend request sent!"),
//                                     ),
//                                   );
//                               } catch (e) {
//                                 ScaffoldMessenger.of(context)
//                                   ..hideCurrentSnackBar()
//                                   ..showSnackBar(
//                                     SnackBar(content: Text("Error: $e")),
//                                   );
//                               }
//                             },
//                           ),
//                         ),
//                       );
//                   }
//                 },
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }

import 'package:chat_box/constants/app_colors.dart';
import 'package:chat_box/constants/app_icons.dart';
import 'package:chat_box/services/my_service/friend_service.dart';
import 'package:chat_box/view/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
    final mq = MediaQuery.of(context).size;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("users").snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No users found"));
        }

        final users = snapshot.data!.docs.where((doc) {
          final name = (doc['name'] ?? "").toString().toLowerCase();
          return name.contains(searchQuery.toLowerCase()) &&
              doc.id != currentUserId;
        }).toList();

        if (users.isEmpty) {
          return const Center(child: Text("No users found"));
        }

        final friendService = FriendService();

        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];

            return Padding(
              padding: EdgeInsets.all(mq.height * .01),
              child: ListTile(
                onTap: () async {
                  final areFriends = await friendService.areFriends(
                    currentUserId,
                    user.id,
                  );

                  if (areFriends) {
                    // Agar friend hai → ChatScreen open karo
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatScreen(
                          currentUserId: currentUserId,
                          otherUserId: user.id,
                        ),
                      ),
                    );
                  } else {
                    // Agar friend nahi hai → Snackbar show karo
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          content: const Text(
                            "You can only chat with your friends.",
                          ),
                          backgroundColor: AppColors.blueColor,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                  }
                },

                leading: const CircleAvatar(
                  radius: 28,
                  child: Icon(AppIcons.cupertinoPersonIcon),
                ),
                title: Text(
                  user["name"],
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                trailing: FutureBuilder<bool>(
                  future: friendService.areFriends(
                    currentUserId,
                    user.id,
                  ), // ✅ check friendship
                  builder: (context, snap) {
                    if (snap.connectionState == ConnectionState.waiting) {
                      return const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      );
                    }

                    final isFriend = snap.data ?? false;
                    if (isFriend) {
                      return const Text(
                        "Friends",
                        style: TextStyle(color: Colors.green),
                      );
                    }

                    return FutureBuilder<bool>(
                      future: friendService.hasPendingRequest(
                        currentUserId,
                        user.id,
                      ), // ✅ check request status
                      builder: (context, reqSnap) {
                        if (reqSnap.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          );
                        }

                        final hasRequest = reqSnap.data ?? false;

                        return ElevatedButton(
                          onPressed: hasRequest
                              ? null
                              : () async {
                                  final senderDoc = await FirebaseFirestore
                                      .instance
                                      .collection("users")
                                      .doc(currentUserId)
                                      .get();

                                  try {
                                    await friendService.sendFriendRequest(
                                      receiverId: user.id,
                                      receiverName: user['name'],
                                      senderName: senderDoc["name"],
                                    );

                                    ScaffoldMessenger.of(context)
                                      ..hideCurrentSnackBar()
                                      ..showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            "Friend request sent successfully!",
                                          ),
                                        ),
                                      );
                                  } catch (e) {
                                    ScaffoldMessenger.of(context)
                                      ..hideCurrentSnackBar()
                                      ..showSnackBar(
                                        SnackBar(content: Text("Error: $e")),
                                      );
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: hasRequest
                                ? Colors.grey
                                : AppColors.blueColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            hasRequest ? "Pending" : "Send Request",
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
