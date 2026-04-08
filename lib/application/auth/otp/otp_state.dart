import 'package:dartz/dartz.dart';
import 'package:qflow/domain/core/failures.dart';

class OTPState {
  final bool isSubmitting;
  final Option<Either<MainFailure, Unit>> otpFailureOrSuccessOption;

  const OTPState({
    required this.isSubmitting,
    required this.otpFailureOrSuccessOption,
  });

  factory OTPState.initial() => OTPState(
        isSubmitting: false,
        otpFailureOrSuccessOption: none(),
      );

  OTPState copyWith({
    bool? isSubmitting,
    Option<Either<MainFailure, Unit>>? otpFailureOrSuccessOption,
  }) {
    return OTPState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      otpFailureOrSuccessOption:
          otpFailureOrSuccessOption ?? this.otpFailureOrSuccessOption,
    );
  }
}
