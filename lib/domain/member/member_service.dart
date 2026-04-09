import 'package:dartz/dartz.dart';
import 'package:qflow/domain/core/failures.dart';
import 'package:qflow/domain/member/member_model.dart';

abstract class IMemberService {
  Future<Either<MainFailure, List<MemberModel>>> getMembers();
  Future<Either<MainFailure, Unit>> addMember({required MemberModel member});
  Future<Either<MainFailure, Unit>> updateMember({required MemberModel member});
  Future<Either<MainFailure, Unit>> deleteMember(String id);
}
