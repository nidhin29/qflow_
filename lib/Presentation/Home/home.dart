import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:qflow/application/appointment/appointment_cubit.dart';
import 'package:qflow/application/appointment/appointment_state.dart';
import 'package:qflow/application/profile/profile_cubit.dart';
import 'package:qflow/application/profile/profile_state.dart';
import 'package:qflow/constants/const.dart';
import 'package:qflow/domain/appointment/appointment_model/appointment_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // PageController to handle swiping
    final PageController pageController = PageController();
    // ValueNotifier to track the current page index
    final ValueNotifier<int> currentPageNotifier = ValueNotifier<int>(0);

    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            left: 30.w,
            top: 81.h,
            right: 10.w,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      BlocBuilder<ProfileCubit, ProfileState>(
                        builder: (context, state) {
                          final userName = state.userOption.fold(
                            () => 'User',
                            (user) => '${user.firstName} ${user.lastName}',
                          );
                          return Text(
                            userName,
                            style: TextStyle(
                              fontSize: 21.45.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 25.h),
                    child: Container(
                        width: 56.w,
                        height: 56.h,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromRGBO(245, 245, 245, 1)),
                        child: Image.asset('assets/icon/not.png')),
                  )
                ],
              ),
              kheight10,
              kheight20,
              SizedBox(
                width: 362.w,
                height: 80.h,
                child: TextField(
                  cursorColor: const Color.fromRGBO(66, 132, 156, 1),
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      color: Color.fromRGBO(34, 34, 34, 1),
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  decoration: InputDecoration(
                    counterStyle: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        color: Color.fromRGBO(173, 173, 173, 1),
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    prefixIcon: TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        surfaceTintColor: Colors.white,
                        overlayColor: const Color.fromRGBO(173, 173, 173, 1),
                      ),
                      child: Container(
                        width: 28.w,
                        height: 28.h,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/icon/search1.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    hintText: 'Search',
                    hintStyle: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                            color: Color.fromRGBO(173, 173, 173, 1),
                            fontSize: 18,
                            fontWeight: FontWeight.w400)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.r),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: const Color.fromRGBO(248, 248, 248, 0.6),
                    contentPadding: EdgeInsets.symmetric(vertical: 25.h),
                  ),
                ),
              ),
              kheight20,
              Text('My Appointments',
                  style: GoogleFonts.dmSans(
                      textStyle: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color.fromRGBO(125, 125, 125, 1),
                  ))),
              kheight20,
              // Sliding Carousel
              BlocBuilder<AppointmentCubit, AppointmentState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state.upcomingAppointments.isEmpty) {
                    return const Center(child: Text('No upcoming appointments'));
                  }
                  return SizedBox(
                    height: 320.h,
                    child: PageView.builder(
                      controller: pageController,
                      itemCount: state.upcomingAppointments.length,
                      onPageChanged: (index) {
                        currentPageNotifier.value = index;
                      },
                      itemBuilder: (context, index) =>
                          _buildCard(state.upcomingAppointments[index]),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),

              // Page Indicator using ValueListenableBuilder
              Center(
                child: BlocBuilder<AppointmentCubit, AppointmentState>(
                  builder: (context, state) {
                    return ValueListenableBuilder<int>(
                      valueListenable: currentPageNotifier,
                      builder: (context, currentPage, _) {
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(
                              state.upcomingAppointments.length, (index) {
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              width: currentPage == index ? 60 : 25,
                              height: 6,
                              decoration: BoxDecoration(
                                color: currentPage == index
                                    ? const Color.fromRGBO(147, 147, 147, 1)
                                    : const Color.fromRGBO(230, 230, 230, 1),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            );
                          }),
                        );
                      },
                    );
                  },
                ),
              ),
              kheight20,
              Text('Previous Appointments',
                  style: GoogleFonts.dmSans(
                      textStyle: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color.fromRGBO(125, 125, 125, 1),
                  ))),

              BlocBuilder<AppointmentCubit, AppointmentState>(
                builder: (context, state) {
                  if (state.isLoading && state.pastAppointments.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final appointment = state.pastAppointments[index];
                      return Padding(
                        padding: EdgeInsets.only(right: 20.h),
                        child: Container(
                          width: 348.w,
                          height: 125.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.r),
                            border: Border.all(
                              color: const Color.fromRGBO(209, 209, 209, 1),
                            ),
                            color: const Color.fromRGBO(255, 255, 255, 1),
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 20.w),
                                child: const CircleAvatar(
                                  backgroundColor: Colors.grey,
                                  radius: 23,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 25.w, vertical: 8.w),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        appointment.hospitalName,
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        DateFormat('d MMM y').format(
                                            DateTime.parse(
                                                appointment.appointmentDate)),
                                        style: TextStyle(
                                          fontSize: 13.sp,
                                          fontFamily: 'CabinetGrotesk',
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(appointment.patientName,
                                          style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 13.sp,
                                            color: const Color.fromRGBO(
                                                145, 145, 145, 1),
                                          ))),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => kheight20,
                    itemCount: state.pastAppointments.length,
                  );
                },
              ),
              kheight20,
              kheight20,
              kheight20,
              kheight20,
            ],
          ),
        ),
      ),
    );
  }

  // Card Builder for Carousel
  Widget _buildCard(AppointmentModel appointment) {
    return Container(
      width: 318.w,
      height: 320.h,
      margin: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: const Color.fromRGBO(209, 209, 209, 1),
        ),
        color: const Color.fromRGBO(255, 255, 255, 1),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 17.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                kheight10,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [
                          Color.fromRGBO(38, 91, 138, 1),
                          Color.fromRGBO(88, 135, 177, 1),
                          Color.fromRGBO(148, 188, 224, 1),
                          Color.fromRGBO(182, 219, 251, 1),
                          Color.fromRGBO(38, 91, 138, 1),
                        ],
                        tileMode: TileMode.mirror,
                      ).createShader(bounds),
                      child: Text(
                        'Out Patient\nTICKET',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: 'CabinetGrotesk',
                          fontSize: 26.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat('d MMM').format(
                              DateTime.parse(appointment.appointmentDate)),
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontFamily: 'CabinetGrotesk',
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          DateFormat('y').format(
                              DateTime.parse(appointment.appointmentDate)),
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontFamily: 'CabinetGrotesk',
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                kheight5,
                Text(
                  appointment.hospitalName,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontFamily: 'CabinetGrotesk',
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                kheight5,
                Text(appointment.hospitalAddress,
                    style: GoogleFonts.dmSans(
                        textStyle: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 15.sp,
                      color: Colors.black,
                    ))),
                kheight5,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    BookTileWidget(
                      heading: 'Estimated Time',
                      content: appointment.estimatedTime,
                    ),
                    kwidth5,
                    kwidth5,
                    kwidth5,
                    kwidth5,
                    kwidth5,
                    kwidth5,
                    kwidth5,
                    kwidth5,
                    BookTileWidget(
                        heading: 'OP Ticket Number',
                        content: '#${appointment.tokenNumber}'),
                    kwidth5,
                    kwidth5,
                  ],
                ),
                kheight5,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    BookTileWidget(
                      heading: 'Patient',
                      content: appointment.patientName,
                    ),
                    kwidth5,
                    kwidth5,
                    kwidth5,
                    kwidth5,
                    kwidth5,
                    kwidth5,
                    kwidth5,
                    kwidth5,
                    BookTileWidget(
                        heading: 'Department',
                        content: appointment.departmentName),
                    kwidth5,
                    kwidth5,
                    kwidth5,
                    kwidth5,
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BookTileWidget extends StatelessWidget {
  final String heading;
  final String content;
  const BookTileWidget({
    super.key,
    required this.heading,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          heading,
          style: GoogleFonts.dmSans(
            textStyle: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 10.sp,
              color: const Color.fromRGBO(
                191,
                191,
                191,
                1,
              ),
            ),
          ),
        ),
        Text(
          content,
          style: TextStyle(
            fontSize: 20.sp,
            fontFamily: 'CabinetGrotesk',
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
