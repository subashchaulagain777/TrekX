import 'package:cloud_firestore/cloud_firestore.dart';

class GearItem {
  final String id;
  final String title;
  final double price;
  final String condition;
  final String imageUrl;
  final String sellerId;
  final String description; // Add this line

  GearItem({
    required this.id,
    required this.title,
    required this.price,
    required this.condition,
    required this.imageUrl,
    required this.sellerId,
    required this.description, // Add this line
  });

  factory GearItem.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return GearItem(
      id: doc.id,
      title: data['title'] ?? 'No Title',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      condition: data['condition'] ?? 'N/A',
      imageUrl: data['imageUrl'] ?? 'https://placehold.co/400x400/EEE/31343C?text=No+Image',
      sellerId: data['sellerId'] ?? '',
      description: data['description'] ?? 'No description provided.', // Add this line
    );
  }
}