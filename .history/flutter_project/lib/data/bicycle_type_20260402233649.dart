class BicycleType {
  const BicycleType({
    required this.id,
    required this.typeName,
    required this.displayName,
    required this.description,
    required this.availableCount,
  });

  final int id;
  final String typeName;
  final String displayName;
  final String description;
  final int availableCount;

  factory BicycleType.fromJson(Map<String, dynamic> json) {
    return BicycleType(
      id: json['id'] as int,
      typeName: json['type_name'] as String,
      displayName: json['display_name'] as String,
      description: json['description'] as String,
      availableCount: json['available_count'] as int,
    );
  }
}
