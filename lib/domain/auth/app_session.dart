import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AppSession {
  final FlutterSecureStorage _storage;

  AppSession(this._storage);

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

  Future<void> initialize() async {
    accessToken = await _storage.read(key: 'access_token');
    refreshToken = await _storage.read(key: 'refresh_token');
    log('AppSession: Initialized with tokens. LoggedIn: $isLoggedIn');
  }

  Future<void> saveTokens({required String access, required String refresh}) async {
    accessToken = access;
    refreshToken = refresh;
    await _storage.write(key: 'access_token', value: access);
    await _storage.write(key: 'refresh_token', value: refresh);
    log('AppSession: Tokens persisted to secure storage');
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

  Future<void> clear() async {
    accessToken = null;
    refreshToken = null;
    username = null;
    firstName = null;
    lastName = null;
    city = null;
    district = null;
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
    log('AppSession: Session cleared and tokens deleted');
  }
}
