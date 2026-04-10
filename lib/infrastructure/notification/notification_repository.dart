
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:qflow/domain/core/failures.dart';
import 'package:qflow/domain/notification/notification_model/notification_model.dart';
import 'package:qflow/domain/notification/notification_service.dart';
import 'package:qflow/infrastructure/core/api_utils.dart';

@LazySingleton(as: INotificationService)
class NotificationRepository implements INotificationService {
  final Dio _dio;

  NotificationRepository(this._dio);

  @override
  Future<Either<MainFailure, List<NotificationModel>>> getNotifications() async {
    try {
      final response = await _dio.get('/notifications/');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        final notifications = data
            .map((e) => NotificationModel.fromMap(e as Map<String, dynamic>))
            .toList();
        return right(notifications);
      } else {
        return left(MainFailure.serverError(
            code: response.statusCode,
            message: (response.data is Map)
                ? response.data['message'] ?? 'Failed to fetch notifications'
                : 'Failed to fetch notifications'));
      }
    } on DioException catch (e) {
      return left(MainFailure.serverError(
          code: e.response?.statusCode,
          message: getErrorMessage(e, 'Failed to load notifications')));
    } catch (e) {
      return left(const MainFailure.clientFailure());
    }
  }
}
