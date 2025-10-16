import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FriendService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  /// Send friend request by email
  Future<void> sendFriendRequest(String receiverEmail) async {
    final sender = _auth.currentUser;
    if (sender == null) throw Exception("User not logged in");

    // Find receiver user by email
    final receiverSnap = await _db
        .collection('users')
        .where('email', isEqualTo: receiverEmail)
        .limit(1)
        .get();

    if (receiverSnap.docs.isEmpty) throw Exception("User not found");

    final receiverId = receiverSnap.docs.first.id;

    // Save friend request in Firestore
    await _db.collection('friendRequests').add({
      'senderId': sender.uid,
      'receiverId': receiverId,
      'status': 'pending',
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  /// Accept friend request
  Future<void> acceptFriendRequest(String requestId, String senderId) async {
    final receiverId = _auth.currentUser?.uid;
    if (receiverId == null) throw Exception("User not logged in");

    // Update status to accepted
    await _db.collection('friendRequests').doc(requestId).update({
      'status': 'accepted',
    });

    // Add each other to 'friends' list
    await _db.collection('users').doc(receiverId).set({
      'friends': FieldValue.arrayUnion([senderId]),
    }, SetOptions(merge: true));

    await _db.collection('users').doc(senderId).set({
      'friends': FieldValue.arrayUnion([receiverId]),
    }, SetOptions(merge: true));
  }

  /// Reject friend request
  Future<void> rejectFriendRequest(String requestId) async {
    await _db.collection('friendRequests').doc(requestId).update({
      'status': 'rejected',
    });
  }

  /// Stream incoming friend requests
  Stream<QuerySnapshot> getIncomingRequests() {
    final uid = _auth.currentUser?.uid;
    return _db
        .collection('friendRequests')
        .where('receiverId', isEqualTo: uid)
        .where('status', isEqualTo: 'pending')
        .snapshots();
  }

  /// Get friends list
  Future<List<String>> getFriendsList() async {
    final uid = _auth.currentUser?.uid;
    final doc = await _db.collection('users').doc(uid).get();
    final data = doc.data();
    return (data?['friends'] as List?)?.cast<String>() ?? [];
  }
}
