import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FriendService {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  get uid => null;

  /// 🔹 Stream of incoming friend requests (requests sent *to* current user)
  Stream<List<QueryDocumentSnapshot>> incomingRequestsStream() {
    final currentUserId = _auth.currentUser!.uid;

    return _firestore
        .collection("friend_requests")
        .where("receiverId", isEqualTo: currentUserId)
        .where("status", isEqualTo: "pending")
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs);
  }

  /// 🔹 Send a new friend request
  Future<void> sendFriendRequest({
    required String receiverId,
    required String receiverName,
    required String senderName,
  }) async {
    final senderId = _auth.currentUser!.uid;

    await _firestore.collection("friend_requests").add({
      "senderId": senderId,
      "senderName": senderName,
      "receiverId": receiverId,
      "receiverName": receiverName,
      "status": "pending",
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  /// 🔹 Accept a request
  Future<void> acceptRequest(String requestId) async {
    final requestDoc = await _firestore
        .collection("friend_requests")
        .doc(requestId)
        .get();
    final data = requestDoc.data() ?? {};

    final senderId = data["senderId"];
    final receiverId = data["receiverId"];

    // ✅ Add both users in 'contacts' collection
    await _firestore.collection("contacts").add({
      "members": [senderId, receiverId],
      "createdAt": FieldValue.serverTimestamp(),
    });

    // ✅ Update request status
    await _firestore.collection("friend_requests").doc(requestId).update({
      "status": "accepted",
    });
  }

  /// 🔹 Reject a request
  Future<void> rejectRequest(String requestId) async {
    await _firestore.collection("friend_requests").doc(requestId).update({
      "status": "rejected",
    });
  }

  /// 🔹 Check if already friends
  Future<bool> areFriends(String uid1, String uid2) async {
    final snapshot = await _firestore
        .collection("contacts")
        .where("members", arrayContains: uid1)
        .get();

    return snapshot.docs.any((doc) {
      final members = List<String>.from(doc["members"] ?? []);
      return members.contains(uid2);
    });
  }

  /// 🔹 Check if a pending request exists
  Future<bool> hasPendingRequest(String senderId, String receiverId) async {
    final snapshot = await _firestore
        .collection("friend_requests")
        .where("senderId", isEqualTo: senderId)
        .where("receiverId", isEqualTo: receiverId)
        .where("status", isEqualTo: "pending")
        .get();

    return snapshot.docs.isNotEmpty;
  }

  /// 🔹 Stream of accepted contacts
  Stream<List<QueryDocumentSnapshot>> contactsStream() {
    final currentUserId = _auth.currentUser!.uid;

    return _firestore
        .collection("contacts")
        .where("members", arrayContains: currentUserId)
        .snapshots()
        .map((snapshot) => snapshot.docs);
  }

  /// 🔹 Cancel a sent friend request
  Future<void> cancelRequest(String requestId) async {
    try {
      await _firestore.collection('friend_requests').doc(requestId).delete();
    } catch (e) {
      throw Exception('Failed to cancel request: $e');
    }
  }

  Future<List<String>> getFriendsList() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final contactsSnap = await FirebaseFirestore.instance
        .collection('contacts')
        .where('members', arrayContains: uid)
        .get();

    final friendIds = contactsSnap.docs.map((doc) {
      final members = List<String>.from(doc['members']);
      return members.firstWhere((id) => id != uid);
    }).toList();

    return friendIds;
  }
}
