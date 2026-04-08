import 'package:dartz/dartz.dart';
import 'package:qflow/domain/core/failures.dart';
import 'package:qflow/domain/user/user_model/user_model.dart';

class ProfileState {
  final bool isLoading;
  final Option<UserModel> userOption;
  final Option<Either<MainFailure, Unit>> failureOrSuccessOption;

  const ProfileState({
    required this.isLoading,
    required this.userOption,
    required this.failureOrSuccessOption,
  });

  factory ProfileState.initial() => ProfileState(
        isLoading: false,
        userOption: none(),
        failureOrSuccessOption: none(),
      );

  @override
  String toString() {
    return 'ProfileState(isLoading: $isLoading, userOption: $userOption, failureOrSuccessOption: $failureOrSuccessOption)';
  }

  ProfileState copyWith({
    bool? isLoading,
    Option<UserModel>? userOption,
    Option<Either<MainFailure, Unit>>? failureOrSuccessOption,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      userOption: userOption ?? this.userOption,
      failureOrSuccessOption:
          failureOrSuccessOption ?? this.failureOrSuccessOption,
    );
  }
}
