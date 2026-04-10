import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:qflow/application/appointment/appointment_cubit.dart';
import 'package:qflow/application/appointment/appointment_state.dart';
import 'package:qflow/application/profile/profile_cubit.dart';
import 'package:qflow/application/profile/profile_state.dart';
import 'package:qflow/domain/appointment/appointment_model/appointment_model.dart';
import 'package:qflow/domain/core/failures.dart';
import 'package:qflow/Presentation/Home/home_shimmer.dart';
import 'package:qflow/Presentation/Core/empty_state_widget.dart';
import 'package:qflow/Presentation/Notification/notification.dart';
import 'package:qflow/domain/auth/app_session.dart';
import 'package:qflow/domain/core/di/injection.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _refreshData(BuildContext context) async {
    final appointmentCubit = context.read<AppointmentCubit>();
    await Future.wait([
      appointmentCubit.getUpcomingAppointments(),
      appointmentCubit.getPastAppointments(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Profile check
      final profileState = context.read<ProfileCubit>().state;
      if (profileState.userOption.isNone() && !profileState.isLoading) {
        context.read<ProfileCubit>().getUserDetails();
      }

      // Appointment check
      final appointmentState = context.read<AppointmentCubit>().state;
      
      if (!appointmentState.hasInitialized && !appointmentState.isLoading) {
        context.read<AppointmentCubit>().getUpcomingAppointments();
        context.read<AppointmentCubit>().getPastAppointments();
      }
    });

    return MultiBlocListener(
      listeners: [
        BlocListener<ProfileCubit, ProfileState>(
          listener: (context, state) {
            state.failureOrSuccessOption.fold(
              () => null,
              (either) => either.fold(
                (failure) => _showErrorSnackBar(context, failure),
                (success) => null,
              ),
            );
          },
        ),
        BlocListener<AppointmentCubit, AppointmentState>(
          listener: (context, state) {
            state.failureOrSuccessOption.fold(
              () => null,
              (either) => either.fold(
                (failure) => _showErrorSnackBar(context, failure),
                (success) => null,
              ),
            );
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
        body: RefreshIndicator(
          onRefresh: () => _refreshData(context),
          color: const Color.fromRGBO(66, 132, 156, 1),
          backgroundColor: Colors.white,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 70.h),
                  const _HomeHeader(),
                  SizedBox(height: 25.h),
                  const _HomeSearchField(),
                  SizedBox(height: 30.h),
                  const _HomeSectionTitle(),
                  SizedBox(height: 20.h),
                  const _HomeAppointmentCarousel(),
                  SizedBox(height: 35.h),
                  const _HomePastAppointmentsTitle(),
                  const _HomePastAppointmentsList(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, MainFailure failure) {
    final message = failure.map(
      clientFailure: (_) => "Something wrong with your network",
      authFailure: (_) => "Access token timed out",
      serverFailure: (_) => "Server is down",
      serverError: (e) => e.message ?? "Something Unexpected Happened",
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back',
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w400, color: Colors.grey[600]),
            ),
            BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, state) {
                final session = getIt<AppSession>();
                // Prioritize session full name if available (instant response),
                // otherwise fall back to profile state if it has a result.
                final userName = state.userOption.fold(
                  () => session.fullName ?? 'User', 
                  (user) => '${user.firstName} ${user.lastName}'
                );
                
                return Text(
                  userName,
                  style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w600, fontFamily: 'CabinetGrotesk'),
                );
              },
            ),
          ],
        ),
        GestureDetector(
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const NotificationPage())),
          child: Container(
            width: 50.w,
            height: 50.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color.fromRGBO(245, 245, 245, 1),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Center(child: Image.asset('assets/icon/not.png', width: 24.w, height: 24.w)),
          ),
        )
      ],
    );
  }
}

class _HomeSearchField extends StatefulWidget {
  const _HomeSearchField();

  @override
  State<_HomeSearchField> createState() => _HomeSearchFieldState();
}

class _HomeSearchFieldState extends State<_HomeSearchField> {
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55.h,
      child: TextField(
        controller: searchController,
        cursorColor: const Color.fromRGBO(66, 132, 156, 1),
        onChanged: (value) {
          context.read<AppointmentCubit>().searchAppointments(value);
          setState(() {}); // To update clear button visibility
        },
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: EdgeInsets.all(15.w),
            child: Image.asset("assets/icon/search1.png", color: Colors.grey[400]),
          ),
          suffixIcon: searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, color: Colors.grey[400]),
                  onPressed: () {
                    searchController.clear();
                    context.read<AppointmentCubit>().clearSearch();
                    setState(() {});
                  },
                )
              : null,
          hintText: 'Search',
          hintStyle: GoogleFonts.poppins(fontSize: 14.sp, color: Colors.grey[400]),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.r), borderSide: BorderSide.none),
          filled: true,
          fillColor: const Color.fromRGBO(248, 248, 248, 1),
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }
}

class _HomeSectionTitle extends StatelessWidget {
  const _HomeSectionTitle();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppointmentCubit, AppointmentState>(
      builder: (context, state) {
        return Text(state.isSearching ? 'Search Results' : 'My Appointments',
            style: GoogleFonts.dmSans(fontSize: 18.sp, fontWeight: FontWeight.w700, color: const Color.fromRGBO(39, 39, 39, 1)));
      },
    );
  }
}

class _HomeAppointmentCarousel extends StatefulWidget {
  const _HomeAppointmentCarousel();

  @override
  State<_HomeAppointmentCarousel> createState() => _HomeAppointmentCarouselState();
}

class _HomeAppointmentCarouselState extends State<_HomeAppointmentCarousel> {
  late PageController pageController;
  late ValueNotifier<int> currentPageNotifier;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    currentPageNotifier = ValueNotifier<int>(0);
  }

  @override
  void dispose() {
    pageController.dispose();
    currentPageNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppointmentCubit, AppointmentState>(
      builder: (context, state) {
        final list = state.isSearching ? state.searchResults : state.upcomingAppointments;

        if (state.isLoading) {
          return SizedBox(height: 300.h, child: ListView.builder(scrollDirection: Axis.horizontal, itemCount: 2, itemBuilder: (ctx, i) => const AppointmentCardShimmer()));
        }

        if (list.isEmpty) {
          return SizedBox(height: 300.h, child: EmptyStateWidget(title: state.isSearching ? 'No Results' : 'No Appointments', description: 'No upcoming appointments found.'));
        }

        return Column(
          children: [
            SizedBox(
              height: 300.h,
              child: PageView.builder(
                controller: pageController,
                itemCount: list.length,
                onPageChanged: (i) => currentPageNotifier.value = i,
                itemBuilder: (ctx, i) => _buildCard(list[i]),
              ),
            ),
            SizedBox(height: 15.h),
            ValueListenableBuilder<int>(
              valueListenable: currentPageNotifier,
              builder: (ctx, current, _) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(list.length, (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: current == i ? 24.w : 8.w,
                    height: 4.h,
                    decoration: BoxDecoration(color: current == i ? Colors.black : Colors.grey[200], borderRadius: BorderRadius.circular(2)),
                  )),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildCard(AppointmentModel appointment) {
    return Container(
      width: 318.w,
      margin: EdgeInsets.only(right: 15.w, bottom: 5.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 8))],
        border: Border.all(color: const Color.fromRGBO(245, 245, 245, 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(colors: [Color(0xFF1A3955), Color(0xFF2C5E8A), Color(0xFF4A8CC7)]).createShader(bounds),
                    child: Text('Out Patient\nTICKET', style: TextStyle(fontFamily: 'CabinetGrotesk', fontSize: 28.sp, height: 0.9, fontWeight: FontWeight.w900, color: Colors.white)),
                  ),
                  if (appointment.currentlyServing != null)
                    Padding(padding: EdgeInsets.only(top: 4.h), child: Text('Currently Serving: #${appointment.currentlyServing}', style: GoogleFonts.dmSans(fontSize: 10.sp, fontWeight: FontWeight.w600, color: Colors.grey[600]))),
                ],
              ),
              _DateDisplay(date: appointment.appointmentDate),
            ],
          ),
          SizedBox(height: 15.h),
          Text(appointment.hospitalName, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 18.sp, fontFamily: 'CabinetGrotesk', fontWeight: FontWeight.w700)),
          Text(appointment.hospitalAddress, maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.dmSans(fontSize: 13.sp, color: Colors.grey[500])),
          const Spacer(),
          _BookTileRow(appointment: appointment),
        ],
      ),
    );
  }
}

class _DateDisplay extends StatelessWidget {
  final String date;
  const _DateDisplay({required this.date});
  @override
  Widget build(BuildContext context) {
    final parsed = DateTime.parse(date);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(DateFormat('dd MMM').format(parsed), style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Colors.grey[400])),
        Text(DateFormat('yyyy').format(parsed), style: TextStyle(fontSize: 22.sp, fontFamily: 'CabinetGrotesk', fontWeight: FontWeight.w800)),
      ],
    );
  }
}

class _BookTileRow extends StatelessWidget {
  final AppointmentModel appointment;
  const _BookTileRow({required this.appointment});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _BookTile(heading: 'Estimated Time', content: appointment.estimatedTime),
            _BookTile(heading: 'OP Ticket Number', content: '#${appointment.tokenNumber}'),
          ],
        ),
        SizedBox(height: 15.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _BookTile(heading: 'Patient', content: appointment.patientName),
            _BookTile(heading: 'Department', content: appointment.departmentName),
          ],
        ),
      ],
    );
  }
}

class _BookTile extends StatelessWidget {
  final String heading, content;
  const _BookTile({required this.heading, required this.content});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(heading.toUpperCase(), style: GoogleFonts.dmSans(fontSize: 9.sp, fontWeight: FontWeight.w800, color: Colors.grey[400])),
        Text(content, style: TextStyle(fontSize: 16.sp, fontFamily: 'CabinetGrotesk', fontWeight: FontWeight.w700)),
      ],
    );
  }
}

class _HomePastAppointmentsTitle extends StatelessWidget {
  const _HomePastAppointmentsTitle();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppointmentCubit, AppointmentState>(
      builder: (context, state) {
        if (state.isSearching) return const SizedBox();
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Previous Appointments', style: GoogleFonts.dmSans(fontSize: 18.sp, fontWeight: FontWeight.w700)),
          SizedBox(height: 15.h),
        ]);
      },
    );
  }
}

class _HomePastAppointmentsList extends StatelessWidget {
  const _HomePastAppointmentsList();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppointmentCubit, AppointmentState>(
      builder: (context, state) {
        if (state.isSearching) return const SizedBox();
        if (state.isLoading && state.pastAppointments.isEmpty) return const PreviousAppointmentShimmer();
        if (state.pastAppointments.isEmpty) return const Padding(padding: EdgeInsets.symmetric(vertical: 20), child: EmptyStateWidget(title: 'No History', description: 'Your previous history will appear here.'));
        
        return ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.only(bottom: 100.h),
          separatorBuilder: (ctx, i) => SizedBox(height: 12.h),
          itemCount: state.pastAppointments.length,
          itemBuilder: (ctx, i) => _PastCard(appointment: state.pastAppointments[i]),
        );
      },
    );
  }
}

class _PastCard extends StatelessWidget {
  final AppointmentModel appointment;
  const _PastCard({required this.appointment});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(18.r), color: Colors.white, border: Border.all(color: const Color.fromRGBO(240, 240, 240, 1))),
      child: Row(
        children: [
          Container(width: 50.w, height: 50.w, decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(12.r)), child: const Center(child: Icon(Icons.local_hospital_outlined, color: Color(0xFF1A3955)))),
          SizedBox(width: 15.w),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(appointment.hospitalName, maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.poppins(fontSize: 14.sp, fontWeight: FontWeight.w600)),
            Text(DateFormat('dd MMM yyyy').format(DateTime.parse(appointment.appointmentDate)), style: TextStyle(fontSize: 11.sp, color: Colors.grey[500])),
            Text(appointment.patientName, style: TextStyle(fontSize: 10.sp, color: Colors.grey[400])),
          ])),
        ],
      ),
    );
  }
}
