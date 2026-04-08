import 'package:dartz/dartz.dart';
import 'package:qflow/domain/core/failures.dart';
import 'package:qflow/domain/appointment/appointment_model/appointment_model.dart';

abstract class IAppointmentService {
  Future<Either<MainFailure, Unit>> bookAppointment({
    required AppointmentModel appointment,
  });

  Future<Either<MainFailure, List<AppointmentModel>>> getUserAppointments({
    required String type, // 'upcoming' or 'past'
  });
}
