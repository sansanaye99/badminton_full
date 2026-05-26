  import 'package:flutter/material.dart';
  import 'package:flutter_riverpod/flutter_riverpod.dart';
  import '../../models/tournament.dart';
  import '../../providers/admin_provider.dart';
  import '../../providers/tournament_provider.dart';
  import '../../validators/form_validators.dart';

  class AdminTournamentsScreen extends ConsumerWidget {
    const AdminTournamentsScreen({super.key});

    static const Color pink = Color(0xFFE87EA1);
    static const Color mint = Color(0xFF5BC8AF);
    static const Color background = Color(0xFFFFFBFD);
    static const Color pinkLight = Color(0xFFFFD6E7);

    static const _locations = [
      'Kauppi Sports Center',
      'Tampere Tennis Center',
      'SportUni Kauppi',
      'Tesoma Sports Hall',
      'SportUni Hervanta',
    ];

    @override
    Widget build(BuildContext context, WidgetRef ref) {
      final async = ref.watch(tournamentsProvider);

      return Scaffold(
        backgroundColor: background,
        appBar: AppBar(
          title: const Text('Manage tournaments'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add, color: pink),
              onPressed: () => _showDialog(context, ref),
            ),
          ],
        ),
        body: async.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: pink),
          ),
          error: (_, __) => const Center(
            child: Text(
              'Failed to load',
              style: TextStyle(color: Colors.black87),
            ),
          ),
          data: (list) {
            if (list.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.emoji_events, size: 64, color: Colors.grey),
                    const SizedBox(height: 12),
                    const Text(
                      'No active tournaments yet',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      onPressed: () => _showDialog(context, ref),
                      icon: const Icon(Icons.add),
                      label: const Text('Add tournament'),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: list.length,
              itemBuilder: (ctx, i) {
                final t = list[i];

                return Card(
                  color: Colors.white,
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: pinkLight,
                      child: Icon(Icons.emoji_events, color: pink, size: 18),
                    ),
                    title: Text(
                      t.name,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      '${t.location} · ${t.date.day}/${t.date.month}/${t.date.year} · ${t.level}',
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.visibility_off_outlined,
                        color: Colors.orange,
                        size: 22,
                      ),
                      onPressed: () async {
                        await ref
                            .read(adminNotifierProvider.notifier)
                            .hideTournament(t.id);
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

    void _showDialog(BuildContext context, WidgetRef ref) {
      final nameCtrl = TextEditingController();
      final descCtrl = TextEditingController();
      final imageUrlCtrl = TextEditingController();

      String location = _locations.first;
      String level = 'basic';
      String season = 'summer';
      int maxPlayers = 16;
      DateTime date = DateTime.now().add(const Duration(days: 30));

      final formKey = GlobalKey<FormState>();

      showDialog(
        context: context,
        builder: (ctx) => StatefulBuilder(
          builder: (ctx, setState) => AlertDialog(
            backgroundColor: Colors.white,
            title: const Text(
              'Add tournament',
              style: TextStyle(color: pink, fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: nameCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Tournament name',
                      ),
                      validator: (v) => FormValidators.validateNotEmpty(v, 'Name'),
                    ),

                    const SizedBox(height: 10),

                    TextFormField(
                      controller: descCtrl,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                      ),
                      validator: (v) =>
                          FormValidators.validateNotEmpty(v, 'Description'),
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
                      value: location,
                      decoration: const InputDecoration(labelText: 'Location'),
                      items: _locations
                          .map(
                            (l) => DropdownMenuItem(
                          value: l,
                          child: Text(
                            l,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      )
                          .toList(),
                      onChanged: (v) => setState(() => location = v!),
                    ),

                    const SizedBox(height: 10),

                    DropdownButtonFormField<String>(
                      value: level,
                      decoration: const InputDecoration(labelText: 'Level'),
                      items: ['basic', 'intermediate', 'advanced']
                          .map((l) => DropdownMenuItem(value: l, child: Text(l)))
                          .toList(),
                      onChanged: (v) => setState(() => level = v!),
                    ),

                    const SizedBox(height: 10),

                    DropdownButtonFormField<String>(
                      value: season,
                      decoration: const InputDecoration(labelText: 'Season'),
                      items: ['summer', 'winter']
                          .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                          .toList(),
                      onChanged: (v) => setState(() => season = v!),
                    ),

                    const SizedBox(height: 10),

                    DropdownButtonFormField<int>(
                      value: maxPlayers,
                      decoration: const InputDecoration(labelText: 'Max players'),
                      items: [8, 16, 32]
                          .map(
                            (n) => DropdownMenuItem(
                          value: n,
                          child: Text('$n players'),
                        ),
                      )
                          .toList(),
                      onChanged: (v) => setState(() => maxPlayers = v!),
                    ),

                    const SizedBox(height: 10),

                    InkWell(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: ctx,
                          initialDate: date,
                          firstDate: DateTime.now(),
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
                          labelText: 'Tournament date',
                        ),
                        child: Text(
                          '${date.day}/${date.month}/${date.year}',
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

                  await ref.read(adminNotifierProvider.notifier).addTournament(
                    Tournament(
                      id: '',
                      name: nameCtrl.text.trim(),
                      description: descCtrl.text.trim(),
                      date: date,
                      location: location,
                      imageUrl: imageUrlCtrl.text.trim(),
                      maxPlayers: maxPlayers,
                      registeredPlayers: 0,
                      level: level,
                      season: season,
                      status: 'open',
                      isActive: true,
                    ),
                  );

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