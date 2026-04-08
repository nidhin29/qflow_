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
        data: appointment.toMap(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return right(unit);
      } else {
        return left(const MainFailure.serverFailure());
      }
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
        final List<dynamic> dataList = response.data['data'] ?? [];
        final appointments = dataList
            .map((e) => AppointmentModel.fromMap(e as Map<String, dynamic>))
            .toList();
        return right(appointments);
      } else {
        return left(const MainFailure.serverFailure());
      }
    } catch (e) {
      return left(const MainFailure.clientFailure());
    }
  }
}
