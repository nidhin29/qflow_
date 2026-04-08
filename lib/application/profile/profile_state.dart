import 'package:dartz/dartz.dart';
import 'package:qflow/domain/core/failures.dart';
import 'package:qflow/domain/user/user_model/user_model.dart';

class ProfileState {
  final bool isLoading;
  final Option<UserModel> userOption;
  final Option<Either<MainFailure, Unit>> failureOrSuccessOption;
  final String? profileImagePath;

  const ProfileState({
    required this.isLoading,
    required this.userOption,
    required this.failureOrSuccessOption,
    this.profileImagePath,
  });

  factory ProfileState.initial() => ProfileState(
        isLoading: false,
        userOption: none(),
        failureOrSuccessOption: none(),
        profileImagePath: null,
      );

  @override
  String toString() {
    return 'ProfileState(isLoading: $isLoading, userOption: $userOption, failureOrSuccessOption: $failureOrSuccessOption, profileImagePath: $profileImagePath)';
  }

  ProfileState copyWith({
    bool? isLoading,
    Option<UserModel>? userOption,
    Option<Either<MainFailure, Unit>>? failureOrSuccessOption,
    String? profileImagePath,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      userOption: userOption ?? this.userOption,
      failureOrSuccessOption:
          failureOrSuccessOption ?? this.failureOrSuccessOption,
      profileImagePath: profileImagePath ?? this.profileImagePath,
    );
  }
}
