import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qflow/application/member/member_cubit.dart';

class ProfileTabCarousel extends StatefulWidget {
  final List<String> tabs;
  final ValueNotifier<int> indexNotifier;

  const ProfileTabCarousel({
    super.key,
    required this.tabs,
    required this.indexNotifier,
  });

  @override
  State<ProfileTabCarousel> createState() => _ProfileTabCarouselState();
}

class _ProfileTabCarouselState extends State<ProfileTabCarousel> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.tabs.length; // Start in the middle set for infinite-feeling scroll
    widget.indexNotifier.value = _currentIndex;
    _pageController = PageController(
      initialPage: _currentIndex,
      viewportFraction: 0.31,
    );
  }

  void _onItemTap(int index) {
    final targetLogicalIndex = index % widget.tabs.length;
    
    setState(() {
      _currentIndex = (_currentIndex - (_currentIndex % widget.tabs.length) + targetLogicalIndex);
    });
    
    widget.indexNotifier.value = _currentIndex;

    _pageController.animateToPage(
      _currentIndex,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );

    // Specific logic for Members tab
    if (targetLogicalIndex == 1) {
      context.read<MemberCubit>().getMembers();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final visibleTabs = [...widget.tabs, ...widget.tabs, ...widget.tabs];

    return SizedBox(
      height: 78.h,
      child: PageView.builder(
        controller: _pageController,
        itemCount: visibleTabs.length,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final logicalIndex = index % widget.tabs.length;
          final isCenter = index == _currentIndex;

          return GestureDetector(
            onTap: () => _onItemTap(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              child: Center(
                child: Text(
                  widget.tabs[logicalIndex],
                  style: TextStyle(
                    fontSize: isCenter ? 15.sp : 12.sp,
                    fontWeight: FontWeight.w400,
                    color: isCenter ? Colors.black : Colors.grey,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
