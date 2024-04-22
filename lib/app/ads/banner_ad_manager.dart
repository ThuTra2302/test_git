import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../build_constants.dart';

class BannerAdManager {
  BannerAdManager._();

  static AnchoredAdaptiveBannerAdSize? _size;

  static Future<void> init() async {
    _size = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
        (Get.width - 12).truncate());
  }

  static BannerAd createBannerAd(Function() onAdLoaded) {
    if (_size != null) {
      return BannerAd(
        size: _size!,
        adUnitId: BuildConstants.idBannerAd,
        listener: BannerAdListener(
          onAdLoaded: (Ad ad) {
            debugPrint('---BANNER ADS---: $BannerAd loaded.');
            onAdLoaded();
          },
          onAdFailedToLoad: (Ad ad, LoadAdError error) {
            ad.dispose();
            debugPrint('---BANNER ADS---: $BannerAd failedToLoad: $error');
          },
          onAdOpened: (Ad ad) =>
              debugPrint('---BANNER ADS---: $BannerAd onAdOpened.'),
          onAdClosed: (Ad ad) =>
              debugPrint('---BANNER ADS---: $BannerAd onAdClosed.'),
        ),
        request: const AdRequest(),
      );
    }

    return BannerAd(
      size: AdSize.banner,
      adUnitId: BuildConstants.idBannerAd,
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          debugPrint('---BANNER ADS---: $BannerAd loaded.');
          onAdLoaded();
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
          debugPrint('---BANNER ADS---: $BannerAd failedToLoad: $error');
        },
        onAdOpened: (Ad ad) =>
            debugPrint('---BANNER ADS---: $BannerAd onAdOpened.'),
        onAdClosed: (Ad ad) =>
            debugPrint('---BANNER ADS---: $BannerAd onAdClosed.'),
      ),
      request: const AdRequest(),
    );
  }

  static createCollapsibleAd(Function() onAdLoaded) {
    if (_size != null) {
      return BannerAd(
        size: _size!,
        adUnitId: BuildConstants.idBannerAd,
        listener: BannerAdListener(
          onAdLoaded: (Ad ad) {
            debugPrint('---COLLAPSIBLE ADS---: $BannerAd loaded.');
            onAdLoaded();
          },
          onAdFailedToLoad: (Ad ad, LoadAdError error) {
            ad.dispose();
            debugPrint('---COLLAPSIBLE ADS---: $BannerAd failedToLoad: $error');
          },
          onAdOpened: (Ad ad) =>
              debugPrint('---COLLAPSIBLE ADS---: $BannerAd onAdOpened.'),
          onAdClosed: (Ad ad) =>
              debugPrint('---COLLAPSIBLE ADS---: $BannerAd onAdClosed.'),
        ),
        request: const AdRequest(
          extras: {"collapsible": "bottom"},
        ),
      );
    }

    return BannerAd(
      size: AdSize.banner,
      adUnitId: BuildConstants.idBannerAd,
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          debugPrint('---COLLAPSIBLE ADS---: $BannerAd loaded.');
          onAdLoaded();
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
          debugPrint('---COLLAPSIBLE ADS---: $BannerAd failedToLoad: $error');
        },
        onAdOpened: (Ad ad) =>
            debugPrint('---COLLAPSIBLE ADS---: $BannerAd onAdOpened.'),
        onAdClosed: (Ad ad) =>
            debugPrint('---COLLAPSIBLE ADS---: $BannerAd onAdClosed.'),
      ),
      request: const AdRequest(
        extras: {"collapsible": "bottom"},
      ),
    );
  }
}
