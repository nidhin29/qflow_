import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:qflow/application/auth/sign_in/sign_in_state.dart';
import 'package:qflow/domain/auth/auth_service.dart';

@injectable
class SignInCubit extends Cubit<SignInState> {
  final IAuthService _authService;

  SignInCubit(this._authService) : super(SignInState.initial());

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

  Future<void> signInWithEmailAndPasswordPressed() async {
    emit(state.copyWith(
      isSubmitting: true,
      authFailureOrSuccessOption: none(),
    ));

    final failureOrSuccess = await _authService.signInWithEmailAndPassword(
      emailAddress: state.emailAddress,
      password: state.password,
    );

    emit(state.copyWith(
      isSubmitting: false,
      showErrorMessages: true,
      authFailureOrSuccessOption: optionOf(failureOrSuccess),
    ));
  }

  Future<void> signInWithGooglePressed() async {
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
