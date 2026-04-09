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
import 'package:qflow/Presentation/Home/home_shimmer.dart';
import 'package:qflow/Presentation/Core/empty_state_widget.dart';
import 'package:qflow/Presentation/Core/error_state_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // PageController to handle swiping
  final PageController pageController = PageController();
  // ValueNotifier to track the current page index
  final ValueNotifier<int> currentPageNotifier = ValueNotifier<int>(0);
  // Controller for the search field
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch appointments on load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshData();
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    currentPageNotifier.dispose();
    searchController.dispose();
    super.dispose();
  }

  Future<void> _refreshData() async {
    final appointmentCubit = context.read<AppointmentCubit>();
    await Future.wait([
      appointmentCubit.getUpcomingAppointments(),
      appointmentCubit.getPastAppointments(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: const Color.fromRGBO(66, 132, 156, 1),
        backgroundColor: Colors.white,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
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
                    controller: searchController,
                    onChanged: (value) {
                      context.read<AppointmentCubit>().searchAppointments(value);
                    },
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(15.w),
                        child: Image.asset(
                          "assets/icon/search1.png",
                          color: Colors.grey[400],
                        ),
                      ),
                      suffixIcon: searchController.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.clear, color: Colors.grey[400]),
                              onPressed: () {
                                searchController.clear();
                                context.read<AppointmentCubit>().clearSearch();
                              },
                            )
                          : null,
                      hintText: 'Search',
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
                BlocBuilder<AppointmentCubit, AppointmentState>(
                  builder: (context, state) {
                    if (state.isSearching) {
                      return Text('Search Results',
                          style: GoogleFonts.dmSans(
                              textStyle: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color.fromRGBO(39, 39, 39, 1),
                          )));
                    }
                    return Text('My Appointments',
                        style: GoogleFonts.dmSans(
                            textStyle: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color.fromRGBO(39, 39, 39, 1),
                        )));
                  },
                ),
                SizedBox(height: 20.h),
                // Sliding Carousel
                BlocConsumer<AppointmentCubit, AppointmentState>(
                  listener: (context, state) {
                    state.failureOrSuccessOption.fold(
                      () => null,
                      (either) => either.fold(
                        (failure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(failure.map(
                                clientFailure: (_) => 'Network Error',
                                authFailure: (_) => 'Session Expired',
                                serverFailure: (_) => 'Server Error',
                                serverError: (e) => e.message ?? 'Server error',
                              )),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        },
                        (_) => null,
                      ),
                    );
                  },
                  builder: (context, state) {
                    final displayedAppointments = state.isSearching
                        ? state.searchResults
                        : state.upcomingAppointments;

                    if (state.isLoading) {
                      return SizedBox(
                        height: 300.h,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          itemCount: 2,
                          itemBuilder: (context, index) =>
                              const AppointmentCardShimmer(),
                        ),
                      );
                    }

                    if (displayedAppointments.isEmpty) {
                      return state.failureOrSuccessOption.fold(
                        () => SizedBox(
                          height: 300.h,
                          child: EmptyStateWidget(
                            title: state.isSearching
                                ? 'No Results'
                                : 'No Appointments',
                            description: state.isSearching
                                ? 'No appointments found matching your search.'
                                : 'You have no upcoming appointments scheduled.',
                          ),
                        ),
                        (either) => either.fold(
                          (failure) => SizedBox(
                            height: 300.h,
                            child: ErrorStateWidget(
                              errorMessage: failure.map(
                                clientFailure: (_) =>
                                    'Please check your internet connection.',
                                authFailure: (_) =>
                                    'Your session has expired. Please log in again.',
                                serverFailure: (_) =>
                                    'We are having trouble reaching our servers.',
                                serverError: (e) =>
                                    e.message ?? 'A server error occurred.',
                              ),
                              onRetry: () => state.isSearching
                                  ? context
                                      .read<AppointmentCubit>()
                                      .searchAppointments(searchController.text)
                                  : context
                                      .read<AppointmentCubit>()
                                      .getUpcomingAppointments(),
                            ),
                          ),
                          (_) => SizedBox(
                            height: 300.h,
                            child: EmptyStateWidget(
                              title: state.isSearching
                                  ? 'No Results'
                                  : 'No Appointments',
                              description: state.isSearching
                                  ? 'No appointments found matching your search.'
                                  : 'You have no upcoming appointments scheduled.',
                            ),
                          ),
                        ),
                      );
                    }
                    return SizedBox(
                      height: 300.h,
                      child: PageView.builder(
                        controller: pageController,
                        itemCount: displayedAppointments.length,
                        onPageChanged: (index) {
                          currentPageNotifier.value = index;
                        },
                        itemBuilder: (context, index) =>
                            _buildCard(displayedAppointments[index]),
                      ),
                    );
                  },
                ),
                SizedBox(height: 15.h),

                // Page Indicator
                Center(
                  child: BlocBuilder<AppointmentCubit, AppointmentState>(
                    builder: (context, state) {
                      final list = state.isSearching
                          ? state.searchResults
                          : state.upcomingAppointments;
                      if (list.isEmpty) return const SizedBox();
                      return ValueListenableBuilder<int>(
                        valueListenable: currentPageNotifier,
                        builder: (context, currentPage, _) {
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(list.length, (index) {
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 4),
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
                BlocBuilder<AppointmentCubit, AppointmentState>(
                  builder: (context, state) {
                    if (state.isSearching) return const SizedBox();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Previous Appointments',
                            style: GoogleFonts.dmSans(
                                textStyle: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color.fromRGBO(39, 39, 39, 1),
                            ))),
                        SizedBox(height: 15.h),
                      ],
                    );
                  },
                ),

                BlocBuilder<AppointmentCubit, AppointmentState>(
                  builder: (context, state) {
                    if (state.isSearching) return const SizedBox();
                    if (state.isLoading && state.pastAppointments.isEmpty) {
                      return const PreviousAppointmentShimmer();
                    }
                    if (state.pastAppointments.isEmpty && !state.isLoading) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.h),
                        child: const EmptyStateWidget(
                          title: 'No History',
                          description: 'Your previous appointment history will appear here.',
                        ),
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
                            border: Border.all(
                                color: const Color.fromRGBO(240, 240, 240, 1)),
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
                                  child: Icon(Icons.local_hospital_outlined,
                                      color: const Color(0xFF1A3955)),
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
                                    Row(
                                      children: [
                                        Text(
                                          DateFormat('dd MMM yyyy').format(
                                              DateTime.parse(
                                                  appointment.appointmentDate)),
                                          style: TextStyle(
                                            fontSize: 11.sp,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey[500],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      appointment.patientName,
                                      style: TextStyle(
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey[400],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 12.h),
                      itemCount: state.pastAppointments.length,
                    );
                  },
                ),
              ],
            ),
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
                Column(
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
                        'Out Patient\nTICKET',
                        style: TextStyle(
                          fontFamily: 'CabinetGrotesk',
                          fontSize: 28.sp,
                          height: 0.9,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    if (appointment.currentlyServing != null)
                      Padding(
                        padding: EdgeInsets.only(top: 4.h),
                        child: Text(
                          'Currently Serving: #${appointment.currentlyServing}',
                          style: GoogleFonts.dmSans(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF2C5E8A).withOpacity(0.7),
                          ),
                        ),
                      ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      DateFormat('dd MMM')
                          .format(DateTime.parse(appointment.appointmentDate)),
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[400],
                      ),
                    ),
                    Text(
                      DateFormat('yyyy')
                          .format(DateTime.parse(appointment.appointmentDate)),
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
                  heading: 'Estimated Time',
                  content: appointment.appointmentTime,
                ),
                BookTileWidget(
                  heading: 'OP Ticket Number',
                  content: '#${appointment.tokenNumber}',
                ),
              ],
            ),
            SizedBox(height: 15.h),
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
