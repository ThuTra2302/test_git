import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../build_constants.dart';
import '../controller/app_controller.dart';
import '../util/app_util.dart';

/// Utility class that manages loading and showing app open ads.
class OpenAdManager {
  /// Maximum duration allowed between loading and showing the ad.
  final Duration maxCacheDuration = const Duration(hours: 4);

  /// Keep track of load time so we don't show an expired ad.
  DateTime? _appOpenLoadTime;

  AppOpenAd? _appOpenAd;
  bool _isShowingAd = false;

  String adUnitId = BuildConstants.idOpenAppAd;

  /// Load an [AppOpenAd].
  void loadAd() {
    AppOpenAd.load(
      adUnitId: adUnitId,
      orientation: AppOpenAd.orientationPortrait,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          log('---OPEN APP AD: $ad loaded');
          _appOpenLoadTime = DateTime.now();
          _appOpenAd = ad;
        },
        onAdFailedToLoad: (error) {
          log('---OPEN APP AD: AppOpenAd failed to load: $error');
        },
      ),
    );
  }

  /// Whether an ad is available to be shown.
  bool get isAdAvailable {
    return _appOpenAd != null;
  }

  /// Shows the ad, if one exists and is not already being shown.
  ///
  /// If the previously cached ad has expired, this just loads and caches a
  /// new ad.
  void showAdIfAvailable() {
    if (Get.find<AppController>().isPremium.value) {
      return;
    }
    if (!isAdAvailable) {
      log('---OPEN APP AD: Tried to show ad before available.');
      loadAd();
      return;
    }
    if (_isShowingAd) {
      log('---OPEN APP AD: Tried to show ad while already showing an ad.');
      return;
    }
    if (DateTime.now().subtract(maxCacheDuration).isAfter(_appOpenLoadTime!)) {
      log('---OPEN APP AD: Maximum cache duration exceeded. Loading another ad.');
      _appOpenAd!.dispose();
      _appOpenAd = null;
      loadAd();
      return;
    }
    // Set the fullScreenContentCallback and show the ad.
    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        _isShowingAd = true;
        log('---OPEN APP AD: $ad onAdShowedFullScreenContent');
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        log('---OPEN APP AD: $ad onAdFailedToShowFullScreenContent: $error');
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
      },
      onAdDismissedFullScreenContent: (ad) {
        log('---OPEN APP AD: $ad onAdDismissedFullScreenContent');
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
        loadAd();
      },
    );
    _appOpenAd!.show();
  }
}
