import 'package:cloud_firestore/cloud_firestore.dart';

class StatusItemModel {
  final String id;
  final String? imageUrl;
  final String? text;
  final String type;
  final String? caption;
  final Timestamp timestamp;
  final Timestamp? expireAt;

  StatusItemModel({
    required this.id,
    this.imageUrl,
    this.text,
    required this.type,
    this.caption,
    required this.timestamp,
    this.expireAt,
  });

  factory StatusItemModel.fromMap(Map<String, dynamic> data, String docId) {
  return StatusItemModel(
    id: docId,
    imageUrl: data["imageUrl"] as String?,
    text: data["text"] as String?,
    type: data["type"] as String? ?? 'text',
    caption: data["caption"] as String?,
    expireAt: data["expireAt"] as Timestamp?,
    timestamp: data["timestamp"] as Timestamp? ?? Timestamp.now(),
  );
}


  Map<String, dynamic> toMap() {
    return {
      "imageUrl": imageUrl,
      "text": text,
      "type": type,
      "caption": caption,
      "expireAt": expireAt,
      "timestamp": timestamp,
    };
  }
}
