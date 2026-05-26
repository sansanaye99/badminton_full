import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        title: const Text('About'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 44,
              backgroundColor:
                  const Color(0xFFC9A84C).withOpacity(0.2),
              child: const Icon(Icons.person,
                  color: Color(0xFFC9A84C), size: 44),
            ),
            const SizedBox(height: 12),
            const Text('Your Name',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            const Text('Mobile Applications — TAMK 2026',
                style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 20),
            Card(
              color: const Color(0xFF0F3460),
              child: Column(children: [
                ListTile(
                  leading: const Icon(Icons.email_outlined,
                      color: Color(0xFFC9A84C)),
                  title: const Text('your.email@tuni.fi',
                      style: TextStyle(color: Colors.white)),
                ),
                ListTile(
                  leading: const Icon(Icons.school_outlined,
                      color: Color(0xFFC9A84C)),
                  title: const Text(
                      'Tampere University of Applied Sciences',
                      style: TextStyle(color: Colors.white)),
                ),
              ]),
            ),
            const SizedBox(height: 16),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('About this app',
                  style: TextStyle(
                      color: Color(0xFFC9A84C),
                      fontWeight: FontWeight.bold,
                      fontSize: 15)),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tampere Badminton Club is a mobile app for managing club '
              'tournaments, court bookings, player rankings, news, and '
              'club activities. Members can register, book courts, and '
              'participate in seasonal tournaments (Basic → Intermediate → Advanced).',
              style: TextStyle(
                  color: Color(0xFFAABBCC), height: 1.7, fontSize: 13),
            ),
            const SizedBox(height: 16),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Built with',
                  style: TextStyle(
                      color: Color(0xFFC9A84C),
                      fontWeight: FontWeight.bold,
                      fontSize: 15)),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ['Flutter', 'Firebase', 'Riverpod', 'go_router',
                'Firestore', 'Firebase Auth']
                  .map((t) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFC9A84C).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color:
                                  const Color(0xFFC9A84C).withOpacity(0.3)),
                        ),
                        child: Text(t,
                            style: const TextStyle(
                                color: Color(0xFFC9A84C), fontSize: 12)),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
