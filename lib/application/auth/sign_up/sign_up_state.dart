import 'package:dartz/dartz.dart';
import 'package:qflow/domain/auth/auth_success.dart';
import 'package:qflow/domain/core/failures.dart';

class SignUpState {
  final String fullName;
  final String emailAddress;
  final String password;
  final String confirmPassword;
  final bool isSubmitting;
  final bool showErrorMessages;
  final Option<Either<MainFailure, AuthSuccess>> authFailureOrSuccessOption;

  const SignUpState({
    required this.fullName,
    required this.emailAddress,
    required this.password,
    required this.confirmPassword,
    required this.isSubmitting,
    required this.showErrorMessages,
    required this.authFailureOrSuccessOption,
  });

  factory SignUpState.initial() => SignUpState(
        fullName: '',
        emailAddress: '',
        password: '',
        confirmPassword: '',
        isSubmitting: false,
        showErrorMessages: false,
        authFailureOrSuccessOption: none(),
      );

  SignUpState copyWith({
    String? fullName,
    String? emailAddress,
    String? password,
    String? confirmPassword,
    bool? isSubmitting,
    bool? showErrorMessages,
    Option<Either<MainFailure, AuthSuccess>>? authFailureOrSuccessOption,
  }) {
    return SignUpState(
      fullName: fullName ?? this.fullName,
      emailAddress: emailAddress ?? this.emailAddress,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      showErrorMessages: showErrorMessages ?? this.showErrorMessages,
      authFailureOrSuccessOption:
          authFailureOrSuccessOption ?? this.authFailureOrSuccessOption,
    );
  }
}
