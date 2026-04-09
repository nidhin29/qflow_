import 'package:dartz/dartz.dart';
import 'package:qflow/domain/core/failures.dart';
import 'package:qflow/domain/member/member_model.dart';

class MemberState {
  final bool isLoading;
  final List<MemberModel> members;
  final Option<Either<MainFailure, Unit>> failureOrSuccessOption;

  const MemberState({
    required this.isLoading,
    required this.members,
    required this.failureOrSuccessOption,
  });

  factory MemberState.initial() => MemberState(
        isLoading: false,
        members: [],
        failureOrSuccessOption: none(),
      );

  @override
  String toString() {
    return 'MemberState(isLoading: $isLoading, membersCount: ${members.length})';
  }

  MemberState copyWith({
    bool? isLoading,
    List<MemberModel>? members,
    Option<Either<MainFailure, Unit>>? failureOrSuccessOption,
  }) {
    return MemberState(
      isLoading: isLoading ?? this.isLoading,
      members: members ?? this.members,
      failureOrSuccessOption:
          failureOrSuccessOption ?? this.failureOrSuccessOption,
    );
  }
}
