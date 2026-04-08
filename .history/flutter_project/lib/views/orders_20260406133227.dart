import 'package:flutter/material.dart';
import 'package:flutter_application_1/configs/colors.dart';
import 'package:flutter_application_1/configs/controllers/session_controller.dart';
import 'package:flutter_application_1/services/rental_api_service.dart';
import 'package:get/get.dart';

class MyRentalsScreen extends StatefulWidget {
  const MyRentalsScreen({super.key, this.newRental});

  final Map<String, dynamic>? newRental;

  @override
  State<MyRentalsScreen> createState() => _MyRentalsScreenState();
}

class _MyRentalsScreenState extends State<MyRentalsScreen> {
  late final int? userId;
  late Future<List<Map<String, dynamic>>> _rentalsFuture;

  @override
  void initState() {
    super.initState();
    final sessionController = Get.find<SessionController>();
    userId = sessionController.userId;
    _rentalsFuture = _loadRentals();
  }

  Future<List<Map<String, dynamic>>> _loadRentals() {
    if (userId == null) {
      return Future.value([]);
    }
    return RentalApiService.fetchRentals(userId!);
  }

  Future<void> _refreshRentals() async {
    if (userId == null) return;
    setState(() {
      _rentalsFuture = RentalApiService.fetchRentals(userId!);
    });
  }

  Future<void> _returnRental(int rentalId, int bikeId) async {
    try {
      await RentalApiService.returnRental(rentalId: rentalId, bikeId: bikeId);
      Get.snackbar(
        'Bike returned',
        'Your bike has been returned and is available again.',
        backgroundColor: successSurfaceColor,
      );
      await _refreshRentals();
    } catch (e) {
      Get.snackbar(
        'Return failed',
        e.toString().replaceFirst('Exception: ', ''),
        backgroundColor: dangerSurfaceColor,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (userId == null) {
      return const Scaffold(
        body: Center(child: Text('Please login to view your rentals.')),
      );
    }

    return Scaffold(
      backgroundColor: appBackgroundColor,
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _rentalsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  snapshot.error.toString().replaceFirst('Exception: ', ''),
                ),
              ),
            );
          }

          final rentals = snapshot.data ?? [];

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
            children: [
              const Text(
                'My Rentals',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: secondaryColor,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Track your current, upcoming, and completed bike bookings here.',
                style: TextStyle(color: mutedTextColor),
              ),
              const SizedBox(height: 18),
              if (rentals.isEmpty)
                const Text(
                  'No rentals yet. Book your first bike to see it here.',
                ),
              ...rentals.map(
                (rental) => Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              rental['bike_name'] as String,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          _StatusBadge(
                            status: rental['rental_status'] as String,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text('Pickup: ${rental['pickup_station']}'),
                      const SizedBox(height: 6),
                      Text(
                        'Dates: ${rental['start_date']} - ${rental['end_date']}',
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Duration: ${rental['duration_days']} ${rental['rental_type'] == 'hour' ? 'hour(s)' : 'day(s)'}',
                        style: const TextStyle(color: mutedTextColor),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Amount: KSh ${rental['total_amount']}',
                        style: const TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 14),
                      if ((rental['rental_status'] as String).toLowerCase() ==
                          'active')
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              final confirmed = await Get.dialog<bool>(
                                AlertDialog(
                                  title: const Text('Return bike'),
                                  content: const Text(
                                    'Are you sure you want to return this bike? This will make it available again.',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Get.back(result: false),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () => Get.back(result: true),
                                      child: const Text('Return'),
                                    ),
                                  ],
                                ),
                              );

                              if (confirmed == true) {
                                await _returnRental(
                                  rental['id'] as int,
                                  rental['bike_id'] as int,
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: successColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text('Return bike'),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final normalized = status.toLowerCase();
    final color = switch (normalized) {
      'active' => successColor,
      'upcoming' => warningColor,
      _ => const Color(0xFF607D8B),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withAlpha(31),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        status,
        style: TextStyle(color: color, fontWeight: FontWeight.w700),
      ),
    );
  }
}
