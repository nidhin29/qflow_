import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:qflow/application/appointment/appointment_state.dart';
import 'package:qflow/domain/appointment/appointment_model/appointment_model.dart';
import 'package:qflow/domain/appointment/appointment_service.dart';

@injectable
class AppointmentCubit extends Cubit<AppointmentState> {
  final IAppointmentService _appointmentService;

  AppointmentCubit(this._appointmentService) : super(AppointmentState.initial());

  Future<void> getUpcomingAppointments() async {
    emit(state.copyWith(isLoading: true, failureOrSuccessOption: none()));
    
    final failureOrSuccess = await _appointmentService.getUserAppointments(type: 'upcoming');
    
    emit(failureOrSuccess.fold(
      (f) => state.copyWith(
        isLoading: false,
        failureOrSuccessOption: some(left(f)),
      ),
      (list) => state.copyWith(
        isLoading: false,
        upcomingAppointments: list,
        failureOrSuccessOption: none(),
      ),
    ));
  }

  Future<void> getPastAppointments() async {
    emit(state.copyWith(isLoading: true, failureOrSuccessOption: none()));
    
    final failureOrSuccess = await _appointmentService.getUserAppointments(type: 'past');
    
    emit(failureOrSuccess.fold(
      (f) => state.copyWith(
        isLoading: false,
        failureOrSuccessOption: some(left(f)),
      ),
      (list) => state.copyWith(
        isLoading: false,
        pastAppointments: list,
        failureOrSuccessOption: none(),
      ),
    ));
  }

  Future<void> bookAppointment(AppointmentModel appointment) async {
    emit(state.copyWith(isLoading: true, failureOrSuccessOption: none()));
    
    final failureOrSuccess = await _appointmentService.bookAppointment(appointment: appointment);
    
    emit(state.copyWith(
      isLoading: false,
      failureOrSuccessOption: some(failureOrSuccess),
    ));

    // Refresh upcoming list on success
    if (failureOrSuccess.isRight()) {
      getUpcomingAppointments();
    }
  }
}
