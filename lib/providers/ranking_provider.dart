import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/player.dart';
import 'firestore_provider.dart';

final rankingProvider = FutureProvider<List<Player>>((ref) async {
  return ref.read(firestoreServiceProvider).getRanking();
});

final playerDetailProvider =
    FutureProvider.family<Player?, String>((ref, id) async {
  return ref.read(firestoreServiceProvider).getPlayerById(id);
});

final isAdminProvider = FutureProvider<bool>((ref) async {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) return false;
  return ref.read(firestoreServiceProvider).isAdmin(uid);
});
