import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qflow/Presentation/Home/home.dart';
import 'package:qflow/Presentation/Member/member.dart';
import 'package:qflow/Presentation/Profile/profile.dart';
import 'package:qflow/application/appointment/appointment_cubit.dart';
import 'package:qflow/application/profile/profile_cubit.dart';
import 'package:qflow/application/member/member_cubit.dart';
import 'package:qflow/domain/core/di/injection.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  static final ValueNotifier<int> _selectedIndexNotifier =
      ValueNotifier<int>(0);
  static final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<AppointmentCubit>()
            ..getUpcomingAppointments()
            ..getPastAppointments(),
        ),
        BlocProvider(
          create: (context) => getIt<ProfileCubit>()..getUserDetails(),
        ),
        BlocProvider(
          create: (context) => getIt<MemberCubit>(),
        ),
      ],
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            PageView(
              controller: _pageController,
              onPageChanged: (index) {
                _selectedIndexNotifier.value = index;
              },
              children: const [
                HomeScreen(),
                MemberScreen(),
                ProfileScreen(),
              ],
            ),
            Positioned(
              bottom: 15.h,
              left: 0,
              right: 0,
              child: CustomNavBar(
                selectedIndexNotifier: _selectedIndexNotifier,
                pageController: _pageController,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class PageContent extends StatelessWidget {
//   final ValueNotifier<int> selectedIndexNotifier;

//   const PageContent({super.key, required this.selectedIndexNotifier});

//   @override
//   Widget build(BuildContext context) {
//     return ValueListenableBuilder<int>(
//       valueListenable: selectedIndexNotifier,
//       builder: (context, selectedIndex, _) {
//         return IndexedStack(
//           index: selectedIndex,
//           children: [
//             const HomeScreen(),
//             MemberScreen(),
//             const ProfileScreen(),
//           ],
//         );
//       },
//     );
//   }
// }

class CustomNavBar extends StatelessWidget {
  final ValueNotifier<int> selectedIndexNotifier;
  final PageController pageController;
  const CustomNavBar(
      {super.key,
      required this.selectedIndexNotifier,
      required this.pageController});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 85.h,
        width: 245.w,
        margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(79, 79, 79, 0.11),
          borderRadius: BorderRadius.circular(35),
          // boxShadow: const [
          //   BoxShadow(
          //     color: Colors.black26,
          //     blurRadius: 10,
          //     offset: Offset(0, 4),
          //   ),
          // ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            NavBarItem(
              imagePath: 'assets/icon/ticket.png',
              index: 0,
              notifier: selectedIndexNotifier,
              pageController: pageController,
            ),
            NavBarItem(
              imagePath: 'assets/icon/home.png',
              index: 1,
              notifier: selectedIndexNotifier,
              pageController: pageController,
            ),
            NavBarItem(
              imagePath: 'assets/icon/profile.png',
              index: 2,
              notifier: selectedIndexNotifier,
              pageController: pageController,
              isCenterIcon: true,
            ),
          ],
        ),
      ),
    );
  }
}

class NavBarItem extends StatelessWidget {
  final String imagePath;
  final int index;
  final ValueNotifier<int> notifier;
  final PageController pageController;
  final bool isCenterIcon;

  const NavBarItem({
    super.key,
    required this.imagePath,
    required this.index,
    required this.notifier,
    this.isCenterIcon = false,
    required this.pageController,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: notifier,
      builder: (context, selectedIndex, _) {
        final bool isSelected = selectedIndex == index;

        return GestureDetector(
          onTap: () {
            notifier.value = index;
            pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeInOut,
            );
          },
          child: Container(
            width: 70.w,
            height: 72.h,
            decoration: BoxDecoration(
              color: !isSelected
                  ? const Color.fromRGBO(255, 255, 255, 0.22)
                  : const Color.fromRGBO(253, 253, 253, 1),
              shape: BoxShape.circle,

              border: BoxBorder.lerp(
                Border.all(
                  color: const Color.fromRGBO(247, 247, 247, 1),
                  width: 0,
                ),
                Border.all(
                  color: Colors.white,
                  width: 1,
                ),
                1,
              ),
              // boxShadow: isSelected
              //     ? const [
              //         BoxShadow(
              //           color: Colors.black26,
              //           blurRadius: 8,
              //           offset: Offset(0, 4),
              //         ),
              //       ]
              //     : null,
            ),
            child: Center(
              child: SizedBox(
                width: 20.w,
                height: 22.h,
                child: Image.asset(
                  imagePath,
                  color: Colors.black,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
