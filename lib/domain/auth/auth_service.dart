import 'package:dartz/dartz.dart';
import 'package:qflow/domain/core/failures.dart';

abstract class IAuthService {
  Future<Either<MainFailure, Unit>> registerWithEmailAndPassword({
    required String emailAddress,
    required String password,
    required String fullName,
  });

  Future<Either<MainFailure, Unit>> signInWithEmailAndPassword({
    required String emailAddress,
    required String password,
  });

  Future<Either<MainFailure, Unit>> signInWithGoogle();
  
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
