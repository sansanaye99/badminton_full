import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/news.dart';
import '../../providers/admin_provider.dart';
import '../../validators/form_validators.dart';

class AdminNewsScreen extends ConsumerWidget {
  const AdminNewsScreen({super.key});

  static const Color pink = Color(0xFFE87EA1);
  static const Color background = Color(0xFFFFFBFD);
  static const Color pinkLight = Color(0xFFFFD6E7);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newsAsync = ref.watch(newsProvider);

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text('Manage news'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: pink),
            onPressed: () => _showDialog(context, ref, null),
          ),
        ],
      ),
      body: newsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: pink),
        ),
        error: (_, __) => const Center(
          child: Text(
            'Failed to load',
            style: TextStyle(color: Colors.black87),
          ),
        ),
        data: (newsList) {
          if (newsList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.newspaper, size: 64, color: Colors.grey),
                  const SizedBox(height: 12),
                  const Text(
                    'No active news yet',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: () => _showDialog(context, ref, null),
                    icon: const Icon(Icons.add),
                    label: const Text('Add news'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: newsList.length,
            itemBuilder: (ctx, i) {
              final n = newsList[i];

              return Card(
                color: Colors.white,
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: pinkLight,
                    child: Icon(Icons.newspaper, color: pink, size: 18),
                  ),
                  title: Text(
                    n.title,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    n.category,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.edit_outlined,
                          color: Colors.blue,
                          size: 20,
                        ),
                        onPressed: () => _showDialog(context, ref, n),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.visibility_off_outlined,
                          color: Colors.orange,
                          size: 20,
                        ),
                        onPressed: () => _confirmHide(context, ref, n.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showDialog(BuildContext context, WidgetRef ref, News? existing) {
    final titleCtrl = TextEditingController(text: existing?.title ?? '');
    final contentCtrl = TextEditingController(text: existing?.content ?? '');
    final imageUrlCtrl = TextEditingController(text: existing?.imageUrl ?? '');

    String category = existing?.category ?? 'announcement';

    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            existing == null ? 'Add news' : 'Edit news',
            style: const TextStyle(
              color: pink,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: titleCtrl,
                    decoration: const InputDecoration(labelText: 'Title'),
                    validator: (v) =>
                        FormValidators.validateNotEmpty(v, 'Title'),
                  ),

                  const SizedBox(height: 10),

                  TextFormField(
                    controller: contentCtrl,
                    maxLines: 4,
                    decoration: const InputDecoration(labelText: 'Content'),
                    validator: (v) =>
                        FormValidators.validateNotEmpty(v, 'Content'),
                  ),

                  const SizedBox(height: 10),

                  TextFormField(
                    controller: imageUrlCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Image URL',
                      hintText: 'https://example.com/image.jpg',
                    ),
                  ),

                  const SizedBox(height: 10),

                  DropdownButtonFormField<String>(
                    value: category,
                    decoration: const InputDecoration(labelText: 'Category'),
                    items: ['announcement', 'result', 'event']
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (v) => setState(() => category = v!),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            FilledButton(
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;

                final news = News(
                  id: existing?.id ?? '',
                  title: titleCtrl.text.trim(),
                  content: contentCtrl.text.trim(),
                  category: category,
                  createdAt: existing?.createdAt ?? DateTime.now(),
                  imageUrl: imageUrlCtrl.text.trim(),
                  isActive: true,
                );

                if (existing == null) {
                  await ref.read(adminNotifierProvider.notifier).addNews(news);
                } else {
                  await ref
                      .read(adminNotifierProvider.notifier)
                      .updateNews(news);
                }

                if (ctx.mounted) Navigator.pop(ctx);
              },
              child: Text(existing == null ? 'Add' : 'Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmHide(BuildContext context, WidgetRef ref, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text(
          'Hide news?',
          style: TextStyle(color: Colors.black87),
        ),
        content: const Text(
          'This news will disappear from the main page and See all page.',
          style: TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.orange),
            onPressed: () async {
              await ref.read(adminNotifierProvider.notifier).hideNews(id);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Hide'),
          ),
        ],
      ),
    );
  }
}