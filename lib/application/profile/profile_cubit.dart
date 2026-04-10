
import 'package:dartz/dartz.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:qflow/application/profile/profile_state.dart';
import 'package:qflow/domain/core/failures.dart';
import 'package:qflow/domain/user/user_service.dart';
import 'package:qflow/domain/user/user_model/user_model.dart';
import 'package:qflow/domain/auth/app_session.dart';

@injectable
class ProfileCubit extends Cubit<ProfileState> {
  final IUserService _userService;

  ProfileCubit(this._userService, AppSession appSession)
      : super(ProfileState.initial().copyWith(
          userOption: optionOf(appSession.toUserModel()),
        ));

  Future<void> getUserDetails() async {
    emit(state.copyWith(isLoading: true, failureOrSuccessOption: none()));

    final failureOrUser = await _userService.getUserDetails();

    emit(failureOrUser.fold(
      (f) => state.copyWith(
        isLoading: false,
        failureOrSuccessOption: some(left<MainFailure, Unit>(f)),
      ),
      (user) {
        // Check and sync FCM token if null or empty
        if (user.fcmToken == null || user.fcmToken!.isEmpty) {
          _syncFcmToken();
        }

        return state.copyWith(
          isLoading: false,
          userOption: some(user),
          failureOrSuccessOption: none(),
        );
      },
    ));
  }

  Future<void> _syncFcmToken() async {
    try {
      final fcm = FirebaseMessaging.instance;
      // Request permission (standard practice for FCM)
      await fcm.requestPermission();
      final token = await fcm.getToken();
      if (token != null) {
        await _userService.updateFcmToken(token);
      }

    } catch (e) {
    }

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
    ));

    // After a successful update, re-fetch the user details to get fresh data (including thumbnails/URLs)
    // from the server, since the update API only returns a success message.
    if (failureOrSuccess.isRight()) {
      await getUserDetails();
    }
  }

  void clear() {
    emit(ProfileState.initial());
  }
}
