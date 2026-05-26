import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/activity.dart';
import '../providers/admin_provider.dart';

class ActivitiesScreen extends ConsumerWidget {
  const ActivitiesScreen({super.key});

  static const Color pink = Color(0xFFE87EA1);
  static const Color mint = Color(0xFF5BC8AF);
  static const Color background = Color(0xFFFFFBFD);
  static const Color mintLight = Color(0xFFD6F0D6);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activitiesAsync = ref.watch(activitiesProvider);

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text('Club activities'),
      ),
      body: activitiesAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: pink),
        ),
        error: (error, stack) {
          debugPrint('ACTIVITIES LOAD ERROR: $error');

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Failed to load activities\n$error',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        },
        data: (activities) {
          if (activities.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.photo_library_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'No activities yet',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            color: pink,
            onRefresh: () async {
              ref.invalidate(activitiesProvider);
            },
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 12, bottom: 24),
              itemCount: activities.length,
              itemBuilder: (context, index) {
                final activity = activities[index];

                return ActivityTile(
                  activity: activity,
                  onTap: () {
                    context.push(
                      '/activities/${activity.id}',
                      extra: activity,
                    );
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

class ActivityTile extends StatelessWidget {
  final Activity activity;
  final VoidCallback onTap;

  const ActivityTile({
    super.key,
    required this.activity,
    required this.onTap,
  });

  static const Color pink = Color(0xFFE87EA1);
  static const Color mint = Color(0xFF5BC8AF);
  static const Color mintLight = Color(0xFFD6F0D6);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(
          color: Color(0xFFFFD6E7),
          width: 1,
        ),
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
                  width: 82,
                  height: 82,
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
                    const SizedBox(height: 5),
                    Text(
                      '${_formatDate(activity.date)} · ${activity.category}',
                      style: const TextStyle(
                        color: pink,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      activity.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      activity.location,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: pink,
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _emptyImage() {
    return Container(
      width: 82,
      height: 82,
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