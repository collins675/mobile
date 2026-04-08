import 'package:flutter/material.dart';
import 'package:flutter_application_1/configs/colors.dart';
import 'package:flutter_application_1/data/bicycle_type.dart';
import 'package:flutter_application_1/data/bike_data.dart';
import 'package:flutter_application_1/services/rental_api_service.dart';
import 'package:get/get.dart';

class BicycleListScreen extends StatelessWidget {
  const BicycleListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBackgroundColor,
      body: SafeArea(
        child: FutureBuilder<List<dynamic>>(
          future: Future.wait<dynamic>([
            RentalApiService.fetchBikes(),
            RentalApiService.fetchBicycleTypes(),
          ]),
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
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            final bikes = snapshot.data![0] as List<BikeRental>;
            final types = snapshot.data![1] as List<BicycleType>;

            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
              children: [
                const Text(
                  'Available Bikes',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: secondaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Choose a bike that matches your route, time, and budget.',
                  style: TextStyle(color: mutedTextColor, height: 1.4),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  height: 150,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: types.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final type = types[index];
                      return _TypeCard(type: type);
                    },
                  ),
                ),
                const SizedBox(height: 22),
                ...bikes.map(
                  (bike) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _BikeCard(bike: bike),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _TypeCard extends StatelessWidget {
  const _TypeCard({required this.type});

  final BicycleType type;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 210,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12032540),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: accentSurfaceColor,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              '${type.availableCount} available',
              style: const TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            type.displayName,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: secondaryColor,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Text(
              type.description,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                color: mutedTextColor,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BikeCard extends StatelessWidget {
  const _BikeCard({required this.bike});

  final BikeRental bike;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.toNamed('/bike-details', arguments: bike),
      borderRadius: BorderRadius.circular(24),
      child: Ink(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(
              color: Color(0x10032540),
              blurRadius: 22,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isCompact = constraints.maxWidth < 360;

            if (isCompact) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _BikeImage(bike: bike, height: 180, width: double.infinity),
                  const SizedBox(height: 14),
                  _BikeInfo(bike: bike, compact: true),
                ],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _BikeImage(bike: bike, height: 150, width: 122),
                const SizedBox(width: 14),
                Expanded(child: _BikeInfo(bike: bike, compact: false)),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _BikeImage extends StatelessWidget {
  const _BikeImage({
    required this.bike,
    required this.height,
    required this.width,
  });

  final BikeRental bike;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Image.asset(
        bike.image,
        height: height,
        width: width,
        fit: BoxFit.cover,
      ),
    );
  }
}

class _BikeInfo extends StatelessWidget {
  const _BikeInfo({required this.bike, required this.compact});

  final BikeRental bike;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 10,
          runSpacing: 10,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: compact ? 260 : 190),
              child: Text(
                bike.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: secondaryColor,
                  height: 1.2,
                ),
              ),
            ),
            _CategoryChip(label: bike.category),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 2),
              child: Icon(
                Icons.place_outlined,
                size: 18,
                color: mutedTextColor,
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                bike.location,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: mutedTextColor, height: 1.35),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: bike.isAvailable ? successSurfaceColor : dangerSurfaceColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Icon(
                bike.isAvailable ? Icons.check_circle : Icons.schedule,
                size: 18,
                color: bike.isAvailable ? successColor : dangerColor,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  bike.isAvailable
                      ? '${bike.availableQuantity} bike(s) available'
                      : 'Already booked. Wait about one hour.',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: bike.isAvailable ? successColor : dangerColor,
                    fontWeight: FontWeight.w600,
                    height: 1.25,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            _PriceChip(label: 'Per hour', value: 'KSh ${bike.pricePerHour}'),
            _PriceChip(label: 'Per day', value: 'KSh ${bike.pricePerDay}'),
          ],
        ),
      ],
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: accentSurfaceColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: primaryColor,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _PriceChip extends StatelessWidget {
  const _PriceChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: appBackgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: mutedTextColor, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: secondaryColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
