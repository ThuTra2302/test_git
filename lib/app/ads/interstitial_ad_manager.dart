import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel/app/controller/app_flyer_controller.dart';

import '../common/remote_config.dart';
import '../controller/app_controller.dart';
import '../util/app_log.dart';
import '../util/app_util.dart';

class AddInterstitialAdManager {
  static var TAG = "---Interstitial Ad ---";
  // Inter:
  // ID1: ca-app-pub-9819920607806935/9630632376
  // ID2: ca-app-pub-9819920607806935/8301825562
  // ID3: ca-app-pub-9819920607806935/5675662221

  static InterstitialAd? interstitialAd;
  static var appFlyer = Get.find<AppFlyerController>();
  static String keyInterAds="ca-app-pub-9819920607806935/9630632376";
  static int cntAds=0;
  static void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: keyInterAds,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint("Interstitial ad load");
          appFlyer.loadAds(TAG, 'success');
          interstitialAd = ad;
          cntAds=0;
          AppLog.info("Key ads $keyInterAds");
          keyInterAds="ca-app-pub-9819920607806935/9630632376";
        },
        onAdFailedToLoad: (error) {
          debugPrint("Interstitial ad load failed: Error code = ${error.code}");
          debugPrint(
              "Interstitial ad load failed: Error message = ${error.message}");
          cntAds++;
          AppLog.error("Key ads $keyInterAds");
          if(cntAds==1){
            keyInterAds="ca-app-pub-9819920607806935/8301825562";
          }
          else {
            keyInterAds="ca-app-pub-9819920607806935/5675662221";
          }
          if(cntAds<3){
            loadInterstitialAd();
          }
          else {
            cntAds=0;

            keyInterAds="ca-app-pub-9819920607806935/9630632376";
          }
        },
      ),
    );
  }

  static void showInterstitialAd(Function() onAdHiddenCallback) {
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
          loadInterstitialAd();

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
          loadInterstitialAd();

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
      debugPrint('Interstitial ad is not ready yet.');

      onAdHiddenCallback();
      loadInterstitialAd();
    }
  }

  static bool checkInterstitial() {
    return interstitialAd == null;
  }
}

void showInterstitialAds(Function() onAdHiddenCallback) async {
  var TAG = "---Interstitial Ad---";

  debugPrint("$TAG: onClick");
  ConnectivityResult connectivityResult =
      await Connectivity().checkConnectivity();

  if (connectivityResult == ConnectivityResult.none) {
    onAdHiddenCallback();
    showToast('No internet connection, please try again later');
  } else {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? interTime = prefs.getInt('inter_time');

    AppLog.debug("Inter Capping: ${RemoteConfig.getIntersCapping()}");

    if (interTime == null) {
      AddInterstitialAdManager.showInterstitialAd(onAdHiddenCallback);
      prefs.setInt("inter_time", DateTime.now().millisecondsSinceEpoch);
    } else {
      if (DateTime.now().millisecondsSinceEpoch >=
          interTime + 1000 * RemoteConfig.getIntersCapping()) {
        AddInterstitialAdManager.showInterstitialAd(onAdHiddenCallback);
        prefs.setInt("inter_time", DateTime.now().millisecondsSinceEpoch);
      } else {
        onAdHiddenCallback();
      }
    }
  }
}

void loadInterstitialAd() {
  AddInterstitialAdManager.loadInterstitialAd();
}
