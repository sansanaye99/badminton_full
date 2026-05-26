import 'package:badminton_club/models/player.dart';
import 'package:badminton_club/widgets/player_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Player.fromJson', () {
    final json = {
      'id': 'p1', 'name': 'Alice', 'email': 'alice@test.com',
      'ranking': 1, 'wins': 10, 'losses': 2, 'photoUrl': '',
    };

    test('creates Player correctly', () {
      final p = Player.fromJson(json);
      expect(p.id, 'p1');
      expect(p.name, 'Alice');
      expect(p.ranking, 1);
      expect(p.wins, 10);
    });

    test('toJson round-trip', () {
      final p = Player.fromJson(json);
      final out = p.toJson();
      expect(out['name'], 'Alice');
      expect(out['ranking'], 1);
    });

    test('defaults level to basic', () {
      final p = Player.fromJson(json);
      expect(p.level, 'basic');
    });
  });

  group('PlayerTile widget', () {
    final player = Player(
      id: 'p1', name: 'Alice', email: 'alice@test.com',
      ranking: 1, wins: 10, losses: 2, photoUrl: '',
    );

    testWidgets('renders player name', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(body: PlayerTile(player: player, onTap: () {})),
      ));
      expect(find.text('Alice'), findsOneWidget);
    });

    testWidgets('renders rank badge', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(body: PlayerTile(player: player, onTap: () {})),
      ));
      expect(find.text('#1'), findsOneWidget);
    });

    testWidgets('renders win/loss record', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(body: PlayerTile(player: player, onTap: () {})),
      ));
      expect(find.textContaining('10W'), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(body: PlayerTile(player: player, onTap: () => tapped = true)),
      ));
      await tester.tap(find.byType(InkWell));
      expect(tapped, isTrue);
    });
  });
}
