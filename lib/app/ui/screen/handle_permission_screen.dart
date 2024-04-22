import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:travel/app/controller/app_controller.dart';
import 'package:travel/app/route/app_route.dart';
import 'package:travel/app/ui/theme/app_color.dart';
import 'package:travel/app/ui/widget/app_header.dart';
import 'package:travel/app/ui/widget/app_image_widget.dart';

import '../../res/image/app_image.dart';
import '../widget/app_container.dart';
import '../widget/app_touchable3.dart';
import '../widget/flutter_switch.dart';

class HandlePermissionScreen extends StatefulWidget {
  const HandlePermissionScreen({Key? key}) : super(key: key);

  @override
  State<HandlePermissionScreen> createState() => _HandlePermissionScreenState();
}

class _HandlePermissionScreenState extends State<HandlePermissionScreen> {
  bool isNotification = false;
  bool isLocation = false;
  bool isTracking = false;

  @override
  void initState() {
    Future.delayed(
      Duration.zero,
      () async {
        isNotification =
            await Permission.notification.status == PermissionStatus.granted;

        isLocation =
            await Permission.location.status == PermissionStatus.granted;

        isTracking = await Permission.appTrackingTransparency.status ==
            PermissionStatus.granted;

        setState(() {});
      },
    );

    super.initState();
  }

  Future<void> onPressAllowAccess() async {
    debugPrint("Allow Access click");
    if (isNotification) {
      await Permission.notification.request();
    }

    if (isLocation) {
      await Geolocator.requestPermission();
    }

    if (Platform.isIOS) {}

    if (Get.find<AppController>().isPremium.value) {
      Get.toNamed(AppRoute.mainScreen);
    } else {
       Get.toNamed(AppRoute.mainScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      backgroundColor: AppColor.grayFF9,
      showBanner: false,
      child: Column(
        children: [
          const AppHeader(
            title: 'Request Permission',
            leftWidget: SizedBox.shrink(),
          ),
          Container(
            width: Get.width,
            margin: EdgeInsets.symmetric(
              horizontal: 16.0.sp,
            ),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: AppColor.white,
              borderRadius: BorderRadius.circular(16.0.sp),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 16.0.sp,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 12.0.sp,
                    ),
                    AppImageWidget.asset(
                      path: AppImage.icPermissionNotification,
                    ),
                    SizedBox(
                      width: 8.0.sp,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Notification Permission",
                            style: TextStyle(
                              color: AppColor.black333,
                              fontWeight: FontWeight.w500,
                              fontSize: 16.0.sp,
                            ),
                          ),
                          SizedBox(
                            height: 4.0.sp,
                          ),
                          Text(
                            "Receive notifications",
                            style: TextStyle(
                              color: AppColor.grayE93,
                              fontWeight: FontWeight.w400,
                              fontSize: 12.0.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 8.0.sp,
                    ),
                    FlutterSwitch(
                      // This bool value toggles the switch.
                      value: isNotification,
                      activeColor: CupertinoColors.activeBlue,
                      onToggle: (bool? value) {
                        // This is called when the user toggles the switch.
                        setState(() {
                          isNotification = value ?? false;
                        });
                      },
                    ),
                    SizedBox(
                      width: 12.0.sp,
                    ),
                  ],
                ),
                Container(
                  width: Get.width,
                  height: 1.0.sp,
                  margin: EdgeInsets.only(
                    left: 12.0.sp,
                    right: 12.0.sp,
                    top: 16.0.sp,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD1D1D6),
                    borderRadius: BorderRadius.circular(4.0.sp),
                    shape: BoxShape.rectangle,
                  ),
                ),
                SizedBox(
                  height: 16.0.sp,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 12.0.sp,
                    ),
                    AppImageWidget.asset(
                      path: AppImage.icPermissionLocation,
                    ),
                    SizedBox(
                      width: 8.0.sp,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Location Permission",
                            style: TextStyle(
                              color: AppColor.black333,
                              fontWeight: FontWeight.w500,
                              fontSize: 16.0.sp,
                            ),
                          ),
                          SizedBox(
                            height: 4.0.sp,
                          ),
                          Text(
                            "Locate current location",
                            style: TextStyle(
                              color: AppColor.grayE93,
                              fontWeight: FontWeight.w400,
                              fontSize: 12.0.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 8.0.sp,
                    ),
                    FlutterSwitch(
                      // This bool value toggles the switch.
                      value: isLocation,
                      activeColor: CupertinoColors.activeBlue,
                      onToggle: (bool? value) {
                        // This is called when the user toggles the switch.
                        setState(() {
                          isLocation = value ?? false;
                        });
                      },
                    ),
                    SizedBox(
                      width: 12.0.sp,
                    ),
                  ],
                ),
                if (Platform.isIOS) ...[
                  Container(
                    width: Get.width,
                    height: 1.0.sp,
                    margin: EdgeInsets.only(
                      left: 12.0.sp,
                      right: 12.0.sp,
                      top: 16.0.sp,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD1D1D6),
                      borderRadius: BorderRadius.circular(4.0.sp),
                      shape: BoxShape.rectangle,
                    ),
                  ),
                  SizedBox(
                    height: 16.0.sp,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 12.0.sp,
                      ),
                      AppImageWidget.asset(
                        path: AppImage.icPermissionNotification,
                      ),
                      SizedBox(
                        width: 8.0.sp,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Notification Permission",
                              style: TextStyle(
                                color: AppColor.black333,
                                fontWeight: FontWeight.w500,
                                fontSize: 16.0.sp,
                              ),
                            ),
                            SizedBox(
                              height: 4.0.sp,
                            ),
                            Text(
                              "Receive notifications",
                              style: TextStyle(
                                color: AppColor.grayE93,
                                fontWeight: FontWeight.w400,
                                fontSize: 12.0.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 8.0.sp,
                      ),
                      FlutterSwitch(
                        // This bool value toggles the switch.
                        value: isNotification,
                        activeColor: CupertinoColors.activeBlue,
                        onToggle: (bool? value) {
                          // This is called when the user toggles the switch.
                          setState(() {
                            isNotification = value ?? false;
                          });
                        },
                      ),
                      SizedBox(
                        width: 12.0.sp,
                      ),
                    ],
                  ),
                ],
                SizedBox(
                  height: 16.0.sp,
                ),
              ],
            ),
          ),
          Get.find<AppController>().isPremium.value
              ? const SizedBox.shrink()
              : Container(
                  margin:
                      EdgeInsets.only(top: 10.sp, left: 20.sp, right: 20.sp),
                  child: Obx(
                    () =>
                        Get.find<AppController>()
                            .nativeAdsMapPermission['widget'] ??
                        const SizedBox.shrink(),
                  ),
                ),
          const Spacer(),
          AppTouchable3(
            onPressed: () async => onPressAllowAccess(),
            rippleColor: Colors.transparent,
            child: Container(
              width: Get.width,
              padding: EdgeInsets.symmetric(
                vertical: 16.0.sp,
                horizontal: 10.0.sp,
              ),
              margin: EdgeInsets.only(
                left: 40.0.sp,
                right: 40.0.sp,
                bottom: 12.0.sp
              ),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(12.sp)),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF437AFF),
                    Color(0xFF67A4FE),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: Text(
                "Allow Access",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 18.0.sp,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 12.0.sp,
          ),
        ],
      ),
    );
  }
}
