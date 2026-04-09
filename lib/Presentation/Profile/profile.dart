import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qflow/application/member/member_cubit.dart';
import 'package:qflow/application/member/member_state.dart' as ms;
import 'package:qflow/domain/member/member_model.dart';
import 'package:qflow/application/profile/profile_cubit.dart';
import 'package:qflow/application/profile/profile_state.dart';
import 'package:qflow/constants/const.dart';
import 'package:qflow/domain/core/di/injection.dart';
import 'package:qflow/domain/user/user_model/user_model.dart';
import 'package:qflow/domain/auth/auth_service.dart';
import 'package:qflow/Presentation/Auth/sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:qflow/Presentation/Profile/location_page.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _SmoothCarouselProfileScreenState();
}

class _SmoothCarouselProfileScreenState extends State<ProfileScreen> {
  final List<String> _originalTabs = ["Avatar", "Members", "History"];
  late PageController _pageController;
  bool _isEditMode = false;
  late int _currentIndex;
  var date = DateTime.now();

  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController usernameController;
  late TextEditingController ageController;
  late TextEditingController weightController;
  late TextEditingController heightController;
  late TextEditingController contactNumberController;

  String? selectedGender;
  String? selectedBloodGroup;

  @override
  void initState() {
    super.initState();
    _currentIndex = _originalTabs.length;
    _pageController = PageController(
      initialPage: _currentIndex,
      viewportFraction: 0.31,
    );

    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    usernameController = TextEditingController();
    ageController = TextEditingController();
    weightController = TextEditingController();
    heightController = TextEditingController();
    contactNumberController = TextEditingController();
  }

  void _toggleEditMode(UserModel user) {
    if (!_isEditMode) {
      firstNameController.text = user.firstName;
      lastNameController.text = user.lastName;
      usernameController.text = user.username;
      ageController.text = user.age.toString();
      weightController.text = user.weight.toString();
      heightController.text = user.height.toString();
      contactNumberController.text = user.contactNumber;
      selectedGender = user.gender.isNotEmpty
          ? user.gender[0].toUpperCase() +
              user.gender.substring(1).toLowerCase()
          : 'Male';
      selectedBloodGroup = user.bloodGroup.isNotEmpty ? user.bloodGroup : 'O+';
    }
    setState(() {
      _isEditMode = !_isEditMode;
    });
  }

  void _onItemTap(int index) {
    // Calculate the logical target index
    final targetIndex = index % _originalTabs.length;

    setState(() {
      // Update _currentIndex to ensure the clicked tab is in the center
      _currentIndex = (_currentIndex -
          (_currentIndex % _originalTabs.length) +
          targetIndex);
    });

    // Smoothly animate to the updated index
    _pageController.animateToPage(
      _currentIndex,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );

    // Call API for members only when switching to the Members tab (index 1)
    if (targetIndex == 1) {
      if (mounted) {
        context.read<MemberCubit>().getMembers();
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    usernameController.dispose();
    ageController.dispose();
    weightController.dispose();
    heightController.dispose();
    contactNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        state.failureOrSuccessOption.fold(
          () => null,
          (either) => either.fold(
            (failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(failure.map(
                    clientFailure: (_) => 'Network Error',
                    serverFailure: (_) => 'Server Error',
                    authFailure: (_) => 'Session Expired',
                  )),
                  backgroundColor: Colors.red,
                ),
              );
            },
            (_) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Profile updated successfully'),
                  backgroundColor: Colors.green,
                ),
              );
              setState(() => _isEditMode = false);
            },
          ),
        );
      },
        builder: (context, state) {
          final userOption = state.userOption;
          final user = userOption.getOrElse(
            () => const UserModel(
              firstName: "Loading...",
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
            ),
          );

          final visibleTabs = [
            ..._originalTabs,
            ..._originalTabs,
            ..._originalTabs,
          ];

          return Scaffold(
            body: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : Stack(
                    children: [
                      // Gradient Background
                      Stack(
                        children: [
                          // Background Gradient
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
                          // Foreground Gradient and Text
                          Container(
                            height: 350.h,
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
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 25.h),
                              child: Center(
                                child: Text(
                                  "Profile",
                                  style: TextStyle(
                                    fontSize: 32.17.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Bottom Content with Carousel
                      Container(
                        margin: EdgeInsets.only(top: 290.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(47.r),
                            topRight: Radius.circular(47.r),
                          ),
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 20.h),
                            // Carousel Tabs
                            SizedBox(
                              height: 78.h,
                              child: PageView.builder(
                                controller: _pageController,
                                itemCount: visibleTabs.length,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  final logicalIndex = index %
                                      _originalTabs
                                          .length; // Logical index for wrap-around
                                  final isCenter = index == _currentIndex;

                                  return GestureDetector(
                                    onTap: () => _onItemTap(index),
                                    child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 500),
                                      curve: Curves.easeInOut,
                                      child: Center(
                                        child: Text(
                                          _originalTabs[logicalIndex],
                                          style: TextStyle(
                                            fontSize: isCenter ? 15.sp : 12.sp,
                                            fontWeight: FontWeight.w400,
                                            color: isCenter
                                                ? Colors.black
                                                : Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),

                            Flexible(
                              child: _isEditMode
                                  ? _buildEditUI(() => _toggleEditMode(user),
                                      context, user, state)
                                  : IndexedStack(
                                      index: _currentIndex %
                                          _originalTabs.length,
                                      children: [
                                        _buildAvatarTab(
                                            () => _toggleEditMode(user), user),
                                        _buildMemberTab(
                                            () => _toggleEditMode(user), user),
                                        _buildHistoryTab(
                                            () => _toggleEditMode(user), user),
                                      ],
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          );
        },
      );
  }

  String getOrdinalSuffix(int day) {
    if (day >= 11 && day <= 13) {
      return 'th';
    }
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  String getMonth(int month) {
    const List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }

  String formatDateWithSuffix(DateTime date) {
    int day = date.day;
    String suffix = getOrdinalSuffix(day);
    return suffix;
  }

  Widget _buildAvatarTab(Function() onTap, UserModel user) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 31.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 20.h),
          Row(
            children: [
              SizedBox(
                width: 77.w,
                height: 90.h,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14.r),
                  child: user.profileImageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: user.profileImageUrl!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              user.thumbnailUrl != null
                                  ? CachedNetworkImage(
                                      imageUrl: user.thumbnailUrl!,
                                      fit: BoxFit.cover,
                                    )
                                  : Container(color: Colors.grey),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        )
                      : Container(color: Colors.grey),
                ),
              ),
              kwidth5,
              kwidth5,
              kwidth5,
              kwidth5,
              kwidth5,
              kwidth5,
              kwidth5,
              kwidth5,
              kwidth5,
              kwidth5,
              kwidth5,
              kwidth5,
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  kheight10,
                  Flexible(
                    child: Text(
                      "${user.firstName} ${user.lastName}",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  kheight10,
                  Text(
                    user.username,
                    style: TextStyle(
                      fontSize: 8.08.sp,
                      color: Colors.black,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: onTap,
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(165.w, 21.h),
                      backgroundColor: const Color.fromRGBO(225, 225, 225, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                    ),
                    child: Text(
                      "Edit Profile",
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: Colors.black,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
          kheight20,
          kheight10,
          ElevatedButton(
            onPressed: () {
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
            style: ElevatedButton.styleFrom(
              minimumSize: Size(325.w, 41.h),
              backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Location",
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: Colors.black,
                  ),
                ),
                Icon(Icons.arrow_forward_ios, size: 14.sp, color: Colors.black),
              ],
            ),
          ),
          kheight20,
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              minimumSize: Size(325.w, 41.h),
              backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Clear History",
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: Colors.black,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 14.sp,
                  color: Colors.black,
                ),
              ],
            ),
          ),
          kheight20,
          ElevatedButton(
            onPressed: () {
              getIt<IAuthService>().logout().then((_) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const SignInScreen()),
                  (route) => false,
                );
              });
            },
            style: ElevatedButton.styleFrom(
              minimumSize: Size(325.w, 41.h),
              backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Log Out",
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: Colors.black,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 14.sp,
                  color: Colors.black,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMemberTab(Function() onTap, UserModel user) {
    return BlocConsumer<MemberCubit, ms.MemberState>(
      listener: (context, state) {
        state.failureOrSuccessOption.fold(
          () => null,
          (either) => either.fold(
            (failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    failure.map(
                      serverFailure: (_) => 'Server Error. Reverting changes...',
                      clientFailure: (_) => 'Connection Error. Reverting changes...',
                      authFailure: (_) => 'Authentication Error. Reverting changes...',
                    ),
                  ),
                  backgroundColor: Colors.redAccent,
                ),
              );
            },
            (_) => null,
          ),
        );
      },
      builder: (context, state) {
        if (state.isLoading && state.members.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              if (state.members.isEmpty)
                SizedBox(
                  height: 300.h,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.people_outline,
                            size: 64.sp, color: Colors.grey[300]),
                        SizedBox(height: 16.h),
                        Text(
                          "No family members added yet",
                          style: TextStyle(
                              color: Colors.grey[500], fontSize: 14.sp),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 31.w),
                  itemCount: state.members.length,
                  separatorBuilder: (context, index) => const GradientDivider(
                    thickness: 1.0,
                  ),
                  itemBuilder: (context, index) {
                    final member = state.members[index];
                    return _buildMemberCard(member);
                  },
                ),
              SizedBox(height: 10.h),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  onPressed: () => _showAddMemberSheet(context),
                  child: Text('Add Member',
                      style: TextStyle(
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFFA4A4A4),
                      )),
                ),
              ),
              SizedBox(height: 100.h), // Space for bottom navigation
            ],
          ),
        );
      },
    );
  }

  Widget _buildHistoryTab(Function() onTap, UserModel user) {
    return const Center(child: Text("Appointment History (Coming Soon)"));
  }

  Widget _buildEditUI(Function() onTap, BuildContext context, UserModel user,
      ProfileState state) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(left: 29.w, right: 29.w, top: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Stack(
                  children: [
                    SizedBox(
                      width: 79.w,
                      height: 74.h,
                    ),
                    Container(
                      width: 69.w,
                      height: 69.h,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14.r),
                        child: state.profileImagePath != null
                            ? Image.file(
                                File(state.profileImagePath!),
                                fit: BoxFit.cover,
                              )
                            : user.profileImageUrl != null
                                ? CachedNetworkImage(
                                    imageUrl: user.profileImageUrl!,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) =>
                                        user.thumbnailUrl != null
                                            ? CachedNetworkImage(
                                                imageUrl: user.thumbnailUrl!,
                                                fit: BoxFit.cover,
                                              )
                                            : Container(color: Colors.grey),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  )
                                : Container(color: Colors.grey),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 24.48.w,
                        height: 24.48.h,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFE1E1E1),
                        ),
                        child: GestureDetector(
                          onTap: () async {
                            final picker = ImagePicker();
                            final XFile? image = await picker.pickImage(
                              source: ImageSource.gallery,
                              imageQuality: 50,
                            );
                            if (image != null) {
                              if (context.mounted) {
                                context
                                    .read<ProfileCubit>()
                                    .profileImageChanged(image.path);
                              }
                            }
                          },
                          child: Icon(
                            Icons.edit,
                            size: 14.sp,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: onTap,
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(165.w, 25.h),
                        backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                      ),
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ProfileCubit>().updateProfile(
                              user: user.copyWith(
                                firstName: firstNameController.text,
                                lastName: lastNameController.text,
                                username: usernameController.text,
                                contactNumber: contactNumberController.text,
                                age: int.tryParse(ageController.text) ??
                                    user.age,
                                weight:
                                    double.tryParse(weightController.text) ??
                                        user.weight,
                                height:
                                    double.tryParse(heightController.text) ??
                                        user.height,
                                gender: selectedGender?.toLowerCase() ??
                                    user.gender,
                                bloodGroup:
                                    selectedBloodGroup ?? user.bloodGroup,
                              ),
                            );
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(165.w, 25.h),
                        backgroundColor: Colors.greenAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                      ),
                      child: Text(
                        "Save",
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.black,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
            kheight20,
            _buildEditableField("Username", usernameController),
            kheight20,
            Row(
              children: [
                Expanded(
                    child:
                        _buildEditableField("First Name", firstNameController)),
                SizedBox(width: 10.w),
                Expanded(
                    child:
                        _buildEditableField("Last Name", lastNameController)),
              ],
            ),
            kheight20,
            _buildEditableField("Contact Number", contactNumberController,
                keyboardType: TextInputType.phone),
            kheight20,
            Row(
              children: [
                Expanded(
                    child: _buildEditableField("Age", ageController,
                        keyboardType: TextInputType.number)),
                SizedBox(width: 10.w),
                Expanded(
                  child: _buildDropdownField(
                    label: "Gender",
                    value: selectedGender!,
                    items: ["Male", "Female", "Other"],
                    onChanged: (val) => setState(() => selectedGender = val),
                  ),
                ),
              ],
            ),
            kheight20,
            Row(
              children: [
                Expanded(
                    child: _buildEditableField("Weight", weightController,
                        keyboardType: TextInputType.number)),
                SizedBox(width: 10.w),
                Expanded(
                    child: _buildEditableField("Height", heightController,
                        keyboardType: TextInputType.number)),
              ],
            ),
            kheight20,
            _buildDropdownField(
              label: "Blood Group",
              value: selectedBloodGroup!,
              items: ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'],
              onChanged: (val) => setState(() => selectedBloodGroup = val),
            ),
            SizedBox(height: 100.h),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w400),
          ),
          SizedBox(height: 1.h),
          SizedBox(
            height: 35.h,
            child: TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color.fromRGBO(116, 116, 116, 1)),
              decoration: InputDecoration(
                fillColor: const Color.fromRGBO(248, 248, 248, 1),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w400),
        ),
        SizedBox(height: 1.h),
        SizedBox(
          height: 35.h,
          child: DropdownButtonFormField<String>(
            value: value,
            style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w400,
                color: const Color.fromRGBO(116, 116, 116, 1)),
            decoration: InputDecoration(
              fillColor: const Color.fromRGBO(248, 248, 248, 1),
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
            ),
            items: items
                .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                .toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildMemberCard(MemberModel member) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(member.name,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
          )),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          kheight5,
          Text('Age : ${member.age}',
              style: TextStyle(
                fontSize: 10.77.sp,
                fontWeight: FontWeight.w400,
              )),
          if (member.weight != null || member.height != null)
            Text(
                '${member.weight != null ? "${member.weight} kg" : ""} ${member.height != null ? "| ${member.height} cm" : ""}',
                style: TextStyle(
                  fontSize: 10.sp,
                  color: Colors.grey,
                  fontWeight: FontWeight.w400,
                )),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 34.w,
            height: 20.h,
            decoration: BoxDecoration(
              color: const Color(0xFFE1E1E1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: GestureDetector(
              onTap: () {
                _showEditMemberSheet(context, member);
              },
              child: Icon(
                Icons.edit,
                size: 14.sp,
              ),
            ),
          ),
          kwidth5,
          TextButton(
            onPressed: () {
              context.read<MemberCubit>().deleteMember(member.id ?? "");
            },
            style: ButtonStyle(
              padding: const WidgetStatePropertyAll(EdgeInsets.zero),
              minimumSize: WidgetStateProperty.all(Size(73.w, 20.h)),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(19.r),
                ),
              ),
              backgroundColor: WidgetStateProperty.all(
                const Color(0xFFE1E1E1),
              ),
            ),
            child: Text('Delete',
                style: TextStyle(
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.redAccent,
                )),
          ),
        ],
      ),
    );
  }

  void _showAddMemberSheet(BuildContext context) {
    final nameController = TextEditingController();
    final ageController = TextEditingController();
    final weightController = TextEditingController();
    final heightController = TextEditingController();
    String selectedRelation = 'Spouse';
    String selectedGender = 'male';
    String selectedBloodGroup = 'O+';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => BlocProvider.value(
        value: context.read<MemberCubit>(),
        child: StatefulBuilder(
          builder: (context, setModalState) => Container(
            height: MediaQuery.of(context).size.height * 0.85,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
            ),
            padding: EdgeInsets.symmetric(horizontal: 29.w, vertical: 25.h),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    "Add Family Member",
                    style:
                        TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 25.h),
                  _buildEditableField("Full Name", nameController),
                  SizedBox(height: 15.h),
                  Row(
                    children: [
                      Expanded(
                          child: _buildEditableField("Age", ageController,
                              keyboardType: TextInputType.number)),
                      SizedBox(width: 15.w),
                      Expanded(
                        child: _buildDropdownField(
                          label: "Relationship",
                          value: selectedRelation,
                          items: [
                            'Mother',
                            'Father',
                            'Spouse',
                            'Child',
                            'Parent',
                            'Sibling',
                            'Other'
                          ],
                          onChanged: (val) =>
                              setModalState(() => selectedRelation = val!),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15.h),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDropdownField(
                          label: "Gender",
                          value: selectedGender,
                          items: ['male', 'female', 'other'],
                          onChanged: (val) =>
                              setModalState(() => selectedGender = val!),
                        ),
                      ),
                      SizedBox(width: 15.w),
                      Expanded(
                        child: _buildDropdownField(
                          label: "Blood Group",
                          value: selectedBloodGroup,
                          items: [
                            'A+',
                            'A-',
                            'B+',
                            'B-',
                            'AB+',
                            'AB-',
                            'O+',
                            'O-'
                          ],
                          onChanged: (val) =>
                              setModalState(() => selectedBloodGroup = val!),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15.h),
                  Row(
                    children: [
                      Expanded(
                          child: _buildEditableField("Weight (kg)", weightController,
                              keyboardType: TextInputType.number)),
                      SizedBox(width: 15.w),
                      Expanded(
                          child: _buildEditableField("Height (cm)", heightController,
                              keyboardType: TextInputType.number)),
                    ],
                  ),
                  SizedBox(height: 40.h),
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          final member = MemberModel(
                            name: nameController.text,
                            age: int.tryParse(ageController.text) ?? 0,
                            gender: selectedGender,
                            bloodGroup: selectedBloodGroup,
                            relation: selectedRelation,
                            weight: double.tryParse(weightController.text),
                            height: double.tryParse(heightController.text),
                          );
                          context.read<MemberCubit>().addMember(member: member);
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 25.h),
                          backgroundColor: Colors.greenAccent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.r)),
                        ),
                        child: Text("Register Member",
                            style: TextStyle(
                                color: Colors.black, fontSize: 10.sp)),
                      ),
                      SizedBox(height: 12.h),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 25.h),
                          backgroundColor: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.r)),
                        ),
                        child: Text("Cancel",
                            style: TextStyle(
                                color: Colors.black, fontSize: 10.sp)),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showEditMemberSheet(BuildContext context, MemberModel member) {
    final nameController = TextEditingController(text: member.name);
    final ageController = TextEditingController(text: member.age.toString());
    final weightController =
        TextEditingController(text: member.weight?.toString() ?? "");
    final heightController =
        TextEditingController(text: member.height?.toString() ?? "");

    // Normalize relation to match dropdown items
    final List<String> relationItems = [
      'Mother',
      'Father',
      'Spouse',
      'Child',
      'Parent',
      'Sibling',
      'Other'
    ];
    String selectedRelation = relationItems.firstWhere(
        (e) => e.toLowerCase() == member.relation.toLowerCase(),
        orElse: () => 'Other');

    String selectedGender = member.gender.toLowerCase();
    if (!['male', 'female', 'other'].contains(selectedGender)) {
      selectedGender = 'male';
    }
    String selectedBloodGroup = member.bloodGroup.isNotEmpty ? member.bloodGroup : 'O+';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => BlocProvider.value(
        value: context.read<MemberCubit>(),
        child: StatefulBuilder(
          builder: (context, setModalState) => Container(
            height: MediaQuery.of(context).size.height * 0.85,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
            ),
            padding: EdgeInsets.symmetric(horizontal: 29.w, vertical: 25.h),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    "Edit Family Member",
                    style:
                        TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 25.h),
                  _buildEditableField("Full Name", nameController),
                  SizedBox(height: 15.h),
                  Row(
                    children: [
                      Expanded(
                          child: _buildEditableField("Age", ageController,
                              keyboardType: TextInputType.number)),
                      SizedBox(width: 15.w),
                      Expanded(
                        child: _buildDropdownField(
                          label: "Relationship",
                          value: selectedRelation,
                          items: relationItems,
                          onChanged: (val) =>
                              setModalState(() => selectedRelation = val!),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15.h),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDropdownField(
                          label: "Gender",
                          value: selectedGender,
                          items: ['male', 'female', 'other'],
                          onChanged: (val) =>
                              setModalState(() => selectedGender = val!),
                        ),
                      ),
                      SizedBox(width: 15.w),
                      Expanded(
                        child: _buildDropdownField(
                          label: "Blood Group",
                          value: selectedBloodGroup,
                          items: [
                            'A+',
                            'A-',
                            'B+',
                            'B-',
                            'AB+',
                            'AB-',
                            'O+',
                            'O-'
                          ],
                          onChanged: (val) =>
                              setModalState(() => selectedBloodGroup = val!),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15.h),
                  Row(
                    children: [
                      Expanded(
                          child: _buildEditableField("Weight (kg)", weightController,
                              keyboardType: TextInputType.number)),
                      SizedBox(width: 15.w),
                      Expanded(
                          child: _buildEditableField("Height (cm)", heightController,
                              keyboardType: TextInputType.number)),
                    ],
                  ),
                  SizedBox(height: 40.h),
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          context.read<MemberCubit>().updateMember(
                                member: member.copyWith(
                                  name: nameController.text,
                                  age: int.tryParse(ageController.text) ??
                                      member.age,
                                  gender: selectedGender.toLowerCase(),
                                  bloodGroup: selectedBloodGroup,
                                  relation: selectedRelation,
                                  weight:
                                      double.tryParse(weightController.text),
                                  height:
                                      double.tryParse(heightController.text),
                                ),
                              );
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 25.h),
                          backgroundColor: Colors.greenAccent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.r)),
                        ),
                        child: Text("Save Changes",
                            style: TextStyle(
                                color: Colors.black, fontSize: 10.sp)),
                      ),
                      SizedBox(height: 12.h),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 25.h),
                          backgroundColor: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.r)),
                        ),
                        child: Text("Cancel",
                            style: TextStyle(
                                color: Colors.black, fontSize: 10.sp)),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GradientDivider extends StatelessWidget {
  final double thickness;

  const GradientDivider({
    super.key,
    this.thickness = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: thickness,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(0, 0, 0, 0), // Fully transparent (start)
            Color.fromRGBO(176, 176, 176, 0.5), // Soft middle gradient
            Color.fromRGBO(176, 176, 176, 1), // Strong center line
            Color.fromRGBO(176, 176, 176, 0.5), // Soft middle gradient
            Color.fromRGBO(0, 0, 0, 0), // Fully transparent (end)
          ],
          stops: [0.0, 0.2, 0.5, 0.8, 1.0], // Positions for smoothness
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
    );
  }
}
