import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qflow/Presentation/Auth/register_details.dart';
import 'package:qflow/Presentation/Auth/sign_in.dart';
import 'package:qflow/Presentation/Auth/otp_screen.dart';
import 'package:qflow/application/auth/sign_up/sign_up_cubit.dart';
import 'package:qflow/application/auth/sign_up/sign_up_state.dart';
import 'package:qflow/domain/auth/auth_success.dart';
import 'package:qflow/Presentation/Home/mainscreen.dart';
import 'package:qflow/constants/const.dart';
import 'package:qflow/domain/core/di/injection.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isPasswordObscured = true;
  bool _isConfirmPasswordObscured = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SignUpCubit>(),
      child: BlocConsumer<SignUpCubit, SignUpState>(
        listener: (context, state) {
          state.authFailureOrSuccessOption.fold(
            () => null,
            (either) => either.fold(
              (failure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(failure.map(
                    clientFailure: (_) => 'Client Failure',
                    authFailure: (_) => 'Auth Failure',
                    serverFailure: (_) => 'Server Error',
                    serverError: (e) => e.message ?? 'Server Error',
                  ))),
                );
              },
              (successType) {
                // If it's a regular email registration, go to OTP
                if (state.emailAddress.isNotEmpty && state.password.isNotEmpty && state.fullName.isNotEmpty) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => OTPScreen(email: state.emailAddress),
                    ),
                  );
                } else {
                  // If it's Google Sign In, handle based on profile completion
                  if (successType == AuthSuccess.incomplete) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => const RegisterDetailsScreen()),
                    );
                  } else {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => const MainScreen()),
                    );
                  }
                }
              },
            ),
          );
        },
        builder: (context, state) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
            body: Column(
              children: [
                SizedBox(
                  height: 87.h,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 7.w),
                  child: Text('Sign Up',
                      style: TextStyle(
                          fontSize: 21.45.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.black)),
                ),
                SizedBox(
                  height: 80.h,
                ),
                Padding(
                    padding: EdgeInsets.only(left: 32.w, right: 32.w),
                    child: Column(children: [
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.black,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(9.84.r),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(9.84.r),
                          ),
                        ),
                        onChanged: (value) =>
                            context.read<SignUpCubit>().emailChanged(value),
                      ),
                      kheight15,
                      TextFormField(
                        obscureText: _isPasswordObscured,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.black,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordObscured
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordObscured = !_isPasswordObscured;
                              });
                            },
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(9.84.r),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(9.84.r),
                          ),
                        ),
                        onChanged: (value) =>
                            context.read<SignUpCubit>().passwordChanged(value),
                      ),
                      kheight15,
                      TextFormField(
                        obscureText: _isConfirmPasswordObscured,
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          labelStyle: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.black,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isConfirmPasswordObscured
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              setState(() {
                                _isConfirmPasswordObscured =
                                    !_isConfirmPasswordObscured;
                              });
                            },
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(9.84.r),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(9.84.r),
                          ),
                        ),
                        onChanged: (value) => context
                            .read<SignUpCubit>()
                            .confirmPasswordChanged(value),
                      ),
                      kheight15,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Already have an account?',
                              style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black)),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        const SignInScreen()));
                              },
                              child: Text('Sign In',
                                  style: TextStyle(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey)))
                        ],
                      ),
                      kheight20,
                      TextButton(
                          onPressed: () {
                            context.read<SignUpCubit>().registerPressed();
                          },
                          style: ButtonStyle(
                            minimumSize:
                                WidgetStateProperty.all(Size(346.w, 54.82.h)),
                            shape:
                                WidgetStateProperty.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(9.84.r),
                              side: const BorderSide(
                                  color: Colors.black), // Border color
                            )),
                            backgroundColor:
                                WidgetStateProperty.all(Colors.white),
                          ),
                          child: state.isSubmitting
                              ? const CircularProgressIndicator()
                              : Text('Continue',
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black))),
                      kheight20,
                      kheight10,
                      Row(
                        children: [
                          const Expanded(
                            child: Divider(
                              color: Color.fromRGBO(31, 31, 31, 1),
                              thickness: 1.5,
                              endIndent: 14,
                            ),
                          ),
                          Text(
                            'or',
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color.fromRGBO(31, 31, 31, 1),
                            ),
                          ),
                          const Expanded(
                            child: Divider(
                              color: Color.fromRGBO(31, 31, 31, 1),
                              thickness: 1.5,
                              indent: 14,
                            ),
                          ),
                        ],
                      ),
                      kheight20,
                      kheight10,
                      TextButton(
                          onPressed: () {
                            context.read<SignUpCubit>().googleSignInClicked();
                          },
                          style: ButtonStyle(
                            minimumSize:
                                WidgetStateProperty.all(Size(346.w, 54.82.h)),
                            shape:
                                WidgetStateProperty.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(9.84.r),
                              side: const BorderSide(
                                  color: Colors.black), // Border color
                            )),
                            backgroundColor:
                                WidgetStateProperty.all(Colors.white),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('assets/icon/google.png',
                                  width: 48.w, height: 33.h),
                              Text('Sign in with Google',
                                  style: TextStyle(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black))
                            ],
                          )),
                    ])),
                SizedBox(
                  height: 59.h,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'By clicking continue, you agree to our',
                      style: TextStyle(
                        fontSize: 9.75.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 9.75.sp,
                          fontFamily: 'MonumentExtended',
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Terms of Service',
                            style: TextStyle(
                              fontSize: 9.75.sp,
                              fontFamily: 'MonumentExtended',
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                            ),
                          ),
                          TextSpan(
                            text: ' and ',
                            style: TextStyle(
                              fontSize: 9.75.sp,
                              fontFamily: 'MonumentExtended',
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: TextStyle(
                              fontSize: 9.75.sp,
                              fontFamily: 'MonumentExtended',
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
