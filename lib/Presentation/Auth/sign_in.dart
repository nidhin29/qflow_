import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qflow/Presentation/Auth/register_details.dart';
import 'package:qflow/Presentation/Auth/sign_up.dart';
import 'package:qflow/Presentation/Home/mainscreen.dart';
import 'package:qflow/application/auth/sign_in/sign_in_cubit.dart';
import 'package:qflow/application/auth/sign_in/sign_in_state.dart';
import 'package:qflow/domain/auth/auth_success.dart';
import 'package:qflow/constants/const.dart';
import 'package:qflow/domain/core/di/injection.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _isPasswordObscured = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SignInCubit>(),
      child: BlocConsumer<SignInCubit, SignInState>(
        listener: (context, state) {
          state.authFailureOrSuccessOption.fold(
            () => null,
            (either) => either.fold(
              (failure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(failure.map(
                      clientFailure: (_) => 'Network Error',
                      authFailure: (_) => 'Invalid credentials',
                      serverFailure: (_) => 'Server Error',
                      serverError: (e) => e.message ?? 'Authentication Failed',
                    )),
                  ),
                );
              },
              (successType) {
                if (successType == AuthSuccess.incomplete) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) => const RegisterDetailsScreen()),
                  );
                } else {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const MainScreen()),
                  );
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
                  child: Text('Log In',
                      style: TextStyle(
                          fontSize: 21.45.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.black)),
                ),
                SizedBox(
                  height: 124.h,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 32.w, right: 32.w),
                  child: Column(
                    children: [
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
                            context.read<SignInCubit>().emailChanged(value),
                      ),
                      kheight15,
                      TextFormField(
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
                        obscureText: _isPasswordObscured,
                        onChanged: (value) =>
                            context.read<SignInCubit>().passwordChanged(value),
                      ),
                      kheight15,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('Forgot Password?',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black)),
                        ],
                      ),
                      kheight20,
                      if (state.isSubmitting)
                        const CircularProgressIndicator()
                      else
                        TextButton(
                            onPressed: () {
                              context
                                  .read<SignInCubit>()
                                  .signInWithEmailAndPasswordPressed();
                            },
                            style: ButtonStyle(
                              minimumSize:
                                  WidgetStateProperty.all(Size(346.w, 54.82.h)),
                              shape: WidgetStateProperty.all(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9.84.r),
                                side: const BorderSide(color: Colors.black),
                              )),
                              backgroundColor:
                                  WidgetStateProperty.all(Colors.white),
                            ),
                            child: Text('Continue',
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
                            context
                                .read<SignInCubit>()
                                .signInWithGooglePressed();
                          },
                          style: ButtonStyle(
                            minimumSize:
                                WidgetStateProperty.all(Size(346.w, 54.82.h)),
                            shape:
                                WidgetStateProperty.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(9.84.r),
                              side: const BorderSide(color: Colors.black),
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
                      kheight10,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Don\'t have an account?',
                              style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black)),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        const SignUpScreen()));
                              },
                              child: Text('Sign Up',
                                  style: TextStyle(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey)))
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
