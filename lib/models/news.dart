import 'package:cloud_firestore/cloud_firestore.dart';

class News {
  final String id;
  final String title;
  final String content;
  final String category; // announcement, result, event
  final DateTime createdAt;
  final String imageUrl;
  final bool isActive;

  News({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.createdAt,
    required this.imageUrl,
    this.isActive = true,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    final createdAtValue = json['createdAt'];

    DateTime createdAtDate;

    if (createdAtValue is Timestamp) {
      createdAtDate = createdAtValue.toDate();
    } else if (createdAtValue is DateTime) {
      createdAtDate = createdAtValue;
    } else {
      createdAtDate = DateTime.now();
    }

    return News(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      category: json['category'] as String? ?? 'announcement',
      createdAt: createdAtDate,
      imageUrl: json['imageUrl'] as String? ?? '',
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'content': content,
    'category': category,
    'createdAt': Timestamp.fromDate(createdAt),
    'imageUrl': imageUrl,
    'isActive': isActive,
  };
}