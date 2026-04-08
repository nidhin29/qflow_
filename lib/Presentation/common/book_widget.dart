import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qflow/constants/const.dart';

class BookFieldWidget extends StatelessWidget {
  const BookFieldWidget({
    super.key,
    required this.selectedDepartment,
    required this.title,
    required this.list,
  });

  final ValueNotifier<String?> selectedDepartment;
  final String title;
  final List<String> list;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: GoogleFonts.dmSans(
                textStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16.sp,
              color: const Color.fromRGBO(39, 39, 39, 1),
            ))),
        kheight5,
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: Color.fromRGBO(210, 210, 210, 1)),
                borderRadius: BorderRadius.all(Radius.circular(8.77.r)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: Color.fromRGBO(210, 210, 210, 1)),
                borderRadius: BorderRadius.all(Radius.circular(8.77.r)),
              ),
              border: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: Color.fromRGBO(210, 210, 210, 1)),
                borderRadius: BorderRadius.all(Radius.circular(8.77.r)),
              ),
              fillColor: const Color.fromRGBO(246, 246, 246, 1),
              filled: true),
          value: selectedDepartment.value,
          hint: Text(
            'Select',
            style: GoogleFonts.dmSans(
                textStyle:
                    TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400)),
          ),
          items: list
              .map((dept) => DropdownMenuItem(value: dept, child: Text(dept)))
              .toList(),
          onChanged: (value) {
            selectedDepartment.value = value!;
          },
          dropdownColor: const Color.fromRGBO(246, 246, 246, 1),
          style: GoogleFonts.ptSans(
              textStyle: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color.fromRGBO(39, 39, 39, 1))),
        ),
      ],
    );
  }
}
