import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../providers/ranking_provider.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  static const pink = Color(0xFFE87EA1);
  static const mint = Color(0xFF5BC8AF);
  static const purple = Color(0xFFA78BFA);
  static const pinkLight = Color(0xFFFFD6E7);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).value;
    final isAdminAsync = ref.watch(isAdminProvider);

    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFFF0F5), Color(0xFFF0F0FF), Color(0xFFF0FFF8)],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 52, height: 52,
                  decoration: const BoxDecoration(color: pinkLight, shape: BoxShape.circle),
                  child: const Icon(Icons.sports_tennis, color: pink, size: 28),
                ),
                const SizedBox(height: 8),
                const Text('Tampere Badminton Club',
                    style: TextStyle(color: Colors.black87, fontSize: 15, fontWeight: FontWeight.bold)),
                Text(user?.email ?? '', style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          _DrawerItem(icon: Icons.home_outlined, label: 'Home', color: pink,
              onTap: () { Navigator.pop(context); context.go('/home'); }),
          _DrawerItem(icon: Icons.newspaper_outlined, label: 'News', color: purple,
              onTap: () { Navigator.pop(context); context.go('/news'); }),
          _DrawerItem(icon: Icons.directions_run_outlined, label: 'Club activities', color: mint,
              onTap: () { Navigator.pop(context); context.go('/activities'); }),
          const Divider(color: Color(0xFFFFD6E7)),
          _DrawerItem(icon: Icons.settings_outlined, label: 'Settings', color: Colors.grey,
              onTap: () { Navigator.pop(context); context.go('/settings'); }),
          _DrawerItem(icon: Icons.info_outline, label: 'About', color: Colors.grey,
              onTap: () { Navigator.pop(context); context.go('/about'); }),
          isAdminAsync.when(
            data: (isAdmin) => isAdmin
                ? Column(children: [
                    const Divider(color: Color(0xFFFFE8C0)),
                    _DrawerItem(icon: Icons.admin_panel_settings_outlined, label: 'Admin panel', color: Colors.orange,
                        onTap: () { Navigator.pop(context); context.go('/admin'); }),
                  ])
                : const SizedBox.shrink(),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          const Divider(color: Color(0xFFFFD6E7)),
          _DrawerItem(
            icon: Icons.logout,
            label: 'Logout',
            color: Colors.red[400]!,
            onTap: () async {
              Navigator.pop(context);
              await ref.read(authNotifierProvider.notifier).signOut();
            },
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
        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: color, size: 18),
      ),
      title: Text(label, style: TextStyle(color: color == Colors.grey ? Colors.black87 : color, fontSize: 14, fontWeight: FontWeight.w500)),
      onTap: onTap,
      dense: true,
    );
  }
}
