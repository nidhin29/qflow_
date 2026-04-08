import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:qflow/application/auth/otp/otp_state.dart';
import 'package:qflow/domain/auth/auth_service.dart';
import 'package:dartz/dartz.dart';

@injectable
class OTPCubit extends Cubit<OTPState> {
  final IAuthService _authService;

  OTPCubit(this._authService) : super(OTPState.initial());

  Future<void> verifyOtp({required String email, required String otp}) async {
    emit(state.copyWith(
      isSubmitting: true,
      otpFailureOrSuccessOption: none(),
    ));

    final failureOrSuccess = await _authService.verifyOtp(
      email: email,
      otp: otp,
    );

    emit(state.copyWith(
      isSubmitting: false,
      otpFailureOrSuccessOption: some(failureOrSuccess),
    ));
  }

  Future<void> resendOtp({required String email}) async {
    emit(state.copyWith(
      isSubmitting: true,
      otpFailureOrSuccessOption: none(),
    ));

    final failureOrSuccess = await _authService.sendOtp(email: email);

    emit(state.copyWith(
      isSubmitting: false,
      otpFailureOrSuccessOption: some(failureOrSuccess),
    ));
  }
}
