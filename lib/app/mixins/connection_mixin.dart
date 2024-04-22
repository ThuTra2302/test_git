import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:open_settings/open_settings.dart';
import 'package:travel/app/ui/widget/app_touchable3.dart';

import '../ui/theme/app_color.dart';

mixin ConnectionMixin {
  Future<void> showNotConnectDialog(BuildContext context) async {
    if (Platform.isAndroid) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            elevation: 0,
            title: Text(
              "No internet connection",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColor.black333,
                fontWeight: FontWeight.w600,
                fontSize: 18.0.sp,
              ),
            ),
            content: Text(
              "You can connected to the internet",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColor.black333,
                fontWeight: FontWeight.w400,
                fontSize: 12.0.sp,
              ),
            ),
            actions: [
              AppTouchable3(
                margin: EdgeInsets.only(
                  left: 6.0.sp,
                  bottom: 12.0.sp,
                ),
                onPressed: () => Get.back(),
                child: const Text("Back"),
              ),
              AppTouchable3(
                margin: EdgeInsets.only(
                  left: 6.0.sp,
                  bottom: 12.0.sp,
                  right: 12.0.sp,
                ),
                onPressed: () => OpenSettings.openWIFISetting(),
                child: const Text("Open setting"),
              ),
            ],
          );
        },
      );
    } else {
      showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(
              "No internet connection",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColor.black333,
                fontWeight: FontWeight.w600,
                fontSize: 18.0.sp,
              ),
            ),
            content: Text(
              "You can connected to the internet",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColor.black333,
                fontWeight: FontWeight.w400,
                fontSize: 12.0.sp,
              ),
            ),
            actions: [
              CupertinoButton(
                onPressed: () => Get.back(),
                child: const Text("Back"),
              ),
              CupertinoButton(
                onPressed: () => OpenSettings.openWIFISetting(),
                child: const Text("Open setting"),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> showConnectError({
    required BuildContext context,
    required PlatformException exception,
  }) async {
    if (Platform.isAndroid) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Check connect error",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColor.black333,
                fontWeight: FontWeight.w600,
                fontSize: 18.0.sp,
              ),
            ),
            content: Text(
              exception.message ?? "",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColor.black333,
                fontWeight: FontWeight.w400,
                fontSize: 12.0.sp,
              ),
            ),
            actions: [
              AppTouchable3(
                margin: EdgeInsets.only(
                  left: 6.0.sp,
                  bottom: 12.0.sp,
                ),
                onPressed: () => Get.back(),
                child: const Text("Back"),
              ),
            ],
          );
        },
      );
    } else {
      showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(
              "Check connect error",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColor.black333,
                fontWeight: FontWeight.w600,
                fontSize: 18.0.sp,
              ),
            ),
            content: Text(
              exception.message ?? "",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColor.black333,
                fontWeight: FontWeight.w400,
                fontSize: 12.0.sp,
              ),
            ),
            actions: [
              CupertinoButton(
                onPressed: () => Get.back(),
                child: const Text("Back"),
              ),
            ],
          );
        },
      );
    }
  }
}
