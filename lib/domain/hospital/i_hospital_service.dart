import 'package:dartz/dartz.dart';
import 'package:qflow/domain/core/failures.dart';
import 'package:qflow/domain/hospital/hospital_model.dart';
import 'package:qflow/domain/hospital/location_model.dart';

abstract class IHospitalService {
  Future<Either<MainFailure, List<HospitalModel>>> getHospitalsByLocation({
    required String location,
    int page = 1,
    int limit = 10,
  });

  Future<Either<MainFailure, HospitalModel>> getHospitalById({
    required String hospitalId,
  });

  Future<Either<MainFailure, List<LocationModel>>> searchLocations({
    required String query,
  });

  Future<Either<MainFailure, List<HospitalModel>>> searchHospitals({
    required String query,
    String? filter,
    int page = 1,
    int limit = 10,
  });
}
