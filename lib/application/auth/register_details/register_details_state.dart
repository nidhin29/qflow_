import 'package:dartz/dartz.dart';
import 'package:qflow/domain/core/failures.dart';

class RegisterDetailsState {
  final String username;
  final String firstName;
  final String lastName;
  final int age;
  final double weight;
  final double height;
  final String gender;
  final String bloodGroup;
  final String contactNumber;
  final String city;
  final String district;
  final String? profileImagePath;
  final bool isSubmitting;
  final bool showErrorMessages;
  final Option<Either<MainFailure, Unit>> failureOrSuccessOption;

  const RegisterDetailsState({
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.weight,
    required this.height,
    required this.gender,
    required this.bloodGroup,
    required this.contactNumber,
    required this.city,
    required this.district,
    this.profileImagePath,
    required this.isSubmitting,
    required this.showErrorMessages,
    required this.failureOrSuccessOption,
  });

  factory RegisterDetailsState.initial() => RegisterDetailsState(
        username: '',
        firstName: '',
        lastName: '',
        age: 0,
        weight: 0.0,
        height: 0.0,
        gender: 'Male',
        bloodGroup: 'A+',
        contactNumber: '',
        city: '',
        district: '',
        profileImagePath: null,
        isSubmitting: false,
        showErrorMessages: false,
        failureOrSuccessOption: none(),
      );

  RegisterDetailsState copyWith({
    String? username,
    String? firstName,
    String? lastName,
    int? age,
    double? weight,
    double? height,
    String? gender,
    String? bloodGroup,
    String? contactNumber,
    String? city,
    String? district,
    String? profileImagePath,
    bool? isSubmitting,
    bool? showErrorMessages,
    Option<Either<MainFailure, Unit>>? failureOrSuccessOption,
  }) {
    return RegisterDetailsState(
      username: username ?? this.username,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      age: age ?? this.age,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      gender: gender ?? this.gender,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      contactNumber: contactNumber ?? this.contactNumber,
      city: city ?? this.city,
      district: district ?? this.district,
      profileImagePath: profileImagePath ?? this.profileImagePath,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      showErrorMessages: showErrorMessages ?? this.showErrorMessages,
      failureOrSuccessOption:
          failureOrSuccessOption ?? this.failureOrSuccessOption,
    );
  }
}
