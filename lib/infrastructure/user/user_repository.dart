
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:injectable/injectable.dart';
import 'package:qflow/domain/core/failures.dart';
import 'package:qflow/domain/user/user_service.dart';
import 'package:qflow/domain/user/user_model/user_model.dart';
import 'package:qflow/domain/auth/app_session.dart';
import 'package:qflow/infrastructure/core/api_utils.dart';

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
        final userData = data['user'] ?? data;
        final user = UserModel.fromMap(userData as Map<String, dynamic>);
        
        await _session.saveUsername(username: user.username);
        await _session.saveProfileInfo(
          userId: user.id ?? _session.userId ?? '',
          firstName: user.firstName,
          lastName: user.lastName,
        );
        
        if (user.city.isNotEmpty || user.district.isNotEmpty) {
          await _session.saveLocation(city: user.city, district: user.district);
        }
        
        return right(user);
      } else {
        return left(MainFailure.serverError(
            code: response.statusCode,
            message: (response.data is Map)
                ? response.data['message'] ?? 'Failed to fetch user'
                : 'Failed to fetch user'));
      }
    } on DioException catch (e) {
      return left(MainFailure.serverError(
          code: e.response?.statusCode,
          message: getErrorMessage(e, 'Failed to fetch profile')));
    } catch (e) {
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
        MapEntry('city', user.city),
        MapEntry('district', user.district),
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
        final data = response.data['data'] ?? response.data;
        final userData = data['user'] ?? data;
        
        final confirmedUsername = userData['username'] ?? user.username;
        final confirmedCity = userData['city'] ?? user.city;
        final confirmedDistrict = userData['district'] ?? user.district;
        final confirmedId = (userData['id'] ?? userData['id'] ?? _session.userId)?.toString();
        
        await _session.saveUsername(username: confirmedUsername);
        if (confirmedId != null) {
          await _session.saveProfileInfo(
            userId: confirmedId,
            firstName: userData['first_name'] ?? user.firstName,
            lastName: userData['last_name'] ?? user.lastName,
          );
        }
        await _session.saveLocation(city: confirmedCity, district: confirmedDistrict);
        
        return right(unit);
      } else {
        return left(MainFailure.serverError(
            code: response.statusCode,
            message: (response.data is Map)
                ? response.data['message'] ?? 'Registration failed'
                : 'Registration failed'));
      }
    } on DioException catch (e) {
      return left(MainFailure.serverError(
          code: e.response?.statusCode,
          message: getErrorMessage(e, 'Registration failed')));
    } catch (e) {
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
        MapEntry('age', user.age.toString()),
        MapEntry('weight', user.weight.toString()),
        MapEntry('height', user.height.toString()),
        MapEntry('gender', user.gender.toLowerCase()),
        MapEntry('blood_group', user.bloodGroup),
        MapEntry('contact_number', user.contactNumber),
        MapEntry('city', user.city),
        MapEntry('district', user.district),
        MapEntry('username', user.username),
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
        await _session.saveLocation(city: user.city, district: user.district);
        await _session.saveUsername(username: user.username);
        await _session.saveProfileInfo(
          userId: user.id ?? _session.userId ?? '',
          firstName: user.firstName,
          lastName: user.lastName,
        );
        return right(unit);
      } else {
        return left(MainFailure.serverError(
            code: response.statusCode,
            message: (response.data is Map)
                ? response.data['message'] ?? 'Update failed'
                : 'Update failed'));
      }
    } on DioException catch (e) {
      return left(MainFailure.serverError(
          code: e.response?.statusCode,
          message: getErrorMessage(e, 'Update failed')));
    } catch (e) {
      return left(const MainFailure.clientFailure());
    }
  }

  @override
  Future<Either<MainFailure, Unit>> updateFcmToken(String fcmToken) async {
    try {
      final response = await _dio.patch(
        '/users/update-fcm-token',
        data: {'fcmToken': fcmToken},
      );

      if (response.statusCode == 200) {
        return right(unit);
      } else {
        return left(MainFailure.serverError(
            code: response.statusCode,
            message: (response.data is Map)
                ? response.data['message'] ?? 'FCM update failed'
                : 'FCM update failed'));
      }
    } on DioException catch (e) {
      return left(MainFailure.serverError(
          code: e.response?.statusCode,
          message: getErrorMessage(e, 'Failed to update FCM token')));
    } catch (e) {
      return left(const MainFailure.clientFailure());
    }
  }
}
