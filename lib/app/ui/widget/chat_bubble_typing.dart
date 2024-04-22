import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../res/image/app_image.dart';
import 'app_image_widget.dart';

class ChatBubbleTyping extends StatelessWidget {
  final double bubbleRadius;

  const ChatBubbleTyping({
    Key? key,
    this.bubbleRadius = 16,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 12.0.sp,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 60.0.sp,
            height: 60.0.sp,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            padding: EdgeInsets.all(4.0.sp),
            child: AppImageWidget.asset(
              path: AppImage.animationBotAvatar,
            ),
          ),
          Container(
            width: 50.0.sp,
            height: 40.0.sp,
            margin: EdgeInsets.symmetric(
              horizontal: 12.0.sp,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F3F3),
              borderRadius: BorderRadius.all(Radius.circular(bubbleRadius)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppImageWidget.asset(
                  path: AppImage.loadingTyping,
                  height: 40.0.sp,
                  width: 40.0.sp,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
