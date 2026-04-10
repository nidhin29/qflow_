import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qflow/application/profile/profile_cubit.dart';
import 'package:qflow/application/profile/profile_state.dart';
import 'package:qflow/domain/user/user_model/user_model.dart';
import 'package:qflow/constants/const.dart';

class ProfileEditForm extends StatefulWidget {
  final UserModel user;
  final VoidCallback onCancel;
  final ProfileState state;

  const ProfileEditForm({
    super.key,
    required this.user,
    required this.onCancel,
    required this.state,
  });

  @override
  State<ProfileEditForm> createState() => _ProfileEditFormState();
}

class _ProfileEditFormState extends State<ProfileEditForm> {
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
    firstNameController = TextEditingController(text: widget.user.firstName);
    lastNameController = TextEditingController(text: widget.user.lastName);
    usernameController = TextEditingController(text: widget.user.username);
    ageController = TextEditingController(text: widget.user.age.toString());
    weightController = TextEditingController(text: widget.user.weight.toString());
    heightController = TextEditingController(text: widget.user.height.toString());
    contactNumberController = TextEditingController(text: widget.user.contactNumber);
    
    selectedGender = widget.user.gender.isNotEmpty
        ? widget.user.gender[0].toUpperCase() + widget.user.gender.substring(1).toLowerCase()
        : 'Male';
    selectedBloodGroup = widget.user.bloodGroup.isNotEmpty ? widget.user.bloodGroup : 'O+';
  }

  @override
  void dispose() {
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
                    SizedBox(width: 79.w, height: 74.h),
                    SizedBox(
                      width: 69.w,
                      height: 69.h,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14.r),
                        child: widget.state.profileImagePath != null
                            ? Image.file(
                                File(widget.state.profileImagePath!),
                                fit: BoxFit.cover,
                                key: ValueKey(widget.state.profileImagePath),
                              )
                            : widget.user.profileImageUrl != null
                                ? CachedNetworkImage(
                                    imageUrl: widget.user.profileImageUrl!,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) =>
                                        widget.user.thumbnailUrl != null
                                            ? CachedNetworkImage(
                                                imageUrl: widget.user.thumbnailUrl!,
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
                                context.read<ProfileCubit>().profileImageChanged(image.path);
                              }
                            }
                          },
                          child: Icon(Icons.edit, size: 14.sp),
                        ),
                      ),
                    )
                  ],
                ),
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: widget.onCancel,
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(165.w, 25.h),
                        backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
                      ),
                      child: Text("Cancel", style: TextStyle(fontSize: 10.sp, color: Colors.black)),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ProfileCubit>().updateProfile(
                              user: widget.user.copyWith(
                                firstName: firstNameController.text,
                                lastName: lastNameController.text,
                                username: usernameController.text,
                                contactNumber: contactNumberController.text,
                                age: int.tryParse(ageController.text) ?? widget.user.age,
                                weight: double.tryParse(weightController.text) ?? widget.user.weight,
                                height: double.tryParse(heightController.text) ?? widget.user.height,
                                gender: selectedGender?.toLowerCase() ?? widget.user.gender,
                                bloodGroup: selectedBloodGroup ?? widget.user.bloodGroup,
                              ),
                            );
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(165.w, 25.h),
                        backgroundColor: Colors.greenAccent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
                      ),
                      child: Text("Save", style: TextStyle(fontSize: 10.sp, color: Colors.black)),
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
                Expanded(child: _buildEditableField("First Name", firstNameController)),
                SizedBox(width: 10.w),
                Expanded(child: _buildEditableField("Last Name", lastNameController)),
              ],
            ),
            kheight20,
            _buildEditableField("Contact Number", contactNumberController, keyboardType: TextInputType.phone),
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
                Expanded(child: _buildEditableField("Weight", weightController, keyboardType: TextInputType.number)),
                SizedBox(width: 10.w),
                Expanded(child: _buildEditableField("Height", heightController, keyboardType: TextInputType.number)),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w400)),
        SizedBox(height: 1.h),
        SizedBox(
          height: 35.h,
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(116, 116, 116, 1)),
            decoration: InputDecoration(
              fillColor: const Color.fromRGBO(248, 248, 248, 1),
              filled: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
              contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
            ),
          ),
        ),
      ],
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
        Text(label, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w400)),
        SizedBox(height: 1.h),
        SizedBox(
          height: 35.h,
          child: DropdownButtonFormField<String>(
            value: value,
            style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(116, 116, 116, 1)),
            decoration: InputDecoration(
              fillColor: const Color.fromRGBO(248, 248, 248, 1),
              filled: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
              contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
            ),
            items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
