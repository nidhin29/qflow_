import 'package:dartz/dartz.dart';
import 'package:qflow/domain/core/failures.dart';

class SignInState {
  final String emailAddress;
  final String password;
  final bool isSubmitting;
  final bool showErrorMessages;
  final Option<Either<MainFailure, Unit>> authFailureOrSuccessOption;

  const SignInState({
    required this.emailAddress,
    required this.password,
    required this.isSubmitting,
    required this.showErrorMessages,
    required this.authFailureOrSuccessOption,
  });

  factory SignInState.initial() => SignInState(
        emailAddress: '',
        password: '',
        isSubmitting: false,
        showErrorMessages: false,
        authFailureOrSuccessOption: none(),
      );

  @override
  String toString() {
    return 'SignInState(emailAddress: $emailAddress, password: $password, isSubmitting: $isSubmitting, showErrorMessages: $showErrorMessages, authFailureOrSuccessOption: $authFailureOrSuccessOption)';
  }

  SignInState copyWith({
    String? emailAddress,
    String? password,
    bool? isSubmitting,
    bool? showErrorMessages,
    Option<Either<MainFailure, Unit>>? authFailureOrSuccessOption,
  }) {
    return SignInState(
      emailAddress: emailAddress ?? this.emailAddress,
      password: password ?? this.password,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      showErrorMessages: showErrorMessages ?? this.showErrorMessages,
      authFailureOrSuccessOption:
          authFailureOrSuccessOption ?? this.authFailureOrSuccessOption,
    );
  }
}
