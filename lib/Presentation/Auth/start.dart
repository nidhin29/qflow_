import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qflow/Presentation/Auth/sign_in.dart';
import 'package:qflow/Presentation/Auth/sign_up.dart';
import 'package:qflow/Presentation/common/auth_button.dart';
import 'package:qflow/constants/const.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
        body: Column(
          children: [
            kheight100,
            kheight20,
            kwidth5,
            Container(
              height: 309.22.h,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/icon/start.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            kheight20,
            kheight20,
            Text('Don\'t Wait for anything\nLet\'s save it together',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 19.5.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.black)),
            kheight20,
            kheight20,
            Text(
              'Get your ticket you want and save\nyour time easily',
              textAlign: TextAlign.center,
              style: GoogleFonts.dmSans(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
            ),
            kheight20,
            kheight20,
            kheight10,
            kheight10,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ToggleAuthButtonWidget(
                  'Sign In',
                  title: 'Log In',
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const SignInScreen()));
                  },
                ),
                kwidth5,
                kwidth5,
                kwidth5,
                kwidth5,
                ToggleAuthButtonWidget(
                  'Sign Up',
                    title: 'Sign Up',
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const SignUpScreen()));
                    })
              ],
            )
          ],
        ));
  }
}
