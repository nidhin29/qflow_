import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:qflow/application/notification/notification_cubit.dart';
import 'package:qflow/application/notification/notification_state.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  String _getOrdinalDate(DateTime date) {
    final day = date.day;
    final suffix = (day >= 11 && day <= 13)
        ? 'th'
        : (day % 10 == 1)
            ? 'st'
            : (day % 10 == 2)
                ? 'nd'
                : (day % 10 == 3)
                    ? 'rd'
                    : 'th';
    return '$day$suffix ${DateFormat('MMM').format(date)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Custom Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 15,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child:
                          Icon(Icons.arrow_back, size: 24.sp, color: Colors.black),
                    ),
                  ),
                  SizedBox(width: 25.w),
                  Text(
                    'Notification',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'CabinetGrotesk',
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            // Notification List
            Expanded(
              child: BlocBuilder<NotificationCubit, NotificationState>(
                builder: (context, state) {
                  if (state.isLoading && state.notifications.isEmpty) {
                    return const Center(
                        child: CircularProgressIndicator(color: Colors.black));
                  }

                  if (state.notifications.isEmpty) {
                    return RefreshIndicator(
                      onRefresh: () =>
                          context.read<NotificationCubit>().getNotifications(),
                      color: Colors.black,
                      child: ListView(
                        children: [
                          SizedBox(height: 100.h),
                          Center(
                            child: Text(
                              'No notifications found',
                              style: GoogleFonts.dmSans(color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () =>
                        context.read<NotificationCubit>().getNotifications(),
                    color: Colors.black,
                    child: ListView.builder(
                      padding:
                          EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
                      itemCount: state.notifications.length,
                      itemBuilder: (context, index) {
                        final notification = state.notifications[index];
                        return Padding(
                          padding: EdgeInsets.only(bottom: 25.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Date Column
                              SizedBox(
                                width: 85.w,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _getOrdinalDate(notification.date),
                                      style: GoogleFonts.dmSans(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    Text(
                                      DateFormat('yyyy')
                                          .format(notification.date),
                                      softWrap: false,
                                      style: TextStyle(
                                        fontSize: 22.sp,
                                        fontWeight: FontWeight.w800,
                                        fontFamily: 'CabinetGrotesk',
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 15.w),
                              // Message Card
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20.w, vertical: 22.h),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFBFBFB),
                                    borderRadius: BorderRadius.circular(12.r),
                                    border: Border.all(
                                      color: const Color(0xFFF0F0F0),
                                      width: 0.5,
                                    ),
                                  ),
                                  child: Text(
                                    notification.text,
                                    style: GoogleFonts.dmSans(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black.withOpacity(0.9),
                                      height: 1.3,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
