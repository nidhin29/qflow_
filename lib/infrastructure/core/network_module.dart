import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:qflow/domain/auth/app_session.dart';
import 'package:qflow/domain/auth/auth_service.dart';
import 'package:qflow/domain/core/di/injection.dart';

@module
abstract class NetworkModule {
  @lazySingleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage();

  @lazySingleton
  Dio dio(AppSession session) {
    final dio = Dio(BaseOptions(
      baseUrl: 'https://backend.devforchange.com/api/v1',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ));

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Skip auth for specialized requests (login, register, refresh)
        if (options.headers.containsKey('skip_auth')) {
          options.headers.remove('skip_auth');
          return handler.next(options);
        }

        String? token = session.accessToken;

        if (token == null) {
          const storage = FlutterSecureStorage();
          token = await storage.read(key: 'access_token');
          if (token != null) {
            session.accessToken = token;
          }
        }

        if (token != null) {
          log('NetworkModule: Attaching Bearer token to request: ${options.path}');
          options.headers['Authorization'] = 'Bearer $token';
        }

        return handler.next(options);
      },
      onError: (err, handler) async {
        // If 401 Unauthorized, try to refresh token
        if (err.response?.statusCode == 401) {
          log('NetworkModule: 401 Unauthorized detected on ${err.requestOptions.path}. Attempting refresh...');

          try {
            // Use getIt to avoid circular dependency during Dio initialization
            final authService = getIt<IAuthService>();
            final result = await authService.refreshAccessToken();

            return await result.fold(
              (failure) async {
                log('NetworkModule: Refresh token failed or expired. Logging out.');
                await authService.logout();
                return handler.reject(err);
              },
              (success) async {
                log('NetworkModule: Token refreshed successfully. Retrying original request.');

                // Create new options with the fresh token
                final options = err.requestOptions;
                options.headers['Authorization'] =
                    'Bearer ${session.accessToken}';

                try {
                  // Retry the request
                  final response = await dio.fetch(options);
                  return handler.resolve(response);
                } catch (retryError) {
                  return handler.reject(err);
                }
              },
            );
          } catch (e) {
            log('NetworkModule: Exception during refresh flow: $e');
            return handler.reject(err);
          }
        }
        return handler.next(err);
      },
    ));

    return dio;
  }
}
