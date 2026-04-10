import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:qflow/application/notification/notification_state.dart';
import 'package:qflow/domain/notification/notification_service.dart';

@injectable
class NotificationCubit extends Cubit<NotificationState> {
  final INotificationService _notificationService;

  NotificationCubit(this._notificationService)
      : super(NotificationState.initial());

  Future<void> getNotifications() async {
    emit(state.copyWith(isLoading: true, failureOrSuccessOption: none()));

    final result = await _notificationService.getNotifications();

    emit(result.fold(
      (f) => state.copyWith(
        isLoading: false,
        failureOrSuccessOption: some(left(f)),
      ),
      (notifications) => state.copyWith(
        isLoading: false,
        notifications: notifications,
        failureOrSuccessOption: none(),
      ),
    ));
  }
}
