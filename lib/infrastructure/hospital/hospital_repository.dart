import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:qflow/domain/core/failures.dart';
import 'package:qflow/domain/hospital/hospital_model.dart';
import 'package:qflow/domain/hospital/i_hospital_service.dart';
import 'package:qflow/domain/hospital/location_model.dart';

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
            message: response.data['message'] ?? 'Failed to fetch hospitals'));
      }
    } on DioException catch (e) {
      log('HospitalRepository getHospitalsByLocation Error: ${e.toString()}');
      return left(MainFailure.serverError(
          code: e.response?.statusCode,
          message: e.response?.data?['message'] ?? 'Network error occurred'));
    } catch (e) {
      log('HospitalRepository getHospitalsByLocation Error: ${e.toString()}');
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
            message: response.data['message'] ?? 'Failed to load hospital details'));
      }
    } on DioException catch (e) {
      log('HospitalRepository getHospitalById Error: ${e.toString()}');
      return left(MainFailure.serverError(
          code: e.response?.statusCode,
          message: e.response?.data?['message'] ?? 'Failed to load details'));
    } catch (e) {
      log('HospitalRepository getHospitalById Error: ${e.toString()}');
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
      log('HospitalRepository searchLocations Error: ${e.toString()}');
      return left(MainFailure.serverError(
          code: e.response?.statusCode,
          message: e.response?.data?['message'] ?? 'Connection error'));
    } catch (e) {
      log('HospitalRepository searchLocations Error: ${e.toString()}');
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
      log('HospitalRepository searchHospitals Error: ${e.toString()}');
      return left(MainFailure.serverError(
          code: e.response?.statusCode,
          message: e.response?.data?['message'] ?? 'Failed to search hospitals'));
    } catch (e) {
      log('HospitalRepository searchHospitals Error: ${e.toString()}');
      return left(const MainFailure.clientFailure());
    }
  }
}
