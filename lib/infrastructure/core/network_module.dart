
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

    dio.interceptors.add(LogInterceptor(
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
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

          options.headers['Authorization'] = 'Bearer $token';
        }

        return handler.next(options);
      },
      onError: (err, handler) async {
        // If 401 Unauthorized, try to refresh token
        if (err.response?.statusCode == 401 && !err.requestOptions.path.contains('/users/logout')) {
          try {
            // Use getIt to avoid circular dependency during Dio initialization
            final authService = getIt<IAuthService>();
            final result = await authService.refreshAccessToken();

            return await result.fold(
              (failure) async {

                await authService.logout();
                return handler.reject(err);
              },
              (success) async {


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

            return handler.reject(err);
          }
        }
        return handler.next(err);
      },
    ));

    return dio;
  }
}
