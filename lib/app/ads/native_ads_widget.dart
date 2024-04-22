import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';


import '../controller/app_controller.dart';
import 'native_ad_manager.dart';


class NativeAdsWidget extends StatefulWidget {
  const NativeAdsWidget({Key? key}) : super(key: key);

  @override
  State<NativeAdsWidget> createState() => _NativeAdsWidget();
}

class _NativeAdsWidget extends State<NativeAdsWidget> {
  Map nativeAdsMap = {};

  @override
  void initState() {
    _initNativeAds();

    super.initState();
  }

  _initNativeAds() {
    if (Get.find<AppController>().isPremium.value) return;

    NativeAd? nativeAd;

    nativeAd = createNativeAd(() {
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

class MediumNativeAdsWidget extends StatefulWidget {
  const MediumNativeAdsWidget({Key? key}) : super(key: key);

  @override
  State<MediumNativeAdsWidget> createState() => _MediumNativeAdsWidget();
}

class _MediumNativeAdsWidget extends State<MediumNativeAdsWidget> {
  Map nativeAdsMap = {};

  @override
  void initState() {
    _initNativeAds();

    super.initState();
  }

  _initNativeAds() {
    if (Get.find<AppController>().isPremium.value) return;

    NativeAd? nativeAd;

    nativeAd = createMediumNativeAd(() {
      nativeAdsMap = {
        'ad': nativeAd,
        'widget': Container(
          width: Get.width,
          constraints: BoxConstraints(
            minHeight: 340.sp,
            maxHeight: 420.sp,
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

class ExitNativeAdsWidget extends StatefulWidget {
  const ExitNativeAdsWidget({Key? key}) : super(key: key);

  @override
  State<ExitNativeAdsWidget> createState() => _ExitNativeAdsWidget();
}

class _ExitNativeAdsWidget extends State<ExitNativeAdsWidget> {
  Map nativeAdsMap = {};

  @override
  void initState() {
    _initNativeAds();

    super.initState();
  }

  _initNativeAds() {
    if (Get.find<AppController>().isPremium.value) return;

    NativeAd? nativeAd;

    nativeAd = createExitNativeAd(() {
      nativeAdsMap = {
        'ad': nativeAd,
        'widget': Container(
          width: Get.width,
          constraints: BoxConstraints(
            minHeight: 340.sp,
            maxHeight: 420.sp,
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


