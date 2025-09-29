import 'package:chat_box/services/my_service/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// class ChatScreen extends StatefulWidget {
//
//   ///ye us user ki id ha jis se chat hogi
//   final String peerId;
//
//   ///ye us user ka name jis se chat hogi
//   final String peerName;
//
//   ///or ye us user ka photo jis se chat hogi
//   final String? peerPhoto;
//
//   ///constructor
//   const ChatScreen({
//     super.key,
//     required this.peerId,
//     required this.peerName,
//     this.peerPhoto,
//   });
//
//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }
//
// class _ChatScreenState extends State<ChatScreen> {
//   ///ye controller message bhejne k liye
//   final TextEditingController _messageController = TextEditingController();
//
//   ///ye controller chats ko scroll krne k liye
//   final ScrollController _scrollCtrl = ScrollController();
//
//   ///current logged in user ka id
//   late final String myUid;
//   ///dono users ki unique chat id jo chats service.chatId se aegi
//   late final String chatId;
//
//   @override
//   void initState() {
//     super.initState();
//     ///init state ma current user ka id takay screen open hoti hi ye access hojae
//     myUid = FirebaseAuth.instance.currentUser!.uid;
//
//     ///or init state ma chat id takay screen open
//     ///hote hi both users ki unique chat id ban jae
//     chatId = ChatService.chatId(myUid, widget.peerId);
//
//     ///or is ki help se screen open hote hi do users k b/w
//     ///chat create hona start hojaegi agr vo chat krte ha tw
//     ChatService.createChatIfNotExist(chatId, myUid, widget.peerId);
//   }
//
//   Future<void> _send() async {
//     final text = _messageController.text.trim();
//     if (text.isEmpty) return;
//     await ChatService.sendMessage(chatId, myUid, text);
//     _messageController.clear();
//     // Optionally scroll to bottom after small delay
//     Future.delayed(const Duration(milliseconds: 100), () {
//       if (_scrollCtrl.hasClients) {
//         _scrollCtrl.animateTo(
//           0.0,
//           duration: const Duration(milliseconds: 200),
//           curve: Curves.easeOut,
//         );
//       }
//     });
//   }
//
//   Widget _buildMessageTile(Map<String, dynamic> msg) {
//     ///iska mtlb k agr msg ma ne bheja ha tw isMe = true
//     final bool isMe = msg['senderId'] == myUid;
//
//     ///current time
//     final ts = (msg['timestamp'] as Timestamp?)?.toDate();
//     return Align(
//       ///agr msg mane bheja ha tw right side bubble varna left side
//       alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
//
//       ///phir container jis ma msgs show honge
//       child: Container(
//         constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
//         margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
//         padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
//         decoration: BoxDecoration(
//           ///agr ma ne msg bheja ha tw blue color varna grey
//           color: isMe ? Colors.blueAccent : Colors.grey[800],
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Column(
//           crossAxisAlignment:
//               isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//           children: [
//             Text(msg['text'] ?? '', style: const TextStyle(fontSize: 16)),
//             const SizedBox(height: 6),
//             Text(
//               ts != null ? '${ts.hour}:${ts.minute.toString().padLeft(2, '0')}' : '',
//               style: TextStyle(fontSize: 11, color: Colors.white70),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final messagesStream = FirebaseFirestore.instance
//         .collection('chats')
//         .doc(chatId)
//         .collection('messages')
//         .orderBy('timestamp', descending: true)
//         .snapshots();
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Row(
//           children: [
//             CircleAvatar(
//               backgroundImage:
//                   widget.peerPhoto != null ? NetworkImage(widget.peerPhoto!) : null,
//               child:
//                   widget.peerPhoto == null ? Text(widget.peerName[0]) : null,
//             ),
//             const SizedBox(width: 12),
//             Text(widget.peerName),
//           ],
//         ),
//       ),
//       body: SafeArea(
//         child: Column(
//           children: [
//             // messages list
//             Expanded(
//               child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
//                 stream: messagesStream,
//                 builder: (context, snapshot) {
//                   if (snapshot.hasError) {
//                     return Center(child: Text('Error: ${snapshot.error}'));
//                   }
//                   if (!snapshot.hasData) {
//                     return const Center(child: CircularProgressIndicator());
//                   }
//                   final docs = snapshot.data!.docs;
//                   if (docs.isEmpty) {
//                     return const Center(child: Text('No messages yet. Say hi!'));
//                   }
//                   return ListView.builder(
//                     controller: _scrollCtrl,
//                     reverse: true,
//                     itemCount: docs.length,
//                     itemBuilder: (context, index) {
//                       final data = docs[index].data();
//                       return _buildMessageTile(data);
//                     },
//                   );
//                 },
//               ),
//             ),
//
//             // input
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//               color: Colors.grey[900],
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: _messageController,
//                       textCapitalization: TextCapitalization.sentences,
//                       decoration: const InputDecoration(
//                         hintText: 'Type a message',
//                         border: InputBorder.none,
//                       ),
//                       minLines: 1,
//                       maxLines: 5,
//                     ),
//                   ),
//                   IconButton(
//                     onPressed: _send,
//                     icon: const Icon(Icons.send),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// class ChatScreen extends StatefulWidget {
//   final String peerId;
//   final String peerName;
//   final String? peerPhoto;
//
//   const ChatScreen({
//     super.key,
//     required this.peerId,
//     required this.peerName,
//     this.peerPhoto,
//   });
//
//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }
//
// class _ChatScreenState extends State<ChatScreen> {
//   final TextEditingController _messageController = TextEditingController();
//   final ScrollController _scrollCtrl = ScrollController();
//
//   late final String myUid;
//   late final String chatId;
//
//   @override
//   void initState() {
//     super.initState();
//     myUid = FirebaseAuth.instance.currentUser!.uid;
//     chatId = ChatService.chatId(myUid, widget.peerId);
//
//     /// chat room create if not exists
//     ChatService.createChatIfNotExist(chatId, myUid, widget.peerId);
//   }
//
//   Future<void> _send() async {
//     final text = _messageController.text.trim();
//     if (text.isEmpty) return;
//
//     await ChatService.sendMessage(myUid, chatId, text); // ✅ fixed order
//     _messageController.clear();
//
//     Future.delayed(const Duration(milliseconds: 100), () {
//       if (_scrollCtrl.hasClients) {
//         _scrollCtrl.animateTo(
//           0.0,
//           duration: const Duration(milliseconds: 200),
//           curve: Curves.easeOut,
//         );
//       }
//     });
//   }
//
//   Widget _buildMessageTile(Map<String, dynamic> msg) {
//     final bool isMe = msg['senderId'] == myUid;
//     final ts = (msg['timestamp'] as Timestamp?)?.toDate();
//
//     return Align(
//       alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         constraints: BoxConstraints(
//             maxWidth: MediaQuery.of(context).size.width * 0.75),
//         margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
//         padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
//         decoration: BoxDecoration(
//           color: isMe ? Colors.blueAccent : Colors.grey[800],
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Column(
//           crossAxisAlignment:
//           isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//           children: [
//             Text(msg['text'] ?? '',
//                 style: const TextStyle(fontSize: 16, color: Colors.white)),
//             const SizedBox(height: 6),
//             Text(
//               ts != null
//                   ? '${ts.hour}:${ts.minute.toString().padLeft(2, '0')}'
//                   : '',
//               style: const TextStyle(fontSize: 11, color: Colors.white70),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final messagesStream = FirebaseFirestore.instance
//         .collection('chats')
//         .doc(chatId)
//         .collection('messages')
//         .orderBy('timestamp', descending: true)
//         .snapshots();
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Row(
//           children: [
//             CircleAvatar(
//               backgroundImage: widget.peerPhoto != null
//                   ? NetworkImage(widget.peerPhoto!)
//                   : null,
//               child: widget.peerPhoto == null
//                   ? Text(widget.peerName.isNotEmpty
//                   ? widget.peerName[0]
//                   : "?")
//                   : null,
//             ),
//             const SizedBox(width: 12),
//             Text(widget.peerName),
//           ],
//         ),
//       ),
//       body: SafeArea(
//         child: Column(
//           children: [
//             Expanded(
//               child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
//                 stream: messagesStream,
//                 builder: (context, snapshot) {
//                   if (snapshot.hasError) {
//                     return Center(
//                         child: Text('Error: ${snapshot.error}'));
//                   }
//                   if (!snapshot.hasData) {
//                     return const Center(
//                         child: CircularProgressIndicator());
//                   }
//                   final docs = snapshot.data!.docs;
//                   if (docs.isEmpty) {
//                     return const Center(
//                         child: Text('No messages yet. Say hi!'));
//                   }
//                   return ListView.builder(
//                     controller: _scrollCtrl,
//                     reverse: true,
//                     itemCount: docs.length,
//                     itemBuilder: (context, index) {
//                       final data = docs[index].data();
//                       return _buildMessageTile(data);
//                     },
//                   );
//                 },
//               ),
//             ),
//
//             // input box
//             Container(
//               padding:
//               const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//               color: Colors.grey[900],
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: _messageController,
//                       textCapitalization: TextCapitalization.sentences,
//                       decoration: const InputDecoration(
//                         hintText: 'Type a message',
//                         border: InputBorder.none,
//                       ),
//                       minLines: 1,
//                       maxLines: 5,
//                     ),
//                   ),
//                   IconButton(
//                     onPressed: _send,
//                     icon: const Icon(Icons.send),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String currentUserId; // jis user ne login kiya hai
  final String otherUserId;   // jis se chat ho rahi hai

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
    /// dono users ke ids se unique chatId bna rahe
    chatId = ChatService.chatId(widget.currentUserId, widget.otherUserId);

    /// pehli dafa ensure kar lo chat room bana ho
    ChatService.createChatIfNotExist(chatId, widget.currentUserId, widget.otherUserId);
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat with ${widget.otherUserId}"),
      ),
      body: Column(
        children: [
          /// Messages list
          Expanded(
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
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.blue[300] : Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          msg["text"],
                          style: TextStyle(color: isMe ? Colors.white : Colors.black),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          /// Text input area
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            color: Colors.grey[200],
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      hintText: "Type a message...",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
