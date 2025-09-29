import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class ChatService {
  ///Ye func aik unique chat id banata ha do users k b/w
  static String chatId(String a, String b) =>
      a.compareTo(b) > 0 ? "${b}_$a" : "${a}_$b";

  ///Ye func chats create krega do users k b/w
  static Future<void> createChatIfNotExist(
    String chatId,
    String uidA,
    String uidB,
  ) async {
    final ref = FirebaseFirestore.instance.collection("chats").doc(chatId);
    final snap = await ref.get();

    ///agr chats ka document nh bana ha tw usko create krega
    if (!snap.exists) {
      ref.set({
        "participants": [uidA, uidB],
        "createdAt": FieldValue.serverTimestamp(),
        "lastMessage": "",
        "lastMessageTime": null,
      });
    }
  }

  ///do users aik dosre ko message send is func ki help se kr skhenge
  ///messages collection ma particular cheezo k sath store honge
  static Future<void> sendMessage(String senderId, String chatId, String text) async {
    await FirebaseFirestore.instance
        .collection("chats")
        .doc(chatId)
        .collection("messages")
        .add({
          "senderId": senderId,
          "text": text,
          "timeStamp": FieldValue.serverTimestamp(),
          "read": false,
        });

    await FirebaseFirestore.instance.collection("chats").doc(chatId).set({
      "lastMessage": text,
      "lastMessageTime": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
