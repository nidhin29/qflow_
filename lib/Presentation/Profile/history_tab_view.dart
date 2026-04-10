import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:qflow/application/appointment/appointment_cubit.dart';
import 'package:qflow/application/appointment/appointment_state.dart' as app_state;
import 'package:qflow/Presentation/Core/empty_state_widget.dart';
import 'package:qflow/Presentation/Core/error_state_widget.dart';
import 'package:qflow/Presentation/Profile/profile_shimmer.dart';

class HistoryTabView extends StatelessWidget {
  const HistoryTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppointmentCubit, app_state.AppointmentState>(
      builder: (context, state) {
        if (state.isLoading && state.pastAppointments.isEmpty) {
          return const ProfileHistoryShimmer();
        }

        if (state.pastAppointments.isEmpty) {
          return state.failureOrSuccessOption.fold(
            () => SizedBox(
              height: 300.h,
              child: const EmptyStateWidget(
                title: 'No History',
                description: 'You haven’t completed any appointments yet.',
              ),
            ),
            (either) => either.fold(
              (failure) => SizedBox(
                height: 300.h,
                child: ErrorStateWidget(
                  errorMessage: failure.map(
                    clientFailure: (_) => 'Check your connection.',
                    authFailure: (_) => 'Session expired.',
                    serverFailure: (_) => 'Unable to load history.',
                    serverError: (e) => e.message ?? 'History error.',
                  ),
                  onRetry: () => context.read<AppointmentCubit>().getPastAppointments(),
                ),
              ),
              (_) => SizedBox(
                height: 300.h,
                child: const EmptyStateWidget(
                  title: 'No History',
                  description: 'You haven’t completed any appointments yet.',
                ),
              ),
            ),
          );
        }

        return ListView.separated(
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: 31.w, vertical: 20.h),
          itemCount: state.pastAppointments.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            final appointment = state.pastAppointments[index];
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Row(
                children: [
                  Container(
                    width: 50.w,
                    height: 50.w,
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: const Center(
                      child: Icon(Icons.local_hospital_outlined, color: Color(0xFF1A3355)),
                    ),
                  ),
                  SizedBox(width: 15.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appointment.hospitalName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Text(
                          DateFormat('dd MMM yyyy').format(DateTime.parse(appointment.appointmentDate)),
                          style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w500, color: Colors.grey[500]),
                        ),
                        Text(
                          appointment.patientName,
                          style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w500, color: Colors.grey[400]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
