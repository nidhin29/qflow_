import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qflow/Presentation/common/book_widget.dart';
import 'package:qflow/Presentation/common/file_widget.dart';
import 'package:qflow/application/appointment/appointment_cubit.dart';
import 'package:qflow/application/appointment/appointment_state.dart';
import 'package:qflow/constants/const.dart';
import 'package:qflow/domain/appointment/appointment_model/appointment_model.dart';

class BookingPage extends StatelessWidget {
  const BookingPage({super.key});

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

    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      body: SingleChildScrollView(
        child: Padding(
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
              Container(
                width: 350.w,
                height: 339.h,
                decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage("assets/icon/hospital.jpeg"),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(21.r),
                    boxShadow: [
                      BoxShadow(
                        // ignore: deprecated_member_use
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 7,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ]),
              ),
              kheight20,
              Text(
                'Dr. KM Cherian Institute of Medical Science',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontFamily: 'CabinetGrotesk',
                  fontSize: 23.sp,
                  color: const Color.fromRGBO(39, 39, 39, 1),
                ),
              ),
              kheight15,
              Text('Kallishery,Alappuzha',
                  style: GoogleFonts.dmSans(
                      textStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 19.sp,
                    color: const Color.fromRGBO(39, 39, 39, 1),
                  ))),
              kheight15,
              Container(
                width: 350.w,
                height: 125.h,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(255, 255, 255, 1),
                  borderRadius: BorderRadius.circular(21.r),
                  boxShadow: [
                    BoxShadow(
                      // ignore: deprecated_member_use
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 7,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 1.w, vertical: 5.w),
                      child: ListTile(
                        tileColor: const Color.fromRGBO(252, 252, 252, 1),
                        leading: CircleAvatar(
                          radius: 20.r,
                          backgroundImage:
                              const AssetImage('assets/icon/hospital.jpeg'),
                        ),
                        title: Text('Receptionist',
                            style: GoogleFonts.ptSans(
                                textStyle: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12.9.sp,
                              color: const Color.fromRGBO(39, 39, 39, 1),
                            ))),
                        trailing: Image.asset(
                          'assets/icon/call.png',
                          color: Colors.black,
                          scale: 0.9,
                        ),
                      ),
                    ),
                    kheight20,
                    Padding(
                      padding: EdgeInsets.only(left: 18.w),
                      child: const SizedBox(
                        height: 20,
                        child: FieldsWidget(
                          color: Color.fromRGBO(39, 39, 39, 1),
                          color1: Color.fromRGBO(223, 226, 243, 1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              kheight20,
              Container(
                width: 350.w,
                height: 461.h,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(255, 255, 255, 1),
                  borderRadius: BorderRadius.circular(28.r),
                  boxShadow: [
                    BoxShadow(
                      // ignore: deprecated_member_use
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 7,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 20.h, right: 20.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          kheight20,
                          kheight5,
                          kheight10,
                          Text(
                            'Book your Slot',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontFamily: 'TestSohne',
                              fontSize: 19.sp,
                              color: const Color.fromRGBO(39, 39, 39, 1),
                            ),
                          ),
                          kheight20,
                          BookFieldWidget(
                            selectedDepartment: selectedDepartment,
                            title: 'Department',
                            list: const [
                              'Cardiology',
                              'Neurology',
                              'Orthopedics'
                            ],
                          ),
                          kheight10,
                          BookFieldWidget(
                            selectedDepartment: selectedPatient,
                            title: 'Patient',
                            list: const ['John', 'Alex', 'Mathew'],
                          ),
                          kheight10,
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Time',
                                        style: GoogleFonts.dmSans(
                                            textStyle: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16.sp,
                                          color: const Color.fromRGBO(
                                              39, 39, 39, 1),
                                        ))),
                                    Container(
                                      width: 130.w,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: const Color.fromRGBO(
                                                210, 210, 210, 1)),
                                        borderRadius: BorderRadius.circular(10),
                                        color: const Color.fromRGBO(
                                            246, 246, 246, 1),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          GestureDetector(
                                            onTap: () async {
                                              await selectTime(context);
                                            },
                                            child: ValueListenableBuilder<
                                                TimeOfDay>(
                                              valueListenable: selectedTime,
                                              builder: (context, value, child) {
                                                return Row(
                                                  children: [
                                                    Text(
                                                      value.format(context),
                                                      style: GoogleFonts.dmSans(
                                                          textStyle: TextStyle(
                                                              fontSize: 17.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400)),
                                                    ),
                                                    const SizedBox(width: 3),
                                                  ],
                                                );
                                              },
                                            ),
                                          ),
                                          Container(
                                            width: 1.5,
                                            height: 55,
                                            color: const Color.fromRGBO(
                                                210, 210, 210, 1),
                                          ),
                                          const SizedBox(width: 12),
                                          GestureDetector(
                                            onTap: () {
                                              // Toggle AM/PM
                                              if (selectedTime.value.period ==
                                                  DayPeriod.am) {
                                                selectedTime.value = TimeOfDay(
                                                    hour: selectedTime
                                                            .value.hour +
                                                        12,
                                                    minute: selectedTime
                                                        .value.minute);
                                              } else {
                                                selectedTime.value = TimeOfDay(
                                                    hour: selectedTime
                                                            .value.hour -
                                                        12,
                                                    minute: selectedTime
                                                        .value.minute);
                                              }
                                            },
                                            child: ValueListenableBuilder<
                                                TimeOfDay>(
                                              valueListenable: selectedTime,
                                              builder: (context, value, child) {
                                                return Text(
                                                  value.period == DayPeriod.am
                                                      ? "AM"
                                                      : "PM",
                                                  style: GoogleFonts.dmSans(
                                                      textStyle: TextStyle(
                                                          fontSize: 14.sp,
                                                          fontWeight:
                                                              FontWeight.w400)),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 10.w),
                                    child: Text('Date',
                                        style: GoogleFonts.dmSans(
                                            textStyle: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16.sp,
                                          color: const Color.fromRGBO(
                                              39, 39, 39, 1),
                                        ))),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 10.w),
                                    child: InkWell(
                                      onTap: () => selectDate(context),
                                      child: InputDecorator(
                                        decoration: InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Color.fromRGBO(
                                                      210, 210, 210, 1)),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8.77.r)),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Color.fromRGBO(
                                                      210, 210, 210, 1)),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8.77.r)),
                                            ),
                                            border: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Color.fromRGBO(
                                                      210, 210, 210, 1)),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8.77.r)),
                                            ),
                                            fillColor: const Color.fromRGBO(
                                                246, 246, 246, 1),
                                            filled: true),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8),
                                          child: ValueListenableBuilder(
                                            valueListenable: selectedDate,
                                            builder: (context, value, child) {
                                              return Text(
                                                "${value.day}/${value.month}/${value.year}",
                                                style: GoogleFonts.dmSans(
                                                    textStyle: TextStyle(
                                                        fontSize: 18.sp,
                                                        fontWeight:
                                                            FontWeight.w400)),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                            ],
                          ),
                          kheight20,
                        ],
                      ),
                    ),
                    BlocConsumer<AppointmentCubit, AppointmentState>(
                      listener: (context, state) {
                        state.failureOrSuccessOption.fold(
                          () => null,
                          (either) => either.fold(
                            (f) => ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Booking Failed')),
                            ),
                            (_) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Booking Successful')),
                              );
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
                                  final appointment = AppointmentModel(
                                    hospitalId: '123', // Dummy for now
                                    hospitalName:
                                        'Dr. KM Cherian Institute of Medical Science',
                                    hospitalAddress: 'Kallishery,Alappuzha',
                                    appointmentDate: selectedDate.value
                                        .toIso8601String()
                                        .split('T')[0],
                                    appointmentTime:
                                        selectedTime.value.format(context),
                                    estimatedTime: 'Pending',
                                    tokenNumber: 'TBD',
                                    department: selectedDepartment.value ??
                                        'General',
                                    departmentName: selectedDepartment.value ??
                                        'General',
                                    patientName: selectedPatient.value ??
                                        'Self',
                                  );

                                  context
                                      .read<AppointmentCubit>()
                                      .bookAppointment(appointment);
                                },
                          style: ButtonStyle(
                            minimumSize:
                                WidgetStateProperty.all(Size(330.w, 52.h)),
                            backgroundColor:
                                WidgetStateProperty.all(Colors.black),
                            overlayColor:
                                WidgetStateProperty.all(Colors.transparent),
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.2.r),
                              ),
                            ),
                          ),
                          child: state.isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : Text(
                                  'Book Now',
                                  style: GoogleFonts.ptSans(
                                      textStyle: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 18.sp,
                                          color: Colors.white)),
                                ),
                        );
                      },
                    )
                  ],
                ),
              ),
              kheight20,
              kheight20,
              kheight20
            ],
          ),
        ),
      ),
    );
  }
}
