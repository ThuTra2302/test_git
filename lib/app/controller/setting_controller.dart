import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../res/string/app_strings.dart';
import '../ui/screen/sub_screen.dart';
import '../ui/screen/web_view_screen.dart';
import '../ui/theme/app_color.dart';
import '../ui/widget/app_dialog.dart';
import '../util/app_constant.dart';
import '../util/app_util.dart';
import 'app_controller.dart';

class SettingController extends GetxController {
  RxString currentLanguageCode = ''.obs;

  @override
  void onReady() {
    super.onReady();
    currentLanguageCode.value =
        Get.find<AppController>().currentLocale.toLanguageTag() == 'vi-VN' ? 'VI' : 'EN';
  }

  openLink(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      log('Could not launch $url');
    }
  }

  onPressItemSetting(String url) {
    Get.to(
          () => WebViewScreen(
        url: url,
      ),
    );
  }

  onPressPrivacyPolicy() {
    openLink('https://appvillage.com.vn/privacy.txt');
  }

  onPressTermOfCondition() {
    openLink('https://appvillage.com.vn/privacy.txt');
  }

  onPressContactUs() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'appvillage.publishing@gmail.com',
      // Địa chỉ email của người nhận
      queryParameters: {'subject': '', 'body': ''},
    );

    if (await canLaunchUrl(
    Uri.parse(emailLaunchUri.toString()))) {
    await launchUrl(
    Uri.parse(emailLaunchUri.toString()));
    } else {
    throw 'Could not launch email';
    }
  }

  void onPressShareApp() {
    if (Platform.isIOS) {
      Share.share('${StringConstants.shareMessage.tr}: itms-apps://apple.com/app/');
    } else {
      Share.share(
          '${StringConstants.shareMessage.tr}: https://play.google.com/store/apps/details?id=com.roadtrippers.weather.activity.notes');
    }
  }

  void openSub() {
    Get.to(() => const SubScreen());
  }

  onPressLanguage(BuildContext context) {
    showAppDialog(
      context,
      StringConstants.language.tr,
      '',
      hideGroupButton: true,
      widgetBody: Column(
        children: [
          SizedBox(height: 32.0.sp),
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () async {
              Get.find<AppController>().currentLanguageCode.value = 'Eng';
              final prefs = await SharedPreferences.getInstance();
              prefs.setString('language', '1');
              Get.find<AppController>().updateLocale(AppConstant.availableLocales[1]);
              Get.back();
            },
            borderRadius: BorderRadius.circular(10.0.sp),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12.0.sp, horizontal: 16.0.sp),
              decoration: BoxDecoration(
                color: AppColor.whiteBG,
                borderRadius: BorderRadius.circular(10.0.sp),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(-6.0.sp, -6.0.sp),
                    blurRadius: 10.0.sp,
                    spreadRadius: 0,
                    color: AppColor.white,
                  ),
                  BoxShadow(
                    offset: Offset(5.0.sp, 5.0.sp),
                    blurRadius: 10.0.sp,
                    spreadRadius: 0,
                    color: const Color(0xFFBFC9D7),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'English',
                      style: TextStyle(
                        fontSize: 16.0.sp,
                        color: AppColor.gray,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Container(
                    width: 20.0.sp,
                    height: 20.0.sp,
                    padding: EdgeInsets.all(2.0.sp),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(12.0.sp),
                      border: Border.all(color: AppColor.gray, width: 2),
                    ),
                    child: Obx(() => Get.find<AppController>().currentLanguageCode.value == 'Eng'
                        ? Container(
                            decoration: BoxDecoration(
                              color: AppColor.gray,
                              borderRadius: BorderRadius.circular(12.0.sp),
                            ),
                          )
                        : const SizedBox.shrink()),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16.0.sp),
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () async {
              Get.find<AppController>().currentLanguageCode.value = 'Viet';
              final prefs = await SharedPreferences.getInstance();
              prefs.setString('language', '0');
              Get.find<AppController>().updateLocale(AppConstant.availableLocales[0]);
              Get.back();
            },
            borderRadius: BorderRadius.circular(10.0.sp),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12.0.sp, horizontal: 16.0.sp),
              decoration: BoxDecoration(
                color: AppColor.whiteBG,
                borderRadius: BorderRadius.circular(10.0.sp),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(-6.0.sp, -6.0.sp),
                    blurRadius: 10.0.sp,
                    spreadRadius: 0,
                    color: AppColor.white,
                  ),
                  BoxShadow(
                    offset: Offset(5.0.sp, 5.0.sp),
                    blurRadius: 10.0.sp,
                    spreadRadius: 0,
                    color: const Color(0xFFBFC9D7),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Tiếng Việt',
                      style: TextStyle(
                        fontSize: 16.0.sp,
                        color: AppColor.gray,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Container(
                    width: 20.0.sp,
                    height: 20.0.sp,
                    padding: EdgeInsets.all(2.0.sp),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(12.0.sp),
                      border: Border.all(color: AppColor.gray, width: 2),
                    ),
                    child: Obx(() => Get.find<AppController>().currentLanguageCode.value == 'Viet'
                        ? Container(
                            decoration: BoxDecoration(
                              color: AppColor.gray,
                              borderRadius: BorderRadius.circular(12.0.sp),
                            ),
                          )
                        : const SizedBox.shrink()),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 32.0.sp),
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: Get.back,
            child: Icon(
              Icons.clear,
              size: 28.0.sp,
              color: AppColor.gray,
            ),
          ),
        ],
      ),
    );
  }
}
