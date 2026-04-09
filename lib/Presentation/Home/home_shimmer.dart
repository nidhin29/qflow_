import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qflow/Presentation/Core/shimmer_loading.dart';

class AppointmentCardShimmer extends StatelessWidget {
  const AppointmentCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 318.w,
      margin: EdgeInsets.only(right: 15.w, bottom: 5.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        color: Colors.white,
        border: Border.all(color: const Color.fromRGBO(245, 245, 245, 1)),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const ShimmerWidget.rectangular(height: 50, width: 150),
                const ShimmerWidget.rectangular(height: 40, width: 60),
              ],
            ),
            SizedBox(height: 15.h),
            const ShimmerWidget.rectangular(height: 20, width: 200),
            SizedBox(height: 8.h),
            const ShimmerWidget.rectangular(height: 15, width: 250),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTileShimmer(),
                _buildTileShimmer(),
              ],
            ),
            SizedBox(height: 15.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTileShimmer(),
                _buildTileShimmer(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTileShimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ShimmerWidget.rectangular(height: 8, width: 60),
        SizedBox(height: 4.h),
        const ShimmerWidget.rectangular(height: 16, width: 100),
      ],
    );
  }
}

class PreviousAppointmentShimmer extends StatelessWidget {
  const PreviousAppointmentShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      separatorBuilder: (context, index) => SizedBox(height: 12.h),
      itemBuilder: (context, index) => Container(
        height: 70.h,
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: const Color.fromRGBO(245, 245, 245, 1)),
        ),
        child: Row(
          children: [
            const ShimmerWidget.circular(width: 45, height: 45),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ShimmerWidget.rectangular(height: 14, width: 120),
                  SizedBox(height: 6.h),
                  const ShimmerWidget.rectangular(height: 10, width: 80),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
