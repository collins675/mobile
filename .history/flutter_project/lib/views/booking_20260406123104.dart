import 'package:flutter/material.dart';
import 'package:flutter_application_1/configs/colors.dart';
import 'package:flutter_application_1/data/bike_data.dart';
import 'package:get/get.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final List<String> pickupStations = const [
    'CBD Station Near Heri',
    'Lukenya mMotocross',
    'Daystar University',
  ];

  DateTime startDate = DateTime.now().add(const Duration(days: 1));
  DateTime endDate = DateTime.now().add(const Duration(days: 2));
  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay endTime = TimeOfDay.now().replacing(hour: (TimeOfDay.now().hour + 1) % 24);
  String selectedStation = 'CBD Station Near Heri';
  String rentalType = 'day'; // 'hour' or 'day'

  Future<void> _pickDate({required bool isStart}) async {
    final initialDate = isStart ? startDate : endDate;
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 60)),
    );

    if (picked == null) {
      return;
    }

    setState(() {
      if (isStart) {
        startDate = picked;
        if (rentalType == 'day' && !endDate.isAfter(startDate)) {
          endDate = startDate.add(const Duration(days: 1));
        } else if (rentalType == 'hour' && !_isEndTimeAfterStartTime(startTime, endTime, startDate, picked)) {
          endTime = startTime.replacing(hour: (startTime.hour + 1) % 24);
        }
      } else {
        if (rentalType == 'day') {
          endDate = picked.isAfter(startDate)
              ? picked
              : startDate.add(const Duration(days: 1));
        }
      }
    });
  }

  Future<void> _pickTime({required bool isStart}) async {
    final initialTime = isStart ? startTime : endTime;
    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (picked == null) {
      return;
    }

    setState(() {
      if (isStart) {
        startTime = picked;
        if (rentalType == 'hour' && !_isEndTimeAfterStartTime(picked, endTime, startDate, startDate)) {
          endTime = picked.replacing(hour: (picked.hour + 1) % 24);
        }
      } else {
        endTime = picked;
      }
    });
  }

  bool _isEndTimeAfterStartTime(TimeOfDay start, TimeOfDay end, DateTime startDate, DateTime endDate) {
    if (startDate.isBefore(endDate)) return true;
    if (startDate.isAfter(endDate)) return false;
    return end.hour > start.hour || (end.hour == start.hour && end.minute > start.minute);
  }

  String _formatDate(DateTime value) {
    return '${value.day}/${value.month}/${value.year}';
  }

  String _formatTime(TimeOfDay value) {
    final hour = value.hourOfPeriod == 0 ? 12 : value.hourOfPeriod;
    final period = value.period == DayPeriod.am ? 'AM' : 'PM';
    return '${hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')} $period';
  }

  String _formatApiDate(DateTime value) {
    final month = value.month.toString().padLeft(2, '0');
    final day = value.day.toString().padLeft(2, '0');
    return '${value.year}-$month-$day';
  }

  String _formatApiTime(TimeOfDay value) {
    return '${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}:00';
  }

  @override
  Widget build(BuildContext context) {
    final bike = Get.arguments as BikeRental;
    final durationDays = endDate.difference(startDate).inDays;
    final totalAmount = durationDays * bike.pricePerDay;

    return Scaffold(
      backgroundColor: appBackgroundColor,
      appBar: AppBar(
        title: const Text('Booking'),
        backgroundColor: surfaceColor,
        foregroundColor: secondaryColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        bike.image,
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            bike.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            bike.category,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'KSh ${bike.pricePerDay} per day',
                            style: const TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if (!bike.isAvailable)
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: dangerSurfaceColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    'This bike has already been booked. Please wait for about one hour or add more available bikes in the database.',
                    style: TextStyle(
                      color: dangerColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              const Text(
                'Pickup station',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                initialValue: selectedStation,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: surfaceColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: pickupStations
                    .map(
                      (station) => DropdownMenuItem(
                        value: station,
                        child: Text(station),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedStation = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _DateCard(
                      label: 'Start date',
                      value: _formatDate(startDate),
                      onTap: () => _pickDate(isStart: true),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _DateCard(
                      label: 'End date',
                      value: _formatDate(endDate),
                      onTap: () => _pickDate(isStart: false),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: secondaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Booking summary',
                      style: TextStyle(
                        color: inverseTextColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _SummaryRow(
                      label: 'Duration',
                      value: '$durationDays day(s)',
                    ),
                    _SummaryRow(label: 'Pickup', value: selectedStation),
                    _SummaryRow(
                      label: 'Total amount',
                      value: 'KSh $totalAmount',
                      highlight: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: bike.isAvailable
                      ? () {
                          Get.toNamed(
                            '/payment',
                            arguments: {
                              'bike': bike,
                              'pickupStation': selectedStation,
                              'startDateDisplay': _formatDate(startDate),
                              'endDateDisplay': _formatDate(endDate),
                              'startDate': _formatApiDate(startDate),
                              'endDate': _formatApiDate(endDate),
                              'durationDays': durationDays,
                              'totalAmount': totalAmount,
                            },
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text(
                    'Continue to payment',
                    style: TextStyle(color: inverseTextColor, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DateCard extends StatelessWidget {
  const _DateCard({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Ink(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(color: mutedTextColor, fontSize: 13),
            ),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: inverseMutedTextColor)),
          Text(
            value,
            style: TextStyle(
              color: inverseTextColor,
              fontWeight: highlight ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
