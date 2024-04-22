import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../build_constants.dart';
import '../common/app_log.dart';
import '../controller/app_controller.dart';

class RewardAdsManager {
  RewardAdsManager._();

  static var TAG = "=-= Reward ads =-=";

  static RewardedAd? _rewardedAd;

  static void loadRewardAds() {
    RewardedAd.load(
      adUnitId: BuildConstants.idRewardAd,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          AppLog.debug("Reward ad load");
          _rewardedAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          AppLog.debug(
              "Interstitial ad load failed: Error code = ${error.code}");
          AppLog.debug(
              "Interstitial ad load failed: Error message = ${error.message}");
        },
      ),
    );
  }

  static void showRewardAds(Function() onAdHiddenCallback) {
    if (_rewardedAd != null) {
      _rewardedAd?.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (ad) {
          // Called when the ad showed the full screen content.

          AppLog.debug("$TAG: onAdShowedFullScreenContent");

          if (Get.isRegistered<AppController>()) {
            Get.find<AppController>().avoidShowOpenApp = true;
          }
        },
        onAdImpression: (ad) {
          // Called when an impression occurs on the ad.

          AppLog.debug("$TAG: onAdImpression");

          if (Get.isRegistered<AppController>()) {
            Get.find<AppController>().avoidShowOpenApp = true;
          }
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          // Called when the ad failed to show full screen content.
          AppLog.error("$TAG error: $error");

          // Dispose the ad here to free resources.
          ad.dispose();
          onAdHiddenCallback();
          loadRewardAds();

          if (Get.isRegistered<AppController>()) {
            Get.find<AppController>().avoidShowOpenApp = true;
          }
        },
        // Called when the ad dismissed full screen content.
        onAdDismissedFullScreenContent: (ad) {
          // Dispose the ad here to free resources.
          AppLog.debug("$TAG: onAdDismissedFullScreenContent");

          ad.dispose();
          onAdHiddenCallback();
          loadRewardAds();

          if (Get.isRegistered<AppController>()) {
            Get.find<AppController>().avoidShowOpenApp = false;
          }
        },
        // Called when a click is recorded for an ad.
        onAdClicked: (ad) {
          AppLog.debug("$TAG: onAdClicked");

          if (Get.isRegistered<AppController>()) {
            Get.find<AppController>().avoidShowOpenApp = true;
          }
        },
      );

      _rewardedAd?.show(
        onUserEarnedReward: (ad, reward) {},
      );
    } else {
      AppLog.debug('Interstitial ad is not ready yet.');

      onAdHiddenCallback();
      loadRewardAds();
    }
  }
}

void showRewardAds(Function() onAdHiddenCallback) async {
  ConnectivityResult connectivityResult =
      await Connectivity().checkConnectivity();

  if (connectivityResult == ConnectivityResult.none) {
    onAdHiddenCallback();
  } else {
    RewardAdsManager.showRewardAds(onAdHiddenCallback);
  }
}

void loadRewardAd() {
  RewardAdsManager.loadRewardAds();
}