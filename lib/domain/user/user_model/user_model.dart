import 'dart:convert';

class UserModel {
  final String? id;
  final String firstName;
  final String lastName;
  final String username;
  final int age;
  final double weight;
  final double height;
  final String gender;
  final String bloodGroup;
  final String contactNumber;
  final String city;
  final String district;
  final String? profileImageUrl;
  final String? thumbnailUrl;
  final String? fcmToken;

  const UserModel({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.age,
    required this.weight,
    required this.height,
    required this.gender,
    required this.bloodGroup,
    required this.contactNumber,
    required this.city,
    required this.district,
    this.profileImageUrl,
    this.thumbnailUrl,
    this.fcmToken,
  });

  @override
  String toString() {
    return 'UserModel(firstName: $firstName, lastName: $lastName, username: $username, age: $age, weight: $weight, height: $height, gender: $gender, bloodGroup: $bloodGroup, contactNumber: $contactNumber, city: $city, district: $district, profileImageUrl: $profileImageUrl, thumbnailUrl: $thumbnailUrl, fcmToken: $fcmToken)';
  }

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      id: (data['_id'] ?? data['id'])?.toString(),
      firstName: (data['first_name'] ?? data['firstName'] ?? '').toString(),
      lastName: (data['last_name'] ?? data['lastName'] ?? '').toString(),
      username: (data['username'] ?? '').toString(),
      age: data['age'] ?? 0,
      weight: (data['weight'] as num?)?.toDouble() ?? 0.0,
      height: (data['height'] as num?)?.toDouble() ?? 0.0,
      gender: (data['gender'] ?? '').toString(),
      bloodGroup: (data['blood_group'] ?? data['bloodGroup'] ?? '').toString(),
      contactNumber:
          (data['contact_number'] ?? data['contactNumber'] ?? '').toString(),
      city: (data['city'] ?? '').toString(),
      district: (data['district'] ?? '').toString(),
      profileImageUrl: data['profile_image'] ?? data['profileImageUrl'],
      thumbnailUrl: data['thumbnail_url'] ?? data['thumbnailUrl'],
      fcmToken: data['fcmToken'] ?? data['fcm_token'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'username': username,
      'age': age,
      'weight': weight,
      'height': height,
      'gender': gender,
      'blood_group': bloodGroup,
      'contact_number': contactNumber,
      'city': city,
      'district': district,
      'profile_image': profileImageUrl,
      'thumbnail_url': thumbnailUrl,
      'fcm_token': fcmToken,
    };
  }

  /// `dart:convert`
  factory UserModel.fromJson(String data) {
    return UserModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  String toJson() => json.encode(toMap());

  UserModel copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? username,
    int? age,
    double? weight,
    double? height,
    String? gender,
    String? bloodGroup,
    String? contactNumber,
    String? city,
    String? district,
    String? profileImageUrl,
    String? thumbnailUrl,
    String? fcmToken,
  }) {
    return UserModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      username: username ?? this.username,
      age: age ?? this.age,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      gender: gender ?? this.gender,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      contactNumber: contactNumber ?? this.contactNumber,
      city: city ?? this.city,
      district: district ?? this.district,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      fcmToken: fcmToken ?? this.fcmToken,
    );
  }
}
