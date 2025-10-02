import 'package:chat_box/constants/app_colors.dart';
import 'package:chat_box/constants/app_icons.dart';
import 'package:chat_box/services/my_service/chat_service.dart';
import 'package:chat_box/widgets/message_bubble.dart';
import 'package:chat_box/widgets/message_input.dart';
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
        color: AppColors.lightGrey,
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
                  ///agr data nh ha tw sized box show krdo
                  if (!snapshot.hasData) {
                    return const Center(child: SizedBox());
                  }

                  ///yaha sara snapshot ka data messages variable ma store krdiya
                  final messages = snapshot.data!.docs;

                  ///agr messages list empty ha tw ye text show kro center ma
                  return messages.isEmpty
                      ? Center(
                          child: Text(
                            "Say Hi 👋 to start the conversation",
                            style: TextStyle(
                              fontSize: mq.height * .02,
                              color: AppColors.white70,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        )
                      ///else listview builder ma
                      : ListView.builder(
                          ///niche se scroll start
                          reverse: true,

                          ///messages list ki length
                          itemCount: messages.length,

                          ///list view ka builder jis ki help se do users ki
                          ///chats build hone k bd screen pe show hoti ha
                          itemBuilder: (context, index) {
                            final msg = messages[index];

                            ///custom message bubble widget jis ma
                            ///do users ki chats show hongi ui pe
                            return MessageBubble(
                              text: msg['text'],
                              isMe: msg['senderId'] == widget.currentUserId,
                            );
                          },
                        );
                },
              ),
            ),

            ///custom message send widget jo bottom ma show hota ha
            MessageInput(controller: _messageController, onSend: _sendMessage),
          ],
        ),
      ),
    );
  }
}
