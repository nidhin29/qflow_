import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qflow/Presentation/Core/shimmer_loading.dart';

class MemberListItemShimmer extends StatelessWidget {
  const MemberListItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const ShimmerWidget.circular(width: 50, height: 50),
      title: const ShimmerWidget.rectangular(height: 14, width: 100),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8.h),
          const ShimmerWidget.rectangular(height: 10, width: 60),
          SizedBox(height: 4.h),
          const ShimmerWidget.rectangular(height: 10, width: 80),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ShimmerWidget.rectangular(height: 20, width: 34),
          SizedBox(width: 5.w),
          const ShimmerWidget.rectangular(height: 20, width: 73),
        ],
      ),
    );
  }
}

class ProfileHistoryShimmer extends StatelessWidget {
  const ProfileHistoryShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 4,
      separatorBuilder: (context, index) => SizedBox(height: 15.h),
      itemBuilder: (context, index) => Container(
        padding: EdgeInsets.all(15.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(color: const Color.fromRGBO(245, 245, 245, 1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ShimmerWidget.rectangular(height: 16, width: 150),
                ShimmerWidget.rectangular(height: 14, width: 80),
              ],
            ),
            SizedBox(height: 10.h),
            const ShimmerWidget.rectangular(height: 12, width: 200),
            SizedBox(height: 10.h),
            Row(
              children: [
                const ShimmerWidget.rectangular(height: 12, width: 60),
                SizedBox(width: 10.w),
                const ShimmerWidget.rectangular(height: 12, width: 60),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
