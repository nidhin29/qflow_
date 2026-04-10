import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:qflow/domain/core/failures.dart';
import 'package:qflow/domain/notification/notification_model/notification_model.dart';

part 'notification_state.freezed.dart';

@freezed
class NotificationState with _$NotificationState {
  const factory NotificationState({
    required List<NotificationModel> notifications,
    required bool isLoading,
    required Option<Either<MainFailure, Unit>> failureOrSuccessOption,
  }) = _NotificationState;

  factory NotificationState.initial() => NotificationState(
        notifications: [],
        isLoading: false,
        failureOrSuccessOption: none(),
      );
}
