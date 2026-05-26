import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/news.dart';
import '../models/tournament.dart';
import '../models/activity.dart';
import '../providers/admin_provider.dart';
import '../providers/tournament_provider.dart';

class LandingScreen extends ConsumerStatefulWidget {
  const LandingScreen({super.key});

  @override
  ConsumerState<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends ConsumerState<LandingScreen> {
  final _scrollController = ScrollController();
  bool _showStickyHeader = false;

  // Pastel color palette
  static const pink = Color(0xFFE87EA1);
  static const mint = Color(0xFF5BC8AF);
  static const purple = Color(0xFFA78BFA);
  static const peach = Color(0xFFF4A261);
  static const softBlue = Color(0xFF64B5F6);
  static const pinkLight = Color(0xFFFFD6E7);
  static const mintLight = Color(0xFFD6F0D6);
  static const purpleLight = Color(0xFFE8D6FF);
  static const peachLight = Color(0xFFFFE8C0);
  static const blueLight = Color(0xFFD6E8FF);

  // Color helpers based on level/category
  Color _levelColor(String level) {
    switch (level.toLowerCase()) {
      case 'intermediate': return peach;
      case 'advanced': return pink;
      default: return mint;
    }
  }

  Color _levelLightColor(String level) {
    switch (level.toLowerCase()) {
      case 'intermediate': return peachLight;
      case 'advanced': return pinkLight;
      default: return mintLight;
    }
  }

  Color _levelTextColor(String level) {
    switch (level.toLowerCase()) {
      case 'intermediate': return const Color(0xFFB35900);
      case 'advanced': return const Color(0xFFC0185A);
      default: return const Color(0xFF2E7D32);
    }
  }

  Color _categoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'result': return mint;
      case 'event': return purple;
      default: return pink;
    }
  }

  Color _categoryLightColor(String category) {
    switch (category.toLowerCase()) {
      case 'result': return mintLight;
      case 'event': return purpleLight;
      default: return pinkLight;
    }
  }

  Color _categoryTextColor(String category) {
    switch (category.toLowerCase()) {
      case 'result': return const Color(0xFF2E7D32);
      case 'event': return const Color(0xFF6B3FA0);
      default: return const Color(0xFFC0185A);
    }
  }

  IconData _categoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'result': return Icons.emoji_events_outlined;
      case 'event': return Icons.stadium_outlined;
      default: return Icons.campaign_outlined;
    }
  }

  Color _activityColor(String type) {
    switch (type.toLowerCase()) {
      case 'friendly': return mint;
      case 'coaching': return purple;
      case 'junior': return peach;
      default: return pink;
    }
  }

  Color _activityLightColor(String type) {
    switch (type.toLowerCase()) {
      case 'friendly': return mintLight;
      case 'coaching': return purpleLight;
      case 'junior': return peachLight;
      default: return pinkLight;
    }
  }

  Color _activityTextColor(String type) {
    switch (type.toLowerCase()) {
      case 'friendly': return const Color(0xFF1A7A5A);
      case 'coaching': return const Color(0xFF6B3FA0);
      case 'junior': return const Color(0xFFB35900);
      default: return const Color(0xFFC0185A);
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        _showStickyHeader = _scrollController.offset > 220;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tournamentsAsync = ref.watch(tournamentsProvider);
    final newsAsync = ref.watch(newsProvider);
    final activitiesAsync = ref.watch(activitiesProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              // ── Hero ─────────────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFFFF0F5),
                        Color(0xFFF0F0FF),
                        Color(0xFFF0FFF8),
                      ],
                    ),
                  ),
                  child: SafeArea(
                    child: Stack(
                      children: [
                        // Pastel blob decorations
                        Positioned(
                          top: -10, right: -10,
                          child: Container(
                            width: 140, height: 140,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: pinkLight.withOpacity(0.7),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 40, right: 60,
                          child: Container(
                            width: 90, height: 90,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: blueLight.withOpacity(0.7),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -20, right: -20,
                          child: Container(
                            width: 120, height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: mintLight.withOpacity(0.7),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 30, right: 70,
                          child: Container(
                            width: 70, height: 70,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: purpleLight.withOpacity(0.6),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Top nav
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(children: [
                                    const Icon(Icons.sports_tennis, color: pink, size: 26),
                                    const SizedBox(width: 6),
                                    RichText(
                                      text: const TextSpan(children: [
                                        TextSpan(text: 'T', style: TextStyle(color: pink, fontSize: 16, fontWeight: FontWeight.bold)),
                                        TextSpan(text: 'BC', style: TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold)),
                                      ]),
                                    ),
                                  ]),
                                  Row(children: [
                                    OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: pink,
                                        side: const BorderSide(color: pink),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      ),
                                      onPressed: () => context.go('/login'),
                                      child: const Text('Login', style: TextStyle(fontSize: 13)),
                                    ),
                                    const SizedBox(width: 8),
                                    FilledButton(
                                      style: FilledButton.styleFrom(
                                        backgroundColor: pink,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      ),
                                      onPressed: () => context.go('/signup'),
                                      child: const Text('Sign up', style: TextStyle(fontSize: 13)),
                                    ),
                                  ]),
                                ],
                              ),
                              const SizedBox(height: 28),
                              const Text('Tampere\nBadminton Club',
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      height: 1.2)),
                              const SizedBox(height: 6),
                              const Text('Tampere, Finland · Est. 2010',
                                  style: TextStyle(color: Colors.grey, fontSize: 13)),
                              const SizedBox(height: 20),
                              Row(children: [
                                _HeroStat(value: '120+', label: 'Members', color: pink),
                                const SizedBox(width: 20),
                                _HeroStat(value: '2', label: 'Seasons/yr', color: purple),
                                const SizedBox(width: 20),
                                _HeroStat(value: '4', label: 'Courts', color: mint),
                                const SizedBox(width: 20),
                                _HeroStat(value: '15+', label: 'Years', color: peach),
                              ]),
                              const SizedBox(height: 22),
                              Container(
                                width: double.infinity,
                                height: 50,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(colors: [pink, purple, mint]),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: TextButton.icon(
                                  onPressed: () => context.go('/signup'),
                                  icon: const Icon(Icons.sports_tennis, color: Colors.white, size: 20),
                                  label: const Text('Join the club — it\'s free',
                                      style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Tournaments (from Firestore) ───────────────────────────────
              SliverToBoxAdapter(child: _SectionHeader(
                title: 'Upcoming tournaments',
                onSeeAll: () => context.go('/public-tournaments'),
              )),
              SliverToBoxAdapter(
                child: tournamentsAsync.when(
                  loading: () => const SizedBox(
                    height: 100,
                    child: Center(child: CircularProgressIndicator(color: pink)),
                  ),
                  error: (_, __) => const SizedBox(
                    height: 60,
                    child: Center(child: Text('Could not load tournaments', style: TextStyle(color: Colors.grey))),
                  ),
                  data: (tournaments) {
                    if (tournaments.isEmpty) {
                      return const SizedBox(
                        height: 80,
                        child: Center(child: Text('No tournaments yet', style: TextStyle(color: Colors.grey))),
                      );
                    }
                    return SizedBox(
                      height: 210,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                        itemCount: tournaments.length,
                        itemBuilder: (ctx, i) {
                          final t = tournaments[i];
                          final color = _levelColor(t.level);
                          final lightColor = _levelLightColor(t.level);
                          final textColor = _levelTextColor(t.level);
                          return Container(
                            width: 210,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: lightColor, width: 1.5),
                              boxShadow: [
                                BoxShadow(color: lightColor.withOpacity(0.5), blurRadius: 8, offset: const Offset(0, 2)),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(color: lightColor, borderRadius: BorderRadius.circular(20)),
                                        child: Text(t.level, style: TextStyle(color: textColor, fontSize: 11, fontWeight: FontWeight.w500)),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: t.status == 'open' ? lightColor : Colors.grey[100],
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(t.status, style: TextStyle(color: t.status == 'open' ? textColor : Colors.grey, fontSize: 11)),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Text(t.name, style: const TextStyle(color: Colors.black87, fontSize: 13, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 6),
                                  Row(children: [
                                    const Icon(Icons.location_on_outlined, size: 13, color: Colors.grey),
                                    const SizedBox(width: 3),
                                    Expanded(child: Text(t.location, style: const TextStyle(color: Colors.grey, fontSize: 11), overflow: TextOverflow.ellipsis)),
                                  ]),
                                  const SizedBox(height: 2),
                                  Row(children: [
                                    const Icon(Icons.calendar_today_outlined, size: 13, color: Colors.grey),
                                    const SizedBox(width: 3),
                                    Text('${t.date.day}/${t.date.month}/${t.date.year}',
                                        style: const TextStyle(color: Colors.grey, fontSize: 11)),
                                  ]),
                                  const Spacer(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(children: [
                                        const Icon(Icons.people_outline, size: 13, color: Colors.grey),
                                        const SizedBox(width: 3),
                                        Text('${t.registeredPlayers}/${t.maxPlayers}',
                                            style: const TextStyle(color: Colors.grey, fontSize: 11)),
                                      ]),
                                      if (t.status == 'open')
                                        GestureDetector(
                                          onTap: () => context.go('/login'),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                                            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
                                            child: const Text('Register', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500)),
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),

              // ── News (from Firestore) ─────────────────────────────────────
              SliverToBoxAdapter(child: _SectionHeader(
                title: 'Club news',
                onSeeAll: () => context.go('/public-news'),
              )),
              newsAsync.when(
                loading: () => SliverToBoxAdapter(
                  child: const SizedBox(
                    height: 80,
                    child: Center(child: CircularProgressIndicator(color: pink)),
                  ),
                ),
                error: (_, __) => SliverToBoxAdapter(
                  child: const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('Could not load news', style: TextStyle(color: Colors.grey)),
                  ),
                ),
                data: (newsList) {
                  if (newsList.isEmpty) {
                    return SliverToBoxAdapter(
                      child: const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('No news yet', style: TextStyle(color: Colors.grey)),
                      ),
                    );
                  }
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (ctx, i) {
                        final n = newsList[i];
                        final color = _categoryColor(n.category);
                        final lightColor = _categoryLightColor(n.category);
                        final textColor = _categoryTextColor(n.category);
                        final icon = _categoryIcon(n.category);
                        return Container(
                          margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border(left: BorderSide(color: color, width: 4)),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2)),
                            ],
                          ),
                          child: ListTile(
                            leading: Container(
                              width: 44, height: 44,
                              decoration: BoxDecoration(color: lightColor, borderRadius: BorderRadius.circular(12)),
                              child: Icon(icon, color: color, size: 22),
                            ),
                            title: Text(n.title,
                                style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 13)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 2),
                                Text(n.content, style: const TextStyle(color: Colors.grey, fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
                                const SizedBox(height: 5),
                                Row(children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(color: lightColor, borderRadius: BorderRadius.circular(20)),
                                    child: Text(n.category, style: TextStyle(color: textColor, fontSize: 10)),
                                  ),
                                  const SizedBox(width: 8),
                                  Text('${n.createdAt.day}/${n.createdAt.month}/${n.createdAt.year}',
                                      style: const TextStyle(color: Colors.grey, fontSize: 10)),
                                ]),
                              ],
                            ),
                            trailing: Icon(Icons.chevron_right, color: color),
                            onTap: () => context.go('/login'),
                          ),
                        );
                      },
                      childCount: newsList.length > 3 ? 3 : newsList.length,
                    ),
                  );
                },
              ),

              // ── Activities (from Firestore) ───────────────────────────────
              SliverToBoxAdapter(child: _SectionHeader(
                title: 'Club activities',
                onSeeAll: null,
              )),
              activitiesAsync.when(
                loading: () => SliverToBoxAdapter(
                  child: const SizedBox(height: 60, child: Center(child: CircularProgressIndicator(color: pink))),
                ),
                error: (_, __) => SliverToBoxAdapter(
                  child: const Padding(padding: EdgeInsets.all(16), child: Text('Could not load activities', style: TextStyle(color: Colors.grey))),
                ),
                data: (activities) {
                  if (activities.isEmpty) {
                    return SliverToBoxAdapter(
                      child: const Padding(padding: EdgeInsets.all(16), child: Text('No activities yet', style: TextStyle(color: Colors.grey))),
                    );
                  }
                  return SliverToBoxAdapter(
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: purpleLight, width: 1.5),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
                      ),
                      child: Column(
                        children: activities.asMap().entries.map((e) {
                          final a = e.value;
                          final isLast = e.key == activities.length - 1;
                          final color = _activityColor(a.type);
                          final lightColor = _activityLightColor(a.type);
                          final textColor = _activityTextColor(a.type);
                          return Container(
                            decoration: BoxDecoration(
                              border: isLast ? null : const Border(bottom: BorderSide(color: Color(0xFFF5F0FF))),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            child: Row(children: [
                              Container(
                                width: 10, height: 40,
                                decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(5)),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Text(a.name, style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w500, fontSize: 13)),
                                  const SizedBox(height: 2),
                                  Text('${a.day} · ${a.time}', style: const TextStyle(color: Colors.grey, fontSize: 11)),
                                ]),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(color: lightColor, borderRadius: BorderRadius.circular(20)),
                                child: Text(a.location, style: TextStyle(color: textColor, fontSize: 10, fontWeight: FontWeight.w500)),
                              ),
                            ]),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
              ),

              // ── Venues ────────────────────────────────────────────────────
              SliverToBoxAdapter(child: _SectionHeader(title: 'Our venues', onSeeAll: null)),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 110,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    children: [
                      _VenueCard(emoji: '🏟️', name: 'Kauppi Sports Center', courts: '4 courts', color: pinkLight, textColor: const Color(0xFFC0185A)),
                      _VenueCard(emoji: '🎾', name: 'Tampere Tennis Center', courts: '2 courts', color: blueLight, textColor: const Color(0xFF1565C0)),
                      _VenueCard(emoji: '🏫', name: 'SportUni Kauppi', courts: '2 courts', color: mintLight, textColor: const Color(0xFF1A7A5A)),
                      _VenueCard(emoji: '🏢', name: 'Tesoma Sports Hall', courts: '1 court', color: purpleLight, textColor: const Color(0xFF6B3FA0)),
                    ],
                  ),
                ),
              ),

              // ── Join CTA ──────────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFFFF0F5), Color(0xFFF0F0FF), Color(0xFFF0FFF8)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: purpleLight, width: 1.5),
                  ),
                  child: Column(children: [
                    const Icon(Icons.sports_tennis, color: pink, size: 40),
                    const SizedBox(height: 10),
                    const Text('Ready to play?',
                        style: TextStyle(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    const Text(
                      'Join Tampere Badminton Club and get access to tournaments, court bookings and rankings.',
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 18),
                    Row(children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: pink,
                            side: const BorderSide(color: pink, width: 1.5),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: () => context.go('/login'),
                          child: const Text('Login', style: TextStyle(fontWeight: FontWeight.w500)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          height: 46,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [pink, purple]),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextButton(
                            onPressed: () => context.go('/signup'),
                            child: const Text('Sign up free',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                    ]),
                  ]),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 30)),
            ],
          ),

          // Sticky header
          if (_showStickyHeader)
            Positioned(
              top: 0, left: 0, right: 0,
              child: Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 6,
                  bottom: 8,
                  left: 16,
                  right: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: pink.withOpacity(0.15), blurRadius: 10, offset: const Offset(0, 2))],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      const Icon(Icons.sports_tennis, color: pink, size: 20),
                      const SizedBox(width: 6),
                      RichText(text: const TextSpan(children: [
                        TextSpan(text: 'Tampere ', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 14)),
                        TextSpan(text: 'Badminton Club', style: TextStyle(color: pink, fontWeight: FontWeight.bold, fontSize: 14)),
                      ])),
                    ]),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: pink,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                      onPressed: () => context.go('/login'),
                      child: const Text('Login', style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;
  const _SectionHeader({required this.title, this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold)),
          if (onSeeAll != null)
            GestureDetector(
              onTap: onSeeAll,
              child: const Text('See all →', style: TextStyle(color: Color(0xFFE87EA1), fontSize: 13)),
            ),
        ],
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  const _HeroStat({required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(value, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold)),
      Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10)),
    ]);
  }
}

class _VenueCard extends StatelessWidget {
  final String emoji;
  final String name;
  final String courts;
  final Color color;
  final Color textColor;
  const _VenueCard({required this.emoji, required this.name, required this.courts, required this.color, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(14)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(emoji, style: const TextStyle(fontSize: 22)),
        const SizedBox(height: 6),
        Text(name, style: TextStyle(color: textColor, fontSize: 11, fontWeight: FontWeight.w500), maxLines: 2, overflow: TextOverflow.ellipsis),
        const SizedBox(height: 2),
        Text(courts, style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 10)),
      ]),
    );
  }
}
