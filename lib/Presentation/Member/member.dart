import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qflow/Presentation/Member/booking.dart';
import 'package:qflow/Presentation/Member/member_shimmer.dart';
import 'package:qflow/Presentation/Member/search.dart';
import 'package:qflow/constants/const.dart';
import 'package:qflow/domain/core/di/injection.dart';
import 'package:qflow/Presentation/Hospital/hospital_details_page.dart';
import 'package:qflow/application/hospital/hospital_cubit.dart';
import 'package:qflow/application/hospital/hospital_state.dart';
import 'package:qflow/application/profile/profile_cubit.dart';
import 'package:qflow/application/profile/profile_state.dart';
import 'package:qflow/domain/auth/app_session.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qflow/Presentation/Core/empty_state_widget.dart';
import 'package:qflow/Presentation/Core/error_state_widget.dart';

class MemberScreen extends StatelessWidget {
  const MemberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ValueNotifier<bool> isSearching = ValueNotifier(false);

    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            left: 25.w,
            right: 25.w,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              kheight20,
              kheight10,
              kheight20,
              kheight20,
              //  kheight20,
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: ValueListenableBuilder<bool>(
                      valueListenable: isSearching,
                      builder: (context, searching, child) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BlocBuilder<ProfileCubit, ProfileState>(
                              builder: (context, profileState) {
                                final city = profileState.userOption.fold(
                                  () =>
                                      getIt<AppSession>().city ?? 'Chengannur',
                                  (user) => user.city.isEmpty
                                      ? 'Chengannur'
                                      : user.city,
                                );
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Location',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14.5.sp,
                                          color: const Color.fromRGBO(
                                              89, 89, 89, 1)),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            PageRouteBuilder(
                                                pageBuilder: (context,
                                                        animation,
                                                        secondaryAnimation) =>
                                                    SearchPage(
                                                      label: 'Location',
                                                    ),
                                                transitionsBuilder: (context,
                                                    animation,
                                                    secondaryAnimation,
                                                    child) {
                                                  const begin =
                                                      Offset(1.0, 0.0);
                                                  const end = Offset.zero;
                                                  const curve =
                                                      Curves.easeInOut;

                                                  var tween = Tween(
                                                          begin: begin,
                                                          end: end)
                                                      .chain(CurveTween(
                                                          curve: curve));
                                                  var offsetAnimation =
                                                      animation.drive(tween);

                                                  return SlideTransition(
                                                    position: offsetAnimation,
                                                    child: child,
                                                  );
                                                },
                                                transitionDuration:
                                                    const Duration(
                                                        microseconds: 700000)));
                                      },
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        minimumSize: Size.zero,
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        surfaceTintColor: Colors.white,
                                        overlayColor:
                                            const Color.fromRGBO(89, 89, 89, 1),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            city,
                                            style: GoogleFonts.ptSans(
                                              textStyle: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 18.57.sp,
                                                color: const Color.fromRGBO(
                                                    66, 132, 156, 1),
                                              ),
                                            ),
                                          ),
                                          kwidth5,
                                          const Icon(
                                            Icons.arrow_forward_ios,
                                            color:
                                                Color.fromRGBO(89, 89, 89, 1),
                                            size: 12,
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 10.w, top: 5.h),
                              child: TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(PageRouteBuilder(
                                      pageBuilder: (context, animation,
                                              secondaryAnimation) =>
                                          SearchPage(
                                            label: 'Search',
                                          ),
                                      transitionsBuilder: (context, animation,
                                          secondaryAnimation, child) {
                                        const begin = Offset(1.0, 0.0);
                                        const end = Offset.zero;
                                        const curve = Curves.easeInOut;

                                        var tween = Tween(
                                                begin: begin, end: end)
                                            .chain(CurveTween(curve: curve));
                                        var offsetAnimation =
                                            animation.drive(tween);

                                        return SlideTransition(
                                          position: offsetAnimation,
                                          child: child,
                                        );
                                      },
                                      transitionDuration: const Duration(
                                          microseconds: 700000)));
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  surfaceTintColor: Colors.white,
                                  overlayColor:
                                      const Color.fromRGBO(89, 89, 89, 1),
                                ),
                                child: Container(
                                  width: 28.w,
                                  height: 28.h,
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      image:
                                          AssetImage("assets/icon/search.png"),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
              kheight20,
              Text(
                'Find your\nHospital Near Me',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontFamily: 'TestSohne',
                  fontSize: 28.sp,
                  color: const Color.fromRGBO(89, 89, 89, 1),
                ),
              ),
              kheight20,
              kheight20,
              kheight15,
              kheight10,
              BlocConsumer<HospitalCubit, HospitalState>(
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
                  if (state.isLoading && state.hospitals.isEmpty) {
                    return SizedBox(
                      height: 509.h,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: 2,
                        separatorBuilder: (context, index) =>
                            SizedBox(width: 15.w),
                        itemBuilder: (context, index) =>
                            const HospitalCardShimmer(),
                      ),
                    );
                  }

                  if (state.hospitals.isEmpty) {
                    return state.failureOrSuccessOption.fold(
                      () => SizedBox(
                        height: 509.h,
                        child: const EmptyStateWidget(
                          title: 'No Hospitals Found',
                          description:
                              'We couldn’t find any hospitals in this location.',
                        ),
                      ),
                      (either) => either.fold(
                        (failure) => SizedBox(
                          height: 509.h,
                          child: ErrorStateWidget(
                            errorMessage: failure.map(
                              clientFailure: (_) =>
                                  'Check your internet connection.',
                              authFailure: (_) =>
                                  'You need to be logged in to search hospitals.',
                              serverFailure: (_) =>
                                  'Server is currently unreachable.',
                              serverError: (e) => e.message ?? 'Search failed.',
                            ),
                            onRetry: () => context
                                .read<HospitalCubit>()
                                .getHospitalsByLocation(
                                  location:
                                      getIt<AppSession>().city ?? 'Chengannur',
                                ),
                          ),
                        ),
                        (_) => SizedBox(
                          height: 509.h,
                          child: const EmptyStateWidget(
                            title: 'No Hospitals Found',
                            description:
                                'We couldn’t find any hospitals in this location.',
                          ),
                        ),
                      ),
                    );
                  }

                  return SizedBox(
                    height: 509.h,
                    child: ListView.separated(
                        itemCount: state.hospitals.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final hospital = state.hospitals[index];
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      HospitalDetailsPage(hospital: hospital),
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(20.r),
                            child: Container(
                              width: 315.w,
                              height: 509.h,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(20.r),
                                boxShadow: [
                                  BoxShadow(
                                    // ignore: deprecated_member_use
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 4,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  // 1. Thumbnail (Loads first/Fallback)
                                  Positioned.fill(
                                    child: Image(
                                      image: (hospital.thumbnailUrl != null &&
                                              hospital.thumbnailUrl!.isNotEmpty)
                                          ? NetworkImage(hospital.thumbnailUrl!)
                                          : const AssetImage(
                                                  'assets/icon/hospital.jpeg')
                                              as ImageProvider,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, _, __) =>
                                          Image.asset(
                                              'assets/icon/hospital.jpeg',
                                              fit: BoxFit.cover),
                                    ),
                                  ),
                                  // 2. Profile Image (Higher res, fades in over thumbnail)
                                  if (hospital.profileImageUrl != null &&
                                      hospital.profileImageUrl!.isNotEmpty)
                                    Positioned.fill(
                                      child: FadeInImage(
                                        placeholder: (hospital.thumbnailUrl !=
                                                    null &&
                                                hospital
                                                    .thumbnailUrl!.isNotEmpty)
                                            ? NetworkImage(
                                                hospital.thumbnailUrl!)
                                            : const AssetImage(
                                                    'assets/icon/hospital.jpeg')
                                                as ImageProvider,
                                        image: NetworkImage(
                                            hospital.profileImageUrl!),
                                        fit: BoxFit.cover,
                                        fadeInDuration:
                                            const Duration(milliseconds: 500),
                                        imageErrorBuilder: (context, _, __) =>
                                            const SizedBox.shrink(),
                                      ),
                                    ),
                                  // 3. Gradient Overlay
                                  Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.black.withOpacity(0.9),
                                            Colors.black.withOpacity(0.5),
                                            Colors.transparent,
                                          ],
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // 4. Content
                                  Positioned(
                                    left: 0,
                                    right: 0,
                                    bottom: 0,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15.w, vertical: 20.h),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            hospital.name,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w900,
                                              fontFamily: 'CabinetGrotesk',
                                              fontSize: 32.sp,
                                              color: Colors.white,
                                              height: 1.0,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(height: 6.h),
                                          Text(hospital.city,
                                              style: GoogleFonts.dmSans(
                                                  textStyle: TextStyle(
                                                fontWeight: FontWeight.w800,
                                                fontSize: 16.sp,
                                                color: Colors.white,
                                              ))),
                                          SizedBox(height: 15.h),
                                          SizedBox(
                                            height: 28.h,
                                            child: ListView.separated(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: hospital
                                                  .availableServices.length,
                                              separatorBuilder: (context, _) =>
                                                  SizedBox(width: 8.w),
                                              itemBuilder: (context, sIdx) {
                                                return Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 14.w),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white
                                                        // ignore: deprecated_member_use
                                                        .withOpacity(0.25),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.r),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      hospital.availableServices[
                                                          sIdx],
                                                      style: GoogleFonts.dmSans(
                                                        fontSize: 11.sp,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          SizedBox(height: 20.h),
                                          Row(
                                            children: [
                                              const Spacer(),
                                              ElevatedButton(
                                                onPressed: () {
                                                  context
                                                      .read<HospitalCubit>()
                                                      .getHospitalById(
                                                          hospitalId:
                                                              hospital.id);
                                                  Navigator.of(context).push(
                                                    PageRouteBuilder(
                                                        pageBuilder: (context,
                                                                animation,
                                                                secondaryAnimation) =>
                                                            BookingPage(
                                                          hospitalId:
                                                              hospital.id,
                                                        ),
                                                        transitionsBuilder:
                                                            (context,
                                                                animation,
                                                                secondaryAnimation,
                                                                child) {
                                                          const begin =
                                                              Offset(1.0, 0.0);
                                                          const end =
                                                              Offset.zero;
                                                          const curve =
                                                              Curves.easeInOut;

                                                          var tween = Tween(
                                                                  begin: begin,
                                                                  end: end)
                                                              .chain(CurveTween(
                                                                  curve:
                                                                      curve));

                                                          return SlideTransition(
                                                            position: animation
                                                                .drive(tween),
                                                            child: child,
                                                          );
                                                        },
                                                        transitionDuration:
                                                            const Duration(
                                                                microseconds:
                                                                    700000)),
                                                  );
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.white,
                                                  foregroundColor: Colors.black,
                                                  elevation: 8,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 20.w,
                                                      vertical: 14.h),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30.r),
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      'Get your Ticket Here',
                                                      style: GoogleFonts.dmSans(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 12.sp,
                                                      ),
                                                    ),
                                                    SizedBox(width: 10.w),
                                                    Icon(Icons.arrow_forward,
                                                        size: 18.sp,
                                                        weight: 800),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => kwidth20),
                  );
                },
              ),

              kheight100,
              kheight20,
              kheight20,
            ],
          ),
        ),
      ),
    );
  }
}
