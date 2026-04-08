import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/bicycles.dart';
import 'package:flutter_application_1/views/dashboard.dart';
import 'package:flutter_application_1/views/orders.dart';
import 'package:flutter_application_1/views/profile.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _page;
  Map<String, dynamic>? newRental;

  @override
  void initState() {
    super.initState();
    final arguments = Get.arguments;

    if (arguments is Map<String, dynamic>) {
      _page = arguments['initialIndex'] as int? ?? 0;
      newRental = arguments['newRental'] as Map<String, dynamic>?;
    } else {
      _page = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      const Dashboard(),
      const BicycleListScreen(),
      MyRentalsScreen(newRental: newRental),
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF5F9FC),
        title: const Text(
          'Ride Booking',
          style: TextStyle(
            color: Color(0xFF032540),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _page,
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFFE8F8FF),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.pedal_bike), label: 'Bikes'),
          NavigationDestination(icon: Icon(Icons.receipt_long), label: 'Rentals'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
        onDestinationSelected: (index) {
          setState(() {
            _page = index;
          });
        },
      ),
      body: pages[_page],
    );
  }
}
zy