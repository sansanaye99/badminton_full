class Player {
  final String id;
  final String name;
  final String email;
  final int ranking;
  final int wins;
  final int losses;
  final String photoUrl;
  final String level; // basic, intermediate, advanced
  final String role; // member, admin

  Player({
    required this.id,
    required this.name,
    required this.email,
    required this.ranking,
    required this.wins,
    required this.losses,
    required this.photoUrl,
    this.level = 'basic',
    this.role = 'member',
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      ranking: json['ranking'] as int,
      wins: json['wins'] as int,
      losses: json['losses'] as int,
      photoUrl: json['photoUrl'] as String? ?? '',
      level: json['level'] as String? ?? 'basic',
      role: json['role'] as String? ?? 'member',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'ranking': ranking,
        'wins': wins,
        'losses': losses,
        'photoUrl': photoUrl,
        'level': level,
        'role': role,
      };
}
