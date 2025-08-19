import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
  final String userId; // Add this line
  final String userName;
  final String userAvatarUrl;
  final String imageUrl;
  final String caption;
  int likes;
  final int comments;
  final Timestamp timestamp;
  final List<String> likedBy;

  Post({
    required this.id,
    required this.userId, // Add this line
    required this.userName,
    required this.userAvatarUrl,
    required this.imageUrl,
    required this.caption,
    required this.likes,
    required this.comments,
    required this.timestamp,
    required this.likedBy,
  });

  factory Post.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Post(
      id: doc.id,
      userId: data['userId'] ?? '', // Add this line
      userName: data['userName'] ?? 'Unknown User',
      userAvatarUrl: data['userAvatarUrl'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      caption: data['caption'] ?? '',
      likes: (data['likes'] as num?)?.toInt() ?? 0,
      comments: (data['comments'] as num?)?.toInt() ?? 0,
      timestamp: data['timestamp'] ?? Timestamp.now(),
      likedBy: List<String>.from(data['likedBy'] ?? []),
    );
  }
}