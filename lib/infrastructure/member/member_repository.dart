import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:qflow/domain/core/failures.dart';
import 'package:qflow/domain/member/member_model.dart';
import 'package:qflow/domain/member/member_service.dart';

@LazySingleton(as: IMemberService)
class MemberRepository implements IMemberService {
  final Dio _dio;

  MemberRepository(this._dio);

  @override
  Future<Either<MainFailure, List<MemberModel>>> getMembers() async {
    try {
      final response = await _dio.get('/members/get-members');
      log(response.toString());
      if (response.statusCode == 200) {
        final List<dynamic> data =
            response.data['data'] ?? response.data['members'] ?? [];
        final members = data
            .map((m) => MemberModel.fromMap(m as Map<String, dynamic>))
            .toList();
        return right(members);
      } else {
        return left(const MainFailure.serverFailure());
      }
    } catch (e) {
      log('MemberRepository (getMembers) Error: ${e.toString()}');
      return left(const MainFailure.clientFailure());
    }
  }

  @override
  Future<Either<MainFailure, Unit>> addMember({
    required MemberModel member,
  }) async {
    try {
      // Switch to standard JSON data
      final response = await _dio.post(
        '/members/add-member',
        data: member.toMap(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return right(unit);
      } else {
        return left(const MainFailure.serverFailure());
      }
    } catch (e) {
      log('MemberRepository (addMember) Error: ${e.toString()}');
      return left(const MainFailure.clientFailure());
    }
  }

  @override
  Future<Either<MainFailure, Unit>> deleteMember(String id) async {
    try {
      final response = await _dio.delete(
        '/members/delete-member',
        data: {'_id': id}, // Including both for compatibility
      );

      if (response.statusCode == 200) {
        return right(unit);
      } else {
        return left(const MainFailure.serverFailure());
      }
    } catch (e) {
      log('MemberRepository (deleteMember) Error: ${e.toString()}');
      return left(const MainFailure.clientFailure());
    }
  }

  @override
  Future<Either<MainFailure, Unit>> updateMember({
    required MemberModel member,
  }) async {
    try {
      final Map<String, dynamic> updateData = member.toMap();
      // Ensure the correct ID is passed for the update operation
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
        return left(const MainFailure.serverFailure());
      }
    } catch (e) {
      log('MemberRepository (updateMember) Error: ${e.toString()}');
      return left(const MainFailure.clientFailure());
    }
  }
}
