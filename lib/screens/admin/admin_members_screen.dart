import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/ranking_provider.dart';

class AdminMembersScreen extends ConsumerWidget {
  const AdminMembersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(rankingProvider);
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(title: const Text('Members'), backgroundColor: Colors.orange[900]),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFFC9A84C))),
        error: (_, __) => const Center(child: Text('Failed to load', style: TextStyle(color: Colors.white))),
        data: (players) {
          if (players.isEmpty) {
            return const Center(child: Text('No members yet', style: TextStyle(color: Colors.grey)));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: players.length,
            itemBuilder: (ctx, i) {
              final p = players[i];
              return Card(
                color: const Color(0xFF0F3460),
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.purple.withOpacity(0.3),
                    child: Text(
                      p.name.isNotEmpty ? p.name[0].toUpperCase() : '?',
                      style: const TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text(p.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  subtitle: Text(p.email, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  trailing: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Text('Rank #${p.ranking}',
                        style: const TextStyle(color: Color(0xFFC9A84C), fontWeight: FontWeight.bold, fontSize: 13)),
                    Text('${p.wins}W / ${p.losses}L',
                        style: const TextStyle(color: Colors.grey, fontSize: 11)),
                  ]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
