import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qflow/Presentation/Home/mainscreen.dart';
import 'package:qflow/application/auth/register_details/register_details_cubit.dart';
import 'package:qflow/application/auth/register_details/register_details_state.dart';
import 'package:qflow/constants/const.dart';
import 'package:qflow/domain/core/di/injection.dart';

class RegisterDetailsScreen extends StatelessWidget {
  const RegisterDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<RegisterDetailsCubit>(),
      child: BlocConsumer<RegisterDetailsCubit, RegisterDetailsState>(
        listener: (context, state) {
          state.failureOrSuccessOption.fold(
            () => null,
            (either) => either.fold(
              (failure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Failed to save details')),
                );
              },
              (_) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const MainScreen()),
                  (route) => false,
                );
              },
            ),
          );
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: Text(
                'Personal Details',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              centerTitle: true,
              automaticallyImplyLeading: false,
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Complete your profile',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 30.h),
                  Center(
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
                                .read<RegisterDetailsCubit>()
                                .profileImageChanged(image.path);
                          }
                        }
                      },
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 50.r,
                            backgroundColor: Colors.black12,
                            backgroundImage: state.profileImagePath != null
                                ? FileImage(File(state.profileImagePath!))
                                : null,
                            child: state.profileImagePath == null
                                ? Icon(Icons.person,
                                    size: 50.r, color: Colors.black26)
                                : null,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: CircleAvatar(
                              radius: 15.r,
                              backgroundColor: Colors.black,
                              child: Icon(Icons.add,
                                  size: 18.r, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30.h),
                  _buildTextField(
                    label: 'Username',
                    onChanged: (v) =>
                        context.read<RegisterDetailsCubit>().usernameChanged(v),
                  ),
                  kheight15,
                  _buildTextField(
                    label: 'First Name',
                    onChanged: (v) => context
                        .read<RegisterDetailsCubit>()
                        .firstNameChanged(v),
                  ),
                  kheight15,
                  _buildTextField(
                    label: 'Last Name',
                    onChanged: (v) =>
                        context.read<RegisterDetailsCubit>().lastNameChanged(v),
                  ),
                  kheight15,
                  _buildTextField(
                    label: 'Contact Number',
                    keyboardType: TextInputType.phone,
                    onChanged: (v) => context
                        .read<RegisterDetailsCubit>()
                        .contactNumberChanged(v),
                  ),
                  kheight15,
                  _buildTextField(
                    label: 'City',
                    onChanged: (v) =>
                        context.read<RegisterDetailsCubit>().cityChanged(v),
                  ),
                  kheight15,
                  _buildTextField(
                    label: 'District',
                    onChanged: (v) =>
                        context.read<RegisterDetailsCubit>().districtChanged(v),
                  ),
                  kheight15,
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          label: 'Age',
                          keyboardType: TextInputType.number,
                          onChanged: (v) =>
                              context.read<RegisterDetailsCubit>().ageChanged(v),
                        ),
                      ),
                      SizedBox(width: 15.w),
                      Expanded(
                        child: _buildTextField(
                          label: 'Weight (kg)',
                          keyboardType: TextInputType.number,
                          onChanged: (v) => context
                              .read<RegisterDetailsCubit>()
                              .weightChanged(v),
                        ),
                      ),
                    ],
                  ),
                  kheight15,
                  _buildTextField(
                    label: 'Height (cm)',
                    keyboardType: TextInputType.number,
                    onChanged: (v) => context
                        .read<RegisterDetailsCubit>()
                        .heightChanged(v),
                  ),
                  kheight15,
                  _buildDropdownField(
                    label: 'Gender',
                    value: state.gender,
                    items: ['Male', 'Female', 'Other'],
                    onChanged: (v) =>
                        context.read<RegisterDetailsCubit>().genderChanged(v!),
                  ),
                  kheight15,
                  _buildDropdownField(
                    label: 'Blood Group',
                    value: state.bloodGroup,
                    items: ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'],
                    onChanged: (v) => context
                        .read<RegisterDetailsCubit>()
                        .bloodGroupChanged(v!),
                  ),
                  SizedBox(height: 40.h),
                  if (state.isSubmitting)
                    const Center(
                        child: CircularProgressIndicator(color: Colors.black))
                  else
                    TextButton(
                      onPressed: () =>
                          context.read<RegisterDetailsCubit>().submit(),
                      style: ButtonStyle(
                        minimumSize: WidgetStateProperty.all(
                            Size(double.infinity, 54.82.h)),
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9.84.r),
                            side: const BorderSide(color: Colors.black),
                          ),
                        ),
                        backgroundColor: WidgetStateProperty.all(Colors.white),
                      ),
                      child: Text(
                        'Complete Registration',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  SizedBox(height: 30.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required Function(String) onChanged,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: 12.sp, color: Colors.black54),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(9.84.r),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black12),
          borderRadius: BorderRadius.circular(9.84.r),
        ),
      ),
      onChanged: onChanged,
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: 12.sp, color: Colors.black54),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(9.84.r),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black12),
          borderRadius: BorderRadius.circular(9.84.r),
        ),
      ),
      items: items
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: onChanged,
    );
  }
}
