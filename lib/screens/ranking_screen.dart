import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/ranking_provider.dart';
import '../widgets/player_tile.dart';

class RankingScreen extends ConsumerWidget {
  const RankingScreen({super.key});

  static const pink = Color(0xFFE87EA1);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(rankingProvider);
    return async.when(
      loading: () => const Center(child: CircularProgressIndicator(color: pink)),
      error: (_, __) => Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.error_outline, color: Colors.red, size: 48),
        const SizedBox(height: 12),
        const Text('Failed to load', style: TextStyle(color: Colors.black87)),
        FilledButton(onPressed: () => ref.invalidate(rankingProvider), child: const Text('Retry')),
      ])),
      data: (players) {
        if (players.isEmpty) return const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.leaderboard_outlined, size: 64, color: Colors.grey),
          SizedBox(height: 12),
          Text('No players ranked yet', style: TextStyle(color: Colors.grey)),
        ]));
        return RefreshIndicator(
          color: pink,
          onRefresh: () async => ref.invalidate(rankingProvider),
          child: ListView.builder(
            itemCount: players.length,
            itemBuilder: (ctx, i) => PlayerTile(
              player: players[i],
              onTap: () => context.go('/ranking/${players[i].id}'),
            ),
          ),
        );
      },
    );
  }
}