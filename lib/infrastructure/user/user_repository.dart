import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:injectable/injectable.dart';
import 'package:qflow/domain/core/failures.dart';
import 'package:qflow/domain/user/user_service.dart';
import 'package:qflow/domain/user/user_model/user_model.dart';
import 'package:qflow/domain/auth/app_session.dart';

@LazySingleton(as: IUserService)
class UserRepository implements IUserService {
  final Dio _dio;
  final AppSession _session;

  UserRepository(this._dio, this._session);

  @override
  Future<Either<MainFailure, UserModel>> getUserDetails() async {
    try {
      final response = await _dio.get('/users/get-user-details');

      if (response.statusCode == 200) {
        final data = response.data['data'] ?? response.data;
        log('UserRepository: User details response: $data');
        final userData = data['user'] ?? data;
        final user = UserModel.fromMap(userData as Map<String, dynamic>);
        _session.saveUsername(username: user.username);
        return right(user);
      } else {
        return left(const MainFailure.serverFailure());
      }
    } catch (e) {
      log(e.toString());
      return left(const MainFailure.clientFailure());
    }
  }

  @override
  Future<Either<MainFailure, Unit>> registerUserDetails({
    required UserModel user,
    String? profileImagePath,
  }) async {
    try {
      
      final formData = FormData();
      
      // Explicitly adding fields as strings to prevent multipart boundary issues
      formData.fields.addAll([
        MapEntry('first_name', user.firstName),
        MapEntry('last_name', user.lastName),
        MapEntry('username', user.username),
        MapEntry('age', user.age.toString()),
        MapEntry('weight', user.weight.toString()),
        MapEntry('height', user.height.toString()),
        MapEntry('gender', user.gender.toLowerCase()),
        MapEntry('blood_group', user.bloodGroup),
        MapEntry('contact_number', user.contactNumber),
      ]);

      if (profileImagePath != null && profileImagePath.isNotEmpty) {
        final ext = profileImagePath.split('.').last.toLowerCase();
        formData.files.add(MapEntry(
          'profile_image',
          await MultipartFile.fromFile(
            profileImagePath,
            filename: profileImagePath.split('/').last,
            contentType: MediaType('image', ext == 'png' ? 'png' : 'jpeg'),
          ),
        ));
       
      }


      final response = await _dio.post(
        '/users/register-user-details',
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        log('UserRepository: Registration response: ${response.data}');
        final data = response.data['data'] ?? response.data;
        final userData = data['user'] ?? data;
        final confirmedUsername = userData['username'] ?? user.username;
        _session.saveUsername(username: confirmedUsername);
        log('UserRepository: Session updated with confirmed username: $confirmedUsername');
        return right(unit);
      } else {
        return left(const MainFailure.serverFailure());
      }
    } catch (e) {
      log(e.toString());
      return left(const MainFailure.clientFailure());
    }
  }

  @override
  Future<Either<MainFailure, Unit>> updateUserDetails({
    required UserModel user,
    String? profileImagePath,
  }) async {
    try {
      final formData = FormData();
      
      formData.fields.addAll([
        MapEntry('first_name', user.firstName),
        MapEntry('last_name', user.lastName),
        MapEntry('username', user.username),
        MapEntry('age', user.age.toString()),
        MapEntry('weight', user.weight.toString()),
        MapEntry('height', user.height.toString()),
        MapEntry('gender', user.gender.toLowerCase()),
        MapEntry('blood_group', user.bloodGroup),
        MapEntry('contact_number', user.contactNumber),
      ]);

      if (profileImagePath != null && profileImagePath.isNotEmpty) {
        final ext = profileImagePath.split('.').last.toLowerCase();
        formData.files.add(MapEntry(
          'profile_image',
          await MultipartFile.fromFile(
            profileImagePath,
            filename: profileImagePath.split('/').last,
            contentType: MediaType('image', ext == 'png' ? 'png' : 'jpeg'),
          ),
        ));
      }

      final response = await _dio.put(
        '/users/update-user-details',
        data: formData,
      );

      if (response.statusCode == 200) {
        return right(unit);
      } else {
        return left(const MainFailure.serverFailure());
      }
    } catch (e) {
      return left(const MainFailure.clientFailure());
    }
  }
}
