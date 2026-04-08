import 'package:flutter/material.dart';
import 'package:flutter_application_1/configs/colors.dart';
import 'package:flutter_application_1/configs/controllers/session_controller.dart';
import 'package:flutter_application_1/data/bike_data.dart';
import 'package:flutter_application_1/services/rental_api_service.dart';
import 'package:get/get.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final TextEditingController phoneController = TextEditingController(
    text: '07',
  );
  final SessionController sessionController = Get.find<SessionController>();

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final booking = Get.arguments as Map<String, dynamic>;
    final bike = booking['bike'] as BikeRental;

    return Scaffold(
      backgroundColor: appBackgroundColor,
      appBar: AppBar(
        title: const Text('M-Pesa Payment'),
        backgroundColor: surfaceColor,
        foregroundColor: secondaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: successSurfaceColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pay with M-Pesa',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: successColor,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Enter the phone number that will receive the STK push prompt.',
                    style: TextStyle(height: 1.4),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'M-Pesa phone number',
                hintText: '07XXXXXXXX',
                filled: true,
                fillColor: surfaceColor,
                prefixIcon: const Icon(Icons.phone_android),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Payment summary',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 14),
                  _PaymentRow(label: 'Bike', value: bike.name),
                  _PaymentRow(
                    label: 'Pickup station',
                    value: booking['pickupStation'] as String,
                  ),
                  _PaymentRow(
                    label: 'Rental dates',
                    value:
                        '${booking['startDateDisplay']} - ${booking['endDateDisplay']}',
                  ),
                  _PaymentRow(
                    label: 'Duration',
                    value: booking['rentalType'] == 'hour' 
                        ? '${booking['durationDays']} hour(s)' 
                        : '${booking['durationDays']} day(s)',
                  ),
                  _PaymentRow(
                    label: 'Amount',
                    value: 'KSh ${booking['totalAmount']}',
                    highlight: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (phoneController.text.trim().length < 10) {
                    Get.snackbar(
                      'Invalid number',
                      'Please enter a valid M-Pesa number.',
                      backgroundColor: dangerSurfaceColor,
                    );
                    return;
                  }

                  final userId = sessionController.userId;
                  if (userId == null) {
                    Get.snackbar(
                      'Session expired',
                      'Please login again.',
                      backgroundColor: dangerSurfaceColor,
                    );
                    return;
                  }

                  try {
                    await RentalApiService.createRental(
                      userId: userId,
                      bikeId: int.parse(bike.id),
                      pickupStation: booking['pickupStation'] as String,
                      startDate: booking['startDate'] as String,
                      endDate: booking['endDate'] as String,
                      durationDays: booking['durationDays'] as int,
                      totalAmount: booking['totalAmount'] as int,
                      mpesaPhone: phoneController.text.trim(),
                      rentalType: booking['rentalType'] as String? ?? 'day',
                    );

                    Get.snackbar(
                      'Payment successful',
                      'Rental saved and payment recorded.',
                      backgroundColor: successSurfaceColor,
                      duration: const Duration(seconds: 2),
                    );

                    Get.offAllNamed(
                      '/homescreen',
                      arguments: {'initialIndex': 2},
                    );
                  } catch (e) {
                    Get.snackbar(
                      'Payment failed',
                      e.toString().replaceFirst('Exception: ', ''),
                      backgroundColor: dangerSurfaceColor,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: successColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: const Text(
                  'Pay now',
                  style: TextStyle(color: inverseTextColor, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentRow extends StatelessWidget {
  const _PaymentRow({
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
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: const TextStyle(color: mutedTextColor)),
          ),
          Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontWeight: highlight ? FontWeight.bold : FontWeight.w500,
              color: highlight ? secondaryColor : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
