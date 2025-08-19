import 'package:cloud_firestore/cloud_firestore.dart';

class BookingModel {
  final String bookingId;
  final String trekkerId;
  final String guideId;
  final String guideName;
  final String packageId;
  final String packageName; // Storing this helps on the guide's side
  final String trekkerName; // Storing this also helps
  final DateTime bookingDate;
  final String status;

  BookingModel({
    required this.bookingId,
    required this.trekkerId,
    required this.guideId,
    required this.guideName,
    required this.packageId,
    required this.packageName,
    required this.trekkerName,
    required this.bookingDate,
    required this.status,
  });

  factory BookingModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return BookingModel(
      bookingId: doc.id,
      trekkerId: data['trekkerId'] ?? '',
      guideId: data['guideId'] ?? '',
      guideName: data['guideName'] ?? 'N/A',
      packageId: data['packageId'] ?? '',
      packageName: data['packageName'] ?? '',
      trekkerName: data['trekkerName'] ?? '',
      bookingDate: (data['bookingDate'] as Timestamp).toDate(),
      status: data['status'] ?? 'Pending',
    );
  }
}