

import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:qflow/domain/appointment/appointment_model/appointment_model.dart';
import 'package:qflow/domain/appointment/appointment_service.dart';
import 'package:qflow/domain/core/failures.dart';
import 'package:qflow/infrastructure/core/api_utils.dart';

@LazySingleton(as: IAppointmentService)
class AppointmentRepository implements IAppointmentService {
  final Dio _dio;

  AppointmentRepository(this._dio);

  @override
  Future<Either<MainFailure, Unit>> bookAppointment({
    required AppointmentModel appointment,
  }) async {
    try {
      log(appointment.toString());
      final response = await _dio.post(
        '/appointments/book-appointment',
        data: {
          'hospital_id': appointment.hospitalId,
          'department': appointment.department,
          'patient_name': appointment.patientName,
          'appointment_date': appointment.appointmentDate,
          'appointment_time': appointment.appointmentTime,
          'patient_id': appointment.patientId,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return right(unit);
      } else {
        return left(MainFailure.serverError(
            code: response.statusCode,
            message: (response.data is Map)
                ? response.data['message'] ?? 'Booking failed'
                : 'Booking failed'));
      }
    } on DioException catch (e) {
      return left(MainFailure.serverError(
          code: e.response?.statusCode,
          message: getErrorMessage(e, 'Network error occurred')));
    } catch (e) {
      return left(const MainFailure.clientFailure());
    }
  }

  @override
  Future<Either<MainFailure, List<AppointmentModel>>> getUserAppointments({
    required String type,
  }) async {
    try {
      final response = await _dio.get(
        '/appointments/user-appointments',
        queryParameters: {'type': type},
      );

      if (response.statusCode == 200) {
        log(response.data.toString());
        final List<dynamic> dataList = response.data['data']?['docs'] ?? [];
       
        final appointments = dataList
            .map((e) => AppointmentModel.fromMap(e as Map<String, dynamic>))
            .toList();
        return right(appointments);

      } else {
        return left(MainFailure.serverError(
            code: response.statusCode,
            message: (response.data is Map)
                ? response.data['message'] ?? 'Failed to fetch appointments'
                : 'Failed to fetch appointments'));
      }
    } on DioException catch (e) {
      return left(MainFailure.serverError(
          code: e.response?.statusCode,
          message: getErrorMessage(e, 'Failed to load appointments')));
    } catch (e) {
      return left(const MainFailure.clientFailure());
    }

  }

  @override
  Future<Either<MainFailure, List<AppointmentModel>>> searchAppointments({
    required String query,
  }) async {
    try {
      final response = await _dio.get(
        '/appointments/search-user-appointments',
        queryParameters: {'q': query},
      );

      if (response.statusCode == 200) {
        final List<dynamic> dataList = response.data['data']?['docs'] ?? [];
        final appointments = dataList
            .map((e) => AppointmentModel.fromMap(e as Map<String, dynamic>))
            .toList();
        return right(appointments);
      } else {
        return left(MainFailure.serverError(
            code: response.statusCode,
            message: (response.data is Map)
                ? response.data['message'] ?? 'Search failed'
                : 'Search failed'));
      }
    } on DioException catch (e) {
      return left(MainFailure.serverError(
          code: e.response?.statusCode,
          message: getErrorMessage(e, 'Failed to search appointments')));
    } catch (e) {
      return left(const MainFailure.clientFailure());
    }

  }
}
