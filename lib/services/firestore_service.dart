import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/tournament.dart';
import '../models/player.dart';
import '../models/booking.dart';
import '../models/news.dart';
import '../models/activity.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ── Tournaments ──────────────────────────────────────────────────────────────

  Future<List<Tournament>> getTournaments({
    int limit = 50,
    DocumentSnapshot? lastDoc,
  }) async {
    final snap = await _db.collection('tournaments').get();

    return snap.docs.map((doc) {
      return Tournament.fromJson({
        ...doc.data(),
        'id': doc.id,
      });
    }).toList();
  }

  Future<Tournament?> getTournamentById(String id) async {
    final doc = await _db.collection('tournaments').doc(id).get();

    if (!doc.exists || doc.data() == null) return null;

    return Tournament.fromJson({
      ...doc.data()!,
      'id': doc.id,
    });
  }

  Future<void> addTournament(Tournament tournament) async {
    final ref = _db.collection('tournaments').doc();

    await ref.set({
      ...tournament.toJson(),
      'id': ref.id,
      'isActive': true,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateTournament(Tournament tournament) async {
    await _db.collection('tournaments').doc(tournament.id).update({
      ...tournament.toJson(),
      'isActive': true,
    });
  }

  Future<void> deleteTournament(String id) async {
    await _db.collection('tournaments').doc(id).delete();
  }

  Future<void> hideTournament(String id) async {
    await _db.collection('tournaments').doc(id).update({
      'isActive': false,
    });
  }

  // ── Players / Ranking ────────────────────────────────────────────────────────

  Future<List<Player>> getRanking() async {
    final snap = await _db.collection('players').get();

    return snap.docs.map((doc) {
      return Player.fromJson({
        ...doc.data(),
        'id': doc.id,
      });
    }).toList();
  }

  Future<Player?> getPlayerById(String id) async {
    final doc = await _db.collection('players').doc(id).get();

    if (!doc.exists || doc.data() == null) return null;

    return Player.fromJson({
      ...doc.data()!,
      'id': doc.id,
    });
  }

  Future<bool> isAdmin(String uid) async {
    final doc = await _db.collection('players').doc(uid).get();

    if (!doc.exists || doc.data() == null) return false;

    return doc.data()?['role'] == 'admin';
  }

  // ── Bookings ─────────────────────────────────────────────────────────────────

  Future<bool> isSlotTaken(
      String courtName,
      DateTime date,
      String timeSlot,
      ) async {
    final snap = await _db
        .collection('bookings')
        .where('courtName', isEqualTo: courtName)
        .where('timeSlot', isEqualTo: timeSlot)
        .where('status', isEqualTo: 'confirmed')
        .get();

    return snap.docs.any((doc) {
      final data = doc.data();

      if (data['date'] == null || data['date'] is! Timestamp) {
        return false;
      }

      final bookingDate = (data['date'] as Timestamp).toDate();

      return bookingDate.year == date.year &&
          bookingDate.month == date.month &&
          bookingDate.day == date.day;
    });
  }

  Future<List<String>> getTakenSlots(
      String courtName,
      DateTime date,
      ) async {
    final snap = await _db
        .collection('bookings')
        .where('courtName', isEqualTo: courtName)
        .where('status', isEqualTo: 'confirmed')
        .get();

    return snap.docs
        .where((doc) {
      final data = doc.data();

      if (data['date'] == null || data['date'] is! Timestamp) {
        return false;
      }

      final bookingDate = (data['date'] as Timestamp).toDate();

      return bookingDate.year == date.year &&
          bookingDate.month == date.month &&
          bookingDate.day == date.day;
    })
        .map((doc) => doc.data()['timeSlot'] as String)
        .toList();
  }

  Future<void> createBooking(Booking booking) async {
    await _db.collection('bookings').doc(booking.id).set(
      booking.toJson(),
    );
  }

  Future<List<Booking>> getUserBookings(String userId) async {
    final snap = await _db
        .collection('bookings')
        .where('userId', isEqualTo: userId)
        .get();

    return snap.docs.map((doc) {
      return Booking.fromJson({
        ...doc.data(),
        'id': doc.id,
      });
    }).toList();
  }

  // This deletes the booking completely.
  // After delete, the same court/date/time slot becomes free again.
  Future<void> cancelBooking(String bookingId) async {
    await _db.collection('bookings').doc(bookingId).delete();
  }

  // ── News ─────────────────────────────────────────────────────────────────────

  Future<List<News>> getNews() async {
    final snap = await _db.collection('news').get();

    return snap.docs.map((doc) {
      return News.fromJson({
        ...doc.data(),
        'id': doc.id,
      });
    }).toList();
  }

  Future<void> addNews(News news) async {
    final ref = _db.collection('news').doc();

    await ref.set({
      ...news.toJson(),
      'id': ref.id,
      'isActive': true,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateNews(News news) async {
    await _db.collection('news').doc(news.id).update({
      ...news.toJson(),
      'isActive': true,
    });
  }

  Future<void> deleteNews(String id) async {
    await _db.collection('news').doc(id).delete();
  }

  Future<void> hideNews(String id) async {
    await _db.collection('news').doc(id).update({
      'isActive': false,
    });
  }

  // ── Activities ────────────────────────────────────────────────────────────────

  Future<List<Activity>> getActivities() async {
    final snap = await _db.collection('activities').get();

    return snap.docs.map((doc) {
      return Activity.fromJson({
        ...doc.data(),
        'id': doc.id,
      });
    }).toList();
  }

  Future<void> addActivity(Activity activity) async {
    final ref = _db.collection('activities').doc();

    await ref.set({
      ...activity.toJson(),
      'id': ref.id,
      'isActive': true,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateActivity(Activity activity) async {
    await _db.collection('activities').doc(activity.id).update(
      activity.toJson(),
    );
  }

  Future<void> deleteActivity(String id) async {
    await _db.collection('activities').doc(id).delete();
  }

  // ── Tournament registration ───────────────────────────────────────────────────

  Future<void> registerForTournament(
      String tournamentId,
      String userId,
      String level,
      ) async {
    await _db.collection('registrations').add({
      'tournamentId': tournamentId,
      'userId': userId,
      'level': level,
      'registeredAt': FieldValue.serverTimestamp(),
      'status': 'registered',
    });

    await _db.collection('tournaments').doc(tournamentId).update({
      'registeredPlayers': FieldValue.increment(1),
    });
  }

  Future<bool> isAlreadyRegistered(
      String tournamentId,
      String userId,
      ) async {
    final snap = await _db
        .collection('registrations')
        .where('tournamentId', isEqualTo: tournamentId)
        .where('userId', isEqualTo: userId)
        .get();

    return snap.docs.isNotEmpty;
  }
}