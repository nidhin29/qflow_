import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qflow/Presentation/Member/booking.dart';
import 'package:qflow/application/hospital/hospital_cubit.dart';
import 'package:qflow/application/hospital/hospital_state.dart' as hs;
import 'package:qflow/application/profile/profile_cubit.dart';
import 'package:qflow/constants/const.dart';
import 'package:qflow/domain/core/di/injection.dart';
import 'package:qflow/domain/auth/app_session.dart';
import 'package:qflow/Presentation/Core/snackbar_utils.dart';

class SearchPage extends StatefulWidget {
  final String label;
  const SearchPage({super.key, required this.label});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final ValueNotifier<bool> valueListenable = ValueNotifier<bool>(false);
  final ValueNotifier<bool> valueListenable1 = ValueNotifier<bool>(false);
  final ValueNotifier<bool> valueListenable2 = ValueNotifier<bool>(false);
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    // Listen to tile changes to trigger search with filters
    valueListenable.addListener(_onFilterChanged);
    valueListenable1.addListener(_onFilterChanged);
    valueListenable2.addListener(_onFilterChanged);
  }

  @override
  void dispose() {
    valueListenable.removeListener(_onFilterChanged);
    valueListenable1.removeListener(_onFilterChanged);
    valueListenable2.removeListener(_onFilterChanged);
    _searchController.dispose();
    _debounce?.cancel();
    valueListenable.dispose();
    valueListenable1.dispose();
    valueListenable2.dispose();
    super.dispose();
  }

  void _onFilterChanged() {
    _triggerSearch();
  }

  void _triggerSearch() {
    final query = _searchController.text;
    if (widget.label == 'Location') {
      context.read<HospitalCubit>().searchLocations(query: query);
    } else {
      String? filter;
      if (valueListenable.value) filter = 'hospital';
      if (valueListenable1.value) filter = 'place';
      if (valueListenable2.value) filter = 'department';

      context.read<HospitalCubit>().searchHospitals(
            query: query,
            filter: filter,
          );
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _triggerSearch();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HospitalCubit, hs.HospitalState>(
      listener: (context, state) {
        state.failureOrSuccessOption.fold(
          () => null,
          (either) => either.fold(
            (failure) => showErrorSnackBar(context, failure),
            (success) => null,
          ),
        );
      },
      child: Scaffold(
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
                controller: _searchController,
                onChanged: _onSearchChanged,
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
                  hintText: widget.label == 'Search'
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
            widget.label == 'Search' ? kheight20 : const SizedBox(),
            widget.label == 'Search'
                ? Row(
                    children: [
                      TileWidget(
                          valueListenable: valueListenable,
                          text: "Hospital",
                          onTap: () {
                            valueListenable.value = !valueListenable.value;
                            if (valueListenable.value) {
                              valueListenable1.value = false;
                              valueListenable2.value = false;
                            }
                          }),
                      kwidth5,
                      TileWidget(
                          valueListenable: valueListenable1,
                          text: "Place",
                          onTap: () {
                            valueListenable1.value = !valueListenable1.value;
                            if (valueListenable1.value) {
                              valueListenable.value = false;
                              valueListenable2.value = false;
                            }
                          }),
                      kwidth5,
                      TileWidget(
                          valueListenable: valueListenable2,
                          text: "Department",
                          onTap: () {
                            valueListenable2.value = !valueListenable2.value;
                            if (valueListenable2.value) {
                              valueListenable.value = false;
                              valueListenable1.value = false;
                            }
                          }),
                    ],
                  )
                : const SizedBox(),
            widget.label == 'Search' ? kheight20 : const SizedBox(),
            Expanded(
              child: BlocBuilder<HospitalCubit, hs.HospitalState>(
                builder: (context, hospitalState) {
                  if (widget.label == 'Location') {
                    return ListView.separated(
                      itemCount: hospitalState.locationSuggestions.length,
                      separatorBuilder: (context, index) => const Divider(
                        color: Color.fromRGBO(236, 237, 238, 1),
                        thickness: 1,
                      ),
                      itemBuilder: (context, index) {
                        final location =
                            hospitalState.locationSuggestions[index];
                        return ListTile(
                          onTap: () async {
                            final profileCubit = context.read<ProfileCubit>();
                            profileCubit.state.userOption
                                .fold(() => null, (user) {
                              final updatedUser = user.copyWith(
                                city: location.city,
                                district: location.district,
                              );
                              profileCubit.updateProfile(user: updatedUser);
                              context
                                  .read<HospitalCubit>()
                                  .getHospitalsByLocation(
                                      location: location.city);
                              Navigator.pop(context);
                            });
                          },
                          title: Text(
                            location.city,
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                color: const Color.fromRGBO(34, 34, 34, 1),
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          subtitle: Text(
                            location.district,
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                color: const Color.fromRGBO(131, 131, 131, 1),
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }

                  final results = widget.label == 'Search'
                      ? hospitalState.searchedHospitals
                      : [];

                  return ListView.separated(
                      itemBuilder: (context, index) {
                        final hospital =
                            results.isNotEmpty && index < results.length
                                ? results[index]
                                : null;
                        return Column(
                          children: [
                            ListTile(
                              onTap: hospital != null
                                  ? () {
                                      // Trigger fresh fetch for the specific hospital ID
                                      context.read<HospitalCubit>().getHospitalById(
                                          hospitalId: hospital.id);
                                      // Redirect straight to booking page as requested
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => BookingPage(
                                            hospitalId: hospital.id,
                                          ),
                                        ),
                                      );
                                    }
                                  : null,
                              title: Text(
                                hospital?.name ??
                                    (widget.label == 'Search'
                                        ? 'Dr. KM Cherian Institute of Medical Science'
                                        : getIt<AppSession>().city ??
                                            'Chengannur'),
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    color: const Color.fromRGBO(34, 34, 34, 1),
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              subtitle: widget.label == 'Search'
                                  ? Text(
                                      hospital?.city ?? 'Kallishery',
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
                                            color:
                                                Color.fromRGBO(236, 237, 238, 1),
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
                        if (widget.label == 'Search') {
                          return const Divider(
                            color: Color.fromRGBO(236, 237, 238, 1),
                            thickness: 1,
                            indent: 15,
                            endIndent: 35,
                          );
                        }
                        return const SizedBox();
                      },
                      itemCount: results.isEmpty ? 5 : results.length);
                },
              ),
            ),
            kheight20,
            kheight20
          ],
        ),
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
    required this.onTap,
  });

  final ValueNotifier<bool> valueListenable;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: valueListenable,
      builder: (context, value, child) {
        return GestureDetector(
          onTap: onTap,
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
