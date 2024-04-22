import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:travel/app/ads/native_ads_widget.dart';
import 'package:travel/app/controller/app_controller.dart';
import 'package:travel/app/controller/map_trip_controller.dart';
import 'package:travel/app/res/string/app_strings.dart';
import 'package:travel/app/ui/screen/sub_screen.dart';
import 'package:travel/app/ui/theme/app_color.dart';
import 'package:travel/app/ui/widget/app_container.dart';
import 'package:travel/app/ui/widget/app_header.dart';
import 'package:travel/app/ui/widget/app_image_widget.dart';

import '../../res/image/app_image.dart';
import '../../util/disable_glow_behavior.dart';
import '../widget/app_touchable3.dart';

class MapTripScreen extends GetView<MapTripController> {
  const MapTripScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.context = context;
    return AppContainer(
      resizeToAvoidBottomInset: true,
      showBanner: false,
      backgroundColor: AppColor.grayFF8,
      child: Column(
        children: [
          AppHeader(
            title: StringConstants.weatherForYourTrip.tr,
          ),
          Expanded(
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                ScrollConfiguration(
                  behavior: DisableGlowBehavior(),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 20.0.sp,
                          ),
                          padding: EdgeInsets.all(20.sp),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.sp),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  AppImageWidget.asset(
                                    path: AppImage.weatherTripFrom,
                                    height: 24.0.sp,
                                    width: 24.0.sp,
                                  ),
                                  Expanded(
                                    child: AppTouchable3(
                                      onPressed: () {
                                        controller.onPressFrom();
                                      },
                                      child: Container(
                                        height: 48.0.sp,
                                        margin: EdgeInsets.symmetric(
                                          horizontal: 8.0.sp,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF8F8F8),
                                          borderRadius: BorderRadius.circular(12.0.sp),
                                          shape: BoxShape.rectangle,
                                          border: Border.all(
                                            color: AppColor.gray2F7,
                                            width: 1.0.sp,
                                          ),
                                        ),
                                        child: Obx(
                                              () => Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: 14.0.sp,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  controller.fromAdd.value,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color: controller.textColorFrom()
                                                        ? AppColor.grayE93
                                                        : AppColor.black333,
                                                    fontSize: 16.0.sp,
                                                    fontWeight: FontWeight.w500,
                                                  ),
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
                              Container(
                                width: 3.0.sp,
                                height: 3.0.sp,
                                margin: EdgeInsets.only(
                                  left: 12.0.sp - 1.5.sp,
                                  top: 2.0.sp,
                                  bottom: 2.0.sp,
                                ),
                                decoration: const BoxDecoration(
                                  color: AppColor.grayE93,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Container(
                                width: 3.0.sp,
                                height: 3.0.sp,
                                margin: EdgeInsets.only(
                                  left: 12.0.sp - 1.5.sp,
                                  top: 2.0.sp,
                                  bottom: 2.0.sp,
                                ),
                                decoration: const BoxDecoration(
                                  color: AppColor.grayE93,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Container(
                                width: 3.0.sp,
                                height: 3.0.sp,
                                margin: EdgeInsets.only(
                                  left: 12.0.sp - 1.5.sp,
                                  top: 2.0.sp,
                                  bottom: 2.0.sp,
                                ),
                                decoration: const BoxDecoration(
                                  color: AppColor.grayE93,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Row(
                                children: [
                                  AppImageWidget.asset(
                                    path: AppImage.weatherTripTo,
                                    height: 24.0.sp,
                                    width: 24.0.sp,
                                  ),
                                  Expanded(
                                      child: AppTouchable3(
                                        onPressed: () {
                                          controller.onPressTo();
                                        },
                                        child: Container(
                                          height: 48.0.sp,
                                          margin: EdgeInsets.symmetric(
                                            horizontal: 8.0.sp,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF8F8F8),
                                            borderRadius: BorderRadius.circular(12.0.sp),
                                            shape: BoxShape.rectangle,
                                            border: Border.all(
                                              color: AppColor.gray2F7,
                                              width: 1.0.sp,
                                            ),
                                          ),
                                          child: Obx(
                                                () => Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: 14.0.sp,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    controller.toAdd.value,
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      color: controller.textColorTo()
                                                          ? AppColor.grayE93
                                                          : AppColor.black333,
                                                      fontSize: 16.0.sp,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )),
                                ],
                              ),
                              SizedBox(
                                height: 14.0.sp,
                              ),
                              Text(
                                '*Average speed is 40mph (64km/h)',
                                style: TextStyle(
                                  color: AppColor.black333,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12.0.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 8.sp,
                        ),
                        Container(
                          width: Get.width,
                          margin: EdgeInsets.symmetric(horizontal: 20.sp),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.0.sp),
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 12.0.sp,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 32.0.sp,
                                  ),
                                  Text(
                                    'Departure time',
                                    style: TextStyle(
                                      color: AppColor.black333,
                                      fontSize: 18.0.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 12.0.sp,
                              ),
                              AppTouchable3(
                                onPressed: () => controller.onPressTime(context),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      height: 50.0.sp,
                                      decoration: BoxDecoration(
                                        color: AppColor.grayFF9,
                                        borderRadius: BorderRadius.circular(8.0.sp),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 4.0.sp,
                                      ),
                                      child: Center(
                                        child: Obx(
                                              () => Text(
                                            controller.timeTrip.value.hour
                                                .toString()
                                                .padLeft(2, '0'),
                                            style: TextStyle(
                                              color: AppColor.black333,
                                              fontWeight: FontWeight.w800,
                                              fontSize: 34.0.sp,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 4.0.sp,
                                    ),
                                    Text(
                                      ":",
                                      style: TextStyle(
                                        color: AppColor.black333,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 34.0.sp,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 4.0.sp,
                                    ),
                                    Container(
                                      height: 50.0.sp,
                                      decoration: BoxDecoration(
                                        color: AppColor.grayFF9,
                                        borderRadius: BorderRadius.circular(8.0.sp),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 4.0.sp,
                                      ),
                                      child: Center(
                                        child: Obx(
                                              () => Text(
                                            controller.timeTrip.value.minute
                                                .toString()
                                                .padLeft(2, '0'),
                                            style: TextStyle(
                                              color: AppColor.black333,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 34.0.sp,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 12.0.sp,
                              ),
                              AppTouchable3(
                                onPressed: () => controller.onPressDate(context),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      height: 30.0.sp,
                                      width: 270.sp,
                                      decoration: BoxDecoration(
                                        color: AppColor.grayFF9,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(6.0.sp),
                                        ),
                                      ),
                                      child: Obx(
                                            () => Center(
                                          child: Text(
                                            DateFormat('MMMM dd')
                                                .format(controller.dateTrip.value),
                                            style: TextStyle(
                                              color: AppColor.black333,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 18.0.sp,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20.0.sp,
                              ),
                            ],
                          ),
                        ),
                        Get.find<AppController>().isPremium.value?const SizedBox.shrink():
                        Container(
                          margin: EdgeInsets.only(top: 10.sp,left: 20.sp,right: 20.sp),
                          child: const MediumNativeAdsWidget(),
                        ),
                        SizedBox(height: 60.sp,),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20.sp,
                  child: Obx(
                        () => SizedBox(
                          child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                          SizedBox(
                            width: 12.0.sp,
                          ),
                          AppTouchable3(
                            onPressed: controller.onPressCheckWeather,
                            width: Get.find<AppController>().isPremium.value
                                ? Get.width * 4 / 5
                                : Get.width * 2.3 / 3,
                            height: 44.0.sp,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(12.0.sp),
                              color:controller.colorCheckWeather()? const Color(0xFF3388F2):const Color(0xFFD8D8D8),
                            ),
                            child: Obx(
                                  () => controller.isLoadingWeather.value
                                  ? const CupertinoActivityIndicator(
                                color: AppColor.white,
                              )
                                  : Center(
                                child: Text(
                                  "Check Weather",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10.0.sp,
                          ),
                          Obx(
                                () => Get.find<AppController>().isPremium.value
                                ? const SizedBox.shrink()
                                : AppTouchable3(
                              onPressed: () => Get.to(() => const SubScreen()),
                              width: 40.0.sp,
                              height: 40.0.sp,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    offset: const Offset(0, 0),
                                    blurRadius: 10.0.sp,
                                    spreadRadius: 2.0.sp,
                                    color: Colors.black.withOpacity(0.5),
                                  )
                                ],
                              ),
                              padding: const EdgeInsets.all(6.0),
                              margin: EdgeInsets.only(
                                right: 12.0.sp,
                              ),
                              child: AppImageWidget.asset(
                                path: AppImage.lottiePremium,
                              ),
                            ),
                          ),
                      ],
                    ),
                        ),
                  ),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}
