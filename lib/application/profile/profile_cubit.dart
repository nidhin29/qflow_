import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:qflow/application/profile/profile_state.dart';
import 'package:qflow/domain/user/user_service.dart';
import 'package:qflow/domain/user/user_model/user_model.dart';

@injectable
class ProfileCubit extends Cubit<ProfileState> {
  final IUserService _userService;

  ProfileCubit(this._userService) : super(ProfileState.initial());

  Future<void> getUserDetails() async {
    emit(state.copyWith(isLoading: true));

    final failureOrUser = await _userService.getUserDetails();

    emit(failureOrUser.fold(
      (f) => state.copyWith(
        isLoading: false,
        failureOrSuccessOption: some(left(f)),
      ),
      (user) => state.copyWith(
        isLoading: false,
        userOption: some(user),
      ),
    ));
  }

  void profileImageChanged(String path) {
    emit(state.copyWith(profileImagePath: path, failureOrSuccessOption: none()));
  }

  Future<void> updateProfile({
    required UserModel user,
    String? profileImagePath,
  }) async {
    emit(state.copyWith(isLoading: true, failureOrSuccessOption: none()));

    final failureOrSuccess = await _userService.updateUserDetails(
      user: user,
      profileImagePath: profileImagePath ?? state.profileImagePath,
    );

    emit(state.copyWith(
      isLoading: false,
      failureOrSuccessOption: some(failureOrSuccess),
      // Clean up the temporary path on success
      profileImagePath: failureOrSuccess.isRight() ? null : state.profileImagePath,
      // Update the user model in state on success
      userOption: failureOrSuccess.isRight() ? some(user) : state.userOption,
    ));
  }
}
