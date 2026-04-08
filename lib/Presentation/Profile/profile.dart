import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qflow/application/profile/profile_cubit.dart';
import 'package:qflow/application/profile/profile_state.dart';
import 'package:qflow/constants/const.dart';
import 'package:qflow/domain/core/di/injection.dart';
import 'package:qflow/domain/user/user_model/user_model.dart';
import 'package:qflow/application/appointment/appointment_cubit.dart';
import 'package:qflow/application/appointment/appointment_state.dart';
import 'package:qflow/domain/auth/auth_service.dart';
import 'package:qflow/Presentation/Auth/sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';

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

  void _toggleEditMode() {
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
    return BlocProvider(
      create: (context) => getIt<ProfileCubit>()..getUserDetails(),
      child: BlocConsumer<ProfileCubit, ProfileState>(
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
          final user = state.userOption.getOrElse(
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
                              child: _currentIndex % _originalTabs.length == 1
                                  ? SingleChildScrollView(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 31.w),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            ListView.separated(
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemBuilder: (context, index) {
                                                return ListTile(
                                                  leading: Container(
                                                    width: 45.w,
                                                    height: 45.h,
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey,
                                                      shape: BoxShape.rectangle,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              7.r),
                                                    ),
                                                  ),
                                                  title: Text('Nidhin V Ninan',
                                                      style: TextStyle(
                                                        fontSize: 12.sp,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      )),
                                                  subtitle: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      kheight5,
                                                      Text('Age : 25',
                                                          style: TextStyle(
                                                            fontSize: 10.77.sp,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          )),
                                                    ],
                                                  ),
                                                  trailing: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Container(
                                                        width: 34.w,
                                                        height: 20.h,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: const Color(
                                                              0xFFE1E1E1),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.r),
                                                        ),
                                                        child: GestureDetector(
                                                          onTap: () {},
                                                          child: Icon(
                                                            Icons.edit,
                                                            size: 14.sp,
                                                          ),
                                                        ),
                                                      ),
                                                      kwidth5,
                                                      TextButton(
                                                        onPressed: () {},
                                                        style: ButtonStyle(
                                                          padding:
                                                              const WidgetStatePropertyAll(
                                                                  EdgeInsets
                                                                      .zero),
                                                          minimumSize:
                                                              WidgetStateProperty
                                                                  .all(Size(
                                                                      73.w,
                                                                      20.h)),
                                                          shape:
                                                              WidgetStateProperty
                                                                  .all(
                                                            RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          19.r),
                                                            ),
                                                          ),
                                                          backgroundColor:
                                                              WidgetStateProperty
                                                                  .all(
                                                            const Color(
                                                                0xFFE1E1E1),
                                                          ),
                                                        ),
                                                        child: Text('Coming Soon',
                                                            style: TextStyle(
                                                              fontSize: 9.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color:
                                                                  Colors.black,
                                                            )),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                              itemCount: 10,
                                              separatorBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return const GradientDivider(
                                                  thickness: 1.0,
                                                );
                                              },
                                            ),
                                            SizedBox(height: 10.h),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: TextButton(
                                                onPressed: () {
                                                  // Add more button action
                                                },
                                                child: Text('Add Member',
                                                    style: TextStyle(
                                                      fontSize: 9.sp,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: const Color(
                                                          0xFFA4A4A4),
                                                    )),
                                              ),
                                            ),
                                            SizedBox(height: 100.h),
                                          ],
                                        ),
                                      ),
                                    )
                                  : _currentIndex % _originalTabs.length == 2
                                      ? SingleChildScrollView(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 31.w),
                                            child: Column(
                                              children: [
                                                BlocBuilder<AppointmentCubit,
                                                    AppointmentState>(
                                                  builder: (context, appState) {
                                                    if (appState.isLoading) {
                                                      return const Center(
                                                          child:
                                                              CircularProgressIndicator());
                                                    }
                                                    if (appState
                                                        .pastAppointments
                                                        .isEmpty) {
                                                      return const Center(
                                                          child: Padding(
                                                        padding: EdgeInsets.only(
                                                            top: 50),
                                                        child: Text(
                                                            'No past appointments'),
                                                      ));
                                                    }
                                                    return ListView.separated(
                                                        shrinkWrap: true,
                                                        physics:
                                                            const NeverScrollableScrollPhysics(),
                                                        itemBuilder:
                                                            (context, index) {
                                                          final app = appState
                                                                  .pastAppointments[
                                                              index];
                                                          final appDate =
                                                              DateTime.tryParse(app
                                                                      .appointmentDate) ??
                                                                  DateTime.now();
                                                          return Container(
                                                            width: 350.w,
                                                            height: 182.h,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: const Color
                                                                  .fromRGBO(
                                                                  245,
                                                                  246,
                                                                  250,
                                                                  1),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          13.r),
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsets.only(
                                                                      left: 20.w),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: [
                                                                  Stack(
                                                                    alignment:
                                                                        AlignmentDirectional
                                                                            .bottomStart,
                                                                    children: [
                                                                      Container(
                                                                        height:
                                                                            65.h,
                                                                      ),
                                                                      Positioned(
                                                                        top: -8,
                                                                        child:
                                                                            Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                                appDate.day.toString(),
                                                                                style: TextStyle(
                                                                                  fontSize: 36.sp,
                                                                                  fontWeight: FontWeight.w400,
                                                                                  color: const Color.fromRGBO(73, 142, 167, 1),
                                                                                )),
                                                                            kwidth5,
                                                                            Padding(
                                                                              padding: EdgeInsets.only(top: 7.h),
                                                                              child: Text(
                                                                                  formatDateWithSuffix(appDate),
                                                                                  style: TextStyle(
                                                                                    fontSize: 14.4.sp,
                                                                                    fontWeight: FontWeight.w400,
                                                                                    color: Colors.black,
                                                                                  )),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                          '${getMonth(appDate.month)} ${appDate.year}',
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                18.sp,
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            color: Colors.black,
                                                                          )),
                                                                    ],
                                                                  ),
                                                                  Text(
                                                                      'Department: ${app.departmentName}',
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            9.sp,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400,
                                                                        color: Colors
                                                                            .black,
                                                                      )),
                                                                  Text(
                                                                      app.hospitalName,
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            10.sp,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400,
                                                                        color: Colors
                                                                            .grey,
                                                                      )),
                                                                  Text(
                                                                      app.patientName,
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            10.sp,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400,
                                                                        color: Colors
                                                                            .grey,
                                                                      )),
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        separatorBuilder:
                                                            (context, index) {
                                                          return kheight20;
                                                        },
                                                        itemCount: appState
                                                            .pastAppointments
                                                            .length);
                                                  },
                                                ),
                                                SizedBox(height: 150.h),
                                              ],
                                            ),
                                          ),
                                        )
                                      : _isEditMode
                                          ? _buildEditUI(
                                              _toggleEditMode, context, user, state)
                                          : _buildAvatarTab(
                                              _toggleEditMode, user),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          );
        },
      ),
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
                          placeholder: (context, url) => user.thumbnailUrl != null
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

  Widget _buildEditUI(Function() onTap, BuildContext context, UserModel user,
      ProfileState state) {
    firstNameController.text = user.firstName;
    lastNameController.text = user.lastName;
    usernameController.text = user.username;
    ageController.text = user.age.toString();
    weightController.text = user.weight.toString();
    heightController.text = user.height.toString();
    contactNumberController.text = user.contactNumber;
    selectedGender ??= user.gender.isNotEmpty ? user.gender[0].toUpperCase() + user.gender.substring(1).toLowerCase() : 'Male';
    selectedBloodGroup ??= user.bloodGroup.isNotEmpty ? user.bloodGroup : 'O+';

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
                                bloodGroup: selectedBloodGroup ?? user.bloodGroup,
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
                    child: _buildEditableField("First Name", firstNameController)),
                SizedBox(width: 10.w),
                Expanded(
                    child: _buildEditableField("Last Name", lastNameController)),
              ],
            ),
            kheight20,
            _buildEditableField("Contact Number", contactNumberController,
                keyboardType: TextInputType.phone),
            kheight20,
            Row(
              children: [
                Expanded(child: _buildEditableField("Age", ageController, keyboardType: TextInputType.number)),
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
