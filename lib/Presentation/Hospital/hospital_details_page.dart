import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qflow/Presentation/Member/booking.dart';
import 'package:qflow/domain/hospital/hospital_model.dart';

class HospitalDetailsPage extends StatelessWidget {
  final HospitalModel hospital;

  const HospitalDetailsPage({super.key, required this.hospital});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300.h,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image(
                    image: (hospital.profileImageUrl != null &&
                            hospital.profileImageUrl!.isNotEmpty)
                        ? NetworkImage(hospital.profileImageUrl!)
                        : const AssetImage('assets/icon/hospital.jpeg')
                            as ImageProvider,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/icon/hospital.jpeg',
                        fit: BoxFit.cover,
                      );
                    },
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black45,
                          Colors.transparent,
                          Colors.black87,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 30.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hospital.name,
                    style: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'CabinetGrotesk',
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16.sp, color: Colors.grey),
                      SizedBox(width: 5.w),
                      Text(
                        "${hospital.city}, ${hospital.district}",
                        style: GoogleFonts.dmSans(
                          fontSize: 14.sp,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40.h),
                  Text(
                    "Available Services",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'CabinetGrotesk',
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 15.h),
                  Wrap(
                    spacing: 10.w,
                    runSpacing: 10.h,
                    children: hospital.availableServices.map((service) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 8.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: const Color(0xFFEEEEEE)),
                        ),
                        child: Text(
                          service,
                          style: GoogleFonts.dmSans(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color.fromRGBO(66, 132, 156, 1),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  if (hospital.availableServices.isEmpty)
                    Text(
                      "No special services listed.",
                      style: GoogleFonts.dmSans(
                        fontSize: 13.sp,
                        color: Colors.grey,
                      ),
                    ),
                  SizedBox(height: 100.h),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 25.h),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => BookingPage(hospitalId: hospital.id),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, 55.h),
            backgroundColor: Colors.greenAccent,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.r),
            ),
          ),
          child: Text(
            "Book an Appointment",
            style: GoogleFonts.dmSans(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: const Color.fromRGBO(34, 34, 34, 1),
            ),
          ),
        ),
      ),
    );
  }
}
