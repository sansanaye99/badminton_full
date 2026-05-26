import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/tournament.dart';
import 'firestore_provider.dart';

final tournamentsProvider = FutureProvider<List<Tournament>>((ref) async {
  return ref.read(firestoreServiceProvider).getTournaments();
});

final tournamentDetailProvider =
    FutureProvider.family<Tournament?, String>((ref, id) async {
  return ref.read(firestoreServiceProvider).getTournamentById(id);
});
