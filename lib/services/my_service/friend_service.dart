import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class FriendService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String get uid => _auth.currentUser!.uid;

  //Stream - incoming pending request for current user
  Stream<List<QueryDocumentSnapshot>> incomingRequestsStream() {
    return _db
        .collection("friend_requests")
        .where("receiverId", isEqualTo: uid)
        .where("status", isEqualTo: "pending")
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map((snap) => snap.docs);
  }

  //Stream - contacts where current user is a member
  Stream<List<QueryDocumentSnapshot>> contactsStream() {
    return _db
        .collection("contacts")
        .where("members", arrayContains: uid)
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map((snap) => snap.docs);
  }

  Future<void> sendFriendRequest({
    required String receiverId,
    required String receiverName,
    String? message,
    required String senderName,
  }) async {
    if (receiverId == uid) throw Exception("Can't send request to yourself");

    //check already contacts
    final contacts = await _db
        .collection("contacts")
        .where("member", arrayContains: uid)
        .get();

    final alreadyFriends = contacts.docs.any((d) {
      final members = List.from(d["members"] ?? []);
      return members.contains(receiverId);
    });
    if (alreadyFriends) throw Exception("You are already friends");

    //check pending requests
    final pending1 = await _db
        .collection("friend_requests")
        .where("senderId", isEqualTo: uid)
        .where("receiverId", isEqualTo: receiverId)
        .get();

    final pending2 = await _db
        .collection("friend_requests")
        .where("senderId", isEqualTo: receiverId)
        .where("receiverId", isEqualTo: receiverId)
        .get();

    if (pending1.docs.any((d) => d["status"] == 'pending') ||
        pending2.docs.any((d) => d["status"] == 'pending')) {
      throw Exception("There is already a pending request between you");
    }

    //create request
    await _db.collection("friend_requests").add({
      "senderId": uid,
      "senderName": senderName,
      "receiverId": receiverId,
      "message": message ?? '',
      "status": "pending",
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  //Accept request: update request + create contact
  Future<void> acceptRequest(String requestId) async {
    final reqRef = _db.collection("friend_requests").doc(requestId);

    await _db.runTransaction((tx) async {
      final reqSnap = await tx.get(reqRef);
      if (!reqSnap.exists) return;
      final data = reqSnap.data()!;
      if (data['status'] != 'pending') return;

      tx.update(reqRef, {"status": "accepted"});

      //create contact
      final contactRef = _db.collection("contacts").doc();
      tx.set(contactRef, {
        "user1": data["senderId"],
        "user2": data["receiverId"],
        "members": [data["senderId"], data["receiverId"]],
        "createdAt": FieldValue.serverTimestamp(),
      });
    });
  }

  //Reject request
  Future<void> rejectRequest(String requestId) async {
    final reqRef = _db.collection("friend_requests").doc(requestId);
    await reqRef.update({"status": "rejected"});
  }

  //cancel sent request
  Future<void> cancelRequest(String requestId) async {
    await _db.collection("friend_request").doc(requestId).delete();
  }
}
