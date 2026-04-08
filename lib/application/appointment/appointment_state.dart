import 'package:dartz/dartz.dart';
import 'package:qflow/domain/appointment/appointment_model/appointment_model.dart';
import 'package:qflow/domain/core/failures.dart';

class AppointmentState {
  final List<AppointmentModel> upcomingAppointments;
  final List<AppointmentModel> pastAppointments;
  final bool isLoading;
  final Option<Either<MainFailure, Unit>> failureOrSuccessOption;

  const AppointmentState({
    required this.upcomingAppointments,
    required this.pastAppointments,
    required this.isLoading,
    required this.failureOrSuccessOption,
  });

  factory AppointmentState.initial() => AppointmentState(
        upcomingAppointments: [],
        pastAppointments: [],
        isLoading: false,
        failureOrSuccessOption: none(),
      );

  AppointmentState copyWith({
    List<AppointmentModel>? upcomingAppointments,
    List<AppointmentModel>? pastAppointments,
    bool? isLoading,
    Option<Either<MainFailure, Unit>>? failureOrSuccessOption,
  }) {
    return AppointmentState(
      upcomingAppointments: upcomingAppointments ?? this.upcomingAppointments,
      pastAppointments: pastAppointments ?? this.pastAppointments,
      isLoading: isLoading ?? this.isLoading,
      failureOrSuccessOption:
          failureOrSuccessOption ?? this.failureOrSuccessOption,
    );
  }
}
