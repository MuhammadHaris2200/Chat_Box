import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FriendService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  /// -----------------------------
  /// Send Friend Request by Email
  /// -----------------------------
  Future<void> sendFriendRequest(String receiverEmail) async {
    final sender = _auth.currentUser;
    if (sender == null) throw Exception("User not logged in");

    // 🔹 Find receiver user by email
    final receiverSnap = await _db
        .collection('users')
        .where('email', isEqualTo: receiverEmail)
        .limit(1)
        .get();

    if (receiverSnap.docs.isEmpty) throw Exception("User not found");

    final receiverId = receiverSnap.docs.first.id;

    if (receiverId == sender.uid) {
      throw Exception("You can’t send request to yourself");
    }

    // 🔹 Check if request already exists
    final existing = await _db
        .collection('friendRequests')
        .where('senderId', isEqualTo: sender.uid)
        .where('receiverId', isEqualTo: receiverId)
        .get();

    if (existing.docs.isNotEmpty) {
      throw Exception("Request already sent");
    }

    // 🔹 Check if they are already friends
    final senderDoc = await _db.collection('users').doc(sender.uid).get();
    final senderFriends = (senderDoc.data()?['friends'] ?? []) as List;

    if (senderFriends.contains(receiverId)) {
      throw Exception("Already friends");
    }

    // 🔹 Send new friend request
    await _db.collection('friendRequests').add({
      'senderId': sender.uid,
      'receiverId': receiverId,
      'status': 'pending',
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  /// -----------------------------
  /// Accept Friend Request
  /// -----------------------------
  Future<void> acceptFriendRequest(String requestId, String senderId) async {
    final receiverId = _auth.currentUser?.uid;
    if (receiverId == null) throw Exception("User not logged in");

    // 🔹 Update status to 'accepted'
    await _db.collection('friendRequests').doc(requestId).update({
      'status': 'accepted',
    });

    // 🔹 Add both users to each other’s friend list
    final senderRef = _db.collection('users').doc(senderId);
    final receiverRef = _db.collection('users').doc(receiverId);

    await _db.runTransaction((transaction) async {
      transaction.set(senderRef, {
        'friends': FieldValue.arrayUnion([receiverId]),
      }, SetOptions(merge: true));

      transaction.set(receiverRef, {
        'friends': FieldValue.arrayUnion([senderId]),
      }, SetOptions(merge: true));
    });
  }

  /// -----------------------------
  /// Reject Friend Request
  /// -----------------------------
  Future<void> rejectFriendRequest(String requestId) async {
    await _db.collection('friendRequests').doc(requestId).update({
      'status': 'rejected',
    });
  }

  /// -----------------------------
  /// Stream Incoming Friend Requests
  /// -----------------------------
  Stream<QuerySnapshot> getIncomingRequests() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      throw Exception("User not logged in");
    }

    return _db
        .collection('friendRequests')
        .where('receiverId', isEqualTo: uid)
        .where('status', isEqualTo: 'pending')
        .snapshots();
  }

  /// -----------------------------
  /// Get Friends List (IDs)
  /// -----------------------------
  Future<List<String>> getFriendsList() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception("User not logged in");

    final doc = await _db.collection('users').doc(uid).get();
    final data = doc.data();
    return (data?['friends'] as List?)?.cast<String>() ?? [];
  }
}
