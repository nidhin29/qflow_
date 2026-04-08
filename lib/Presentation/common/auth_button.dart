import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthButtonWidget extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  const AuthButtonWidget({
    super.key,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        minimumSize: WidgetStateProperty.all(Size(160.w, 47.h)),
        backgroundColor: WidgetStateProperty.all(Colors.black),
        overlayColor: WidgetStateProperty.all(Colors.white),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
        side: WidgetStateProperty.all(
          const BorderSide(
            color: Colors.black,
          ),
        ),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 15.sp,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}

class ToggleAuthButtonWidget extends AuthButtonWidget {
  final String decider;
  ToggleAuthButtonWidget(this.decider, {
    super.key,
    required super.title,
    required super.onPressed,
  });

  final ValueNotifier<bool> valueListenable = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: valueListenable,
      builder: (BuildContext context, value, Widget? child) {
        return ElevatedButton(
          onPressed: () {
            onPressed();
          },
          onLongPress: () {
            valueListenable.value = !valueListenable.value;
          },
          style: ButtonStyle(
            minimumSize: WidgetStateProperty.all(Size(160.w, 47.h)),
            backgroundColor:decider == 'Sign In' ? value
                ? WidgetStateProperty.all(Colors.white)
                : WidgetStateProperty.all(Colors.black) : value ? WidgetStateProperty.all(Colors.black) : WidgetStateProperty.all(Colors.white),
            overlayColor: WidgetStateProperty.all(Colors.white),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            side: WidgetStateProperty.all(
              const BorderSide(
                color: Colors.black,
              ),
            ),
          ),
          child: Text(
            title,
            style: TextStyle(
              color:decider == 'Sign In' ?  value ? Colors.black : Colors.white : value ? Colors.white : Colors.black,
              fontSize: 15.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        );
      },
    );
  }
}
