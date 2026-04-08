import 'dart:convert';

import 'package:flutter_application_1/configs/api_config.dart';
import 'package:flutter_application_1/data/bicycle_type.dart';
import 'package:flutter_application_1/data/bike_data.dart';
import 'package:http/http.dart' as http;

class RentalApiService {
  static Future<Map<String, dynamic>> fetchDashboardData(int userId) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/dashboard.php?user_id=$userId'),
    );
    final data = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode != 200 || data['status'] != 'success') {
      throw Exception(data['message'] ?? 'Failed to load dashboard data');
    }

    final stats = Map<String, dynamic>.from(data['stats'] as Map);
    final types = (data['types'] as List<dynamic>)
        .map((item) => Map<String, dynamic>.from(item as Map))
        .toList();

    return {
      'stats': stats,
      'types': types,
    };
  }

  static Future<List<BikeRental>> fetchBikes() async {
    final response = await http.get(Uri.parse('${ApiConfig.baseUrl}/bikes.php'));
    final data = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode != 200 || data['status'] != 'success') {
      throw Exception(data['message'] ?? 'Failed to load bikes');
    }

    final bikes = (data['bikes'] as List<dynamic>)
        .map((item) => BikeRental.fromJson(Map<String, dynamic>.from(item as Map)))
        .toList();

    return bikes;
  }

  static Future<List<BicycleType>> fetchBicycleTypes() async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/bicycle_types.php'),
    );
    final data = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode != 200 || data['status'] != 'success') {
      throw Exception(data['message'] ?? 'Failed to load bicycle types');
    }

    return (data['types'] as List<dynamic>)
        .map((item) => BicycleType.fromJson(Map<String, dynamic>.from(item as Map)))
        .toList();
  }

  static Future<void> createRental({
    required int userId,
    required int bikeId,
    required String pickupStation,
    required String startDate,
    required String endDate,
    required int durationDays,
    required int totalAmount,
    required String mpesaPhone,
  }) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/create_rental.php'),
      body: {
        'user_id': '$userId',
        'bike_id': '$bikeId',
        'pickup_station': pickupStation,
        'start_date': startDate,
        'end_date': endDate,
        'duration_days': '$durationDays',
        'total_amount': '$totalAmount',
        'mpesa_phone': mpesaPhone,
      },
    );

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode != 200 || data['status'] != 'success') {
      throw Exception(data['message'] ?? 'Failed to create rental');
    }
  }

  static Future<List<Map<String, dynamic>>> fetchRentals(int userId) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/rentals.php?user_id=$userId'),
    );
    final data = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode != 200 || data['status'] != 'success') {
      throw Exception(data['message'] ?? 'Failed to load rentals');
    }

    return (data['rentals'] as List<dynamic>)
        .map((item) => Map<String, dynamic>.from(item as Map))
        .toList();
  }

  static Future<Map<String, dynamic>> fetchProfile(int userId) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/profile.php?user_id=$userId'),
    );
    final data = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode != 200 || data['status'] != 'success') {
      throw Exception(data['message'] ?? 'Failed to load profile');
    }

    return (data['user'] as Map).cast<String, dynamic>();
  }
}
