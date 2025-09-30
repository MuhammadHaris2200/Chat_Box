import 'package:chat_box/constants/app_colors.dart';
import 'package:chat_box/constants/app_icons.dart';
import 'package:chat_box/services/my_service/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String currentUserId; // jis user ne login kiya hai
  final String otherUserId; // jis se chat ho rahi hai

  const ChatScreen({
    super.key,
    required this.currentUserId,
    required this.otherUserId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ///message sending controller
  final TextEditingController _messageController = TextEditingController();

  ///variable for unique id of two users, ehichwe intialize late in init state
  late String chatId;

  ///initstate
  @override
  void initState() {
    super.initState();

    ///here we initialize unique id of two users
    chatId = ChatService.chatId(widget.currentUserId, widget.otherUserId);

    ///if chat doesn't exist, we create
    ChatService.createChatIfNotExist(
      chatId,
      widget.currentUserId,
      widget.otherUserId,
    );
  }

  /// message bhejne ka func
  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    ChatService.sendMessage(widget.currentUserId, chatId, text);
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    ///Media query initialization
    final mq = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: Text("Chat with ${widget.otherUserId}")),
      body: Column(
        children: [
          /// Messages list
          Expanded(
            ///Stream builder firebase se real time messages access krta ha
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("chats")
                  .doc(chatId)
                  .collection("messages")
                  .orderBy("timestamp", descending: true) // latest msg top pe
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true, // niche se scroll start
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final isMe = msg["senderId"] == widget.currentUserId;

                    return Align(
                      alignment: isMe
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: mq.width * .02,
                          vertical: mq.height * .005,
                        ),
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: isMe
                              ? AppColors.blueColor
                              : AppColors.lightGrey,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          msg["text"],
                          style: TextStyle(
                            fontSize: mq.height * .02,
                            color: isMe
                                ? AppColors.whiteColor
                                : AppColors.blackColor,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          ///Text input area
          // Padding(
          //   padding: EdgeInsets.only(bottom: mq.height * .05),
          //   child: Container(
          //     padding: EdgeInsets.symmetric(
          //       horizontal: mq.width * .03,
          //       vertical: mq.height * .01,
          //     ),
          //     color: Colors.grey[200],
          //     child: Row(
          //       children: [
          //         Expanded(
          //           child: TextField(
          //             controller: _messageController,
          //             textCapitalization: TextCapitalization.sentences,
          //             decoration: const InputDecoration(
          //               hintText: "Type a message...",
          //               border: ,
          //             ),
          //           ),
          //         ),
          //         IconButton(
          //           icon: const Icon(Icons.send, color: Colors.blue),
          //           onPressed: _sendMessage,
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: mq.width * .02,
              vertical: mq.height * .05,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            AppIcons.cupertinoEmoji,
                            color: AppColors.greyColor,
                          ),
                        ),
                        const SizedBox(width: 8),

                        /// TextField
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: InputDecoration(
                              hintText: "Type a message...",
                              border: InputBorder.none,
                            ),
                          ),
                        ),

                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            AppIcons.cupertinoAttach,
                            color: AppColors.greyColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                /// Send button
                CircleAvatar(
                  radius: 26,
                  backgroundColor: AppColors.greyColor,
                  child: IconButton(
                    icon: Icon(
                      size: 28,
                      AppIcons.cupertinoSend,
                      color: AppColors.blackColor,
                    ),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
// class ChatScreen extends StatefulWidget {
//   final String currentUserId;
//   final String otherUserId;
//   const ChatScreen({
//     super.key,
//     required this.currentUserId,
//     required this.otherUserId,
//   });

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final TextEditingController _messageController = TextEditingController();
//   late String chatId;

//   @override
//   void initState() {
//     super.initState();

//     ///Do users ki unique cha id
//     chatId = ChatService.chatId(widget.currentUserId, widget.otherUserId);

//     ///Agr chat room exist nh krta tw create krde
//     ChatService.createChatIfNotExist(
//       chatId,
//       widget.currentUserId,
//       widget.otherUserId,
//     );
//   }

//   ///Send message func
//   void _sendMessage() {
//     final text = _messageController.text.trim();
//     if (text.isEmpty) return;

//     ChatService.sendMessage(widget.currentUserId, chatId, text);
//     _messageController.clear();
//   }

//   @override
//   Widget build(BuildContext context) {
//     ///Media query initialization
//     final mq = MediaQuery.of(context).size;

//     return Scaffold(
//       appBar: AppBar(title: Text("Chat screen")),
//       body: Column(
//         children: [
//           ///Messages list
//           Expanded(
//             child: StreamBuilder(
//               stream: FirebaseFirestore.instance
//                   .collection("chats")
//                   .doc(chatId)
//                   .collection("messages")
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) {
//                   return const Center(child: CircularProgressIndicator());
//                 }

//                 final messages = snapshot.data!.docs;

//                 return ListView.builder(
//                   reverse: true,
//                   itemCount: messages.length,
//                   itemBuilder: (context, index) {
//                     final msg = messages[index];
//                     final isMe = msg["senderId"] == widget.currentUserId;

//                     return Align(
//                       alignment: isMe
//                           ? Alignment.centerRight
//                           : Alignment.centerLeft,
//                       child: Container(
//                         margin: EdgeInsets.symmetric(
//                           horizontal: mq.width * .03,
//                           vertical: mq.height * .01,
//                         ),
//                         padding: EdgeInsets.all(15),
//                         decoration: BoxDecoration(
//                           color: isMe
//                               ? AppColors.blueColor
//                               : AppColors.blackColor,
//                           borderRadius: BorderRadius.circular(15),
//                         ),
//                         child: Text(
//                           msg["text"],
//                           style: TextStyle(
//                             color: isMe
//                                 ? AppColors.whiteColor
//                                 : AppColors.blackColor,
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
