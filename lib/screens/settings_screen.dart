import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const Color pink = Color(0xFFE87EA1);
  static const Color background = Color(0xFFFFFBFD);
  static const Color pinkLight = Color(0xFFFFD6E7);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: pinkLight,
                width: 1.4,
              ),
            ),
            child: const Row(
              children: [
                CircleAvatar(
                  backgroundColor: pinkLight,
                  child: Icon(
                    Icons.settings,
                    color: pink,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Settings page',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}