import 'package:flutter/material.dart';
import 'package:qflow/Presentation/Auth/start.dart';
import 'package:qflow/Presentation/Home/mainscreen.dart';
import 'package:qflow/domain/auth/app_session.dart';
import 'package:qflow/domain/core/di/injection.dart';
import 'package:qflow/domain/user/user_service.dart';

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
    animcontroller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000));
    animation =
        CurvedAnimation(parent: animcontroller, curve: Curves.easeInOut);

    animcontroller.forward();
    _initApp();
  }

  Future<void> _initApp() async {
    final startTime = DateTime.now();

    // 1. Show animation start
    _startAnimation();

    // 2. Initialize Session (load tokens from storage)
    final session = getIt<AppSession>();
    await session.initialize();

    Widget targetPage = const StartPage();

    // 3. Check Auth Status if tokens exist
    if (session.isLoggedIn) {
      final userService = getIt<IUserService>();
      final result = await userService.getUserDetails();
      
      if (result.isRight()) {
        targetPage = const MainScreen();
      } else {
        // If getting details fails (e.g. refresh token expired)
        targetPage = const StartPage();
      }
    }

    // 4. Ensure minimum splash time (2 seconds for animation)
    final elapsed = DateTime.now().difference(startTime);
    if (elapsed < const Duration(seconds: 2)) {
      await Future.delayed(const Duration(seconds: 2) - elapsed);
    }

    if (mounted) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => targetPage,
      ));
    }
  }

  void _startAnimation() {
    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) {
        setState(() {
          _radius = 80.0;
        });
      }
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
