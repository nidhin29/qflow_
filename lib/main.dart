import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qflow/application/appointment/appointment_cubit.dart';
import 'package:qflow/application/member/member_cubit.dart';
import 'package:qflow/application/profile/profile_cubit.dart';
import 'package:qflow/application/hospital/hospital_cubit.dart';
import 'package:qflow/Presentation/Splash/splash.dart';
import 'package:qflow/domain/core/di/injection.dart';
import 'package:qflow/domain/auth/app_session.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureInjection();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(412, 917),
      splitScreenMode: true,
      minTextAdapt: true,
      child: Provider<AppSession>(
        create: (_) => getIt<AppSession>(),
        child: MultiBlocProvider(
          providers: [
            BlocProvider<ProfileCubit>(
              create: (context) => getIt<ProfileCubit>()..getUserDetails(),
            ),
            BlocProvider<MemberCubit>(
              create: (context) => getIt<MemberCubit>()..getMembers(),
            ),
            BlocProvider<AppointmentCubit>(
              create: (context) => getIt<AppointmentCubit>()
                ..getUpcomingAppointments()
                ..getPastAppointments(),
            ),
            BlocProvider<HospitalCubit>(
              create: (context) {
                final session = getIt<AppSession>();
                final location = session.city ?? session.district ?? 'Chengannur';
                return getIt<HospitalCubit>()
                  ..getHospitalsByLocation(location: location);
              },
            ),
          ],
          child: MaterialApp(
            title: 'Q Flow',
            debugShowCheckedModeBanner: false,
            home: const SplashScreen(),
            theme: ThemeData(
              fontFamily: 'MonumentExtended',
              textSelectionTheme: const TextSelectionThemeData(
                cursorColor: Colors.grey,
              ),
              textButtonTheme: TextButtonThemeData(
                style: ButtonStyle(
                  overlayColor: WidgetStateProperty.all(Colors.grey.shade100),
                ),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ButtonStyle(
                  overlayColor: WidgetStateProperty.all(Colors.grey.shade100),
                ),
              ),
              progressIndicatorTheme: const ProgressIndicatorThemeData(
                color: Colors.grey,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
