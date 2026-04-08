import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:qflow/application/auth/sign_up/sign_up_state.dart';
import 'package:qflow/domain/auth/auth_service.dart';

@injectable
class SignUpCubit extends Cubit<SignUpState> {
  final IAuthService _authService;

  SignUpCubit(this._authService) : super(SignUpState.initial());

  void fullNameChanged(String name) {
    emit(state.copyWith(
      fullName: name,
      authFailureOrSuccessOption: none(),
    ));
  }

  void emailChanged(String emailStr) {
    emit(state.copyWith(
      emailAddress: emailStr,
      authFailureOrSuccessOption: none(),
    ));
  }

  void passwordChanged(String passwordStr) {
    emit(state.copyWith(
      password: passwordStr,
      authFailureOrSuccessOption: none(),
    ));
  }

  void confirmPasswordChanged(String confirmPasswordStr) {
    emit(state.copyWith(
      confirmPassword: confirmPasswordStr,
      authFailureOrSuccessOption: none(),
    ));
  }

  Future<void> registerPressed() async {
    if (state.password != state.confirmPassword) {
      // Handle password mismatch locally if needed, or send specific failure
      return; 
    }

    emit(state.copyWith(
      isSubmitting: true,
      authFailureOrSuccessOption: none(),
    ));

    final failureOrSuccess = await _authService.registerWithEmailAndPassword(
      emailAddress: state.emailAddress,
      password: state.password,
      fullName: state.fullName,
    );

    if (failureOrSuccess.isRight()) {
      await _authService.sendOtp(email: state.emailAddress);
    }

    emit(state.copyWith(
      isSubmitting: false,
      showErrorMessages: true,
      authFailureOrSuccessOption: optionOf(failureOrSuccess),
    ));
  }

  Future<void> googleSignInClicked() async {
    emit(state.copyWith(
      isSubmitting: true,
      authFailureOrSuccessOption: none(),
    ));
    final failureOrSuccess = await _authService.signInWithGoogle();
    emit(state.copyWith(
      isSubmitting: false,
      authFailureOrSuccessOption: optionOf(failureOrSuccess),
    ));
  }
}
