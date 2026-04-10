import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:qflow/domain/appointment/appointment_model/appointment_model.dart';
import 'package:qflow/domain/appointment/appointment_service.dart';
import 'package:qflow/domain/core/failures.dart';

@LazySingleton(as: IAppointmentService)
class AppointmentRepository implements IAppointmentService {
  final Dio _dio;

  AppointmentRepository(this._dio);

  @override
  Future<Either<MainFailure, Unit>> bookAppointment({
    required AppointmentModel appointment,
  }) async {
    try {
      final response = await _dio.post(
        '/appointments/book-appointment',
        data: {
          'hospital_id': appointment.hospitalId,
          'department': appointment.department,
          'patient_name': appointment.patientName,
          'appointment_date': appointment.appointmentDate,
          'appointment_time': appointment.appointmentTime,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return right(unit);
      } else {
        final data = response.data;
        final message = (data is Map) ? data['message'] : data?.toString();
        return left(MainFailure.serverError(
            code: response.statusCode,
            message: message ?? 'Booking failed'));
      }
    } on DioException catch (e) {
      log('AppointmentRepository bookAppointment Error: ${e.toString()}');
      final data = e.response?.data;
      final message = (data is Map) ? data['message'] : data?.toString();
      return left(MainFailure.serverError(
          code: e.response?.statusCode,
          message: message ?? 'Network error occurred'));
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
        final List<dynamic> dataList = response.data['data']?['docs'] ?? [];
       
        final appointments = dataList
            .map((e) => AppointmentModel.fromMap(e as Map<String, dynamic>))
            .toList();
        log(appointments.toString());
        return right(appointments);
      } else {
        final data = response.data;
        final message = (data is Map) ? data['message'] : data?.toString();
        return left(MainFailure.serverError(
            code: response.statusCode,
            message: message ?? 'Failed to fetch appointments'));
      }
    } on DioException catch (e) {
      log('AppointmentRepository getUserAppointments Error: ${e.toString()}');
      final data = e.response?.data;
      final message = (data is Map) ? data['message'] : data?.toString();
      return left(MainFailure.serverError(
          code: e.response?.statusCode,
          message: message ?? 'Failed to load appointments'));
    } catch (e) {
      log(e.toString());
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
        final data = response.data;
        final message = (data is Map) ? data['message'] : data?.toString();
        return left(MainFailure.serverError(
            code: response.statusCode,
            message: message ?? 'Search failed'));
      }
    } on DioException catch (e) {
      log('AppointmentRepository searchAppointments Error: ${e.toString()}');
      final data = e.response?.data;
      final message = (data is Map) ? data['message'] : data?.toString();
      return left(MainFailure.serverError(
          code: e.response?.statusCode,
          message: message ?? 'Failed to search appointments'));
    } catch (e) {
      log(e.toString());
      return left(const MainFailure.clientFailure());
    }
  }
}
