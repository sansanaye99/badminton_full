import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/admin_provider.dart';
import '../widgets/news_tile.dart';

class NewsScreen extends ConsumerWidget {
  const NewsScreen({super.key});

  static const Color pink = Color(0xFFE87EA1);
  static const Color background = Color(0xFFFFFBFD);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newsAsync = ref.watch(newsProvider);

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text('All club news'),
      ),
      body: newsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: pink),
        ),
        error: (error, stack) {
          debugPrint('NEWS LOAD ERROR: $error');

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Failed to load club news\n$error',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        },
        data: (newsList) {
          if (newsList.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.newspaper_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'No active club news yet',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            color: pink,
            onRefresh: () async {
              ref.invalidate(newsProvider);
            },
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 12, bottom: 24),
              itemCount: newsList.length,
              itemBuilder: (context, index) {
                final news = newsList[index];

                return NewsTile(
                  news: news,
                  onTap: () {
                    context.go('/news/${news.id}');
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