import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/bicycle_type.dart';
import 'package:flutter_application_1/data/bike_data.dart';
import 'package:flutter_application_1/services/rental_api_service.dart';
import 'package:get/get.dart';

class BicycleListScreen extends StatelessWidget {
  const BicycleListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FC),
      body: FutureBuilder<List<dynamic>>(
        future: Future.wait<dynamic>([
          RentalApiService.fetchBikes(),
          RentalApiService.fetchBicycleTypes(),
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text('Failed to load bikes from the backend.'),
              ),
            );
          }

          final bikes = snapshot.data![0] as List<BikeRental>;
          final types = snapshot.data![1] as List<BicycleType>;

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
            children: [
              const Text(
                'Available Bikes',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF032540),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Choose a bike that matches your route, time, and budget.',
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 98,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: types.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final type = types[index];
                    return Container(
                      width: 180,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            type.displayName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF032540),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${type.availableCount} available',
                            style: const TextStyle(color: Color(0xFF02AEEE)),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            type.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 18),
              ...bikes.map(
                (bike) => GestureDetector(
                  onTap: () => Get.toNamed('/bike-details', arguments: bike),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: Image.asset(
                            bike.image,
                            height: 104,
                            width: 104,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      bike.name,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE8F8FF),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Text(
                                      bike.category,
                                      style: const TextStyle(
                                        color: Color(0xFF02AEEE),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.place_outlined,
                                    size: 18,
                                    color: Colors.black54,
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      bike.location,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                bike.isAvailable
                                    ? '${bike.availableQuantity} bike(s) available'
                                    : 'Already booked. Wait about one hour.',
                                style: TextStyle(
                                  color: bike.isAvailable
                                      ? const Color(0xFF0A7D3B)
                                      : Colors.redAccent,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'KSh ${bike.pricePerHour}/hr  |  KSh ${bike.pricePerDay}/day',
                                style: const TextStyle(
                                  color: Color(0xFF032540),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
