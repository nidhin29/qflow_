import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qflow/constants/const.dart';

class SearchPage extends StatelessWidget {
  final String label;
  SearchPage({super.key, required this.label});
  final ValueNotifier<bool> valueListenable = ValueNotifier<bool>(false);
  final ValueNotifier<bool> valueListenable1 = ValueNotifier<bool>(false);
  final ValueNotifier<bool> valueListenable2 = ValueNotifier<bool>(false);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      body: Padding(
        padding: EdgeInsets.only(left: 25.h, right: 25.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            kheight20,
            kheight10,
            kheight20,
            kheight20,
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                elevation: const WidgetStatePropertyAll(4),
                minimumSize: WidgetStateProperty.all(Size(75.w, 48.h)),
                backgroundColor: WidgetStateProperty.all(
                    const Color.fromRGBO(255, 255, 255, 1)),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                ),
              ),
              child: const Icon(
                Icons.arrow_back,
                weight: 600,
                color: Color.fromRGBO(34, 34, 34, 1),
                size: 18,
              ),
            ),
            kheight20,
            kheight10,
            SizedBox(
              width: 362.w,
              height: 80.h,
              child: TextField(
                cursorColor: const Color.fromRGBO(66, 132, 156, 1),
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    color: Color.fromRGBO(34, 34, 34, 1),
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                decoration: InputDecoration(
                  counterStyle: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      color: Color.fromRGBO(173, 173, 173, 1),
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  prefixIcon: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      surfaceTintColor: Colors.white,
                      overlayColor: const Color.fromRGBO(173, 173, 173, 1),
                    ),
                    child: Container(
                      width: 28.w,
                      height: 28.h,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/icon/search1.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  hintText: label == 'Search'
                      ? "Search for Hospitals,Place,Departments"
                      : 'Search for Place',
                  hintStyle: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                          color: Color.fromRGBO(173, 173, 173, 1),
                          fontSize: 13,
                          fontWeight: FontWeight.w400)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.r),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: const Color.fromRGBO(248, 248, 248, 0.6),
                  contentPadding: EdgeInsets.symmetric(vertical: 25.h),
                ),
              ),
            ),
            label == 'Search' ? kheight20 : const SizedBox(),
            label == 'Search'
                ? Row(
                    children: [
                      TileWidget(
                          valueListenable: valueListenable, text: "Hospital"),
                      kwidth5,
                      TileWidget(
                          valueListenable: valueListenable1, text: "Place"),
                      kwidth5,
                      TileWidget(
                          valueListenable: valueListenable2,
                          text: "Department"),
                    ],
                  )
                : const SizedBox(),
            label == 'Search' ? kheight20 : const SizedBox(),
            Expanded(
              child: ListView.separated(
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        ListTile(
                          title: Text(
                            label == 'Search'
                                ? 'Dr. KM Cherian Institute of Medical Science'
                                : 'Chengannur',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                color: const Color.fromRGBO(34, 34, 34, 1),
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          subtitle: label == 'Search'
                              ? Text(
                                  'Kallishery',
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      color: const Color.fromRGBO(
                                          131, 131, 131, 0.5),
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                )
                              : index != 4
                                  ? Padding(
                                      padding: EdgeInsets.only(top: 15.w),
                                      child: const Divider(
                                        color: Color.fromRGBO(236, 237, 238, 1),
                                        thickness: 1,
                                        indent: 0,
                                        endIndent: 0,
                                      ),
                                    )
                                  : const SizedBox(),
                        ),
                      ],
                    );
                  },
                  separatorBuilder: (context, index) {
                    if (label == 'Search') {
                      return const Divider(
                        color: Color.fromRGBO(236, 237, 238, 1),
                        thickness: 1,
                        indent: 15,
                        endIndent: 35,
                      );
                    }
                    return const SizedBox();
                  },
                  itemCount: 5),
            ),
            kheight20,
            kheight20
          ],
        ),
      ),
    );
  }
}

class TileWidget extends StatelessWidget {
  const TileWidget({
    super.key,
    required this.valueListenable,
    required this.text,
  });

  final ValueNotifier<bool> valueListenable;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: valueListenable,
      builder: (context, value, child) {
        return GestureDetector(
          onTap: () {
            valueListenable.value = !value;
          },
          child: Container(
            width: text == 'Place'
                ? value
                    ? 85.w
                    : 60.w
                : text == 'Department'
                    ? value
                        ? 125.w
                        : 100.w
                    : value
                        ? 105.w
                        : 76.w,
            decoration: BoxDecoration(
              border: Border.all(
                color: value
                    ? const Color.fromRGBO(41, 177, 229, 1)
                    : const Color.fromRGBO(74, 76, 77, 0.2),
              ),
              borderRadius: BorderRadius.circular(20.r),
              color: value
                  ? const Color.fromRGBO(41, 177, 229, 1)
                  : const Color.fromRGBO(255, 255, 255, 1),
            ),
            height: 40.h,
            child: Padding(
              padding: EdgeInsets.only(
                left: 10.w,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  value
                      ? Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 17.sp,
                        )
                      : const SizedBox(),
                  value ? kwidth5 : const SizedBox(),
                  Text(
                    text,
                    style: GoogleFonts.dmSans(
                      textStyle: TextStyle(
                        color: value
                            ? Colors.white
                            : const Color.fromRGBO(41, 177, 229, 1),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
