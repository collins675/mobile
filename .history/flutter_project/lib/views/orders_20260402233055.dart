import 'package:flutter/material.dart';
import 'package:flutter_application_1/configs/controllers/session_controller.dart';
import 'package:flutter_application_1/services/rental_api_service.dart';
import 'package:get/get.dart';

class MyRentalsScreen extends StatelessWidget {
  const MyRentalsScreen({super.key, this.newRental});

  final Map<String, dynamic>? newRental;

  @override
  Widget build(BuildContext context) {
    final sessionController = Get.find<SessionController>();
    final userId = sessionController.userId;

    if (userId == null) {
      return const Scaffold(
        body: Center(child: Text('Please login to view your rentals.')),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FC),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: RentalApiService.fetchRentals(userId),
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
                  color: Color(0xFF032540),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Track your current, upcoming, and completed bike bookings here.',
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 18),
              if (rentals.isEmpty)
                const Text('No rentals yet. Book your first bike to see it here.'),
              ...rentals.map(
                (rental) => Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
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
                      Text('Dates: ${rental['start_date']} - ${rental['end_date']}'),
                      const SizedBox(height: 6),
                      Text(
                        'Amount: KSh ${rental['total_amount']}',
                        style: const TextStyle(
                          color: Color(0xFF02AEEE),
                          fontWeight: FontWeight.w700,
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
      'active' => const Color(0xFF0A7D3B),
      'upcoming' => const Color(0xFFED8B00),
      _ => const Color(0xFF607D8B),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        status,
        style: TextStyle(color: color, fontWeight: FontWeight.w700),
      ),
    );
  }
}
