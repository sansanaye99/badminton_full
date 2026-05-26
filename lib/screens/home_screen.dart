import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/activity.dart';
import '../providers/auth_provider.dart';
import '../providers/tournament_provider.dart';
import '../providers/admin_provider.dart';
import '../widgets/tournament_tile.dart';
import '../widgets/news_tile.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static const pink = Color(0xFFE87EA1);
  static const mint = Color(0xFF5BC8AF);
  static const softBlue = Color(0xFF64B5F6);
  static const pinkLight = Color(0xFFFFD6E7);
  static const mintLight = Color(0xFFD6F0D6);
  static const blueLight = Color(0xFFD6E8FF);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).value;
    final tournamentsAsync = ref.watch(tournamentsProvider);
    final newsAsync = ref.watch(newsProvider);
    final activitiesAsync = ref.watch(activitiesProvider);

    return RefreshIndicator(
      color: pink,
      onRefresh: () async {
        ref.invalidate(tournamentsProvider);
        ref.invalidate(newsProvider);
        ref.invalidate(activitiesProvider);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome banner
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(14),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFFFF0F5),
                    Color(0xFFF0F0FF),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: pinkLight, width: 1.5),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: pinkLight,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person, color: pink, size: 26),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Welcome back! 👋',
                          style: TextStyle(
                            color: pink,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          user?.email ?? '',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Quick actions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  Expanded(
                    child: _QuickAction(
                      icon: Icons.calendar_today,
                      label: 'Book court',
                      color: softBlue,
                      bgColor: blueLight,
                      onTap: () => context.go('/booking'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _QuickAction(
                      icon: Icons.emoji_events,
                      label: 'Tournaments',
                      color: pink,
                      bgColor: pinkLight,
                      onTap: () => context.go('/tournaments'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _QuickAction(
                      icon: Icons.photo_library_outlined,
                      label: 'Activities',
                      color: mint,
                      bgColor: mintLight,
                      onTap: () => context.go('/activities'),
                    ),
                  ),
                ],
              ),
            ),

            // Club news
            const SizedBox(height: 18),
            _SectionHeader(
              title: 'Club news',
              onSeeAll: () => context.go('/news'),
            ),
            newsAsync.when(
              loading: () => const Padding(
                padding: EdgeInsets.all(20),
                child: Center(
                  child: CircularProgressIndicator(color: pink),
                ),
              ),
              error: (_, __) => const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Failed to load news',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              data: (newsList) {
                if (newsList.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'No news yet',
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                return Column(
                  children: newsList.take(2).map((news) {
                    return NewsTile(
                      news: news,
                      onTap: () => context.go('/news/${news.id}'),
                    );
                  }).toList(),
                );
              },
            ),

            // Upcoming tournaments
            const SizedBox(height: 8),
            _SectionHeader(
              title: 'Upcoming tournaments',
              onSeeAll: () => context.go('/tournaments'),
            ),
            tournamentsAsync.when(
              loading: () => const Padding(
                padding: EdgeInsets.all(20),
                child: Center(
                  child: CircularProgressIndicator(color: pink),
                ),
              ),
              error: (_, __) => Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'Failed to load tournaments',
                      style: TextStyle(color: Colors.grey),
                    ),
                    TextButton(
                      onPressed: () => ref.invalidate(tournamentsProvider),
                      child: const Text(
                        'Retry',
                        style: TextStyle(color: pink),
                      ),
                    ),
                  ],
                ),
              ),
              data: (list) {
                if (list.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'No tournaments yet',
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                return Column(
                  children: list.take(2).map((tournament) {
                    return TournamentTile(
                      tournament: tournament,
                      onTap: () => context.go('/tournaments/${tournament.id}'),
                    );
                  }).toList(),
                );
              },
            ),

            // Activities
            const SizedBox(height: 8),
            _SectionHeader(
              title: 'Activities',
              onSeeAll: () => context.go('/activities'),
            ),
            activitiesAsync.when(
              loading: () => const Padding(
                padding: EdgeInsets.all(20),
                child: Center(
                  child: CircularProgressIndicator(color: pink),
                ),
              ),
              error: (error, stack) {
                debugPrint('HOME ACTIVITIES ERROR: $error');

                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Failed to load activities\n$error',
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                    ),
                  ),
                );
              },
              data: (activities) {
                if (activities.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'No activities yet',
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                return Column(
                  children: activities.take(2).map((activity) {
                    return _ActivityHomeTile(
                      activity: activity,
                      onTap: () {
                        context.push(
                          '/activities/${activity.id}',
                          extra: activity,
                        );
                      },
                    );
                  }).toList(),
                );
              },
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _ActivityHomeTile extends StatelessWidget {
  final Activity activity;
  final VoidCallback onTap;

  const _ActivityHomeTile({
    required this.activity,
    required this.onTap,
  });

  static const pink = Color(0xFFE87EA1);
  static const mint = Color(0xFF5BC8AF);
  static const mintLight = Color(0xFFD6F0D6);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: activity.imageUrl.isNotEmpty
                    ? Image.network(
                  activity.imageUrl,
                  width: 78,
                  height: 78,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _emptyImage(),
                )
                    : _emptyImage(),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_formatDate(activity.date)} · ${activity.category}',
                      style: const TextStyle(
                        color: pink,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      activity.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _emptyImage() {
    return Container(
      width: 78,
      height: 78,
      color: mintLight,
      child: const Icon(
        Icons.image_outlined,
        color: mint,
        size: 30,
      ),
    );
  }

  static String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onSeeAll;

  const _SectionHeader({
    required this.title,
    required this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          GestureDetector(
            onTap: onSeeAll,
            child: const Text(
              'See all →',
              style: TextStyle(
                color: Color(0xFFE87EA1),
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color bgColor;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.bgColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}