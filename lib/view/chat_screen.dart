import 'package:chat_box/viewModel/provider/chat_service_provider.dart';
import 'package:chat_box/constants/app_colors.dart';
import 'package:chat_box/widgets/message_bubble.dart';
import 'package:chat_box/widgets/message_input.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zego_uikit/zego_uikit.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class ChatScreen extends StatefulWidget {
  final String currentUserId;
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
  final TextEditingController _messageController = TextEditingController();
  late String chatId;

  @override
  void initState() {
    super.initState();
    final chatProvider = Provider.of<ChatServiceProvider>(
      context,
      listen: false,
    );

    chatId = chatProvider.chatId(widget.currentUserId, widget.otherUserId);

    chatProvider.createChatIfNotExist(
      chatId,
      widget.currentUserId,
      widget.otherUserId,
    );
  }

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
                  backgroundImage: opponentPic.isNotEmpty
                      ? NetworkImage(opponentPic)
                      : null,
                  child: opponentPic.isEmpty
                      ? Text(
                          opponentName.isNotEmpty
                              ? opponentName[0].toUpperCase()
                              : "?",
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
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(opponentEmail, style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),

            actions: [
              // IconButton(
              //   icon: const Icon(Icons.call),
              //   onPressed: () =>
              //       _sendVoiceCall(widget.otherUserId, opponentName),
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    // height: 20,
                    width: mq.width * .12,
                    child: ZegoSendCallInvitationButton(
                      isVideoCall: false,
                      resourceID: "zegouikit_call",
                      invitees: [
                        ZegoUIKitUser(
                          id: widget.otherUserId,
                          name: opponentName,
                        ),
                        // log();
                        // ...ZegoUIKitUser(id: widget.otherUserId, name: opponentName),
                      ],
                      buttonSize: Size(mq.width * .12, mq.height * .12),
                      iconSize: Size(30, 30),
                    ),
                  ),
                  //SizedBox(width: mq.width * .01),
                  Padding(
                    padding: EdgeInsets.only(right: mq.width * .02),
                    child: SizedBox(
                      width: mq.width * .12,
                      child: ZegoSendCallInvitationButton(
                        isVideoCall: true,
                        
                        resourceID: "zegouikit_call",
                        invitees: [
                          ZegoUIKitUser(
                            id: widget.otherUserId,
                            name: opponentName,
                          ),
                        ],
                        buttonSize: Size(mq.width * .12, mq.height * .12),
                        iconSize: Size(30, 30),
                      ),
                    ),
                  ),
                ],
              ),
              // IconButton(
              //   icon: const Icon(Icons.videocam),
              //   onPressed: () =>
              //       _sendVideoCall(widget.otherUserId, opponentName),
              // ),
              const SizedBox(width: 8),
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
                        return const Center(child: CircularProgressIndicator());
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
