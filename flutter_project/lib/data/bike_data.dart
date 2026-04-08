class BikeRental {
  const BikeRental({
    required this.id,
    required this.name,
    required this.category,
    required this.image,
    required this.location,
    required this.pricePerHour,
    required this.pricePerDay,
    required this.rating,
    required this.range,
    required this.topSpeed,
    required this.description,
    required this.features,
    required this.isElectric,
    required this.totalQuantity,
    required this.availableQuantity,
    required this.isAvailable,
  });

  final String id;
  final String name;
  final String category;
  final String image;
  final String location;
  final int pricePerHour;
  final int pricePerDay;
  final double rating;
  final String range;
  final String topSpeed;
  final String description;
  final List<String> features;
  final bool isElectric;
  final int totalQuantity;
  final int availableQuantity;
  final bool isAvailable;

  static int _toInt(dynamic value, [int fallback = 0]) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse('$value') ?? fallback;
  }

  static double _toDouble(dynamic value, [double fallback = 0]) {
    if (value is double) {
      return value;
    }
    if (value is num) {
      return value.toDouble();
    }
    return double.tryParse('$value') ?? fallback;
  }

  factory BikeRental.fromJson(Map<String, dynamic> json) {
    final availableQuantity = _toInt(json['available_quantity']);
    final totalQuantity = _toInt(json['total_quantity'], availableQuantity);

    return BikeRental(
      id: '${json['id']}',
      name: json['name'] as String? ?? 'Bike',
      category: json['category'] as String? ?? 'General',
      image: json['image'] as String? ?? 'assets/bike.png',
      location: json['location'] as String? ?? 'Main station',
      pricePerHour: _toInt(json['price_per_hour']),
      pricePerDay: _toInt(json['price_per_day']),
      rating: _toDouble(json['rating']),
      range: json['bike_range'] as String? ?? 'Flexible city range',
      topSpeed: json['top_speed'] as String? ?? 'Depends on route',
      description:
          json['description'] as String? ??
          'Comfortable bicycle available for daily rentals.',
      features:
          (json['features'] as List<dynamic>?)
              ?.map((item) => '$item')
              .toList() ??
          const ['Flexible pickup', 'Daily pricing'],
      isElectric: json['is_electric'] as bool? ?? false,
      totalQuantity: totalQuantity,
      availableQuantity: availableQuantity,
      isAvailable: json['is_available'] as bool? ?? availableQuantity > 0,
    );
  }
}
