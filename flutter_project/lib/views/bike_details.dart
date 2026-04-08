import 'package:flutter/material.dart';
import 'package:flutter_application_1/configs/colors.dart';
import 'package:flutter_application_1/data/bike_data.dart';
import 'package:get/get.dart';

class BikeDetailsScreen extends StatelessWidget {
  const BikeDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bike = Get.arguments as BikeRental;

    return Scaffold(
      backgroundColor: appBackgroundColor,
      appBar: AppBar(
        title: Text(bike.name),
        backgroundColor: surfaceColor,
        foregroundColor: secondaryColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 240,
              width: double.infinity,
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(24),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.asset(bike.image, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bike.category,
                        style: const TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        bike.name,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: secondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              bike.description,
              style: const TextStyle(fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: bike.isAvailable
                    ? successSurfaceColor
                    : dangerSurfaceColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(
                    bike.isAvailable ? Icons.check_circle : Icons.schedule,
                    color: bike.isAvailable
                        ? successColor
                        : dangerColor,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      bike.isAvailable
                          ? '${bike.availableQuantity} of ${bike.totalQuantity} bike(s) available'
                          : 'This bike has already been booked. Please wait for about one hour.',
                      style: TextStyle(
                        color: bike.isAvailable
                            ? successColor
                            : dangerColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                _DetailChip(label: bike.location, icon: Icons.place_outlined),
                const SizedBox(width: 10),
                _DetailChip(label: bike.topSpeed, icon: Icons.speed),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _DetailChip(label: bike.range, icon: Icons.bolt_outlined),
                const SizedBox(width: 10),
                _DetailChip(
                  label: bike.isElectric ? 'Electric' : 'Manual',
                  icon: Icons.pedal_bike,
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Included features',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: secondaryColor,
              ),
            ),
            const SizedBox(height: 12),
            ...bike.features.map(
              (feature) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      size: 18,
                      color: primaryColor,
                    ),
                    const SizedBox(width: 8),
                    Text(feature),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 28),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'KSh ${bike.pricePerHour}/hour',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'KSh ${bike.pricePerDay}/day',
                          style: const TextStyle(color: mutedTextColor),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: bike.isAvailable
                        ? () => Get.toNamed('/booking', arguments: bike)
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: secondaryColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      bike.isAvailable ? 'Book now' : 'Booked out',
                      style: const TextStyle(color: inverseTextColor),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailChip extends StatelessWidget {
  const _DetailChip({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: primaryColor),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
