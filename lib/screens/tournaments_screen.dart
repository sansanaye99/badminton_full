import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/tournament_provider.dart';
import '../widgets/tournament_tile.dart';

class TournamentsScreen extends ConsumerWidget {
  const TournamentsScreen({super.key});

  static const Color pink = Color(0xFFE87EA1);
  static const Color background = Color(0xFFFFFBFD);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tournamentsAsync = ref.watch(tournamentsProvider);

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text('All upcoming tournaments'),
      ),
      body: tournamentsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: pink),
        ),
        error: (error, stack) {
          debugPrint('TOURNAMENTS LOAD ERROR: $error');

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Failed to load tournaments\n$error',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        },
        data: (tournaments) {
          if (tournaments.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.emoji_events_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'No active tournaments yet',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            color: pink,
            onRefresh: () async {
              ref.invalidate(tournamentsProvider);
            },
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 12, bottom: 24),
              itemCount: tournaments.length,
              itemBuilder: (context, index) {
                final tournament = tournaments[index];

                return TournamentTile(
                  tournament: tournament,
                  onTap: () {
                    context.go('/tournaments/${tournament.id}');
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}