import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qflow/constants/const.dart';

class FieldsWidget extends StatelessWidget {
  final Color color;
  final Color color1;
  const FieldsWidget({
    super.key,
    required this.color,
    required this.color1,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Container(
            width: 63.w,
            height: 19.h,
            decoration: BoxDecoration(
              color: color1,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Center(
              child: Text(
                'Physician',
                style: GoogleFonts.ptSans(
                  textStyle: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 9.sp,
                      color: color),
                ),
              ),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return kwidth5;
        },
        itemCount: 4);
  }
}
