import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/news.dart';
import '../models/activity.dart';
import '../models/tournament.dart';
import 'firestore_provider.dart';
import 'tournament_provider.dart';

final newsProvider = FutureProvider<List<News>>((ref) async {
  return ref.read(firestoreServiceProvider).getNews();
});

final activitiesProvider = FutureProvider<List<Activity>>((ref) async {
  return ref.read(firestoreServiceProvider).getActivities();
});

class AdminNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  // ── News ─────────────────────────────────────────────

  Future<void> addNews(News news) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(
          () => ref.read(firestoreServiceProvider).addNews(news),
    );

    ref.invalidate(newsProvider);
  }

  Future<void> updateNews(News news) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(
          () => ref.read(firestoreServiceProvider).updateNews(news),
    );

    ref.invalidate(newsProvider);
  }

  // Real delete, only keep this if you still need permanent delete
  Future<void> deleteNews(String id) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(
          () => ref.read(firestoreServiceProvider).deleteNews(id),
    );

    ref.invalidate(newsProvider);
  }

  // New architecture: hide news instead of deleting
  Future<void> hideNews(String id) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(
          () => ref.read(firestoreServiceProvider).hideNews(id),
    );

    ref.invalidate(newsProvider);
  }

  // ── Activities ───────────────────────────────────────

  Future<void> addActivity(Activity activity) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(
          () => ref.read(firestoreServiceProvider).addActivity(activity),
    );

    ref.invalidate(activitiesProvider);
  }

  Future<void> deleteActivity(String id) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(
          () => ref.read(firestoreServiceProvider).deleteActivity(id),
    );

    ref.invalidate(activitiesProvider);
  }

  // ── Tournaments ─────────────────────────────────────

  Future<void> addTournament(Tournament tournament) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(
          () => ref.read(firestoreServiceProvider).addTournament(tournament),
    );

    ref.invalidate(tournamentsProvider);
  }

  // Real delete, only keep this if you still need permanent delete
  Future<void> deleteTournament(String id) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(
          () => ref.read(firestoreServiceProvider).deleteTournament(id),
    );

    ref.invalidate(tournamentsProvider);
  }

  // New architecture: hide tournament instead of deleting
  Future<void> hideTournament(String id) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(
          () => ref.read(firestoreServiceProvider).hideTournament(id),
    );

    ref.invalidate(tournamentsProvider);
  }
}

final adminNotifierProvider =
AsyncNotifierProvider<AdminNotifier, void>(AdminNotifier.new);