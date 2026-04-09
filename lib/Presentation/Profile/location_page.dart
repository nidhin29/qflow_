import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qflow/application/profile/profile_cubit.dart';
import 'package:qflow/application/profile/profile_state.dart';
import 'package:qflow/domain/user/user_model/user_model.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  final TextEditingController cityController = TextEditingController();
  final TextEditingController districtController = TextEditingController();

  @override
  void dispose() {
    cityController.dispose();
    districtController.dispose();
    super.dispose();
  }

  void _showEditLocationSheet(BuildContext context, UserModel user) {
    cityController.text = user.city;
    districtController.text = user.district;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<ProfileCubit>(),
        child: Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 20.h,
            left: 20.w,
            right: 20.w,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.r),
              topRight: Radius.circular(30.r),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Edit Location",
                style: TextStyle(
                  fontSize: 20.sp,
                  fontFamily: 'CabinetGrotesk',
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 25.h),
              _buildDialogTextField("City", cityController),
              SizedBox(height: 15.h),
              _buildDialogTextField("District", districtController),
              SizedBox(height: 30.h),
              ElevatedButton(
                onPressed: () {
                  final updatedUser = user.copyWith(
                    city: cityController.text,
                    district: districtController.text,
                  );
                  context.read<ProfileCubit>().updateProfile(user: updatedUser);
                  Navigator.pop(context);
                },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50.h),
                backgroundColor: Colors.greenAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
                elevation: 0,
              ),
              child: Text(
                "Save Changes",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                ),
              ),
            ),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    ),
  );
}

  Widget _buildDialogTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 5.h),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 10.w),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: const BorderSide(color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final user = state.userOption.getOrElse(() => const UserModel(
              firstName: "",
              lastName: "",
              username: "",
              age: 0,
              weight: 0,
              height: 0,
              gender: "",
              bloodGroup: "",
              contactNumber: "",
              city: "",
              district: "",
            ));

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              "Location Settings",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.sp,
                fontFamily: 'CabinetGrotesk',
                fontWeight: FontWeight.w700,
              ),
            ),
            centerTitle: true,
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F8F8),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: const Color(0xFFEEEEEE)),
                  ),
                  child: Column(
                    children: [
                      _buildLocationTile("City", user.city),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 15.h),
                        child: Divider(color: Colors.grey[200]),
                      ),
                      _buildLocationTile("District", user.district),
                    ],
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () => _showEditLocationSheet(context, user),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 55.h),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      side: const BorderSide(color: Colors.black, width: 1),
                    ),
                  ),
                  child: Text(
                    "Edit Location",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 30.h),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLocationTile(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.dmSans(
            fontSize: 14.sp,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value.isEmpty ? "Not set" : value,
          style: TextStyle(
            fontSize: 16.sp,
            fontFamily: 'CabinetGrotesk',
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
