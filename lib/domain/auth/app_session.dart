import 'dart:developer';

import 'package:injectable/injectable.dart';


@lazySingleton
class AppSession {
  String? accessToken;
  String? refreshToken;
  String? username;
  String? firstName;
  String? lastName;
  String? city;
  String? district;

  bool get isLoggedIn => accessToken != null;

  String? get fullName {
    if (firstName != null && lastName != null) {
      return '$firstName $lastName';
    }
    return firstName ?? lastName ?? username;
  }

  void saveTokens({required String access, required String refresh}) {
    accessToken = access;
    refreshToken = refresh;
  }

  void saveUsername({required String username}) {
    this.username = username;
    log('AppSession: Username saved: $username');
  }

  void saveProfileInfo({
    required String firstName,
    required String lastName,
  }) {
    this.firstName = firstName;
    this.lastName = lastName;
    log('AppSession: Profile info saved: $firstName $lastName');
  }

  void saveLocation({required String city, required String district}) {
    this.city = city;
    this.district = district;
    log('AppSession: Location saved: $city, $district');
  }

  void clear() {
    accessToken = null;
    refreshToken = null;
    username = null;
    firstName = null;
    lastName = null;
    city = null;
    district = null;
  }
}
