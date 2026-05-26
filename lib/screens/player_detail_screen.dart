import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/ranking_provider.dart';

class PlayerDetailScreen extends ConsumerWidget {
  final String id;
  const PlayerDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(playerDetailProvider(id));
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(title: const Text('Player profile')),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFFC9A84C))),
        error: (_, __) => const Center(child: Text('Failed to load', style: TextStyle(color: Colors.white))),
        data: (player) {
          if (player == null) return const Center(child: Text('Not found'));
          final winRate = player.wins + player.losses > 0
              ? (player.wins / (player.wins + player.losses) * 100).round()
              : 0;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 48,
                  backgroundColor: const Color(0xFF0F3460),
                  child: Text(
                    player.name.isNotEmpty ? player.name[0].toUpperCase() : '?',
                    style: const TextStyle(
                        color: Color(0xFFC9A84C),
                        fontSize: 36,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 12),
                Text(player.name,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold)),
                Text(player.email,
                    style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFC9A84C).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('Rank #${player.ranking}  ·  ${player.level}',
                      style: const TextStyle(color: Color(0xFFC9A84C))),
                ),
                const SizedBox(height: 20),
                Row(children: [
                  _StatCard(label: 'Wins', value: player.wins.toString(), color: Colors.green),
                  const SizedBox(width: 10),
                  _StatCard(label: 'Losses', value: player.losses.toString(), color: Colors.red),
                  const SizedBox(width: 10),
                  _StatCard(label: 'Win rate', value: '$winRate%', color: const Color(0xFFC9A84C)),
                ]),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _StatCard({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(children: [
          Text(value,
              style: TextStyle(
                  color: color,
                  fontSize: 22,
                  fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ]),
      ),
    );
  }
}
