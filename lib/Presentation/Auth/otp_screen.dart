import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qflow/Presentation/Auth/register_details.dart';
import 'package:qflow/application/auth/otp/otp_cubit.dart';
import 'package:qflow/application/auth/otp/otp_state.dart';
import 'package:qflow/domain/core/di/injection.dart';

class OTPScreen extends StatefulWidget {
  final String email;
  const OTPScreen({super.key, required this.email});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<OTPCubit>(),
      child: BlocConsumer<OTPCubit, OTPState>(
        listener: (context, state) {
          state.otpFailureOrSuccessOption.fold(
            () => null,
            (either) => either.fold(
              (failure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(failure.map(
                      clientFailure: (_) => 'Network Error',
                      authFailure: (_) => 'Invalid OTP',
                      serverFailure: (_) => 'Server Error',
                      serverError: (e) => e.message ?? 'Invalid OTP',
                    )),
                  ),
                );
              },
              (_) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const RegisterDetailsScreen(),
                  ),
                );
              },
            ),
          );
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Text(
                      'Verify OTP',
                      style: TextStyle(
                        fontSize: 21.45.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Text(
                      'Please enter the 6-digit code sent to ${widget.email}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  SizedBox(height: 40.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        6,
                        (index) => SizedBox(
                          width: 50.w,
                          height: 50.h,
                          child: TextFormField(
                            controller: _controllers[index],
                            focusNode: _focusNodes[index],
                            onChanged: (value) => _onChanged(value, index),
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(1),
                            ],
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.zero,
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.circular(9.84.r),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.black26),
                                borderRadius: BorderRadius.circular(9.84.r),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40.h),
                  if (state.isSubmitting)
                    const Center(child: CircularProgressIndicator())
                  else
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: TextButton(
                        onPressed: () {
                          final otp = _controllers.map((c) => c.text).join();
                          if (otp.length == 6) {
                            context.read<OTPCubit>().verifyOtp(
                                  email: widget.email,
                                  otp: otp,
                                );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please enter 6 digits')),
                            );
                          }
                        },
                        style: ButtonStyle(
                          minimumSize: WidgetStateProperty.all(
                              Size(double.infinity, 54.82.h)),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(9.84.r),
                              side: const BorderSide(color: Colors.black),
                            ),
                          ),
                          backgroundColor: WidgetStateProperty.all(Colors.white),
                        ),
                        child: Text(
                          'Verify',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  SizedBox(height: 20.h),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        context.read<OTPCubit>().resendOtp(email: widget.email);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('OTP Resent')),
                        );
                      },
                      child: Text(
                        'Resend OTP',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
