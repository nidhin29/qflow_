import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:qflow/domain/core/failures.dart';
import 'package:qflow/domain/user/user_service.dart';
import 'package:qflow/domain/user/user_model/user_model.dart';

@LazySingleton(as: IUserService)
class UserRepository implements IUserService {
  final Dio _dio;

  UserRepository(this._dio);

  @override
  Future<Either<MainFailure, UserModel>> getUserDetails() async {
    try {
      final response = await _dio.get('/users/get-user-details');

      if (response.statusCode == 200) {
        final data = response.data['data'];
        return right(UserModel.fromMap(data as Map<String, dynamic>));
      } else {
        return left(const MainFailure.serverFailure());
      }
    } catch (e) {
      return left(const MainFailure.clientFailure());
    }
  }

  @override
  Future<Either<MainFailure, Unit>> registerUserDetails({
    required UserModel user,
    required String profileImagePath,
  }) async {
    try {
      final formData = FormData.fromMap({
        ...user.toMap(),
        'profile_image': await MultipartFile.fromFile(profileImagePath),
      });

      final response = await _dio.post(
        '/users/register-user-details',
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return right(unit);
      } else {
        return left(const MainFailure.serverFailure());
      }
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
      final Map<String, dynamic> data = user.toMap();

      if (profileImagePath != null) {
        data['profile_image'] = await MultipartFile.fromFile(profileImagePath);
      }

      final formData = FormData.fromMap(data);

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
