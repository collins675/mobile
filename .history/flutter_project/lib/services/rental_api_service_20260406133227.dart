import 'dart:convert';

import 'package:flutter_application_1/configs/api_config.dart';
import 'package:flutter_application_1/data/bicycle_type.dart';
import 'package:flutter_application_1/data/bike_data.dart';
import 'package:http/http.dart' as http;

class RentalApiService {
  static const Duration _requestTimeout = Duration(seconds: 15);

  static Uri _uri(String path, [Map<String, dynamic>? queryParameters]) {
    final baseUri = Uri.parse(ApiConfig.baseUrl);
    final normalizedBasePath = baseUri.path.endsWith('/')
        ? baseUri.path.substring(0, baseUri.path.length - 1)
        : baseUri.path;

    return baseUri.replace(
      path: '$normalizedBasePath/$path',
      queryParameters: queryParameters?.map(
        (key, value) => MapEntry(key, '$value'),
      ),
    );
  }

  static Future<Map<String, dynamic>> _getJson(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await http
          .get(
            _uri(path, queryParameters),
            headers: const {'Accept': 'application/json'},
          )
          .timeout(_requestTimeout);

      return _decodeResponse(response);
    } on FormatException {
      rethrow;
    } catch (error) {
      throw Exception(
        'Could not reach the server at ${ApiConfig.baseUrl}. $error',
      );
    }
  }

  static Future<Map<String, dynamic>> _postJson(
    String path, {
    required Map<String, String> body,
  }) async {
    try {
      final response = await http
          .post(
            _uri(path),
            headers: const {'Accept': 'application/json'},
            body: body,
          )
          .timeout(_requestTimeout);

      return _decodeResponse(response);
    } on FormatException {
      rethrow;
    } catch (error) {
      throw Exception(
        'Could not reach the server at ${ApiConfig.baseUrl}. $error',
      );
    }
  }

  static Map<String, dynamic> _decodeResponse(http.Response response) {
    final body = response.body.trim();

    if (body.isEmpty) {
      throw Exception('The server returned an empty response.');
    }

    dynamic decoded;
    try {
      decoded = jsonDecode(body);
    } on FormatException {
      final snippet = body.length > 180 ? '${body.substring(0, 180)}...' : body;
      throw Exception(
        'The server did not return valid JSON. Check your PHP API response: $snippet',
      );
    }

    if (decoded is! Map<String, dynamic>) {
      throw Exception('Unexpected server response format.');
    }

    if (response.statusCode != 200) {
      throw Exception(
        decoded['message']?.toString() ??
            'Request failed with status ${response.statusCode}.',
      );
    }

    return decoded;
  }

  static Future<Map<String, dynamic>> fetchDashboardData(int userId) async {
    final data = await _getJson(
      'dashboard.php',
      queryParameters: {'user_id': userId},
    );

    if (data['status'] != 'success') {
      throw Exception(data['message'] ?? 'Failed to load dashboard data');
    }

    final stats = Map<String, dynamic>.from(data['stats'] as Map);
    final types = (data['types'] as List<dynamic>)
        .map((item) => Map<String, dynamic>.from(item as Map))
        .toList();

    return {'stats': stats, 'types': types};
  }

  static Future<List<BikeRental>> fetchBikes() async {
    final data = await _getJson('bikes.php');

    if (data['status'] != 'success') {
      throw Exception(data['message'] ?? 'Failed to load bikes');
    }

    final bikes = (data['bikes'] as List<dynamic>)
        .map(
          (item) => BikeRental.fromJson(Map<String, dynamic>.from(item as Map)),
        )
        .toList();

    return bikes;
  }

  static Future<List<BicycleType>> fetchBicycleTypes() async {
    final data = await _getJson('bicycle_types.php');

    if (data['status'] != 'success') {
      throw Exception(data['message'] ?? 'Failed to load bicycle types');
    }

    return (data['types'] as List<dynamic>)
        .map(
          (item) =>
              BicycleType.fromJson(Map<String, dynamic>.from(item as Map)),
        )
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
    String? rentalType,
  }) async {
    final data = await _postJson(
      'create_rental.php',
      body: {
        'user_id': '$userId',
        'bike_id': '$bikeId',
        'pickup_station': pickupStation,
        'start_date': startDate,
        'end_date': endDate,
        'duration_days': '$durationDays',
        'total_amount': '$totalAmount',
        'mpesa_phone': mpesaPhone,
        'rental_type': rentalType ?? 'day',
      },
    );

    if (data['status'] != 'success') {
      throw Exception(data['message'] ?? 'Failed to create rental');
    }
  }

  static Future<List<Map<String, dynamic>>> fetchRentals(int userId) async {
    final data = await _getJson(
      'rentals.php',
      queryParameters: {'user_id': userId},
    );

    if (data['status'] != 'success') {
      throw Exception(data['message'] ?? 'Failed to load rentals');
    }

    return (data['rentals'] as List<dynamic>)
        .map((item) => Map<String, dynamic>.from(item as Map))
        .toList();
  }

  static Future<void> returnRental({
    required int rentalId,
    required int bikeId,
  }) async {
    final data = await _postJson(
      'return_rental.php',
      body: {'rental_id': '$rentalId', 'bike_id': '$bikeId'},
    );

    if (data['status'] != 'success') {
      throw Exception(data['message'] ?? 'Failed to return rental');
    }
  }

  static Future<Map<String, dynamic>> fetchProfile(int userId) async {
    final data = await _getJson(
      'profile.php',
      queryParameters: {'user_id': userId},
    );

    if (data['status'] != 'success') {
      throw Exception(data['message'] ?? 'Failed to load profile');
    }

    return (data['user'] as Map).cast<String, dynamic>();
  }
}
