import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:travel/app/ads/native_ad_manager.dart';

import '../controller/app_controller.dart';

class IntroAdsWidget extends StatefulWidget {
  const IntroAdsWidget({Key? key}) : super(key: key);

  @override
  State<IntroAdsWidget> createState() => _IntroAdsWidget();
}

class _IntroAdsWidget extends State<IntroAdsWidget> {
  Map nativeAdsMap = {};

  @override
  void initState() {
    _initNativeAds();

    super.initState();
  }

  _initNativeAds() {
    if (Get.find<AppController>().isPremium.value) return;

    NativeAd? nativeAd;

    nativeAd = createIntroNativeAd(() {
      nativeAdsMap = {
        'ad': nativeAd,
        'widget': Container(
          width: Get.width,
          height: 140.0.sp,
          margin: EdgeInsets.only(
            top: 8.0.sp,
            bottom: 4.0.sp,
          ),
          child: AdWidget(
            ad: nativeAd!,
          ),
        ),
      };
      setState(() {});
    });

    nativeAd.load();
  }

  @override
  Widget build(BuildContext context) {
    return nativeAdsMap['widget'] ?? const SizedBox.shrink();
  }
}