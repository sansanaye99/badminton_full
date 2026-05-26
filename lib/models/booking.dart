import 'package:cloud_firestore/cloud_firestore.dart';

class Booking {
  final String id;
  final String userId;
  final String userName;
  final String courtName;
  final DateTime date;
  final String timeSlot;
  final String status; // confirmed, pending, cancelled

  Booking({
    required this.id,
    required this.userId,
    required this.userName,
    required this.courtName,
    required this.date,
    required this.timeSlot,
    required this.status,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String? ?? '',
      courtName: json['courtName'] as String,
      date: (json['date'] as Timestamp).toDate(),
      timeSlot: json['timeSlot'] as String,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'userName': userName,
        'courtName': courtName,
        'date': Timestamp.fromDate(date),
        'timeSlot': timeSlot,
        'status': status,
      };
}
