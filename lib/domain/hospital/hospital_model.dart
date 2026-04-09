import 'dart:convert';

class HospitalModel {
  final String id;
  final String name;
  final String city;
  final String district;
  final List<String> availableServices;
  final String? profileImageUrl;
  final String? thumbnailUrl;
  final String? receptionistName;
  final String? receptionistContactNumber;
  final String? receptionistImageUrl;

  const HospitalModel({
    required this.id,
    required this.name,
    required this.city,
    required this.district,
    required this.availableServices,
    this.profileImageUrl,
    this.thumbnailUrl,
    this.receptionistName,
    this.receptionistContactNumber,
    this.receptionistImageUrl,
  });

  factory HospitalModel.fromMap(Map<String, dynamic> map) {
    return HospitalModel(
      id: (map['_id'] ?? map['id'] ?? '').toString(),
      name: (map['name'] ?? '').toString(),
      city: (map['city'] ?? '').toString(),
      district: (map['district'] ?? '').toString(),
      availableServices: List<String>.from(map['available_services'] ?? []),
      profileImageUrl:
          (map['profile_image'] ?? map['profileImageUrl'])?.toString(),
      thumbnailUrl: (map['thumbnail_url'] ?? map['thumbnailUrl'])?.toString(),
      receptionistName:
          (map['receptionist_name'] ?? map['receptionistName'])?.toString(),
      receptionistContactNumber: (map['receptionist_contact_number'] ??
              map['receptionistContactNumber'])
          ?.toString(),
      receptionistImageUrl:
          (map['receptionist_image'] ?? map['receptionistImageUrl'])?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'city': city,
      'district': district,
      'available_services': availableServices,
      'profile_image': profileImageUrl,
      'thumbnail_url': thumbnailUrl,
      'receptionist_name': receptionistName,
      'receptionist_contact_number': receptionistContactNumber,
      'receptionist_image': receptionistImageUrl,
    };
  }

  String toJson() => json.encode(toMap());

  factory HospitalModel.fromJson(String source) =>
      HospitalModel.fromMap(json.decode(source) as Map<String, dynamic>);

  HospitalModel copyWith({
    String? id,
    String? name,
    String? city,
    String? district,
    List<String>? availableServices,
    String? profileImageUrl,
    String? thumbnailUrl,
    String? receptionistName,
    String? receptionistContactNumber,
    String? receptionistImageUrl,
  }) {
    return HospitalModel(
      id: id ?? this.id,
      name: name ?? this.name,
      city: city ?? this.city,
      district: district ?? this.district,
      availableServices: availableServices ?? this.availableServices,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      receptionistName: receptionistName ?? this.receptionistName,
      receptionistContactNumber:
          receptionistContactNumber ?? this.receptionistContactNumber,
      receptionistImageUrl: receptionistImageUrl ?? this.receptionistImageUrl,
    );
  }

  @override
  String toString() {
    return 'HospitalModel(id: $id, name: $name, city: $city, district: $district, availableServices: $availableServices, profileImageUrl: $profileImageUrl, thumbnailUrl: $thumbnailUrl, receptionistName: $receptionistName, receptionistContactNumber: $receptionistContactNumber, receptionistImageUrl: $receptionistImageUrl)';
  }
}
