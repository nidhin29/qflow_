
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:qflow/domain/core/failures.dart';
import 'package:qflow/domain/member/member_model.dart';
import 'package:qflow/domain/member/member_service.dart';
import 'package:qflow/infrastructure/core/api_utils.dart';

@LazySingleton(as: IMemberService)
class MemberRepository implements IMemberService {
  final Dio _dio;

  MemberRepository(this._dio);

  @override
  Future<Either<MainFailure, List<MemberModel>>> getMembers() async {
    try {
      final response = await _dio.get('/members/get-members');

      if (response.statusCode == 200) {
        final List<dynamic> data =
            response.data['data'] ?? response.data['members'] ?? [];
        final members = data
            .map((m) => MemberModel.fromMap(m as Map<String, dynamic>))
            .toList();
        return right(members);
      } else {
        return left(MainFailure.serverError(
            code: response.statusCode,
            message: (response.data is Map)
                ? response.data['message'] ?? 'Failed to fetch members'
                : 'Failed to fetch members'));
      }
    } on DioException catch (e) {
      return left(MainFailure.serverError(
          code: e.response?.statusCode,
          message: getErrorMessage(e, 'Failed to load members')));
    } catch (e) {
      return left(const MainFailure.clientFailure());
    }
  }

  @override
  Future<Either<MainFailure, Unit>> addMember({
    required MemberModel member,
  }) async {
    try {
      final response = await _dio.post(
        '/members/add-member',
        data: member.toMap(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return right(unit);
      } else {
        return left(MainFailure.serverError(
            code: response.statusCode,
            message: (response.data is Map)
                ? response.data['message'] ?? 'Failed to add member'
                : 'Failed to add member'));
      }
    } on DioException catch (e) {
      return left(MainFailure.serverError(
          code: e.response?.statusCode,
          message: getErrorMessage(e, 'Failed to add member')));
    } catch (e) {
      return left(const MainFailure.clientFailure());
    }
  }

  @override
  Future<Either<MainFailure, Unit>> deleteMember(String id) async {
    try {
      final response = await _dio.delete(
        '/members/delete-member',
        data: {'_id': id},
      );

      if (response.statusCode == 200) {
        return right(unit);
      } else {
        return left(MainFailure.serverError(
            code: response.statusCode,
            message: (response.data is Map)
                ? response.data['message'] ?? 'Failed to delete member'
                : 'Failed to delete member'));
      }
    } on DioException catch (e) {
      return left(MainFailure.serverError(
          code: e.response?.statusCode,
          message: getErrorMessage(e, 'Failed to delete member')));
    } catch (e) {
      return left(const MainFailure.clientFailure());
    }
  }

  @override
  Future<Either<MainFailure, Unit>> updateMember({
    required MemberModel member,
  }) async {
    try {
      final Map<String, dynamic> updateData = member.toMap();
      if (member.id != null) {
        updateData['_id'] = member.id;
      }

      final response = await _dio.post(
        '/members/update-member',
        data: updateData,
      );

      if (response.statusCode == 200) {
        return right(unit);
      } else {
        return left(MainFailure.serverError(
            code: response.statusCode,
            message: (response.data is Map)
                ? response.data['message'] ?? 'Failed to update member'
                : 'Failed to update member'));
      }
    } on DioException catch (e) {
      return left(MainFailure.serverError(
          code: e.response?.statusCode,
          message: getErrorMessage(e, 'Failed to update member')));
    } catch (e) {
      return left(const MainFailure.clientFailure());
    }
  }
}
