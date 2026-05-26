// ── models/tournament.dart ────────────────────────────────────────────────────
import 'package:cloud_firestore/cloud_firestore.dart';

class Tournament {
  final String id;
  final String name;
  final String description;
  final DateTime date;
  final String location;
  final String imageUrl;
  final int maxPlayers;
  final int registeredPlayers;
  final String level; // basic, intermediate, advanced
  final String season; // summer, winter
  final String status; // open, upcoming, closed
  final bool isActive;

  Tournament({
    required this.id,
    required this.name,
    required this.description,
    required this.date,
    required this.location,
    required this.imageUrl,
    required this.maxPlayers,
    required this.registeredPlayers,
    this.level = 'basic',
    this.season = 'summer',
    this.status = 'open',
    this.isActive = true,
  });

  factory Tournament.fromJson(Map<String, dynamic> json) {
    final dateValue = json['date'];

    DateTime tournamentDate;

    if (dateValue is Timestamp) {
      tournamentDate = dateValue.toDate();
    } else if (dateValue is DateTime) {
      tournamentDate = dateValue;
    } else {
      tournamentDate = DateTime.now();
    }

    return Tournament(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      date: tournamentDate,
      location: json['location'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      maxPlayers: json['maxPlayers'] as int? ?? 0,
      registeredPlayers: json['registeredPlayers'] as int? ?? 0,
      level: json['level'] as String? ?? 'basic',
      season: json['season'] as String? ?? 'summer',
      status: json['status'] as String? ?? 'open',
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'date': Timestamp.fromDate(date),
    'location': location,
    'imageUrl': imageUrl,
    'maxPlayers': maxPlayers,
    'registeredPlayers': registeredPlayers,
    'level': level,
    'season': season,
    'status': status,
    'isActive': isActive,
  };
}