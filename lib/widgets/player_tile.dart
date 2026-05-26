// widgets/player_tile.dart
import 'package:flutter/material.dart';
import '../models/player.dart';

class PlayerTile extends StatelessWidget {
  final Player player;
  final VoidCallback onTap;
  const PlayerTile({super.key, required this.player, required this.onTap});

  Color _rankColor(int rank) {
    if (rank == 1) return Colors.amber;
    if (rank == 2) return Colors.grey;
    if (rank == 3) return const Color(0xFFCD7F32);
    return const Color(0xFFC9A84C);
  }

  @override
  Widget build(BuildContext context) {
    final rc = _rankColor(player.ranking);
    return Card(
      color: const Color(0xFF0F3460),
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: rc.withOpacity(0.2),
                shape: BoxShape.circle,
                border: Border.all(color: rc),
              ),
              child: Center(
                child: Text('#${player.ranking}',
                    style: TextStyle(
                        color: rc, fontWeight: FontWeight.bold, fontSize: 11)),
              ),
            ),
            const SizedBox(width: 10),
            CircleAvatar(
              radius: 20,
              backgroundColor: const Color(0xFFC9A84C).withOpacity(0.15),
              child: Text(
                player.name.isNotEmpty ? player.name[0].toUpperCase() : '?',
                style: const TextStyle(
                    color: Color(0xFFC9A84C), fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(player.name,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                Text('${player.wins}W / ${player.losses}L · ${player.level}',
                    style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ]),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey, size: 18),
          ]),
        ),
      ),
    );
  }
}
