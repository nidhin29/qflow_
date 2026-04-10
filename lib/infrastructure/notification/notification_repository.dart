import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:qflow/domain/core/failures.dart';
import 'package:qflow/domain/notification/notification_model/notification_model.dart';
import 'package:qflow/domain/notification/notification_service.dart';

@LazySingleton(as: INotificationService)
class NotificationRepository implements INotificationService {
  final Dio _dio;

  NotificationRepository(this._dio);

  @override
  Future<Either<MainFailure, List<NotificationModel>>> getNotifications() async {
    try {
      final response = await _dio.get('/notifications/');

      if (response.statusCode == 200) {
        log(response.data.toString());
        final List<dynamic> data = response.data['data'] ?? [];
        final notifications = data
            .map((e) => NotificationModel.fromMap(e as Map<String, dynamic>))
            .toList();
        return right(notifications);
      } else {
        log(response.data.toString());
        return left(const MainFailure.serverFailure());
      }
    } catch (e) {
      log('NotificationRepository getNotifications Error: ${e.toString()}');
      return left(const MainFailure.clientFailure());
    }
  }
}
