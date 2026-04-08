import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient Background
          Container(
            height: 337.h,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white,
                  Color(0xFFCEDFEF),
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          Container(
            height: 390.h,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF81BDFC),
                  Colors.white,
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
            child: Center(
              child: Text(
                "Edit Profile",
                style: TextStyle(
                  fontSize: 32.17.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          // Main Content
          Container(
            margin: EdgeInsets.only(top: 300.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(47.r),
                topRight: Radius.circular(47.r),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: Column(
                children: [
                  SizedBox(height: 20.h),
                  // Avatar Section
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 50.r,
                        backgroundColor: Colors.grey[200],
                        child: Icon(
                          Icons.person,
                          size: 50.sp,
                          color: Colors.grey,
                        ),
                      ),
                      Positioned(
                        bottom: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () {
                            // Handle avatar edit
                          },
                          child: Container(
                            height: 24.h,
                            width: 24.w,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.edit,
                              size: 16.sp,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  // Profile Fields
                  _buildProfileField("Name", "Pranav Das"),
                  SizedBox(height: 15.h),
                  _buildProfileField("Email", "pranavdasd082003@gmail.com"),
                  SizedBox(height: 15.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: _buildProfileField("Weight", "75 kg"),
                      ),
                      SizedBox(width: 15.w),
                      Expanded(
                        child: _buildProfileField("Height", "180 cm"),
                      ),
                    ],
                  ),
                  SizedBox(height: 15.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: _buildProfileField("Age", "21"),
                      ),
                      SizedBox(width: 15.w),
                      Expanded(
                        child: _buildProfileField("Blood Group", "A+ve"),
                      ),
                    ],
                  ),
                  SizedBox(height: 15.h),
                  _buildProfileField("Insurance", "Yes"),
                  SizedBox(height: 30.h),
                  ElevatedButton(
                    onPressed: () {
                      // Save button logic
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      minimumSize: Size(250.w, 50.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.r),
                      ),
                    ),
                    child: Text(
                      "Save Changes",
                      style: TextStyle(
                        fontSize: 18.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey,
          ),
        ),
        SizedBox(height: 5.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          height: 50.h,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
