import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:qflow/application/auth/register_details/register_details_state.dart';
import 'package:qflow/domain/user/user_service.dart';
import 'package:qflow/domain/user/user_model/user_model.dart';
import 'package:dartz/dartz.dart';

@injectable
class RegisterDetailsCubit extends Cubit<RegisterDetailsState> {
  final IUserService _userService;

  RegisterDetailsCubit(this._userService) : super(RegisterDetailsState.initial());

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
    log('RegisterDetailsCubit: Submitting with image path: ${state.profileImagePath}');
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

    emit(state.copyWith(
      isSubmitting: false,
      showErrorMessages: true,
      failureOrSuccessOption: some(failureOrSuccess),
    ));
  }
}
