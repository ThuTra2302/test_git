import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../build_constants.dart';
import '../controller/app_controller.dart';
import '../controller/app_flyer_controller.dart';
import '../util/app_util.dart';

class AddInterstitialOpenAdManager {
  static var TAG = "---Interstitial Open Ad ---";

  static InterstitialAd? interstitialAd;
  static var appFlyer = Get.find<AppFlyerController>();

  static void loadInterstitialOpenAd() {
    InterstitialAd.load(
      adUnitId: BuildConstants.idOpenAppAd,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint("Open Interstitial ad load");
          appFlyer.loadAds(TAG, 'success');
          interstitialAd = ad;
        },
        onAdFailedToLoad: (error) {

          debugPrint("Open Interstitial ad load failed: Error code = ${error.code}");
          debugPrint("Open Interstitial ad load failed: Error message = ${error.message}");
        },
      ),
    );
  }

  static void showInterstitialOpenAd(Function() onAdHiddenCallback) {
    if (interstitialAd != null) {
      interstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
        // Called when the ad showed the full screen content.
        onAdShowedFullScreenContent: (ad) {
          debugPrint("$TAG: onAdShowedFullScreenContent");
          appFlyer.showAds(TAG, 'showed the full screen content');
          if (Get.isRegistered<AppController>()) {
            Get.find<AppController>().avoidShowOpenApp = true;
          }
        },
        // Called when an impression occurs on the ad.
        onAdImpression: (ad) {
          debugPrint("$TAG: onAdImpression");

          if (Get.isRegistered<AppController>()) {
            Get.find<AppController>().avoidShowOpenApp = true;
          }
        },
        // Called when the ad failed to show full screen content.
        onAdFailedToShowFullScreenContent: (ad, err) {
          // Dispose the ad here to free resources.
          debugPrint("$TAG error: $err");
          ad.dispose();
          onAdHiddenCallback();
          loadInterstitialOpenAd();

          if (Get.isRegistered<AppController>()) {
            Get.find<AppController>().avoidShowOpenApp = true;
          }
        },
        // Called when the ad dismissed full screen content.
        onAdDismissedFullScreenContent: (ad) {
          // Dispose the ad here to free resources.
          debugPrint("$TAG: onAdDismissedFullScreenContent");

          ad.dispose();
          onAdHiddenCallback();
          loadInterstitialOpenAd();

          if (Get.isRegistered<AppController>()) {
            Get.find<AppController>().avoidShowOpenApp = false;
          }
        },
        // Called when a click is recorded for an ad.
        onAdClicked: (ad) {
          debugPrint("$TAG: onAdClicked");
          appFlyer.onClickAds(
            TAG,
          );
          if (Get.isRegistered<AppController>()) {
            Get.find<AppController>().avoidShowOpenApp = true;
          }
        },
      );

      interstitialAd!.show();
      interstitialAd = null;
    } else {
      debugPrint('Open Interstitial ad is not ready yet.');
      onAdHiddenCallback();
      loadInterstitialOpenAd();
    }
  }

  static bool checkOpenInterstitial() {
    return interstitialAd == null;
  }
}

void showInterstitialOpenAds(Function() onAdHiddenCallback) async {
  var TAG = "---Open Interstitial Ad---";

  debugPrint("$TAG: onClick");
  ConnectivityResult connectivityResult = await Connectivity().checkConnectivity();

  if (connectivityResult == ConnectivityResult.none) {
    onAdHiddenCallback();
    showToast('No internet connection, please try again later');
  } else {
    AddInterstitialOpenAdManager.showInterstitialOpenAd(onAdHiddenCallback);
  }
}

void loadInterstitialOpenAd() {
  AddInterstitialOpenAdManager.loadInterstitialOpenAd();
}
