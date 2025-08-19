import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String userName;
  final String userAvatarUrl;
  final String text;
  final Timestamp timestamp;

  Comment({
    required this.userName,
    required this.userAvatarUrl,
    required this.text,
    required this.timestamp,
  });

  factory Comment.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Comment(
      userName: data['userName'] ?? 'Unknown User',
      userAvatarUrl: data['userAvatarUrl'] ?? 'https://placehold.co/100x100/EEE/31343C?text=?',
      text: data['text'] ?? '',
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }
}