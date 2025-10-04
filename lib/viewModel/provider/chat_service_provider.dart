import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatServiceProvider with ChangeNotifier {
  /// Ye func aik unique chat id banata ha do users k b/w
  String chatId(String a, String b) =>
      a.compareTo(b) > 0 ? "${b}_$a" : "${a}_$b";

  /// Ye func chats create krega do users k b/w
  Future<void> createChatIfNotExist(
    String chatId,
    String uidA,
    String uidB,
  ) async {
    final ref = FirebaseFirestore.instance.collection("chats").doc(chatId);
    final snap = await ref.get();

    if (!snap.exists) {
      await ref.set({
        "participants": [uidA, uidB],
        "createdAt": FieldValue.serverTimestamp(),
      });
    }
  }

  /// do users aik dosre ko message send is func ki help se kr skhenge
  Future<void> sendMessage(String senderId, String chatId, String text) async {
    await FirebaseFirestore.instance
        .collection("chats")
        .doc(chatId)
        .collection("messages")
        .add({
          "senderId": senderId,
          "text": text,
          "timestamp": FieldValue.serverTimestamp(),
          "read": false,
        });

    await FirebaseFirestore.instance.collection("chats").doc(chatId).set({
      "lastMessage": text,
      "lastMessageTime": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    notifyListeners(); // UI ko update karne ke liye
  }
}
