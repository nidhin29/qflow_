import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:qflow/application/appointment/appointment_cubit.dart';
import 'package:qflow/application/appointment/appointment_state.dart';
import 'package:qflow/application/profile/profile_cubit.dart';
import 'package:qflow/application/profile/profile_state.dart';
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
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 70.h),
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
                          color: Colors.grey[600],
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
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'CabinetGrotesk',
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  Container(
                    width: 50.w,
                    height: 50.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color.fromRGBO(245, 245, 245, 1),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/icon/not.png',
                        width: 24.w,
                        height: 24.w,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 25.h),
              SizedBox(
                height: 55.h,
                child: TextField(
                  cursorColor: const Color.fromRGBO(66, 132, 156, 1),
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      color: const Color.fromRGBO(34, 34, 34, 1),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(15.w),
                      child: Image.asset(
                        "assets/icon/search1.png",
                        color: Colors.grey[400],
                      ),
                    ),
                    hintText: 'Search appointments...',
                    hintStyle: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.r),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: const Color.fromRGBO(248, 248, 248, 1),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              SizedBox(height: 30.h),
              Text('My Appointments',
                  style: GoogleFonts.dmSans(
                      textStyle: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color.fromRGBO(39, 39, 39, 1),
                  ))),
              SizedBox(height: 20.h),
              // Sliding Carousel
              BlocBuilder<AppointmentCubit, AppointmentState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return SizedBox(
                      height: 280.h,
                      child: const Center(child: CircularProgressIndicator(color: Colors.greenAccent)),
                    );
                  }
                  if (state.upcomingAppointments.isEmpty) {
                    return Container(
                      height: 150.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(color: Colors.grey[100]!),
                      ),
                      child: Center(
                        child: Text(
                          'No upcoming appointments',
                          style: GoogleFonts.dmSans(color: Colors.grey),
                        ),
                      ),
                    );
                  }
                  return SizedBox(
                    height: 280.h,
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
              SizedBox(height: 15.h),

              // Page Indicator
              Center(
                child: BlocBuilder<AppointmentCubit, AppointmentState>(
                  builder: (context, state) {
                    if (state.upcomingAppointments.isEmpty) return const SizedBox();
                    return ValueListenableBuilder<int>(
                      valueListenable: currentPageNotifier,
                      builder: (context, currentPage, _) {
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(
                              state.upcomingAppointments.length, (index) {
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: currentPage == index ? 24.w : 8.w,
                              height: 4.h,
                              decoration: BoxDecoration(
                                color: currentPage == index
                                    ? Colors.black
                                    : Colors.grey[200],
                                borderRadius: BorderRadius.circular(2),
                              ),
                            );
                          }),
                        );
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: 35.h),
              Text('Previous Activity',
                  style: GoogleFonts.dmSans(
                      textStyle: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color.fromRGBO(39, 39, 39, 1),
                  ))),
              SizedBox(height: 15.h),

              BlocBuilder<AppointmentCubit, AppointmentState>(
                builder: (context, state) {
                  if (state.isLoading && state.pastAppointments.isEmpty) {
                    return const Center(child: CircularProgressIndicator(color: Colors.greenAccent));
                  }
                  if (state.pastAppointments.isEmpty && !state.isLoading) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      child: Center(child: Text('No previous appointments', style: GoogleFonts.dmSans(color: Colors.grey))),
                    );
                  }
                  return ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.only(bottom: 100.h),
                    itemBuilder: (context, index) {
                      final appointment = state.pastAppointments[index];
                      return Container(
                        padding: EdgeInsets.all(15.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18.r),
                          color: Colors.white,
                          border: Border.all(color: const Color.fromRGBO(240, 240, 240, 1)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 50.w,
                              height: 50.w,
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Center(
                                child: Icon(Icons.local_hospital_outlined, color: Colors.grey[400]),
                              ),
                            ),
                            SizedBox(width: 15.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    appointment.hospitalName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Row(
                                    children: [
                                      Text(
                                        DateFormat('dd MMM yyyy').format(
                                            DateTime.parse(appointment.appointmentDate)),
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey[500],
                                        ),
                                      ),
                                      Container(
                                        width: 3.w,
                                        height: 3.w,
                                        margin: EdgeInsets.symmetric(horizontal: 8.w),
                                        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey[300]),
                                      ),
                                      Text(
                                        appointment.patientName,
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey[500],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Text(
                                'Done',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => SizedBox(height: 12.h),
                    itemCount: state.pastAppointments.length,
                  );
                },
              ),
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
      margin: EdgeInsets.only(right: 15.w, bottom: 5.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: const Color.fromRGBO(245, 245, 245, 1)),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [
                      Color(0xFF1A3955),
                      Color(0xFF2C5E8A),
                      Color(0xFF4A8CC7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds),
                  child: Text(
                    'OP\nTICKET',
                    style: TextStyle(
                      fontFamily: 'CabinetGrotesk',
                      fontSize: 28.sp,
                      height: 0.9,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      DateFormat('dd MMM').format(DateTime.parse(appointment.appointmentDate)),
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[400],
                      ),
                    ),
                    Text(
                      DateFormat('yyyy').format(DateTime.parse(appointment.appointmentDate)),
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontFamily: 'CabinetGrotesk',
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 15.h),
            Text(
              appointment.hospitalName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 18.sp,
                fontFamily: 'CabinetGrotesk',
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              appointment.hospitalAddress,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.dmSans(
                textStyle: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 13.sp,
                  color: Colors.grey[500],
                ),
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BookTileWidget(
                  heading: 'Patient',
                  content: appointment.patientName,
                ),
                BookTileWidget(
                  heading: 'Department',
                  content: appointment.departmentName,
                ),
              ],
            ),
            SizedBox(height: 15.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BookTileWidget(
                  heading: 'Estimated Time',
                  content: appointment.estimatedTime,
                ),
                BookTileWidget(
                  heading: 'Ticket Number',
                  content: '#${appointment.tokenNumber}',
                  isPrimary: true,
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
  final bool isPrimary;
  const BookTileWidget({
    super.key,
    required this.heading,
    required this.content,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          heading.toUpperCase(),
          style: GoogleFonts.dmSans(
            textStyle: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 9.sp,
              letterSpacing: 0.5,
              color: Colors.grey[400],
            ),
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          content,
          style: TextStyle(
            fontSize: 16.sp,
            fontFamily: 'CabinetGrotesk',
            fontWeight: FontWeight.w700,
            color: isPrimary ? const Color(0xFF2C5E8A) : Colors.black,
          ),
        ),
      ],
    );
  }
}
