import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:async';
import 'package:qflow/Presentation/Auth/start.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  double _radius = 0.0;
  late Animation<double> animation;
  late AnimationController animcontroller;

  @override
  void initState() {
    super.initState();
    _startAnimation();
    animcontroller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000));
    animation =
        CurvedAnimation(parent: animcontroller, curve: Curves.easeInOut);

    animcontroller.forward();
    Future.delayed(const Duration(milliseconds: 2700), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const StartPage(),
      ));
    });
  }

  void _startAnimation() {
    Timer(const Duration(milliseconds: 700), () {
      setState(() {
        _radius = 80.0;
      });
    });
  }

  @override
  void dispose() {
    animcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: _radius),
              duration: const Duration(seconds: 2),
              builder: (context, radius, child) {
                return ClipOval(
                  clipper: CircleClipper(radius),
                  child: Image.asset('assets/icon/icon.png'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CircleClipper extends CustomClipper<Rect> {
  final double radius;

  CircleClipper(this.radius);

  @override
  Rect getClip(Size size) {
    return Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2), radius: radius);
  }

  @override
  bool shouldReclip(CircleClipper oldClipper) {
    return oldClipper.radius != radius;
  }
}
