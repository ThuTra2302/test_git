import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:travel/app/ui/widget/app_touchable3.dart';

import '../../res/image/app_image.dart';
import '../screen/sub_screen.dart';
import 'animated_text/animated_text_kit.dart';
import 'app_image_widget.dart';
import 'shake_widget.dart';

const double BUBBLE_RADIUS = 16;

class ChatBubble extends StatelessWidget {
  final double bubbleRadius;
  final bool isSender;
  final String text;
  final bool tail;
  final bool sent;
  final bool delivered;
  final bool seen;
  final bool isLimited;
  final bool isOther;
  final TextStyle? textStyle;
  final bool isTyping;
  final Color? backgroundColor;
  final Function()? onFinished;
  final Function()? unlockLimit;

  const ChatBubble({
    Key? key,
    required this.text,
    this.bubbleRadius = BUBBLE_RADIUS,
    this.isSender = true,
    this.tail = true,
    this.sent = false,
    this.delivered = false,
    this.seen = false,
    this.textStyle,
    this.isTyping = false,
    this.isOther = false,
    this.backgroundColor,
    this.onFinished,
    this.unlockLimit,
    required this.isLimited,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 12.0.sp,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
            isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          isSender
              ? const SizedBox.shrink()
              : Container(
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
          isTyping
              ? Container(
                  width: 50.0.sp,
                  height: 40.0.sp,
                  margin: EdgeInsets.symmetric(
                    horizontal: 12.0.sp,
                  ),
                  decoration: BoxDecoration(
                    color: isSender
                        ? backgroundColor ?? const Color(0xFF008EFF)
                        : const Color(0xFFF3F3F3),
                    borderRadius:
                        BorderRadius.all(Radius.circular(bubbleRadius)),
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
                )
              : Container(
                  width: Get.width,
                  constraints: BoxConstraints(maxWidth: Get.width * 0.75),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.0.sp,
                      vertical: 2.0.sp,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSender
                            ? backgroundColor ?? const Color(0xFF008EFF)
                            : const Color(0xFFF3F3F3),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(bubbleRadius),
                          topRight: Radius.circular(bubbleRadius),
                          bottomLeft: Radius.circular(
                            tail
                                ? isSender
                                    ? bubbleRadius
                                    : 0
                                : BUBBLE_RADIUS,
                          ),
                          bottomRight: Radius.circular(
                            tail
                                ? isSender
                                    ? 0
                                    : bubbleRadius
                                : BUBBLE_RADIUS,
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: 24.0.sp,
                          bottom: 24.0.sp,
                          left: 20.0.sp,
                          right: 20.0.sp,
                        ),
                        child: isSender
                            ? Text(
                                text,
                                style: textStyle ??
                                    TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.0.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                textAlign: TextAlign.left,
                              )
                            : isOther
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AnimatedTextWidget(
                                        isRepeatingAnimation: false,
                                        repeatForever: false,
                                        displayFullTextOnTap: true,
                                        totalRepeatCount: 1,
                                        onFinished: onFinished,
                                        animatedTexts: [
                                          TyperAnimatedText(
                                            text.trim(),
                                            textStyle: TextStyle(
                                              color: const Color(0xFF656565),
                                              fontSize: 14.0.sp,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 12.0.sp),
                                      Stack(
                                        children: [
                                          AppTouchable3(
                                            onPressed: unlockLimit,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF008EFF),
                                              shape: BoxShape.rectangle,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      14.0.sp),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                              vertical: 12.0.sp,
                                              horizontal: 42.0.sp,
                                            ),
                                            margin: EdgeInsets.only(
                                              top: 6.0.sp,
                                              left: 4.0.sp,
                                            ),
                                            child: Text(
                                              "Unlock limit",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14.0.sp,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          AppImageWidget.asset(
                                            path: AppImage.icAds,
                                            height: 20.0.sp,
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 12.0.sp),
                                      AppTouchable3(
                                        onPressed: () =>
                                            Get.to(() => const SubScreen()),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF008EFF),
                                          shape: BoxShape.rectangle,
                                          borderRadius:
                                              BorderRadius.circular(14.0.sp),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          vertical: 12.0.sp,
                                          horizontal: 42.0.sp,
                                        ),
                                        child: Text(
                                          "Unlock full resource",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14.0.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : isLimited
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          AnimatedTextWidget(
                                            isRepeatingAnimation: false,
                                            repeatForever: false,
                                            displayFullTextOnTap: true,
                                            totalRepeatCount: 1,
                                            onFinished: onFinished,
                                            animatedTexts: [
                                              TyperAnimatedText(
                                                text.trim(),
                                                textStyle: TextStyle(
                                                  color:
                                                      const Color(0xFF656565),
                                                  fontSize: 14.0.sp,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 12.0.sp),
                                          ShakeWidget(
                                            shakeOffset: 10,
                                            child: AppTouchable3(
                                              onPressed: () => Get.to(
                                                  () => const SubScreen()),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF008EFF),
                                                shape: BoxShape.rectangle,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        14.0.sp),
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                vertical: 12.0.sp,
                                                horizontal: 14.0.sp,
                                              ),
                                              child: Text(
                                                "Unlock Limit",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14.0.sp,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : AnimatedTextWidget(
                                        isRepeatingAnimation: false,
                                        repeatForever: false,
                                        displayFullTextOnTap: true,
                                        totalRepeatCount: 1,
                                        onFinished: onFinished,
                                        animatedTexts: [
                                          TyperAnimatedText(
                                            text.trim(),
                                            textStyle: TextStyle(
                                              color: const Color(0xFF656565),
                                              fontSize: 14.0.sp,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
