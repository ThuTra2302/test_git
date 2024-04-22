import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:travel/app/controller/app_controller.dart';
import 'package:travel/app/res/image/app_image.dart';
import 'package:travel/app/ui/widget/app_image_widget.dart';

import '../../controller/splash_controller.dart';
import '../theme/app_color.dart';
import '../widget/app_container.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.context = context;
    return AppContainer(
      showBanner: false,
      backgroundColor: AppColor.white,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppImageWidget.asset(
                  path: AppImage.ic_launcher,
                  width: Get.width / 7 * 2,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 18.0.sp),
                Text(
                  "Roadtripper",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColor.black333,
                    fontWeight: FontWeight.w800,
                    fontSize: 32.0.sp,
                  ),
                ),
                SizedBox(height: 4.0.sp),
                Text(
                  "A better Route Planner",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColor.grayE93,
                    fontWeight: FontWeight.w400,
                    fontSize: 14.0.sp,
                  ),
                ),
                SizedBox(height: 12.0.sp),
                const CircularProgressIndicator(
                  color: AppColor.primaryColor,
                ),
                SizedBox(height: 12.0.sp),
                Get.find<AppController>().isPremium.value
                    ? const SizedBox.shrink()
                    : Text(
                        'Ads are about to show...',
                        style: TextStyle(
                          color: AppColor.grayE93,
                          fontWeight: FontWeight.w400,
                          fontSize: 14.0.sp,
                        ),
                      )
              ],
            ),
          ),
          Positioned(
            bottom: 20.0.sp,
            child: Obx(() => Text(
                  controller.version.value,
                  style: const TextStyle(
                    color: AppColor.black,
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
