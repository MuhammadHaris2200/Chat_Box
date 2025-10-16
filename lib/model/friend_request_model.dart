import 'package:cloud_firestore/cloud_firestore.dart';

class FriendRequestModel {
  final String id;
  final String senderId;
  final String receiverId;
  final String status;
  final DateTime timestamp;

  FriendRequestModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.status,
    required this.timestamp,
  });

  factory FriendRequestModel.fromMap(Map<String, dynamic> m, String id) {
    return FriendRequestModel(
      id: id,
      senderId: m["senderId"] ?? '',
      receiverId: m["receiverId"] ?? '',
      status: m["status"] ?? "pending",
      timestamp: (m['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
        'senderId': senderId,
        'receiverId': receiverId,
        'status': status,
        'timestamp': Timestamp.fromDate(timestamp),
      };
}
