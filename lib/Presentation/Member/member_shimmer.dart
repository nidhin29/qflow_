import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qflow/Presentation/Core/shimmer_loading.dart';

class HospitalCardShimmer extends StatelessWidget {
  const HospitalCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 315.w,
      height: 509.h,
      margin: EdgeInsets.only(right: 15.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: const Color.fromRGBO(245, 245, 245, 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerWidget.rectangular(
            height: 300.h,
            shapeBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(15.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ShimmerWidget.rectangular(height: 20, width: 200),
                SizedBox(height: 10.h),
                const ShimmerWidget.rectangular(height: 14, width: 250),
                SizedBox(height: 10.h),
                const ShimmerWidget.rectangular(height: 14, width: 150),
                const Divider(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const ShimmerWidget.rectangular(height: 12, width: 80),
                    const ShimmerWidget.rectangular(height: 30, width: 100),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
