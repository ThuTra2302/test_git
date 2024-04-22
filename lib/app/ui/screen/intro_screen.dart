import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:travel/app/controller/app_controller.dart';

import '../../controller/intro_controller.dart';
import '../../res/image/app_image.dart';
import '../widget/app_container.dart';
import '../widget/app_image_widget.dart';

class IntroScreen extends GetView<IntroController> {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      showBanner: false,
      child: Stack(
        children: [
          Positioned.fill(
            child: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (OverscrollIndicatorNotification overscroll) {
                return true;
              },
              child: CarouselSlider(
                items: controller.listImageAsset.map((listItem) {
                  return Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Positioned.fill(
                        child: AppImageWidget.asset(
                          path: listItem['image'],
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ],
                  );
                }).toList(),
                carouselController: controller.carouselController,
                options: CarouselOptions(
                  height: Get.height,
                  viewportFraction: 1,
                  onPageChanged: (index, reason) =>
                      controller.onPageChanged(index),
                  initialPage: 0,
                  enableInfiniteScroll: false,
                  reverse: false,
                  autoPlay: false,
                  enlargeCenterPage: false,
                  scrollDirection: Axis.horizontal,
                ),
              ),
            ),
          ),
          Positioned(
            top: Get.height / 3,
            child: Container(
              width: Get.width,
              padding: EdgeInsets.only(
                right: 5.0.sp,
                left: 5.sp,
                top: 5.sp,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20.sp),
                  topLeft: Radius.circular(30.sp),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: 8.0.sp),
                  Row(
                    children: [
                      SizedBox(width: 24.0.sp),
                      Obx(
                        () => DotsIndicator(
                          dotsCount: 4,
                          position: controller.currentIndex.value.toDouble(),
                          decorator: DotsDecorator(
                            size: Size(4.0.sp, 4.0.sp),
                            activeSize: Size(27.0.sp, 4.0.sp),
                            color: const Color(0xFF3388F2),
                            activeColor: const Color(0xFF3388F2),
                            activeShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                            spacing: EdgeInsets.symmetric(horizontal: 2.0.sp),
                          ),
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: controller.onPressNext,
                        child: Container(
                          height: 30.sp,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF3388F2),
                          ),
                          padding: EdgeInsets.all(10.sp),
                          child: AppImageWidget.asset(path: AppImage.icArrow),
                        ),
                      ),
                      SizedBox(width: 12.0.sp),
                    ],
                  ),
                  Obx(
                    () => Column(
                      children: [
                        Text(
                          controller
                                  .listImageAsset[controller.currentIndex.value]
                              ['title'],
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20.0.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF5F5F5F),
                          ),
                        ),
                        SizedBox(
                          height: 10.sp,
                        ),
                        Text(
                          controller
                                  .listImageAsset[controller.currentIndex.value]
                              ['subTitle'],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: const Color(0xFF858585),
                            fontSize: 14.0.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0.sp,
            child: Obx(
              () =>
                  Get.find<AppController>().nativeAdsMapIntro['widget'] ??
                  const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }
}
