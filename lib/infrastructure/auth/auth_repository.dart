import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:qflow/domain/auth/auth_service.dart';
import 'package:qflow/domain/core/failures.dart';
import 'package:google_sign_in/google_sign_in.dart';

@LazySingleton(as: IAuthService)
class AuthRepository implements IAuthService {
  final Dio _dio;

  AuthRepository(this._dio);

  @override
  Future<Either<MainFailure, Unit>> registerWithEmailAndPassword({
    required String emailAddress,
    required String password,
    required String fullName,
  }) async {
    try {
      final response = await _dio.post(
        '/users/register',
        data: {
          'email': emailAddress,
          'password': password,
          'fullName': fullName,
        },
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
  Future<Either<MainFailure, Unit>> signInWithEmailAndPassword({
    required String emailAddress,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/users/login',
        data: {
          'email': emailAddress,
          'password': password,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return right(unit);
      } else {
        return left(const MainFailure.authFailure());
      }
    } catch (e) {
      print(e);
      return left(const MainFailure.clientFailure());
    }
  }

  @override
  Future<Either<MainFailure, Unit>> signInWithGoogle() async {
    try {
      final googleSignIn = GoogleSignIn();
      final googleUser = await googleSignIn.signIn();

      if (googleUser == null) return left(const MainFailure.clientFailure());

      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;

      // 1. Send Google ID Token to backend to get Verify Token
      final verifyResponse = await _dio.post(
        '/users/google/verify-token', // Placeholder endpoint
        data: {'idToken': idToken, 'email': googleUser.email},
      );

      if (verifyResponse.statusCode != 200) {
        return left(const MainFailure.serverFailure());
      }

      final verifyToken = verifyResponse.data['verifyToken'];

      // 2. Send Verify Token to get final JWT
      final loginResponse = await _dio.post(
        '/users/google/login', // Placeholder endpoint
        data: {'verifyToken': verifyToken},
      );

      if (loginResponse.statusCode == 200) {
        return right(unit);
      } else {
        return left(const MainFailure.authFailure());
      }
    } catch (e) {
      return left(const MainFailure.clientFailure());
    }
  }
}
