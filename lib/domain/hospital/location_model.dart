class LocationModel {
  final String city;
  final String district;

  const LocationModel({
    required this.city,
    required this.district,
  });

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      city: (map['city'] ?? '').toString(),
      district: (map['district'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'city': city,
      'district': district,
    };
  }

  @override
  String toString() => 'LocationModel(city: $city, district: $district)';
}
