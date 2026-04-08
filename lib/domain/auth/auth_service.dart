import 'package:dartz/dartz.dart';
import 'package:qflow/domain/auth/auth_success.dart';
import 'package:qflow/domain/core/failures.dart';

abstract class IAuthService {
  Future<Either<MainFailure, AuthSuccess>> registerWithEmailAndPassword({
    required String emailAddress,
    required String password,
    required String fullName,
  });

  Future<Either<MainFailure, AuthSuccess>> signInWithEmailAndPassword({
    required String emailAddress,
    required String password,
  });

  Future<Either<MainFailure, AuthSuccess>> signInWithGoogle();
  
  Future<Either<MainFailure, Unit>> sendOtp({required String email});
  
  Future<Either<MainFailure, Unit>> verifyOtp({
    required String email,
    required String otp,
  });
  
  Future<Either<MainFailure, Unit>> forgotPassword({required String email});
  
  Future<Either<MainFailure, Unit>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  });
  
  Future<Either<MainFailure, Unit>> logout();
  
  Future<Either<MainFailure, Unit>> refreshAccessToken();
}
