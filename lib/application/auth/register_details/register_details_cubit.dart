
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:qflow/application/auth/register_details/register_details_state.dart';
import 'package:qflow/domain/user/user_service.dart';
import 'package:qflow/domain/user/user_model/user_model.dart';
import 'package:dartz/dartz.dart';

import 'package:qflow/domain/auth/app_session.dart';

@injectable
class RegisterDetailsCubit extends Cubit<RegisterDetailsState> {
  final IUserService _userService;
  final AppSession _appSession;

  RegisterDetailsCubit(this._userService, this._appSession) : super(RegisterDetailsState.initial());

  void usernameChanged(String username) {
    emit(state.copyWith(username: username, failureOrSuccessOption: none()));
  }

  void firstNameChanged(String firstName) {
    emit(state.copyWith(firstName: firstName, failureOrSuccessOption: none()));
  }

  void lastNameChanged(String lastName) {
    emit(state.copyWith(lastName: lastName, failureOrSuccessOption: none()));
  }

  void ageChanged(String age) {
    emit(state.copyWith(age: int.tryParse(age) ?? 0, failureOrSuccessOption: none()));
  }

  void weightChanged(String weight) {
    emit(state.copyWith(weight: double.tryParse(weight) ?? 0.0, failureOrSuccessOption: none()));
  }

  void heightChanged(String height) {
    emit(state.copyWith(height: double.tryParse(height) ?? 0.0, failureOrSuccessOption: none()));
  }

  void genderChanged(String gender) {
    emit(state.copyWith(gender: gender, failureOrSuccessOption: none()));
  }

  void bloodGroupChanged(String bloodGroup) {
    emit(state.copyWith(bloodGroup: bloodGroup, failureOrSuccessOption: none()));
  }

  void contactNumberChanged(String contactNumber) {
    emit(state.copyWith(contactNumber: contactNumber, failureOrSuccessOption: none()));
  }

  void cityChanged(String city) {
    emit(state.copyWith(city: city, failureOrSuccessOption: none()));
  }

  void districtChanged(String district) {
    emit(state.copyWith(district: district, failureOrSuccessOption: none()));
  }

  void profileImageChanged(String path) {
    emit(state.copyWith(profileImagePath: path, failureOrSuccessOption: none()));
  }

  Future<void> submit() async {

    emit(state.copyWith(isSubmitting: true, failureOrSuccessOption: none()));

    final user = UserModel(
      firstName: state.firstName,
      lastName: state.lastName,
      username: state.username,
      age: state.age,
      weight: state.weight,
      height: state.height,
      gender: state.gender,
      bloodGroup: state.bloodGroup,
      contactNumber: state.contactNumber,
      city: state.city,
      district: state.district,
    );

    final failureOrSuccess = await _userService.registerUserDetails(
      user: user,
      profileImagePath: state.profileImagePath,
    );

    if (failureOrSuccess.isRight()) {
      await _appSession.saveUsername(username: state.username);
      await _appSession.saveProfileInfo(
        userId: _appSession.userId ?? '', // Keep existing ID if available, or empty if waiting for refresh
        firstName: state.firstName,
        lastName: state.lastName,
      );
      await _appSession.saveLocation(city: state.city, district: state.district);
    }

    emit(state.copyWith(
      isSubmitting: false,
      showErrorMessages: true,
      failureOrSuccessOption: some(failureOrSuccess),
    ));
  }
}
