import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:qflow/application/profile/profile_cubit.dart';
import 'package:qflow/application/appointment/appointment_cubit.dart';
import 'package:qflow/application/member/member_cubit.dart';
import 'package:qflow/application/hospital/hospital_cubit.dart';
import 'package:qflow/application/notification/notification_cubit.dart';
import 'package:qflow/domain/user/user_model/user_model.dart';
import 'package:qflow/domain/auth/auth_service.dart';
import 'package:qflow/domain/core/di/injection.dart';
import 'package:qflow/Presentation/Auth/sign_in.dart';
import 'package:qflow/Presentation/Profile/location_page.dart';
import 'package:qflow/constants/const.dart';

class AvatarTabView extends StatelessWidget {
  final UserModel user;
  final VoidCallback onEditTap;

  const AvatarTabView({
    super.key,
    required this.user,
    required this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 31.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 20.h),
          Row(
            children: [
              kwidth5,
              kwidth5,
              SizedBox(
                width: 77.w,
                height: 90.h,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14.r),
                  child: user.profileImageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: user.profileImageUrl!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: const Color(0xFFF6F6F6),
                            child: user.thumbnailUrl != null
                                ? Image(
                                    image: CachedNetworkImageProvider(
                                        user.thumbnailUrl!),
                                    fit: BoxFit.cover,
                                  )
                                : const Icon(Icons.person, color: Colors.grey),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        )
                      : Container(color: Colors.grey),
                ),
              ),
              SizedBox(width: 57.w),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "${user.firstName} ${user.lastName}",
                      style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                    Text(
                      user.username,
                      style: TextStyle(fontSize: 10.sp, color: Colors.black54),
                    ),
                    SizedBox(height: 8.h),
                    ElevatedButton(
                      onPressed: onEditTap,
                      style: ElevatedButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        backgroundColor: const Color.fromRGBO(225, 225, 225, 1),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.r)),
                      ),
                      child: Text("Edit Profile",
                          style:
                              TextStyle(fontSize: 10.sp, color: Colors.black)),
                    )
                  ],
                ),
              ),
            ],
          ),
          kheight20,
          kheight10,
          _buildActionTile(
            context: context,
            label: "Location",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<ProfileCubit>(),
                    child: const LocationPage(),
                  ),
                ),
              );
            },
          ),
          kheight20,
          _buildActionTile(
            context: context,
            label: "Log Out",
            onTap: () async {
              final result = await getIt<IAuthService>().logout();
              
              result.fold(
                (failure) {
                  // If server logout failed, show error and do NOT clear local state
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Log out failed. Please try again."),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                (_) {
                  // Server logout was successful! Now clear everything locally
                  getIt<ProfileCubit>().clear();
                  getIt<AppointmentCubit>().clear();
                  getIt<MemberCubit>().clear();
                  getIt<HospitalCubit>().clear();
                  getIt<NotificationCubit>().clear();
                  
                  if (!context.mounted) return;
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const SignInScreen()),
                    (route) => false,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile(
      {required BuildContext context,
      required String label,
      required VoidCallback onTap}) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(325.w, 41.h),
        backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 10.sp, color: Colors.black)),
          Icon(Icons.arrow_forward_ios, size: 14.sp, color: Colors.black),
        ],
      ),
    );
  }
}
