import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/tournament_provider.dart';
import '../services/firestore_service.dart';
import '../validators/form_validators.dart';

class TournamentRegisterScreen extends ConsumerStatefulWidget {
  final String tournamentId;
  const TournamentRegisterScreen({super.key, required this.tournamentId});

  @override
  ConsumerState<TournamentRegisterScreen> createState() =>
      _TournamentRegisterScreenState();
}

class _TournamentRegisterScreenState
    extends ConsumerState<TournamentRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String _selectedLevel = 'basic';
  bool _isLoading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    setState(() => _isLoading = true);
    try {
      final alreadyRegistered = await FirestoreService()
          .isAlreadyRegistered(widget.tournamentId, uid);
      if (alreadyRegistered && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('You are already registered for this tournament'),
              backgroundColor: Colors.orange),
        );
        setState(() => _isLoading = false);
        return;
      }
      await FirestoreService()
          .registerForTournament(widget.tournamentId, uid, _selectedLevel);
      ref.invalidate(tournamentsProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Registered successfully!'),
              backgroundColor: Colors.green),
        );
        context.go('/tournaments');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      }
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final tournamentAsync =
        ref.watch(tournamentDetailProvider(widget.tournamentId));
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(title: const Text('Register for tournament')),
      body: tournamentAsync.when(
        loading: () => const Center(
            child: CircularProgressIndicator(color: Color(0xFFC9A84C))),
        error: (_, __) =>
            const Center(child: Text('Failed to load', style: TextStyle(color: Colors.white))),
        data: (t) {
          if (t == null) return const Center(child: Text('Not found'));
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tournament info card
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F3460),
                      borderRadius: BorderRadius.circular(12),
                      border: Border(
                        left: BorderSide(
                            color: const Color(0xFFC9A84C), width: 3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(t.name,
                            style: const TextStyle(
                                color: Color(0xFFC9A84C),
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(
                            '${t.location} · ${t.date.day}/${t.date.month}/${t.date.year}',
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 12)),
                        const SizedBox(height: 4),
                        const Text(
                            'Members only — one tournament at a time.',
                            style:
                                TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Name (read-only from account)
                  const Text('Your details',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                          fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F3460),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(children: [
                      const Icon(Icons.email_outlined,
                          color: Color(0xFFC9A84C), size: 18),
                      const SizedBox(width: 8),
                      Text(user?.email ?? '',
                          style: const TextStyle(color: Colors.white)),
                    ]),
                  ),
                  const SizedBox(height: 16),

                  // Level selection
                  const Text('Select your level',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                          fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  Row(children: [
                    Expanded(
                        child: _LevelCard(
                      label: 'Basic',
                      description: 'Beginner',
                      color: Colors.green,
                      isSelected: _selectedLevel == 'basic',
                      onTap: () => setState(() => _selectedLevel = 'basic'),
                    )),
                    const SizedBox(width: 8),
                    Expanded(
                        child: _LevelCard(
                      label: 'Intermediate',
                      description: 'Win basic first',
                      color: const Color(0xFFC9A84C),
                      isSelected: _selectedLevel == 'intermediate',
                      onTap: () =>
                          setState(() => _selectedLevel = 'intermediate'),
                    )),
                    const SizedBox(width: 8),
                    Expanded(
                        child: _LevelCard(
                      label: 'Advanced',
                      description: 'Win inter first',
                      color: Colors.red,
                      isSelected: _selectedLevel == 'advanced',
                      onTap: () =>
                          setState(() => _selectedLevel = 'advanced'),
                    )),
                  ]),
                  const SizedBox(height: 16),

                  // Rule info
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFC9A84C).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color:
                              const Color(0xFFC9A84C).withOpacity(0.3)),
                    ),
                    child: const Row(children: [
                      Icon(Icons.info_outline,
                          color: Color(0xFFC9A84C), size: 16),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'You can only participate in one tournament at a time. Win your current level to advance.',
                          style: TextStyle(
                              color: Color(0xFFC9A84C), fontSize: 12),
                        ),
                      ),
                    ]),
                  ),
                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FilledButton.icon(
                      onPressed: _isLoading ? null : _submit,
                      icon: _isLoading
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.black))
                          : const Icon(Icons.check),
                      label: const Text('Submit registration'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _LevelCard extends StatelessWidget {
  final String label;
  final String description;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _LevelCard({
    required this.label,
    required this.description,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.2) : const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: isSelected ? color : color.withOpacity(0.3),
              width: isSelected ? 2 : 1),
        ),
        child: Column(children: [
          Text(label,
              style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 12),
              textAlign: TextAlign.center),
          const SizedBox(height: 2),
          Text(description,
              style: const TextStyle(color: Colors.grey, fontSize: 10),
              textAlign: TextAlign.center),
        ]),
      ),
    );
  }
}
