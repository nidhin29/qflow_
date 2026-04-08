import 'package:dartz/dartz.dart';
import 'package:qflow/domain/core/failures.dart';
import 'package:qflow/domain/user/user_model/user_model.dart';

abstract class IUserService {
  Future<Either<MainFailure, UserModel>> getUserDetails();

  Future<Either<MainFailure, Unit>> registerUserDetails({
    required UserModel user,
    required String profileImagePath,
  });

  Future<Either<MainFailure, Unit>> updateUserDetails({
    required UserModel user,
    String? profileImagePath,
  });
}
