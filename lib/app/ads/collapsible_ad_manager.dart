import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../build_constants.dart';

class CollapsibleAdManager {
  static Future<BannerAd> createCollapsibleAd(Function() onAdLoaded) async {
    final AnchoredAdaptiveBannerAdSize? size =
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
        Get.width.truncate());
    if (size == null) {
      print('Unable to get height of anchored banner.');
      return BannerAd(
        size: AdSize.fullBanner,
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
          // extras: {
          //   "collapsible": "bottom"
          // },
        ),
      );
    }
    return BannerAd(
      adUnitId: BuildConstants.idBannerAd,
      size: size,
      request: const AdRequest(
        // extras: {
        //   "collapsible": "bottom"
        // },
      ),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          debugPrint('---ADAPTIP BANNER ADS---: $BannerAd loaded.');
          // When the ad is loaded, get the ad size and use it to set
          // the height of the ad container.
          onAdLoaded();
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('Anchored adaptive banner failedToLoad: $error');
          ad.dispose();
        },
        onAdOpened: (Ad ad) => debugPrint('---BANNER ADS---: $BannerAd onAdOpened.'),
        onAdClosed: (Ad ad) => debugPrint('---BANNER ADS---: $BannerAd onAdClosed.'),
      ),

    );
  }

}
