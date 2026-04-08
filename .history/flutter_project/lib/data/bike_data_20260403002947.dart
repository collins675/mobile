// class BikeRental {
//   const BikeRental({
//     required this.id,
//     required this.name,
//     required this.category,
//     required this.image,
//     required this.location,
//     required this.pricePerHour,
//     required this.pricePerDay,
//     required this.rating,
//     required this.range,
//     required this.topSpeed,
//     required this.description,
//     required this.features,
//     required this.isElectric,
//     required this.totalQuantity,
//     required this.availableQuantity,
//     required this.isAvailable,
//   });

//   final String id;
//   final String name;
//   final String category;
//   final String image;
//   final String location;
//   final int pricePerHour;
//   final int pricePerDay;
//   final double rating;
//   final String range;
//   final String topSpeed;
//   final String description;
//   final List<String> features;
//   final bool isElectric;
//   final int totalQuantity;
//   final int availableQuantity;
//   final bool isAvailable;

//   factory BikeRental.fromJson(Map<String, dynamic> json) {
//     return BikeRental(
//       id: '${json['id']}',
//       name: json['name'] as String,
//       category: json['category'] as String,
//       image: json['image'] as String,
//       location: json['location'] as String,
//       pricePerHour: json['price_per_hour'] as int,
//       pricePerDay: json['price_per_day'] as int,
//       rating: (json['rating'] as num).toDouble(),
//       range: json['bike_range'] as String,
//       topSpeed: json['top_speed'] as String,
//       description: json['description'] as String,
//       features: (json['features'] as List<dynamic>).cast<String>(),
//       isElectric: json['is_electric'] as bool,
//       totalQuantity: json['total_quantity'] as int? ?? 1,
//       availableQuantity: json['available_quantity'] as int? ?? 0,
//       isAvailable: json['is_available'] as bool? ?? false,
//     );
//   }
// }

// const List<BikeRental> bikeCatalog = [
//   BikeRental(
//     id: 'bk-101',
//     name: 'City Rider',
//     category: 'Urban',
//     image: 'assets/display1.png',
//     location: 'CBD Station',
//     pricePerHour: 250,
//     pricePerDay: 1800,
//     rating: 4.8,
//     range: '45 km',
//     topSpeed: '25 km/h',
//     description:
//         'A comfortable commuter bike for quick errands, campus rides, and daily movement around town.',
//     features: ['Helmet included', 'Phone holder', 'Front basket'],
//     isElectric: false,
//     totalQuantity: 1,
//     availableQuantity: 1,
//     isAvailable: true,
//   ),
//   BikeRental(
//     id: 'bk-102',
//     name: 'Swift Electric',
//     category: 'E-Bike',
//     image: 'assets/display2.png',
//     location: 'Westlands Hub',
//     pricePerHour: 400,
//     pricePerDay: 2800,
//     rating: 4.9,
//     range: '70 km',
//     topSpeed: '32 km/h',
//     description:
//         'A fast and smooth e-bike with assisted pedaling, perfect for longer trips and busy schedules.',
//     features: ['Battery included', 'USB charging', 'GPS tracker'],
//     isElectric: true,
//     totalQuantity: 1,
//     availableQuantity: 1,
//     isAvailable: true,
//   ),
//   BikeRental(
//     id: 'bk-103',
//     name: 'Trail Master',
//     category: 'Mountain',
//     image: 'assets/display1.png',
//     location: 'Karen Pickup Point',
//     pricePerHour: 350,
//     pricePerDay: 2400,
//     rating: 4.7,
//     range: '55 km',
//     topSpeed: '28 km/h',
//     description:
//         'Built for rough roads and adventure routes with wider tires and stronger suspension support.',
//     features: ['Shock absorber', 'Water bottle rack', 'Repair kit'],
//     isElectric: false,
//     totalQuantity: 1,
//     availableQuantity: 1,
//     isAvailable: true,
//   ),
// ];
