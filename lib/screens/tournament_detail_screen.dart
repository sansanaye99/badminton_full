import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/tournament_provider.dart';

class TournamentDetailScreen extends ConsumerWidget {
  final String id;
  const TournamentDetailScreen({super.key, required this.id});

  Color _levelColor(String level) {
    switch (level) {
      case 'intermediate': return const Color(0xFFC9A84C);
      case 'advanced': return Colors.red;
      default: return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(tournamentDetailProvider(id));
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(title: const Text('Tournament details')),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFFC9A84C))),
        error: (_, __) => Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Text('Failed to load', style: TextStyle(color: Colors.white)),
            FilledButton(onPressed: () => ref.invalidate(tournamentDetailProvider(id)), child: const Text('Retry')),
          ]),
        ),
        data: (t) {
          if (t == null) return const Center(child: Text('Not found', style: TextStyle(color: Colors.white)));
          final lc = _levelColor(t.level);
          return SingleChildScrollView(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(width: double.infinity, height: 160, color: const Color(0xFF0F3460),
                child: const Center(child: Icon(Icons.emoji_events, color: Color(0xFFC9A84C), size: 72))),
              Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Expanded(child: Text(t.name, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold))),
                  Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: lc.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                    child: Text(t.level, style: TextStyle(color: lc, fontWeight: FontWeight.w500))),
                ]),
                const SizedBox(height: 14),
                _InfoRow(icon: Icons.location_on_outlined, label: 'Location', value: t.location),
                _InfoRow(icon: Icons.calendar_today_outlined, label: 'Date',
                    value: '${t.date.day}/${t.date.month}/${t.date.year}'),
                _InfoRow(icon: Icons.wb_sunny_outlined, label: 'Season', value: t.season),
                _InfoRow(icon: Icons.people_outlined, label: 'Players',
                    value: '${t.registeredPlayers}/${t.maxPlayers}'),
                const SizedBox(height: 10),
                ClipRRect(borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: t.maxPlayers > 0 ? t.registeredPlayers / t.maxPlayers : 0,
                    backgroundColor: Colors.grey[800],
                    color: const Color(0xFFC9A84C),
                    minHeight: 8,
                  )),
                const SizedBox(height: 16),
                const Text('About', style: TextStyle(color: Color(0xFFC9A84C), fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(t.description, style: const TextStyle(color: Color(0xFFAABBCC), height: 1.6)),
                const SizedBox(height: 20),
                SizedBox(width: double.infinity, height: 48,
                  child: FilledButton.icon(
                    onPressed: t.registeredPlayers >= t.maxPlayers ? null : () => context.go('/tournaments/${t.id}/register'),
                    icon: const Icon(Icons.how_to_reg),
                    label: Text(t.registeredPlayers >= t.maxPlayers ? 'Tournament full' : 'Register now'),
                  )),
              ])),
            ]),
          );
        },
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(children: [
        Icon(icon, size: 18, color: Colors.grey),
        const SizedBox(width: 8),
        Text('$label: ', style: const TextStyle(color: Colors.grey)),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
      ]),
    );
  }
}
