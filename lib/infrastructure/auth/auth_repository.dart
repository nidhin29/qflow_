import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:qflow/domain/auth/app_session.dart';
import 'package:qflow/domain/auth/auth_service.dart';
import 'package:qflow/domain/auth/auth_success.dart';
import 'package:qflow/domain/core/failures.dart';
import 'package:google_sign_in/google_sign_in.dart';

@LazySingleton(as: IAuthService)
class AuthRepository implements IAuthService {
  final Dio _dio;
  final FlutterSecureStorage _storage;
  final AppSession _session;

  AuthRepository(this._dio, this._storage, this._session);

  @override
  Future<Either<MainFailure, AuthSuccess>> registerWithEmailAndPassword({
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
        return right(AuthSuccess.incomplete);
      } else {
        return left(const MainFailure.serverFailure());
      }
    } catch (e) {
      return left(const MainFailure.clientFailure());
    }
  }

  @override
  Future<Either<MainFailure, AuthSuccess>> signInWithEmailAndPassword({
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

      if (response.statusCode == 201 || response.statusCode == 200) {
        log('AuthRepository: Response data: ${response.data}');
        final data = response.data['data'];
        final access = data['accessToken'] ?? data['access_token'];
        final refresh = data['refreshToken'] ?? data['refresh_token'];
        final username = data['username'] ?? data['fullName'] ?? '';
        
        await _storage.write(key: 'access_token', value: access);
        await _storage.write(key: 'refresh_token', value: refresh);
        _session.saveTokens(access: access ?? '', refresh: refresh ?? '');
        _session.username = username;

        if (response.statusCode == 201) {
          return right(AuthSuccess.incomplete);
        } else {
          return right(AuthSuccess.complete);
        }
      } else {
        return left(const MainFailure.authFailure());
      }
    } catch (e) {
      return left(const MainFailure.clientFailure());
    }
  }

  @override
  Future<Either<MainFailure, AuthSuccess>> signInWithGoogle() async {
    try {
      final googleSignIn = GoogleSignIn(
        serverClientId:
            '796184189112-36k5b1r52phggfn5d7rpotmttvv2vhvm.apps.googleusercontent.com',
      );
      final googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        return left(const MainFailure.clientFailure());
      }

      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;
      final payload = {
        'tokenID': idToken,
        'email': googleUser.email,
        'fullName': googleUser.displayName ?? 'Google User',
      };

      final response = await _dio.post(
        '/users/google-login',
        data: payload,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        log('AuthRepository: Google Login Response: ${response.data}');
        final data = response.data['data'];
        final access = data['accessToken'] ?? data['access_token'];
        final refresh = data['refreshToken'] ?? data['refresh_token'];
        final username = data['username'] ?? data['fullName'] ?? '';

        await _storage.write(key: 'access_token', value: access);
        await _storage.write(key: 'refresh_token', value: refresh);
        _session.saveTokens(access: access ?? '', refresh: refresh ?? '');
        _session.username = username;

        if (response.statusCode == 201) {
          return right(AuthSuccess.incomplete);
        } else {
          return right(AuthSuccess.complete);
        }
      } else {
        return left(const MainFailure.authFailure());
      }
    } catch (e) {
      if (e is DioException) {}
      return left(const MainFailure.clientFailure());
    }
  }

  @override
  Future<Either<MainFailure, Unit>> sendOtp({required String email}) async {
    try {
      final response = await _dio.post(
        '/users/send-otp',
        data: {'email': email},
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
  Future<Either<MainFailure, Unit>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final response = await _dio.post(
        '/users/verify-otp',
        data: {'email': email, 'otp': otp},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        log('AuthRepository: Verify OTP Response: ${response.data}');
        final data = response.data['data'] ?? response.data;
        final access = data['accessToken'] ?? data['access_token'];
        final refresh = data['refreshToken'] ?? data['refresh_token'];
        final username = data['username'];

        if (access != null && refresh != null) {
          await _storage.write(key: 'access_token', value: access);
          await _storage.write(key: 'refresh_token', value: refresh);
          _session.saveTokens(access: access, refresh: refresh);
          if (username != null) _session.username = username;
          log('AuthRepository: Tokens saved successfully');
        } else {
          log('AuthRepository: No tokens found in response data');
        }

        return right(unit);
      } else {
        return left(const MainFailure.authFailure());
      }
    } catch (e) {
      return left(const MainFailure.clientFailure());
    }
  }

  @override
  Future<Either<MainFailure, Unit>> forgotPassword(
      {required String email}) async {
    try {
      final response = await _dio.post(
        '/users/forgot-password',
        data: {'email': email},
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
  Future<Either<MainFailure, Unit>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    try {
      final response = await _dio.post(
        '/users/reset-password',
        data: {
          'email': email,
          'otp': otp,
          'newPassword': newPassword,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return right(unit);
      } else {
        return left(const MainFailure.authFailure());
      }
    } catch (e) {
      return left(const MainFailure.clientFailure());
    }
  }

  @override
  Future<Either<MainFailure, Unit>> logout() async {
    try {
      // Attempt to notify server of logout
      await _dio.post('/users/logout');
    } catch (e) {
      log('AuthRepository: Logout API call failed, but clearing local session anyway: $e');
    } finally {
      // ALWAYS clear local session data regardless of API success/failure
      await _storage.delete(key: 'access_token');
      await _storage.delete(key: 'refresh_token');
      _session.clear();
    }
    return right(unit);
  }

  @override
  Future<Either<MainFailure, Unit>> refreshAccessToken() async {
    try {
      final refreshToUse =
          _session.refreshToken ?? await _storage.read(key: 'refresh_token');

      if (refreshToUse == null) {
        log('AuthRepository: No refresh token available');
        return left(const MainFailure.authFailure());
      }

      final response = await _dio.post(
        '/users/refresh-access-token',
        data: {'refreshToken': refreshToUse},
        options: Options(
          headers: {
            'skip_auth': true, // Prevent auth interceptor from causing loops
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        log('AuthRepository: Refresh response: ${response.data}');
        final data = response.data['data'] ?? response.data;
        final access = data['accessToken'] ?? data['access_token'];
        final refresh = data['refreshToken'] ?? data['refresh_token'];

        if (access != null && refresh != null) {
          await _storage.write(key: 'access_token', value: access);
          await _storage.write(key: 'refresh_token', value: refresh);
          _session.saveTokens(access: access, refresh: refresh);
          log('AuthRepository: Tokens refreshed successfully');
          return right(unit);
        }
      }
      return left(const MainFailure.authFailure());
    } catch (e) {
      log('AuthRepository Error during Refresh Token: ${e.toString()}');
      return left(const MainFailure.clientFailure());
    }
  }
}
