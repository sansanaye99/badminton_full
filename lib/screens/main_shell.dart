import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../providers/ranking_provider.dart';
import '../widgets/app_drawer.dart';

class MainShell extends ConsumerWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  int _idx(BuildContext context) {
    final loc = GoRouterState.of(context).matchedLocation;
    if (loc.startsWith('/tournaments')) return 1;
    if (loc.startsWith('/booking')) return 2;
    if (loc.startsWith('/ranking')) return 3;
    return 0;
  }

  String _title(BuildContext context) {
    final loc = GoRouterState.of(context).matchedLocation;
    if (loc.startsWith('/tournaments')) return 'Tournaments';
    if (loc.startsWith('/booking')) return 'Book a court';
    if (loc.startsWith('/ranking')) return 'Ranking';
    if (loc.startsWith('/news')) return 'Club news';
    if (loc.startsWith('/activities')) return 'Club activities';
    if (loc.startsWith('/settings')) return 'Settings';
    if (loc.startsWith('/about')) return 'About';
    if (loc.startsWith('/admin')) return 'Admin panel';
    return '🏸 Badminton Club';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAdminAsync = ref.watch(isAdminProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          _title(context),
          style: const TextStyle(
            color: Color(0xFFE87EA1),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black87),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFFF0F5), Color(0xFFF0F0FF), Color(0xFFF0FFF8)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 52, height: 52,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFD6E7),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.sports_tennis, color: Color(0xFFE87EA1), size: 28),
                  ),
                  const SizedBox(height: 8),
                  const Text('Tampere Badminton Club',
                      style: TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.bold)),
                  Text(
                    ref.watch(authStateProvider).value?.email ?? '',
                    style: const TextStyle(color: Colors.grey, fontSize: 11),
                  ),
                ],
              ),
            ),
            _DrawerItem(icon: Icons.home_outlined, label: 'Home', color: const Color(0xFFE87EA1),
                onTap: () { Navigator.pop(context); context.go('/home'); }),
            _DrawerItem(icon: Icons.newspaper_outlined, label: 'News', color: const Color(0xFFA78BFA),
                onTap: () { Navigator.pop(context); context.go('/news'); }),
            _DrawerItem(icon: Icons.directions_run_outlined, label: 'Club activities', color: const Color(0xFF5BC8AF),
                onTap: () { Navigator.pop(context); context.go('/activities'); }),
            _DrawerItem(icon: Icons.emoji_events_outlined, label: 'Tournaments', color: const Color(0xFFF4A261),
                onTap: () { Navigator.pop(context); context.go('/tournaments'); }),
            _DrawerItem(icon: Icons.calendar_today_outlined, label: 'Book a court', color: const Color(0xFF64B5F6),
                onTap: () { Navigator.pop(context); context.go('/booking'); }),
            _DrawerItem(icon: Icons.leaderboard_outlined, label: 'Ranking', color: const Color(0xFFE87EA1),
                onTap: () { Navigator.pop(context); context.go('/ranking'); }),
            const Divider(color: Color(0xFFFFD6E7)),
            _DrawerItem(icon: Icons.settings_outlined, label: 'Settings', color: Colors.grey,
                onTap: () { Navigator.pop(context); context.go('/settings'); }),
            _DrawerItem(icon: Icons.info_outline, label: 'About', color: Colors.grey,
                onTap: () { Navigator.pop(context); context.go('/about'); }),
            isAdminAsync.when(
              data: (isAdmin) => isAdmin
                  ? Column(children: [
                const Divider(color: Color(0xFFFFE8C0)),
                _DrawerItem(
                  icon: Icons.admin_panel_settings_outlined,
                  label: 'Admin panel',
                  color: Colors.orange,
                  onTap: () { Navigator.pop(context); context.go('/admin'); },
                ),
              ])
                  : const SizedBox.shrink(),
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
            const Divider(color: Color(0xFFFFD6E7)),
            _DrawerItem(
              icon: Icons.logout,
              label: 'Logout',
              color: Colors.red,
              onTap: () async {
                Navigator.pop(context);
                await ref.read(authNotifierProvider.notifier).signOut();
              },
            ),
          ],
        ),
      ),
      body: child,
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFFFFD6E7),
        selectedIndex: _idx(context),
        onDestinationSelected: (i) {
          switch (i) {
            case 0: context.go('/home');
            case 1: context.go('/tournaments');
            case 2: context.go('/booking');
            case 3: context.go('/ranking');
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined, color: Colors.grey),
            selectedIcon: Icon(Icons.home, color: Color(0xFFE87EA1)),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.emoji_events_outlined, color: Colors.grey),
            selectedIcon: Icon(Icons.emoji_events, color: Color(0xFFE87EA1)),
            label: 'Tournaments',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_today_outlined, color: Colors.grey),
            selectedIcon: Icon(Icons.calendar_today, color: Color(0xFFE87EA1)),
            label: 'Booking',
          ),
          NavigationDestination(
            icon: Icon(Icons.leaderboard_outlined, color: Colors.grey),
            selectedIcon: Icon(Icons.leaderboard, color: Color(0xFFE87EA1)),
            label: 'Ranking',
          ),
        ],
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;
  const _DrawerItem({required this.icon, required this.label, required this.onTap, required this.color});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 36, height: 36,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 18),
      ),
      title: Text(label,
          style: TextStyle(
              color: color == Colors.grey ? Colors.black87 : color,
              fontSize: 14,
              fontWeight: FontWeight.w500)),
      onTap: onTap,
      dense: true,
    );
  }
}