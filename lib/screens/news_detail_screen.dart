// screens/news_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/admin_provider.dart';

class NewsDetailScreen extends ConsumerWidget {
  final String newsId;
  const NewsDetailScreen({super.key, required this.newsId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newsAsync = ref.watch(newsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(title: const Text('News')),
      body: newsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFFC9A84C))),
        error: (_, __) => const Center(child: Text('Failed to load', style: TextStyle(color: Colors.white))),
        data: (newsList) {
          final news = newsList.where((n) => n.id == newsId).firstOrNull;
          if (news == null) return const Center(child: Text('Not found', style: TextStyle(color: Colors.white)));
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 120,
                  color: const Color(0xFF0F3460),
                  child: const Center(
                    child: Icon(Icons.newspaper, color: Color(0xFFC9A84C), size: 48),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFC9A84C).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(news.category,
                            style: const TextStyle(color: Color(0xFFC9A84C), fontSize: 12)),
                      ),
                      const SizedBox(height: 10),
                      Text(news.title,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Text(
                        '${news.createdAt.day}/${news.createdAt.month}/${news.createdAt.year}',
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      const SizedBox(height: 16),
                      Text(news.content,
                          style: const TextStyle(
                              color: Color(0xFFAABBCC), fontSize: 14, height: 1.7)),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: () => context.go('/tournaments'),
                          icon: const Icon(Icons.emoji_events),
                          label: const Text('View tournaments'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
