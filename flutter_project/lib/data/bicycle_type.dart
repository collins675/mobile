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
      id: (json['id'] as num).toInt(),
      typeName: json['type_name'] as String? ?? 'general',
      displayName: json['display_name'] as String? ?? 'Bicycle',
      description:
          json['description'] as String? ?? 'Well-maintained bikes ready to ride.',
      availableCount: (json['available_count'] as num?)?.toInt() ?? 0,
    );
  }
}
