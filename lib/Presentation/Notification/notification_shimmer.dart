import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qflow/Presentation/Core/shimmer_loading.dart';

class NotificationShimmer extends StatelessWidget {
  const NotificationShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
      itemCount: 5,
      separatorBuilder: (context, index) => SizedBox(height: 25.h),
      itemBuilder: (context, index) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Column Shimmer
            SizedBox(
              width: 85.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ShimmerWidget.rectangular(height: 12, width: 60),
                  SizedBox(height: 4.h),
                  const ShimmerWidget.rectangular(height: 22, width: 80),
                ],
              ),
            ),
            SizedBox(width: 15.w),
            // Message Card Shimmer
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 22.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: const Color(0xFFF0F0F0),
                    width: 0.5,
                  ),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerWidget.rectangular(height: 10, width: double.infinity),
                    SizedBox(height: 8),
                    ShimmerWidget.rectangular(height: 10, width: 200),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
