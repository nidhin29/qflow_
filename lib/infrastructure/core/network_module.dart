import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:qflow/domain/auth/app_session.dart';

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
        } else {
          log('NetworkModule: No token available for request: ${options.path}');
        }

        return handler.next(options);
      },
    ));

    return dio;
  }
}
