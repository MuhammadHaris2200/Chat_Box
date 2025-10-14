import 'package:chat_box/model/status_item_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class StatusService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<StatusItemModel>> getUserStatuses(String userId) async {
    final snap = await _db
        .collection("statuses")
        .doc(userId)
        .collection("statusList")
        .where(
          "expireAt",
          isGreaterThan: Timestamp.fromDate(
            DateTime.now().subtract(Duration(days: 1)),
          ),
        )
        .orderBy("timestamp", descending: false)
        .get();

    return snap.docs
        .map((d) => StatusItemModel.fromMap(d.data(), d.id))
        .toList();
  }

  Future<void> uploadTextStatus(String currentUserId, String text) async {
    if (text.trim().isEmpty) throw Exception("Empty text");

    final now = DateTime.now();
    final expireAt = Timestamp.fromDate(now.add(const Duration(hours: 24)));

    final parentRef = _db.collection("statuses").doc(currentUserId);
    final subRef = parentRef.collection("statusList");

    ///create the status doc
    final statusData = {
      'type': 'text',
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
      'expireAt': expireAt,
    };

    await subRef.add(statusData);

    ///update parent doc (lastUpdated,hasStatus, statusCount)
    await parentRef.set({
      "lastUpdated": FieldValue.serverTimestamp(),
      "hasStatus": true,
      "statusCount": FieldValue.increment(1),
      "name": FirebaseAuth.instance.currentUser?.displayName ?? "",
      "profilePic": FirebaseAuth.instance.currentUser?.photoURL ?? "",
    }, SetOptions(merge: true));
  }

  ///get latest status
  Future<StatusItemModel?> getLatestStatus(String userId) async {
    final snap = await _db
        .collection("statuses")
        .doc(userId)
        .collection("statusList")
        .orderBy("timestamp", descending: true)
        .limit(1)
        .get();

    if (snap.docs.isEmpty) return null;
    final doc = snap.docs.first;
    return StatusItemModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
  }

  Future<bool> userHasStatus(String userId) async {
    final snap = await FirebaseFirestore.instance
        .collection("statuses")
        .doc(userId)
        .collection("statusList")
        .where("expireAt", isGreaterThan: Timestamp.fromDate(DateTime.now()))
        .get();

    return snap.docs.isNotEmpty;
  }
}
