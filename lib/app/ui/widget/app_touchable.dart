import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:travel/app/ui/widget/app_image_widget.dart';

import '../theme/app_color.dart';

class AppTouchable extends StatelessWidget {
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
  final BoxDecoration? decoration;
  final BorderRadius? borderRadius;
  final String? backgroundAsset;

  const AppTouchable({
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
    this.decoration,
    this.borderRadius,
    this.backgroundAsset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin ?? EdgeInsets.zero,
      decoration: (decoration ?? const BoxDecoration()).copyWith(borderRadius: borderRadius),
      child: Stack(
        children: [
          backgroundAsset != null
              ? Positioned.fill(
                  child: ClipRRect(
                    borderRadius: borderRadius ?? BorderRadius.zero,
                    child: AppImageWidget.asset(
                      path: backgroundAsset!,
                      fit: BoxFit.fill,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
          Positioned.fill(
            child: TextButton(
              onPressed: onPressed,
              onLongPress: onLongPressed,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(backgroundColor ?? Colors.transparent),
                overlayColor: MaterialStateProperty.all(rippleColor ?? Colors.transparent),
                foregroundColor: MaterialStateProperty.all(foregroundColor ?? AppColor.primaryColor),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: borderRadius ?? BorderRadius.circular(8.0.sp),
                  ),
                ),
                padding: MaterialStateProperty.all(padding ?? EdgeInsets.zero),
                minimumSize: MaterialStateProperty.all(Size.zero),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.standard,
              ),
              child: child ?? const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }
}
