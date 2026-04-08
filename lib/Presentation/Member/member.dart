import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qflow/Presentation/Member/booking.dart';
import 'package:qflow/Presentation/Member/search.dart';
import 'package:qflow/Presentation/common/file_widget.dart';
import 'package:qflow/constants/const.dart';

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
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Location',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14.5.sp,
                                      color:
                                          const Color.fromRGBO(89, 89, 89, 1)),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).push(PageRouteBuilder(
                                        pageBuilder: (context, animation,
                                                secondaryAnimation) =>
                                            SearchPage(
                                              label: 'Location',
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
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Chengannur',
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
                                        color: Color.fromRGBO(89, 89, 89, 1),
                                        size: 12,
                                      )
                                    ],
                                  ),
                                ),
                              ],
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
              Text('Recommended',
                  style: GoogleFonts.ptSansCaption(
                    fontWeight: FontWeight.w600,
                    fontSize: 18.57.sp,
                    color: const Color.fromRGBO(89, 89, 89, 1),
                  )),
              kheight20,
              SizedBox(
                height: 509.h,
                child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Container(
                          width: 315.w,
                          height: 509.h,
                          decoration: BoxDecoration(
                            image: const DecorationImage(
                                image: AssetImage('assets/icon/hospital.jpeg'),
                                fit: BoxFit.cover),
                            boxShadow: [
                              BoxShadow(
                                // ignore: deprecated_member_use
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Column(
                              verticalDirection: VerticalDirection.up,
                              children: [
                                Container(
                                  width: 324.w,
                                  height: 210.h,
                                  decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(20),
                                          bottomRight: Radius.circular(20)),
                                      gradient: LinearGradient(
                                        colors: [
                                          Color.fromRGBO(0, 0, 0, 1),
                                          Color.fromRGBO(0, 0, 0, 0)
                                        ],
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                      )),
                                  child: Padding(
                                    padding:
                                        EdgeInsets.only(left: 9.w, right: 9.w),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Dr. KM Cherian Institute of Medical Science',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontFamily: 'CabinetGrotesk',
                                            fontSize: 24.sp,
                                            color: const Color.fromRGBO(
                                                255, 255, 255, 1),
                                          ),
                                        ),
                                        Text('Kallishery',
                                            style: GoogleFonts.dmSans(
                                                textStyle: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 13.sp,
                                              color: const Color.fromRGBO(
                                                  255, 255, 255, 1),
                                            ))),
                                        kheight10,
                                        SizedBox(
                                          height: 20.h,
                                          child: FieldsWidget(
                                            color: const Color.fromRGBO(
                                                255, 255, 255, 1),
                                            color1: const Color.fromRGBO(
                                                    // ignore: deprecated_member_use
                                                    133,
                                                    136,
                                                    153,
                                                    1)
                                                // ignore: deprecated_member_use
                                                .withOpacity(0.5),
                                          ),
                                        ),
                                        kheight20,
                                        Row(
                                          children: [
                                            const Spacer(),
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.of(context).push(
                                                  PageRouteBuilder(
                                                      pageBuilder: (context,
                                                              animation,
                                                              secondaryAnimation) =>
                                                          const BookingPage(),
                                                      transitionsBuilder:
                                                          (context,
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
                                                            animation
                                                                .drive(tween);

                                                        return SlideTransition(
                                                          position:
                                                              offsetAnimation,
                                                          child: child,
                                                        );
                                                      },
                                                      transitionDuration:
                                                          const Duration(
                                                              microseconds:
                                                                  700000)),
                                                );
                                              },
                                              style: ButtonStyle(
                                                minimumSize:
                                                    WidgetStateProperty.all(
                                                        Size(147.w, 45.h)),
                                                backgroundColor:
                                                    WidgetStateProperty.all(
                                                        const Color.fromRGBO(
                                                            255, 255, 255, 1)),
                                                shape: WidgetStateProperty.all(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16.2.r),
                                                  ),
                                                ),
                                              ),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    'Get Your Ticket Here',
                                                    style: GoogleFonts.dmSans(
                                                      textStyle: TextStyle(
                                                        color: const Color
                                                            .fromRGBO(
                                                            34, 34, 34, 1),
                                                        fontSize: 12.sp,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  kwidth5,
                                                  const Icon(
                                                    Icons.arrow_forward,
                                                    weight: 600,
                                                    color: Color.fromRGBO(
                                                        34, 34, 34, 1),
                                                    size: 15,
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ]));
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(width: 20);
                    },
                    itemCount: 5),
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
