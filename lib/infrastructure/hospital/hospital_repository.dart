
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:qflow/domain/core/failures.dart';
import 'package:qflow/domain/hospital/hospital_model.dart';
import 'package:qflow/domain/hospital/i_hospital_service.dart';
import 'package:qflow/domain/hospital/location_model.dart';
import 'package:qflow/infrastructure/core/api_utils.dart';

@LazySingleton(as: IHospitalService)
class HospitalRepository implements IHospitalService {
  final Dio _dio;

  HospitalRepository(this._dio);

  @override
  Future<Either<MainFailure, List<HospitalModel>>> getHospitalsByLocation({
    required String location,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await _dio.get(
        '/hospital/get-hospitals-by-location',
        queryParameters: {
          'location': location,
          'page': page,
          'limit': limit,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] ?? response.data;
        final List docs = data['docs'] ?? [];
        final hospitals = docs
            .map((m) => HospitalModel.fromMap(m as Map<String, dynamic>))
            .toList();
        return right(hospitals);
      } else {
        return left(MainFailure.serverError(
            code: response.statusCode,
            message: (response.data is Map)
                ? response.data['message'] ?? 'Failed to fetch hospitals'
                : 'Failed to fetch hospitals'));
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
  Future<Either<MainFailure, HospitalModel>> getHospitalById({
    required String hospitalId,
  }) async {
    try {
      final response =
          await _dio.get('/hospital/get-hospital-by-id/$hospitalId');
      if (response.statusCode == 200) {
        final data = response.data['data'] ?? response.data;
        return right(HospitalModel.fromMap(data as Map<String, dynamic>));
      } else {
        return left(MainFailure.serverError(
            code: response.statusCode,
            message: (response.data is Map) 
                ? response.data['message'] ?? 'Failed to load hospital details'
                : 'Failed to load hospital details'));
      }
    } on DioException catch (e) {
      return left(MainFailure.serverError(
          code: e.response?.statusCode,
          message: getErrorMessage(e, 'Failed to load details')));
    } catch (e) {
      return left(const MainFailure.clientFailure());
    }
  }

  @override
  Future<Either<MainFailure, List<LocationModel>>> searchLocations({
    required String query,
  }) async {
    try {
      final response = await _dio.get(
        '/hospital/search-locations',
        queryParameters: {'q': query},
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] ?? response.data;
        final List docs = data['docs'] ?? [];
        final locations = docs
            .map((m) => LocationModel.fromMap(m as Map<String, dynamic>))
            .toList();
        return right(locations);
      } else {
        return left(MainFailure.serverError(
            code: response.statusCode,
            message: response.data['message'] ?? 'Failed to search locations'));
      }
    } on DioException catch (e) {
      return left(MainFailure.serverError(
          code: e.response?.statusCode,
          message: getErrorMessage(e, 'Connection error')));
    } catch (e) {
      return left(const MainFailure.clientFailure());
    }
  }

  @override
  Future<Either<MainFailure, List<HospitalModel>>> searchHospitals({
    required String query,
    String? filter,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final queryParams = {
        'q': query,
        'page': page,
        'limit': limit,
      };
      if (filter != null && filter.isNotEmpty) {
        queryParams['filter'] = filter;
      }

      final response = await _dio.get(
        '/hospital/search-hospitals',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] ?? response.data;
        final List docs = data['docs'] ?? [];
        final hospitals = docs
            .map((m) => HospitalModel.fromMap(m as Map<String, dynamic>))
            .toList();
        return right(hospitals);
      } else {
        return left(MainFailure.serverError(
            code: response.statusCode,
            message: response.data['message'] ?? 'Search failed'));
      }
    } on DioException catch (e) {
      return left(MainFailure.serverError(
          code: e.response?.statusCode,
          message: getErrorMessage(e, 'Failed to search hospitals')));
    } catch (e) {
      return left(const MainFailure.clientFailure());
    }
  }
}
