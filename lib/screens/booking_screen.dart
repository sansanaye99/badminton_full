import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/booking.dart';
import '../providers/booking_provider.dart';
import '../widgets/booking_tile.dart';

class BookingScreen extends ConsumerStatefulWidget {
  const BookingScreen({super.key});

  @override
  ConsumerState<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends ConsumerState<BookingScreen> {
  String _selectedCourt = 'Kauppi Sports Center — Court 1';
  String? _selectedTimeSlot;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));

  static const Color pink = Color(0xFFE87EA1);
  static const Color pinkLight = Color(0xFFFFD6E7);
  static const Color mint = Color(0xFF5BC8AF);
  static const Color background = Color(0xFFFFFBFD);
  static const Color border = Color(0xFFF4C2D7);
  static const Color textDark = Color(0xFF333333);
  static const Color textGrey = Color(0xFF888888);

  final List<String> _courts = [
    'Kauppi Sports Center — Court 1',
    'Kauppi Sports Center — Court 2',
    'Kauppi Sports Center — Court 3',
    'Kauppi Sports Center — Court 4',
    'Tampere Tennis Center — Court 1',
    'Tampere Tennis Center — Court 2',
    'SportUni Kauppi — Court 1',
    'Tesoma Sports Hall — Court 1',
  ];

  final List<String> _timeSlots = [
    '08:00–09:00',
    '09:00–10:00',
    '10:00–11:00',
    '11:00–12:00',
    '13:00–14:00',
    '14:00–15:00',
    '15:00–16:00',
    '16:00–17:00',
    '18:00–19:00',
    '19:00–20:00',
  ];

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      builder: (ctx, child) {
        return Theme(
          data: Theme.of(ctx).copyWith(
            colorScheme: const ColorScheme.light(
              primary: pink,
              surface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked == null) return;

    setState(() {
      _selectedDate = picked;
      _selectedTimeSlot = null;
    });
  }

  Future<void> _createBooking() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please login first'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_selectedTimeSlot == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a time slot'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final bookingDateOnly = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
    );

    final booking = Booking(
      id: '${user.uid}_${DateTime.now().millisecondsSinceEpoch}',
      userId: user.uid,
      userName: user.email ?? 'User',
      courtName: _selectedCourt,
      date: bookingDateOnly,
      timeSlot: _selectedTimeSlot!,
      status: 'confirmed',
    );

    final success = await ref
        .read(bookingNotifierProvider.notifier)
        .createBooking(booking);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Court booked successfully'),
          backgroundColor: mint,
        ),
      );

      setState(() {
        _selectedTimeSlot = null;
      });

      ref.invalidate(userBookingsProvider);
      ref.invalidate(takenSlotsProvider);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This slot is already booked'),
          backgroundColor: Colors.red,
        ),
      );

      ref.invalidate(takenSlotsProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(bookingNotifierProvider).isLoading;
    final bookingsAsync = ref.watch(userBookingsProvider);

    final bookingDateOnly = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
    );

    final takenAsync = ref.watch(
      takenSlotsProvider(
        (
        courtName: _selectedCourt,
        date: bookingDateOnly,
        ),
      ),
    );

    return Container(
      color: background,
      child: RefreshIndicator(
        color: pink,
        onRefresh: () async {
          ref.invalidate(userBookingsProvider);
          ref.invalidate(takenSlotsProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Booking form
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'New booking',
                      style: TextStyle(
                        color: pink,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),

                    const SizedBox(height: 14),

                    DropdownButtonFormField<String>(
                      value: _selectedCourt,
                      decoration: const InputDecoration(
                        labelText: 'Select court',
                        prefixIcon: Icon(
                          Icons.sports_tennis,
                          color: pink,
                        ),
                      ),
                      items: _courts.map((court) {
                        return DropdownMenuItem(
                          value: court,
                          child: Text(
                            court,
                            style: const TextStyle(fontSize: 13),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value == null) return;

                        setState(() {
                          _selectedCourt = value;
                          _selectedTimeSlot = null;
                        });
                      },
                    ),

                    const SizedBox(height: 12),

                    InkWell(
                      onTap: _pickDate,
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Date',
                          prefixIcon: Icon(
                            Icons.calendar_month_outlined,
                            color: pink,
                          ),
                        ),
                        child: Text(
                          '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                          style: const TextStyle(color: textDark),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      'Select time slot',
                      style: TextStyle(
                        color: textGrey,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 10),

                    takenAsync.when(
                      loading: () => const Center(
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: CircularProgressIndicator(color: pink),
                        ),
                      ),
                      error: (error, stack) {
                        debugPrint('TAKEN SLOTS ERROR: $error');

                        return const Text(
                          'Could not check availability. Please try again.',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        );
                      },
                      data: (takenSlots) {
                        return _buildTimeSlots(takenSlots);
                      },
                    ),

                    const SizedBox(height: 18),

                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: FilledButton.icon(
                        onPressed: isLoading ? null : _createBooking,
                        style: FilledButton.styleFrom(
                          backgroundColor: pink,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: pink.withOpacity(0.45),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: isLoading
                            ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                            : const Icon(Icons.check),
                        label: const Text('Confirm booking'),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'My bookings',
                style: TextStyle(
                  color: pink,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 8),

              bookingsAsync.when(
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(color: pink),
                  ),
                ),
                error: (error, stack) {
                  debugPrint('USER BOOKINGS ERROR: $error');

                  return const Text(
                    'Failed to load bookings',
                    style: TextStyle(color: Colors.red),
                  );
                },
                data: (bookings) {
                  if (bookings.isEmpty) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: border),
                      ),
                      child: const Column(
                        children: [
                          Icon(
                            Icons.calendar_month_outlined,
                            size: 42,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 10),
                          Text(
                            'No bookings yet',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }

                  return Column(
                    children: bookings.map((booking) {
                      return BookingTile(booking: booking);
                    }).toList(),
                  );
                },
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeSlots(List<String> takenSlots) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _timeSlots.map((slot) {
        final isTaken = takenSlots.contains(slot);
        final isSelected = _selectedTimeSlot == slot;

        return GestureDetector(
          onTap: isTaken
              ? null
              : () {
            setState(() {
              _selectedTimeSlot = slot;
            });
          },
          child: Container(
            width: 92,
            padding: const EdgeInsets.symmetric(
              horizontal: 6,
              vertical: 9,
            ),
            decoration: BoxDecoration(
              color: isTaken
                  ? Colors.grey.shade200
                  : isSelected
                  ? pinkLight
                  : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isTaken
                    ? Colors.grey.shade400
                    : isSelected
                    ? pink
                    : border,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  slot,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isTaken
                        ? Colors.grey
                        : isSelected
                        ? pink
                        : textDark,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isTaken
                      ? 'Booked'
                      : isSelected
                      ? 'Selected'
                      : 'Free',
                  style: TextStyle(
                    color: isTaken
                        ? Colors.red
                        : isSelected
                        ? pink
                        : mint,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}