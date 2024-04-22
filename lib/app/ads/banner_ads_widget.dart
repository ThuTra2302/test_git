import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../controller/app_controller.dart';
import 'banner_ad_manager.dart';

class BannerAdsWidget extends StatefulWidget {
  final bool isCollapsible;

  const BannerAdsWidget({
    Key? key,
    this.isCollapsible = true,
  }) : super(key: key);

  @override
  State<BannerAdsWidget> createState() => _BannerAdsWidgetState();
}

class _BannerAdsWidgetState extends State<BannerAdsWidget> {
  Map bannerAdMap = {};
  bool isShowSuccess = false;

  @override
  void initState() {
    _initBannerAds();

    super.initState();
  }

  _initBannerAds() async {
    if (Get.find<AppController>().isPremium.value) return;

    BannerAd? bannerAd;

    if (widget.isCollapsible) {
      bannerAd = BannerAdManager.createCollapsibleAd(
            () {
          bannerAdMap = {
            "ad": bannerAd,
            "widget": Container(
              width: bannerAd!.size.width.toDouble(),
              height: bannerAd.size.height.toDouble(),
              margin: EdgeInsets.only(
                bottom: 4.0.sp,
              ),
              alignment: Alignment.bottomCenter,
              child: AdWidget(
                ad: bannerAd,
              ),
            ),
          };
          isShowSuccess = true;
          setState(() {});
        },
      );
    } else {
      bannerAd = BannerAdManager.createBannerAd(
            () {
          bannerAdMap = {
            "ad": bannerAd,
            "widget": Container(
              width: bannerAd!.size.width.toDouble(),
              height: bannerAd.size.height.toDouble(),
              margin: EdgeInsets.only(
                bottom: 4.0.sp,
              ),
              alignment: Alignment.bottomCenter,
              child: AdWidget(
                ad: bannerAd,
              ),
            ),
          };
          isShowSuccess = true;
          setState(() {});
        },
      );
    }

    bannerAd?.load();
  }

  @override
  Widget build(BuildContext context) {
    return isShowSuccess
        ? bannerAdMap['widget'] ?? const SizedBox.shrink()
        : const SizedBox.shrink();
  }
}
