import 'package:chat_box/constants/app_icons.dart';
import 'package:chat_box/video_call.dart';
import 'package:chat_box/voice_call.dart';
import 'package:chat_box/viewModel/provider/chat_service_provider.dart';
import 'package:chat_box/constants/app_colors.dart';
import 'package:chat_box/widgets/message_bubble.dart';
import 'package:chat_box/widgets/message_input.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

    final chatProvider = Provider.of<ChatServiceProvider>(
      context,
      listen: false,
    );

    ///here we initialize unique id of two users
    chatId = chatProvider.chatId(widget.currentUserId, widget.otherUserId);

    ///if chat doesn't exist, we create
    chatProvider.createChatIfNotExist(
      chatId,
      widget.currentUserId,
      widget.otherUserId,
    );
  }

  /// message bhejne ka func
  void _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final chatProvider = context.read<ChatServiceProvider>();

    await chatProvider.sendMessage(widget.currentUserId, chatId, text);
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection("users")
          .doc(widget.otherUserId)
          .snapshots(),
      builder: (context, userSnapshot) {
        if (!userSnapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        var user = userSnapshot.data!;
        final opponentPic = user["profilePic"] ?? "";
        final opponentName = user["name"] ?? "";
        final opponentEmail = user["email"] ?? "";

        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.whiteColor,
            title: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.yellowColor,
                  backgroundImage: opponentPic != ""
                      ? NetworkImage(opponentPic)
                      : null,
                  child: opponentPic == ""
                      ? Text(
                          opponentName[0].toUpperCase(),
                          style: TextStyle(
                            fontSize: mq.height * .03,
                            color: AppColors.blackColor,
                          ),
                        )
                      : null,
                ),
                SizedBox(width: mq.width * .03),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      opponentName,
                      style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(opponentEmail, style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),
            // centerTitle: true,
            actions: [
              // IconButton(
              //   onPressed: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(builder: (_) => VoiceCall()),
              //     );
              //   },
              //   icon: Icon(AppIcons.materialCallIcon, size: mq.height * .030),
              // ),
              // SizedBox(width: mq.width * .02),
              // Padding(
              //   padding: EdgeInsets.only(right: mq.width * .08),
              //   child: InkWell(
              //     onTap: () {
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(builder: (_) => VideoCall()),
              //       );
              //     },
              //     child: Icon(
              //       AppIcons.cupertinoVideoCall,
              //       size: mq.height * .037,
              //     ),
              //   ),
              // ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) {
                        return VoiceCall();
                      },
                    ),
                  );
                },
                child: Icon(AppIcons.cupertinoCallIcon),
              ),
              SizedBox(width: mq.width * .02),
              Padding(
                padding: EdgeInsets.only(right: mq.width * .05),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) {
                          return VideoCall();
                        },
                      ),
                    );
                  },
                  child: Icon(AppIcons.cupertinoVideoCall),
                ),
              ),
            ],
          ),

          body: Container(
            color: AppColors.whiteColor,
            child: Column(
              children: [
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("chats")
                        .doc(chatId)
                        .collection("messages")
                        .orderBy("timestamp", descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: SizedBox());
                      }

                      final messages = snapshot.data!.docs;

                      return messages.isEmpty
                          ? Center(
                              child: Text(
                                "Say Hi 👋 to start the conversation",
                                style: TextStyle(
                                  fontSize: mq.height * .02,
                                  color: AppColors.blackColor,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            )
                          : ListView.builder(
                              reverse: true,
                              itemCount: messages.length,
                              itemBuilder: (context, index) {
                                final msg = messages[index];
                                final isMe =
                                    msg["senderId"] == widget.currentUserId;

                                return MessageBubble(
                                  text: msg['text'],
                                  isMe: isMe,
                                  opponentPic: opponentPic,
                                  opponentName: opponentName,
                                );
                              },
                            );
                    },
                  ),
                ),
                MessageInput(
                  controller: _messageController,
                  onSend: _sendMessage,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
