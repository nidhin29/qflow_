

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:qflow/domain/user/user_model/user_model.dart';

@lazySingleton
class AppSession {
  final FlutterSecureStorage _storage;

  AppSession(this._storage);

  String? accessToken;
  String? refreshToken;
  String? userId;
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

  String get displayLocation {
    if (city != null && city!.isNotEmpty) return city!;
    if (district != null && district!.isNotEmpty) return district!;
    return 'Chengannur';
  }

  UserModel? toUserModel() {
    if (userId == null) return null;
    return UserModel(
      id: userId,
      firstName: firstName ?? '',
      lastName: lastName ?? '',
      username: username ?? '',
      age: 0,
      weight: 0.0,
      height: 0.0,
      gender: '',
      bloodGroup: '',
      contactNumber: '',
      city: city ?? '',
      district: district ?? '',
    );
  }

  Future<void> initialize() async {
    accessToken = await _storage.read(key: 'access_token');
    refreshToken = await _storage.read(key: 'refresh_token');
    userId = await _storage.read(key: 'user_id');
    username = await _storage.read(key: 'username');
    firstName = await _storage.read(key: 'first_name');
    lastName = await _storage.read(key: 'last_name');
    city = await _storage.read(key: 'city');
    district = await _storage.read(key: 'district');
  }

  Future<void> saveTokens(
      {required String access, required String refresh}) async {
    accessToken = access;
    refreshToken = refresh;
    await _storage.write(key: 'access_token', value: access);
    await _storage.write(key: 'refresh_token', value: refresh);
  }

  Future<void> saveUsername({required String username}) async {
    this.username = username;
    await _storage.write(key: 'username', value: username);
  }

  Future<void> saveProfileInfo({
    required String userId,
    required String firstName,
    required String lastName,
  }) async {
    this.userId = userId;
    this.firstName = firstName;
    this.lastName = lastName;
    await _storage.write(key: 'user_id', value: userId);
    await _storage.write(key: 'first_name', value: firstName);
    await _storage.write(key: 'last_name', value: lastName);
  }

  Future<void> saveLocation({required String city, required String district}) async {
    this.city = city;
    this.district = district;
    await _storage.write(key: 'city', value: city);
    await _storage.write(key: 'district', value: district);
  }

  Future<void> clear() async {
    accessToken = null;
    refreshToken = null;
    userId = null;
    username = null;
    firstName = null;
    lastName = null;
    city = null;
    district = null;
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
    await _storage.delete(key: 'user_id');
    await _storage.delete(key: 'username');
    await _storage.delete(key: 'first_name');
    await _storage.delete(key: 'last_name');
    await _storage.delete(key: 'city');
    await _storage.delete(key: 'district');
  }
}
