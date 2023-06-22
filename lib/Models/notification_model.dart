import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String? id;
  final String body;
  final String timestamp;
  final String title;
  final String type;
  final String userId;
  final String requestId;

  NotificationModel({
    this.id,
    required this.body,
    required this.timestamp,
    required this.title,
    required this.type,
    required this.userId,
    required this.requestId,

  });

  toJson() {
    return {
      'body': body,
      'timestamp': timestamp,
      'title': title,
      'type': type,
      'userId': userId,

    };
  }

  factory NotificationModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return NotificationModel(
        id: document.id,
        body: data["body"] as String,
        type: data["type"] as String,
        timestamp: data["timestamp"] as String,
        title: data["title"] as String,
        userId: data["userId"] as String,
       requestId: data["requestId"] as String,


    );
  }


}
