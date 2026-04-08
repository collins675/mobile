import 'package:flutter_application_1/views/bicycles.dart';
import 'package:flutter_application_1/views/bike_details.dart';
import 'package:flutter_application_1/views/booking.dart';
import 'package:flutter_application_1/views/homescreen.dart';
import 'package:flutter_application_1/views/login.dart';
import 'package:flutter_application_1/views/payment.dart';
import 'package:flutter_application_1/views/signup.dart';
import 'package:flutter_application_1/views/dashboard.dart';
import 'package:get/get.dart';

var routes = [
  GetPage(name: "/", page: () => LoginScreen()),
  GetPage(name: "/login", page: () => LoginScreen()),
  GetPage(name: "/signup", page: () => SignupScreen()),
  GetPage(name: "/homescreen", page: () => HomeScreen()),
  GetPage(name: "/dashboard", page: () => Dashboard()),
  GetPage(name: "/bikes", page: () => const BicycleListScreen()),
  GetPage(name: "/bike-details", page: () => const BikeDetailsScreen()),
  GetPage(name: "/booking", page: () => const BookingScreen()),
  GetPage(name: "/payment", page: () => const PaymentScreen()),
];
