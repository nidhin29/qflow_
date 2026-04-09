import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qflow/Presentation/common/book_widget.dart';
import 'package:qflow/application/appointment/appointment_cubit.dart';
import 'package:qflow/application/appointment/appointment_state.dart';
import 'package:qflow/application/hospital/hospital_cubit.dart';
import 'package:qflow/application/hospital/hospital_state.dart';
import 'package:qflow/application/member/member_cubit.dart';
import 'package:qflow/application/member/member_state.dart' as ms;
import 'package:qflow/domain/appointment/appointment_model/appointment_model.dart';
import 'package:qflow/domain/auth/app_session.dart';
import 'package:qflow/Presentation/Member/member_shimmer.dart';

class BookingPage extends StatelessWidget {
  final String hospitalId;
  const BookingPage({super.key, required this.hospitalId});

  @override
  Widget build(BuildContext context) {
    ValueNotifier<String?> selectedDepartment = ValueNotifier<String?>(null);
    ValueNotifier<String?> selectedPatient = ValueNotifier<String?>(null);
    ValueNotifier<TimeOfDay> selectedTime =
        ValueNotifier<TimeOfDay>(const TimeOfDay(hour: 9, minute: 0));
    ValueNotifier<DateTime> selectedDate =
        ValueNotifier<DateTime>(DateTime.now());

    Future<void> selectTime(BuildContext context) async {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: selectedTime.value,
        initialEntryMode: TimePickerEntryMode.inputOnly,
        builder: (context, child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: const ColorScheme.light(
                primary: Color.fromRGBO(66, 132, 156, 1),
                onPrimary: Colors.white,
                onSurface: Color.fromRGBO(66, 132, 156, 1),
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: const Color.fromRGBO(66, 132, 156, 1),
                ),
              ),
            ),
            child: child!,
          );
        },
      );
      if (picked != null && picked != selectedTime.value) {
        selectedTime.value = picked;
      }
    }

    Future<void> selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate.value,
        firstDate: DateTime.now(),
        lastDate: DateTime(2030),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: const ColorScheme.light(
                primary: Color.fromRGBO(66, 132, 156, 1),
                onPrimary: Colors.white,
                onSurface: Color.fromRGBO(66, 132, 156, 1),
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: const Color.fromRGBO(66, 132, 156, 1),
                ),
              ),
            ),
            child: child!,
          );
        },
      );
      if (picked != null && picked != selectedDate.value) {
        selectedDate.value = picked;
      }
    }

    return BlocBuilder<HospitalCubit, HospitalState>(
      builder: (context, hospitalState) {
        return hospitalState.selectedHospital.fold(
          () => const Scaffold(
            body: Center(child: HospitalCardShimmer()),
          ),
          (hospital) {
            return Scaffold(
              backgroundColor: Colors.white,
              body: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 60.h),
                      // Back Button
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ButtonStyle(
                          elevation: const WidgetStatePropertyAll(2),
                          minimumSize:
                              WidgetStateProperty.all(Size(36.w, 36.h)),
                          backgroundColor:
                              WidgetStateProperty.all(Colors.white),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                        ),
                        child: Icon(
                          Icons.arrow_back,
                          color: const Color(0xFF222222),
                          size: 16.sp,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      // Hospital Banner Image
                      Container(
                        width: double.infinity,
                        height: 330.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(21.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              spreadRadius: 0,
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                          image: DecorationImage(
                            image: (hospital.profileImageUrl != null &&
                                    hospital.profileImageUrl!.isNotEmpty)
                                ? NetworkImage(hospital.profileImageUrl!)
                                : const AssetImage("assets/icon/hospital.jpeg")
                                    as ImageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      // Hospital Name
                      Text(
                        hospital.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontFamily: 'CabinetGrotesk',
                          fontSize: 27.sp,
                          letterSpacing: -0.5,
                          color: const Color(0xFF272727),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      // Hospital Location
                      Text(
                        '${hospital.city}, ${hospital.district}',
                        style: GoogleFonts.dmSans(
                          fontWeight: FontWeight.w500,
                          fontSize: 17.5.sp,
                          color: const Color(0xFF595959),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      // Receptionist & Services Card
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(21.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              spreadRadius: 0,
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16.w, vertical: 4.h),
                              leading: CircleAvatar(
                                radius: 20.r,
                                backgroundImage: (hospital.receptionistImageUrl !=
                                            null &&
                                        hospital.receptionistImageUrl!.isNotEmpty)
                                    ? NetworkImage(hospital.receptionistImageUrl!)
                                    : (hospital.thumbnailUrl != null &&
                                            hospital.thumbnailUrl!.isNotEmpty)
                                        ? NetworkImage(hospital.thumbnailUrl!)
                                        : const AssetImage(
                                                'assets/icon/hospital.jpeg')
                                            as ImageProvider,
                              ),
                              title: Text(
                                hospital.receptionistName ?? 'Receptionist',
                                style: GoogleFonts.dmSans(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15.sp,
                                  color: const Color(0xFF272727),
                                ),
                              ),
                              trailing: Padding(
                                padding: EdgeInsets.only(right: 8.w),
                                child: Icon(Icons.phone_outlined,
                                    size: 20.sp,
                                    color: const Color(0xFF272727)),
                              ),
                            ),
                            // Service Chips - REFINED TO BE SLIMMER
                            Padding(
                              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                              child: SizedBox(
                                height: 19.h,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: hospital.availableServices.length,
                                  separatorBuilder: (context, _) =>
                                      SizedBox(width: 8.w),
                                  itemBuilder: (context, index) {
                                    return Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12.w),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFDFE2F3),
                                        borderRadius:
                                            BorderRadius.circular(20.r),
                                      ),
                                      child: Center(
                                        child: Text(
                                          hospital.availableServices[index],
                                          style: GoogleFonts.dmSans(
                                            fontSize: 11.5.sp,
                                            color: const Color(0xFF272727),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),
                      // Booking Card
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(22.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(28.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              spreadRadius: 0,
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Book your Slot',
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontFamily: 'CabinetGrotesk',
                                fontSize: 21.sp,
                                color: const Color(0xFF272727),
                              ),
                            ),
                            SizedBox(height: 18.h),
                            // Select Department
                            _buildLabel('Department'),
                            SizedBox(height: 6.h),
                            BookFieldWidget(
                              selectedDepartment: selectedDepartment,
                              title: 'Select',
                              list: hospital.availableServices,
                            ),
                            SizedBox(height: 14.h),
                            // Select Patient
                            _buildLabel('Patient'),
                            SizedBox(height: 6.h),
                            BlocBuilder<MemberCubit, ms.MemberState>(
                              builder: (context, state) {
                                final appSession = context.read<AppSession>();
                                final membersList =
                                    state.members.map((m) => m.name).toList();
                                
                                // Prepend current user's full name to the list
                                final currentUser = appSession.fullName ?? "Self";
                                final combinedList = [currentUser, ...membersList];
                                
                                return BookFieldWidget(
                                  selectedDepartment: selectedPatient,
                                  title: 'Select',
                                  list: combinedList,
                                );
                              },
                            ),
                            SizedBox(height: 14.h),
                            // Date and Time Row
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildLabel('Time'),
                                      SizedBox(height: 6.h),
                                      GestureDetector(
                                        onTap: () => selectTime(context),
                                        child:
                                            ValueListenableBuilder<TimeOfDay>(
                                          valueListenable: selectedTime,
                                          builder: (context, value, _) {
                                            return _buildDateTimePickerBox(
                                              context,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(value.format(context),
                                                      style: GoogleFonts.dmSans(
                                                          fontSize: 16.sp,
                                                          fontWeight:
                                                              FontWeight.w500)),
                                                  Container(
                                                      width: 1,
                                                      height: 20,
                                                      color: const Color(
                                                          0xFFD2D2D2)),
                                                  Text(
                                                      value.period ==
                                                              DayPeriod.am
                                                          ? "AM"
                                                          : "PM",
                                                      style: GoogleFonts.dmSans(
                                                          fontSize: 13.sp,
                                                          fontWeight:
                                                              FontWeight.w500)),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 14.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildLabel('Date'),
                                      SizedBox(height: 6.h),
                                      GestureDetector(
                                        onTap: () => selectDate(context),
                                        child: ValueListenableBuilder<DateTime>(
                                          valueListenable: selectedDate,
                                          builder: (context, value, _) {
                                            return _buildDateTimePickerBox(
                                              context,
                                              child: Text(
                                                "${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')}/${value.year}",
                                                style: GoogleFonts.dmSans(
                                                    fontSize: 16.sp,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 22.h),
                            // Book Now Button
                            BlocConsumer<AppointmentCubit, AppointmentState>(
                              listener: (context, state) {
                                state.failureOrSuccessOption.fold(
                                  () => null,
                                  (either) => either.fold(
                                    (f) => ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                            content: Text(f.map(
                                      clientFailure: (_) => 'Network Error',
                                      authFailure: (_) => 'Session Expired',
                                      serverFailure: (_) => 'Server Error',
                                      serverError: (e) =>
                                          e.message ?? 'Booking Failed',
                                    )))),
                                    (_) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content:
                                                  Text('Booking Successful')));
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                );
                              },
                              builder: (context, state) {
                                return ElevatedButton(
                                  onPressed: state.isLoading
                                      ? null
                                      : () {
                                          final appSession =
                                              context.read<AppSession>();
                                          final currentUserName =
                                              appSession.fullName ?? "User";

                                          // Validation
                                          if (selectedDepartment.value == null) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content: Text(
                                                        'Please select a department')));
                                            return;
                                          }
                                          if (selectedPatient.value == null) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content: Text(
                                                        'Please select a patient')));
                                            return;
                                          }

                                          // If "Self" is selected, use actual name from session
                                          final pName = (selectedPatient
                                                          .value ==
                                                      "Self" ||
                                                  selectedPatient.value ==
                                                      currentUserName)
                                              ? currentUserName
                                              : selectedPatient.value!;

                                          final appointment = AppointmentModel(
                                            hospitalId: hospitalId,
                                            hospitalName: hospital.name,
                                            hospitalAddress:
                                                '${hospital.city}, ${hospital.district}',
                                            appointmentDate: selectedDate.value
                                                .toIso8601String()
                                                .split('T')[0],
                                            appointmentTime: selectedTime.value
                                                .format(context),
                                            estimatedTime: 'Pending',
                                            tokenNumber: 'TBD',
                                            department:
                                                selectedDepartment.value!,
                                            departmentName:
                                                selectedDepartment.value!,
                                            patientName: pName,
                                          );
                                          context
                                              .read<AppointmentCubit>()
                                              .bookAppointment(appointment);
                                        },
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: Size(double.infinity, 52.h),
                                    backgroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.r)),
                                  ),
                                    child: state.isLoading
                                        ? SizedBox(
                                            height: 20.h,
                                            width: 20.h,
                                            child:
                                                const CircularProgressIndicator(),
                                          )
                                        : Text(
                                            'Book Now',
                                            style: GoogleFonts.dmSans(
                                              color: Colors.white,
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 30.h),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      );
    }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.dmSans(
        fontWeight: FontWeight.w400,
        fontSize: 14.5.sp,
        color: const Color(0xFF595959),
      ),
    );
  }

  Widget _buildDateTimePickerBox(BuildContext context,
      {required Widget child}) {
    return Container(
      height: 48.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F6F6),
        border: Border.all(color: const Color(0xFFD2D2D2)),
        borderRadius: BorderRadius.circular(10.r),
      ),
      alignment: Alignment.center,
      child: child,
    );
  }
}
