import 'package:cloud_firestore/cloud_firestore.dart';

class Activity {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String location;
  final String category;
  final DateTime date;
  final bool isActive;

  Activity({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.location,
    required this.category,
    required this.date,
    required this.isActive,
  });

  // Backup old names, so old code will not break
  String get name => title;
  String get day => '${date.day}/${date.month}/${date.year}';
  String get time => category;
  String get type => category;

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: _readString(json['id']),
      title: _readString(json['title'] ?? json['name']),
      description: _readString(json['description'] ?? json['day']),
      imageUrl: _readString(json['imageUrl']),
      location: _readString(json['location']),
      category: _readString(json['category'] ?? json['type']).isEmpty
          ? 'Activity'
          : _readString(json['category'] ?? json['type']),
      date: _readDate(json['date']),
      isActive: _readBool(json['isActive']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'name': title,
      'description': description,
      'imageUrl': imageUrl,
      'location': location,
      'category': category,
      'type': category,
      'date': Timestamp.fromDate(date),
      'isActive': isActive,
    };
  }

  Activity copyWith({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    String? location,
    String? category,
    DateTime? date,
    bool? isActive,
  }) {
    return Activity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      location: location ?? this.location,
      category: category ?? this.category,
      date: date ?? this.date,
      isActive: isActive ?? this.isActive,
    );
  }

  static String _readString(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }

  static bool _readBool(dynamic value) {
    if (value is bool) return value;
    if (value is String) return value.toLowerCase() == 'true';
    return true;
  }

  static DateTime _readDate(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;

    if (value is String) {
      final parsed = DateTime.tryParse(value);
      if (parsed != null) return parsed;
    }

    return DateTime.now();
  }
}