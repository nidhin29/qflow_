import 'dart:convert';

class UserModel {
  final String firstName;
  final String lastName;
  final String username;
  final int age;
  final double weight;
  final double height;
  final String gender;
  final String bloodGroup;
  final String contactNumber;
  final String? profileImageUrl;

  const UserModel({
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.age,
    required this.weight,
    required this.height,
    required this.gender,
    required this.bloodGroup,
    required this.contactNumber,
    this.profileImageUrl,
  });

  @override
  String toString() {
    return 'UserModel(firstName: $firstName, lastName: $lastName, username: $username, age: $age, weight: $weight, height: $height, gender: $gender, bloodGroup: $bloodGroup, contactNumber: $contactNumber, profileImageUrl: $profileImageUrl)';
  }

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      firstName: data['first_name'] ?? data['firstName'] ?? '',
      lastName: data['last_name'] ?? data['lastName'] ?? '',
      username: data['username'] ?? '',
      age: data['age'] ?? 0,
      weight: (data['weight'] as num?)?.toDouble() ?? 0.0,
      height: (data['height'] as num?)?.toDouble() ?? 0.0,
      gender: data['gender'] ?? '',
      bloodGroup: data['blood_group'] ?? data['bloodGroup'] ?? '',
      contactNumber: data['contact_number'] ?? data['contactNumber'] ?? '',
      profileImageUrl: data['profile_image'] ?? data['profileImageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'username': username,
      'age': age,
      'weight': weight,
      'height': height,
      'gender': gender,
      'blood_group': bloodGroup,
      'contact_number': contactNumber,
      'profile_image': profileImageUrl,
    };
  }

  /// `dart:convert`
  factory UserModel.fromJson(String data) {
    return UserModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  String toJson() => json.encode(toMap());

  UserModel copyWith({
    String? firstName,
    String? lastName,
    String? username,
    int? age,
    double? weight,
    double? height,
    String? gender,
    String? bloodGroup,
    String? contactNumber,
    String? profileImageUrl,
  }) {
    return UserModel(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      username: username ?? this.username,
      age: age ?? this.age,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      gender: gender ?? this.gender,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      contactNumber: contactNumber ?? this.contactNumber,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }
}
