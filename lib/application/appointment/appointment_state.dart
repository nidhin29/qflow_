import 'package:dartz/dartz.dart';
import 'package:qflow/domain/appointment/appointment_model/appointment_model.dart';
import 'package:qflow/domain/core/failures.dart';

class AppointmentState {
  final List<AppointmentModel> upcomingAppointments;
  final List<AppointmentModel> pastAppointments;
  final List<AppointmentModel> searchResults;
  final bool isLoading;
  final bool isSearching;
  final Option<Either<MainFailure, Unit>> failureOrSuccessOption;

  const AppointmentState({
    required this.upcomingAppointments,
    required this.pastAppointments,
    required this.searchResults,
    required this.isLoading,
    required this.isSearching,
    required this.failureOrSuccessOption,
  });

  factory AppointmentState.initial() => AppointmentState(
        upcomingAppointments: [],
        pastAppointments: [],
        searchResults: [],
        isLoading: false,
        isSearching: false,
        failureOrSuccessOption: none(),
      );

  AppointmentState copyWith({
    List<AppointmentModel>? upcomingAppointments,
    List<AppointmentModel>? pastAppointments,
    List<AppointmentModel>? searchResults,
    bool? isLoading,
    bool? isSearching,
    Option<Either<MainFailure, Unit>>? failureOrSuccessOption,
  }) {
    return AppointmentState(
      upcomingAppointments: upcomingAppointments ?? this.upcomingAppointments,
      pastAppointments: pastAppointments ?? this.pastAppointments,
      searchResults: searchResults ?? this.searchResults,
      isLoading: isLoading ?? this.isLoading,
      isSearching: isSearching ?? this.isSearching,
      failureOrSuccessOption:
          failureOrSuccessOption ?? this.failureOrSuccessOption,
    );
  }
}
