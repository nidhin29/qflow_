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

  Future<void> updateProfile({
    required UserModel user,
    String? profileImagePath,
  }) async {
    emit(state.copyWith(isLoading: true));

    final failureOrSuccess = await _userService.updateUserDetails(
      user: user,
      profileImagePath: profileImagePath,
    );

    emit(state.copyWith(
      isLoading: false,
      failureOrSuccessOption: some(failureOrSuccess),
    ));
  }
}
