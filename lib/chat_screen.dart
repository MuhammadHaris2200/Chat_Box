import 'package:chat_box/constants/app_colors.dart';
import 'package:chat_box/constants/app_icons.dart';
import 'package:chat_box/services/my_service/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  ///Current logged in user
  final String currentUserId;

  ///vo user jis se chat horhi ho
  final String otherUserId;

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

  ///variable for unique id of two users, initialize late in init state
  late String chatId;

  ///init state
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
      appBar: AppBar(title: Text("Chat Screen"), centerTitle: true),
      body: Container(
        color: Colors.black,
        child: Column(
          children: [
            /// Messages list
            Expanded(
              ///Stream builder firebase se real time messages access krta ha
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("chats")
                    .doc(chatId)
                    .collection("messages")
                    .orderBy("timestamp", descending: true)
                    ///recent msg top pe
                    .snapshots(),
                builder: (context, snapshot) {
                  ///agr data nh ha tw indicator show krdo
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  ///yaha sara snapshot ka data messages variable ma store krdiya
                  final messages = snapshot.data!.docs;

                  return ListView.builder(
                    reverse: true,

                    ///niche se scroll start
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];

                      ///agay condition check krne k liye likha ha
                      final isMe = msg["senderId"] == widget.currentUserId;

                      ///agr current user ne message kiya ha tw right pe else left pe
                      return Align(
                        alignment: isMe
                            ? Alignment.centerRight
                            : Alignment.centerLeft,

                        ///ye container jis ma messages show hone
                        child: Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: mq.width * .02,
                            vertical: mq.height * .005,
                          ),
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            ///container ka color agr current user ne
                            ///msg kiya ha tw blue color else light gre
                            color: isMe
                                ? AppColors.blueColor
                                : AppColors.lightGrey,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            ///yaha container k andr text ka color agr current user
                            ///ne text kiya ha tw white color else black color
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


            ///Text field
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: mq.width * .02,
                vertical: mq.height * .05,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: mq.width * .02,
                        vertical: mq.width * .01,
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
                           SizedBox(width: mq.width * .01),

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

                   SizedBox(width: mq.width * .02),

                  /// Send button
                  CircleAvatar(
                    radius: mq.height * .028,
                    backgroundColor: AppColors.greyColor,
                    child: IconButton(
                      icon: Icon(
                        size: mq.height * .03,
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
      ),
    );
  }
}
