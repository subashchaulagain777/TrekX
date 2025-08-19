import 'package:cloud_firestore/cloud_firestore.dart';

class TrekPackage {
  final String id;
  final String name;
  final String guideName;
  final String guideId;
  final double price;
  final double rating;
  final String imageUrl;
  final String description; // Add this
  final String itinerary;   // Add this
  final int durationInDays; // Add this

  TrekPackage({
    required this.id,
    required this.name,
    required this.guideName,
    required this.guideId,
    required this.price,
    required this.rating,
    required this.imageUrl,
    required this.description, // Add this
    required this.itinerary,   // Add this
    required this.durationInDays, // Add this
  });

  factory TrekPackage.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return TrekPackage(
      id: doc.id,
      name: data['name'] ?? 'No Name',
      guideName: data['guideName'] ?? 'N/A',
      guideId: data['guideId'] ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
      imageUrl: data['imageUrl'] ?? 'https://placehold.co/600x400/EEE/31343C?text=No+Image',
      description: data['description'] ?? 'No description available.', // Add this
      itinerary: data['itinerary'] ?? 'No itinerary available.',       // Add this
      durationInDays: (data['durationInDays'] as num?)?.toInt() ?? 0, // Add this
    );
  }
}