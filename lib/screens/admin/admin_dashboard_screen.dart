// screens/admin/admin_dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  static const Color pink = Color(0xFFE87EA1);
  static const Color mint = Color(0xFF5BC8AF);
  static const Color purple = Color(0xFFA78BFA);
  static const Color softBlue = Color(0xFF64B5F6);

  static const Color background = Color(0xFFFFFBFD);
  static const Color pinkLight = Color(0xFFFFD6E7);
  static const Color mintLight = Color(0xFFD6F0D6);
  static const Color blueLight = Color(0xFFD6E8FF);
  static const Color purpleLight = Color(0xFFE8DDFF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text('Admin panel'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFFFF0F5),
                  Color(0xFFF0F0FF),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: pinkLight, width: 1.4),
            ),
            child: const Row(
              children: [
                CircleAvatar(
                  backgroundColor: pinkLight,
                  child: Icon(
                    Icons.admin_panel_settings,
                    color: pink,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Admin access. Changes are visible to all members immediately.',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          _AdminCard(
            icon: Icons.newspaper,
            label: 'News articles',
            subtitle: 'Add, edit, or hide club news',
            color: pink,
            bgColor: pinkLight,
            onTap: () => context.go('/admin/news'),
          ),

          const SizedBox(height: 10),

          _AdminCard(
            icon: Icons.emoji_events,
            label: 'Tournaments',
            subtitle: 'Create and manage active tournaments',
            color: mint,
            bgColor: mintLight,
            onTap: () => context.go('/admin/tournaments'),
          ),

          const SizedBox(height: 10),

          _AdminCard(
            icon: Icons.directions_run,
            label: 'Club activities',
            subtitle: 'Manage weekly schedule',
            color: softBlue,
            bgColor: blueLight,
            onTap: () => context.go('/admin/activities'),
          ),

          const SizedBox(height: 10),

          _AdminCard(
            icon: Icons.people,
            label: 'Members',
            subtitle: 'View all registered members',
            color: purple,
            bgColor: purpleLight,
            onTap: () => context.go('/admin/members'),
          ),
        ],
      ),
    );
  }
}

class _AdminCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final Color bgColor;
  final VoidCallback onTap;

  const _AdminCard({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.bgColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: bgColor, width: 1.4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            Icon(
              Icons.chevron_right,
              color: color,
            ),
          ],
        ),
      ),
    );
  }
}