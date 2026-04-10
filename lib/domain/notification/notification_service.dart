import 'package:dartz/dartz.dart';
import 'package:qflow/domain/core/failures.dart';
import 'package:qflow/domain/notification/notification_model/notification_model.dart';

abstract class INotificationService {
  Future<Either<MainFailure, List<NotificationModel>>> getNotifications();
}
