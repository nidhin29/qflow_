import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qflow/application/profile/profile_cubit.dart';
import 'package:qflow/application/profile/profile_state.dart';
import 'package:qflow/domain/user/user_model/user_model.dart';
import 'package:qflow/Presentation/Profile/profile_shimmer.dart';
import 'package:qflow/Presentation/Profile/profile_tab_carousel.dart';
import 'package:qflow/Presentation/Profile/profile_edit_form.dart';
import 'package:qflow/Presentation/Profile/avatar_tab_view.dart';
import 'package:qflow/Presentation/Profile/member_tab_view.dart';
import 'package:qflow/Presentation/Profile/history_tab_view.dart';
import 'package:qflow/Presentation/Core/snackbar_utils.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = context.read<ProfileCubit>().state;
      if (state.userOption.isNone() && !state.isLoading) {
        context.read<ProfileCubit>().getUserDetails();
      }
    });

    final List<String> tabs = ["Avatar", "Members", "History"];
    final ValueNotifier<int> indexNotifier = ValueNotifier<int>(tabs.length);
    final ValueNotifier<bool> isEditModeNotifier = ValueNotifier<bool>(false);

    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        state.failureOrSuccessOption.fold(
          () => null,
          (either) => either.fold(
            (failure) => showErrorSnackBar(context, failure),
            (_) {
              showSuccessSnackBar(context, 'Profile updated successfully');
              isEditModeNotifier.value = false;
            },
          ),
        );
      },
      builder: (context, state) {
        if (state.isLoading) {
          return const _LoadingProfileView();
        }

        final user = state.userOption.getOrElse(() => const UserModel(
              firstName: "User",
              lastName: "",
              username: "",
              age: 0,
              weight: 0,
              height: 0,
              gender: "",
              bloodGroup: "",
              contactNumber: "",
              city: "",
              district: "",
            ));

        return Scaffold(
          body: Stack(
            children: [
              const _ProfileBackgroundHeader(),
              _ProfileContentContainer(
                tabs: tabs,
                indexNotifier: indexNotifier,
                isEditModeNotifier: isEditModeNotifier,
                user: user,
                state: state,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LoadingProfileView extends StatelessWidget {
  const _LoadingProfileView();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(height: 80, width: 80, decoration: const BoxDecoration(color: Colors.grey, shape: BoxShape.circle)),
            const SizedBox(height: 20),
            Container(height: 30, width: 200, color: Colors.grey),
            const SizedBox(height: 40),
            const ProfileHistoryShimmer(),
          ],
        ),
      ),
    );
  }
}

class _ProfileBackgroundHeader extends StatelessWidget {
  const _ProfileBackgroundHeader();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 337.h,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Color(0xFFCEDFEF)],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ),
        Container(
          height: 350.h,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF81BDFC), Colors.white],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(bottom: 25.h),
            child: Center(
              child: Text(
                "Profile",
                style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.w400, color: Colors.black),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ProfileContentContainer extends StatelessWidget {
  final List<String> tabs;
  final ValueNotifier<int> indexNotifier;
  final ValueNotifier<bool> isEditModeNotifier;
  final UserModel user;
  final ProfileState state;

  const _ProfileContentContainer({
    required this.tabs,
    required this.indexNotifier,
    required this.isEditModeNotifier,
    required this.user,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 290.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(47.r),
          topRight: Radius.circular(47.r),
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: 20.h),
          ProfileTabCarousel(tabs: tabs, indexNotifier: indexNotifier),
          Flexible(
            child: ValueListenableBuilder<bool>(
              valueListenable: isEditModeNotifier,
              builder: (ctx, isEditMode, _) {
                if (isEditMode) {
                  return ProfileEditForm(
                    user: user,
                    state: state,
                    onCancel: () => isEditModeNotifier.value = false,
                  );
                }
                return ValueListenableBuilder<int>(
                  valueListenable: indexNotifier,
                  builder: (ctx, currentIndex, _) {
                    return IndexedStack(
                      index: currentIndex % tabs.length,
                      children: [
                        AvatarTabView(user: user, onEditTap: () => isEditModeNotifier.value = true),
                        const MemberTabView(),
                        const HistoryTabView(),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
