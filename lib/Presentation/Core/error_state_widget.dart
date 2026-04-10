import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ErrorStateWidget extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const ErrorStateWidget({
    super.key,
    required this.errorMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icon/error.png',
              width: 180.w,
              height: 180.w,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.error_outline_rounded,
                size: 80.sp,
                color: Colors.red[200],
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'Oops! Something went wrong',
              textAlign: TextAlign.center,
              style: GoogleFonts.dmSans(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A3955),
              ),
            ),
            if (errorMessage.isNotEmpty && 
                errorMessage != 'An unexpected error occurred' &&
                errorMessage != 'Network error occurred')
              Padding(
                padding: EdgeInsets.only(top: 8.h),
                child: Text(
                  errorMessage,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.dmSans(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            SizedBox(height: 30.h),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 20, color: Colors.white),
              label: Text(
                'Retry',
                style: GoogleFonts.dmSans(
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A3955),
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
