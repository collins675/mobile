import 'package:flutter/material.dart';
import 'package:flutter_application_1/configs/colors.dart';
import 'package:flutter_application_1/configs/controllers/session_controller.dart';
import 'package:flutter_application_1/data/bike_data.dart';
import 'package:flutter_application_1/services/rental_api_service.dart';
import 'package:get/get.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final sessionController = Get.find<SessionController>();
    final userId = sessionController.userId ?? 0;

    return Scaffold(
      backgroundColor: appBackgroundColor,
      body: FutureBuilder<Map<String, dynamic>>(
        future: RentalApiService.fetchDashboardData(userId),
        builder: (context, dashboardSnapshot) {
          if (dashboardSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (dashboardSnapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  dashboardSnapshot.error
                      .toString()
                      .replaceFirst('Exception: ', ''),
                ),
              ),
            );
          }

          final dashboardData = dashboardSnapshot.data!;
          final stats = Map<String, dynamic>.from(dashboardData['stats'] as Map);
          final types = (dashboardData['types'] as List<dynamic>)
              .map((item) => Map<String, dynamic>.from(item as Map))
              .toList();

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 28,
                    backgroundColor: secondaryColor,
                    child: Icon(Icons.person, color: inverseTextColor),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Welcome back',
                        style: TextStyle(color: mutedTextColor),
                      ),
                      Text(
                        sessionController.fullName,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: secondaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [secondaryColor, primaryColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ride anywhere, anytime',
                      style: TextStyle(
                        color: inverseTextColor,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${stats['available_types']} bicycle types and ${stats['available_bikes']} bikes are ready to book.',
                      style: const TextStyle(
                        color: inverseMutedTextColor,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 18),
                    ElevatedButton(
                      onPressed: () => Get.toNamed('/bikes'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: surfaceColor,
                        foregroundColor: secondaryColor,
                      ),
                      child: const Text('Browse bikes'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              const Text(
                'Quick stats',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: secondaryColor,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      title: 'Available',
                      value: '${stats['available_bikes']} bikes',
                      icon: Icons.pedal_bike,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      title: 'Booked trips',
                      value: '${stats['booked_trips']} trip(s)',
                      icon: Icons.route,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Available types',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: secondaryColor,
                ),
              ),
              const SizedBox(height: 12),
              ...types.map(
                (type) => Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: accentSurfaceColor,
                        child: Icon(
                          Icons.directions_bike,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              type['display_name'] as String,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: secondaryColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${type['available_count']} available',
                              style: const TextStyle(color: mutedTextColor),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Featured rides',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: secondaryColor,
                ),
              ),
              const SizedBox(height: 12),
              FutureBuilder<List<BikeRental>>(
                future: RentalApiService.fetchBikes(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (snapshot.hasError) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('Could not load featured bikes right now.'),
                    );
                  }

                  final bikes = snapshot.data ?? [];

                  return Column(
                    children: bikes.take(2).map((bike) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: surfaceColor,
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: Image.asset(
                                bike.image,
                                width: 90,
                                height: 90,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    bike.name,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(bike.location),
                                  const SizedBox(height: 8),
                                  Text(
                                    'KSh ${bike.pricePerHour}/hour',
                                    style: const TextStyle(
                                      color: primaryColor,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () => Get.toNamed(
                                '/bike-details',
                                arguments: bike,
                              ),
                              icon: const Icon(
                                Icons.arrow_forward_ios,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: primaryColor),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(color: mutedTextColor)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: secondaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
