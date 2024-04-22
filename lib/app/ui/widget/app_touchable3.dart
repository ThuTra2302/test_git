import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_color.dart';

class AppTouchable3 extends StatelessWidget {
  final Function()? onPressed;
  final Function()? onLongPressed;
  final Widget? child;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? rippleColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final OutlinedBorder? outlinedBorder;
  final BoxDecoration? decoration;

  const AppTouchable3({
    Key? key,
    required this.onPressed,
    this.onLongPressed,
    required this.child,
    this.width,
    this.height,
    this.backgroundColor,
    this.foregroundColor,
    this.rippleColor,
    this.padding,
    this.margin,
    this.outlinedBorder,
    this.decoration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin ?? EdgeInsets.zero,
      decoration: decoration,
      child: TextButton(
        onPressed: onPressed,
        onLongPress: onLongPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(backgroundColor ?? Colors.transparent),
          overlayColor: MaterialStateProperty.all(rippleColor ?? Colors.transparent),
          foregroundColor: MaterialStateProperty.all(foregroundColor ?? AppColor.primaryColor),
          shape: MaterialStateProperty.all(
            outlinedBorder ??
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0.sp),
                ),
          ),
          padding: MaterialStateProperty.all(padding ?? EdgeInsets.zero),
          minimumSize: MaterialStateProperty.all(Size.zero),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.standard,
        ),
        child: child ?? const SizedBox.shrink(),
      ),
    );
  }
}
