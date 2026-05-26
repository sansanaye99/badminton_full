import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/booking.dart';
import 'firestore_provider.dart';

typedef TakenSlotsParams = ({String courtName, DateTime date});

final userBookingsProvider = FutureProvider<List<Booking>>((ref) async {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) return [];

  return ref.read(firestoreServiceProvider).getUserBookings(uid);
});

final takenSlotsProvider =
FutureProvider.family<List<String>, TakenSlotsParams>((ref, params) async {
  return ref.read(firestoreServiceProvider).getTakenSlots(
    params.courtName,
    params.date,
  );
});

class BookingNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<bool> createBooking(Booking booking) async {
    state = const AsyncLoading();

    final taken = await ref.read(firestoreServiceProvider).isSlotTaken(
      booking.courtName,
      booking.date,
      booking.timeSlot,
    );

    if (taken) {
      state = const AsyncData(null);
      ref.invalidate(takenSlotsProvider);
      return false;
    }

    final result = await AsyncValue.guard(
          () => ref.read(firestoreServiceProvider).createBooking(booking),
    );

    state = result;

    ref.invalidate(userBookingsProvider);
    ref.invalidate(takenSlotsProvider);

    return !result.hasError;
  }

  Future<void> cancelBooking(String id) async {
    state = const AsyncLoading();

    final result = await AsyncValue.guard(
          () => ref.read(firestoreServiceProvider).cancelBooking(id),
    );

    state = result;

    ref.invalidate(userBookingsProvider);
    ref.invalidate(takenSlotsProvider);
  }
}

final bookingNotifierProvider =
AsyncNotifierProvider<BookingNotifier, void>(BookingNotifier.new);