import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:qflow/application/appointment/appointment_state.dart';
import 'package:qflow/domain/appointment/appointment_model/appointment_model.dart';
import 'package:qflow/domain/appointment/appointment_service.dart';
import 'package:qflow/infrastructure/core/socket_service.dart';

@injectable
class AppointmentCubit extends Cubit<AppointmentState> {
  final IAppointmentService _appointmentService;
  final SocketService _socketService;
  StreamSubscription? _socketSubscription;

  AppointmentCubit(this._appointmentService, this._socketService) : super(AppointmentState.initial()) {
    _initSocket();
  }

  void _initSocket() {
    _socketService.connect();
    _socketSubscription = _socketService.updates.listen((data) {
      _handleSocketUpdate(data);
    });
  }

  void _handleSocketUpdate(Map<String, dynamic> data) {
    // Expected payload: { hospital_id, department, currently_serving, patients_ahead }
    final String? hospitalId = data['hospital_id'];
    final String? department = data['department'];
    final int? currentlyServing = data['currently_serving'];
    final int? patientsAhead = data['patients_ahead'];
    final String? estimatedServiceTime = data['estimated_service_time'];

    if (hospitalId == null || department == null) return;

    final updatedAppointments = state.upcomingAppointments.map((appt) {
      if (appt.hospitalId == hospitalId && appt.department == department) {
        return appt.copyWith(
          currentlyServing: currentlyServing ?? appt.currentlyServing,
          patientsAhead: patientsAhead ?? appt.patientsAhead,
          estimatedServiceTime: estimatedServiceTime ?? appt.estimatedServiceTime,
        );
      }
      return appt;
    }).toList();

    emit(state.copyWith(upcomingAppointments: updatedAppointments));
  }

  Future<void> getUpcomingAppointments() async {
    emit(state.copyWith(isLoading: true, failureOrSuccessOption: none()));
    
    final failureOrSuccess = await _appointmentService.getUserAppointments(type: 'upcoming');
    
    failureOrSuccess.fold(
      (f) => emit(state.copyWith(
        isLoading: false,
        failureOrSuccessOption: some(left(f)),
      )),
      (list) {
        // Join rooms for each appointment's hospital to receive real-time updates
        final hospitalIds = list.map((a) => a.hospitalId).toSet();
        for (final id in hospitalIds) {
          _socketService.joinHospitalRoom(id);
        }
        
        emit(state.copyWith(
          isLoading: false,
          upcomingAppointments: list,
          failureOrSuccessOption: none(),
        ));
      },
    );
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

  Future<void> searchAppointments(String query) async {
    if (query.isEmpty) {
      emit(state.copyWith(
        isSearching: false,
        searchResults: [],
        failureOrSuccessOption: none(),
      ));
      return;
    }

    emit(state.copyWith(
      isSearching: true,
      isLoading: true,
      failureOrSuccessOption: none(),
    ));

    final result = await _appointmentService.searchAppointments(query: query);

    emit(result.fold(
      (f) => state.copyWith(
        isLoading: false,
        failureOrSuccessOption: some(left(f)),
      ),
      (list) => state.copyWith(
        isLoading: false,
        searchResults: list,
        failureOrSuccessOption: none(),
      ),
    ));
  }

  void clearSearch() {
    emit(state.copyWith(
      isSearching: false,
      searchResults: [],
      failureOrSuccessOption: none(),
    ));
  }

  @override
  Future<void> close() {
    _socketSubscription?.cancel();
    return super.close();
  }
}
