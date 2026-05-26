import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/activity.dart';
import '../../providers/admin_provider.dart';
import '../../validators/form_validators.dart';

class AdminActivitiesScreen extends ConsumerWidget {
  const AdminActivitiesScreen({super.key});

  static const Color pink = Color(0xFFE87EA1);
  static const Color mint = Color(0xFF5BC8AF);
  static const Color background = Color(0xFFFFFBFD);
  static const Color mintLight = Color(0xFFD6F0D6);

  static const _locations = [
    'Kauppi Sports Center',
    'Tampere Tennis Center',
    'SportUni Kauppi',
    'Tesoma Sports Hall',
    'SportUni Hervanta',
  ];

  static const _categories = [
    'Tournament',
    'Training',
    'Friendly Match',
    'Club Event',
    'Junior Event',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(activitiesProvider);

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text('Manage activities'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: pink),
            onPressed: () => _showAddActivityDialog(context, ref),
          ),
        ],
      ),
      body: async.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: pink),
        ),

        error: (error, stack) {
          debugPrint('ACTIVITIES LOAD ERROR: $error');
          debugPrintStack(stackTrace: stack);

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Failed to load\n$error',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        },

        data: (activities) {
          if (activities.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.photo_library_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'No activities yet',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: () => _showAddActivityDialog(context, ref),
                    icon: const Icon(Icons.add),
                    label: const Text('Add activity'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: activities.length,
            itemBuilder: (ctx, index) {
              final activity = activities[index];

              return Card(
                color: Colors.white,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: activity.imageUrl.isNotEmpty
                        ? Image.network(
                      activity.imageUrl,
                      width: 58,
                      height: 58,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _emptyImage(),
                    )
                        : _emptyImage(),
                  ),
                  title: Text(
                    activity.title,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      '${_formatDate(activity.date)} · ${activity.category}\n${activity.location}\n${activity.description}',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.redAccent,
                      size: 22,
                    ),
                    onPressed: () async {
                      await ref
                          .read(adminNotifierProvider.notifier)
                          .deleteActivity(activity.id);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  static Widget _emptyImage() {
    return Container(
      width: 58,
      height: 58,
      color: mintLight,
      child: const Icon(
        Icons.image_outlined,
        color: mint,
        size: 26,
      ),
    );
  }

  static String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showAddActivityDialog(BuildContext context, WidgetRef ref) {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final imageUrlCtrl = TextEditingController();

    String location = _locations.first;
    String category = _categories.first;
    DateTime date = DateTime.now();

    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            'Add activity',
            style: TextStyle(
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
                    decoration: const InputDecoration(
                      labelText: 'Activity title',
                      hintText: 'Summer Badminton Tournament Completed',
                    ),
                    validator: (v) =>
                        FormValidators.validateNotEmpty(v, 'Title'),
                  ),

                  const SizedBox(height: 10),

                  TextFormField(
                    controller: descCtrl,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      hintText: 'Write what the club has done',
                    ),
                    validator: (v) =>
                        FormValidators.validateNotEmpty(v, 'Description'),
                  ),

                  const SizedBox(height: 10),

                  TextFormField(
                    controller: imageUrlCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Image URL',
                      hintText: 'https://example.com/photo.jpg',
                    ),
                  ),

                  const SizedBox(height: 10),

                  DropdownButtonFormField<String>(
                    value: location,
                    decoration: const InputDecoration(
                      labelText: 'Location',
                    ),
                    items: _locations
                        .map(
                          (item) => DropdownMenuItem(
                        value: item,
                        child: Text(
                          item,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    )
                        .toList(),
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() => location = value);
                    },
                  ),

                  const SizedBox(height: 10),

                  DropdownButtonFormField<String>(
                    value: category,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                    ),
                    items: _categories
                        .map(
                          (item) => DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      ),
                    )
                        .toList(),
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() => category = value);
                    },
                  ),

                  const SizedBox(height: 10),

                  InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: ctx,
                        initialDate: date,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now().add(
                          const Duration(days: 365),
                        ),
                      );

                      if (picked != null) {
                        setState(() => date = picked);
                      }
                    },
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Activity date',
                      ),
                      child: Text(
                        _formatDate(date),
                        style: const TextStyle(color: Colors.black87),
                      ),
                    ),
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

                final activity = Activity(
                  id: '',
                  title: titleCtrl.text.trim(),
                  description: descCtrl.text.trim(),
                  imageUrl: imageUrlCtrl.text.trim(),
                  location: location,
                  category: category,
                  date: date,
                  isActive: true,
                );

                await ref
                    .read(adminNotifierProvider.notifier)
                    .addActivity(activity);

                if (ctx.mounted) Navigator.pop(ctx);
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}