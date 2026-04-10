import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qflow/application/member/member_cubit.dart';
import 'package:qflow/application/member/member_state.dart' as ms;
import 'package:qflow/domain/member/member_model.dart';

class MemberTabView extends StatelessWidget {
  const MemberTabView({super.key});

  @override
  Widget build(BuildContext context) {
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
                      serverError: (e) => e.message ?? 'Server error',
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
        // Shimmers should be imported or defined here. 
        // For now, using placeholders if they are not accessible.
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
                        Icon(Icons.people_outline, size: 64.sp, color: Colors.grey[300]),
                        SizedBox(height: 16.h),
                        Text(
                          "No family members added yet",
                          style: TextStyle(color: Colors.grey[500], fontSize: 14.sp),
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
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final member = state.members[index];
                    return MemberCard(member: member);
                  },
                ),
              SizedBox(height: 10.h),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  onPressed: () => _showMemberSheet(context),
                  child: Text('Add Member',
                      style: TextStyle(
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFFA4A4A4),
                      )),
                ),
              ),
              SizedBox(height: 100.h),
            ],
          ),
        );
      },
    );
  }

  void _showMemberSheet(BuildContext context, {MemberModel? existingMember}) {
    final isEditing = existingMember != null;
    final nameController = TextEditingController(text: existingMember?.name);
    final ageController = TextEditingController(text: existingMember?.age.toString() ?? "");
    final weightController = TextEditingController(text: existingMember?.weight?.toString() ?? "");
    final heightController = TextEditingController(text: existingMember?.height?.toString() ?? "");

    final List<String> relationItems = ['Mother', 'Father', 'Spouse', 'Child', 'Parent', 'Sibling', 'Other'];
    String selectedRelation = isEditing 
        ? relationItems.firstWhere((e) => e.toLowerCase() == existingMember.relation.toLowerCase(), orElse: () => 'Other')
        : 'Spouse';
    String selectedGender = isEditing ? existingMember.gender.toLowerCase() : 'male';
    String selectedBloodGroup = (isEditing && existingMember.bloodGroup.isNotEmpty) ? existingMember.bloodGroup : 'O+';

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
                  Center(child: Container(width: 40.w, height: 4.h, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2.r)))),
                  SizedBox(height: 20.h),
                  Text(isEditing ? "Edit Family Member" : "Add Family Member", style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w600)),
                  SizedBox(height: 25.h),
                  _buildSheetField("Full Name", nameController),
                  SizedBox(height: 15.h),
                  Row(
                    children: [
                      Expanded(child: _buildSheetField("Age", ageController, keyboardType: TextInputType.number)),
                      SizedBox(width: 15.w),
                      Expanded(
                        child: _buildDropdownField(
                          label: "Relationship",
                          value: selectedRelation,
                          items: relationItems,
                          onChanged: (val) => setModalState(() => selectedRelation = val!),
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
                          onChanged: (val) => setModalState(() => selectedGender = val!),
                        ),
                      ),
                      SizedBox(width: 15.w),
                      Expanded(
                        child: _buildDropdownField(
                          label: "Blood Group",
                          value: selectedBloodGroup,
                          items: ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'],
                          onChanged: (val) => setModalState(() => selectedBloodGroup = val!),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15.h),
                  Row(
                    children: [
                      Expanded(child: _buildSheetField("Weight (kg)", weightController, keyboardType: TextInputType.number)),
                      SizedBox(width: 15.w),
                      Expanded(child: _buildSheetField("Height (cm)", heightController, keyboardType: TextInputType.number)),
                    ],
                  ),
                  SizedBox(height: 40.h),
                  ElevatedButton(
                    onPressed: () {
                      final member = (isEditing ? existingMember : const MemberModel(name: '', age: 0, gender: '', bloodGroup: '', relation: '')).copyWith(
                        name: nameController.text,
                        age: int.tryParse(ageController.text) ?? 0,
                        gender: selectedGender,
                        bloodGroup: selectedBloodGroup,
                        relation: selectedRelation,
                        weight: double.tryParse(weightController.text),
                        height: double.tryParse(heightController.text),
                      );
                      if (isEditing) {
                        context.read<MemberCubit>().updateMember(member: member);
                      } else {
                        context.read<MemberCubit>().addMember(member: member);
                      }
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50.h),
                      backgroundColor: Colors.greenAccent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
                    ),
                    child: Text(isEditing ? "Save Changes" : "Register Member", style: TextStyle(color: Colors.black, fontSize: 14.sp, fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(height: 12.h),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50.h),
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
                    ),
                    child: Text("Cancel", style: TextStyle(color: Colors.black, fontSize: 14.sp, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSheetField(String label, TextEditingController controller, {TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w400)),
        SizedBox(height: 1.h),
        SizedBox(
          height: 45.h,
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
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

  Widget _buildDropdownField({required String label, required String value, required List<String> items, required Function(String?) onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w400)),
        SizedBox(height: 1.h),
        SizedBox(
          height: 45.h,
          child: DropdownButtonFormField<String>(
            value: value,
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

class MemberCard extends StatelessWidget {
  final MemberModel member;
  const MemberCard({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(member.name, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w400)),
      subtitle: Text('Age : ${member.age}', style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w400)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.edit, size: 18.sp),
            onPressed: () => const MemberTabView()._showMemberSheet(context, existingMember: member),
          ),
          IconButton(
            icon: Icon(Icons.delete, size: 18.sp, color: Colors.redAccent),
            onPressed: () => context.read<MemberCubit>().deleteMember(member.id ?? ""),
          ),
        ],
      ),
    );
  }
}
