import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String fullName;
  final String email;
  final String role;
  final String bio;
  final String avatarUrl;
  final List<String> friends;

  UserModel({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.role,
    required this.bio,
    required this.avatarUrl,
    required this.friends
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      fullName: data['fullName'] ?? 'No Name',
      email: data['email'] ?? '',
      role: data['role'] ?? 'Trekker',
      bio: data['bio'] ?? 'No bio yet.',
      avatarUrl: data['avatarUrl'] ?? 'https://placehold.co/100x100/EEE/31343C?text=?',
      friends: List<String>.from(data['friends'] ?? []),
    );
  }
}