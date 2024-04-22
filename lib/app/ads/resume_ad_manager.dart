import 'dart:developer';

import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../common/app_log.dart';
import '../controller/app_controller.dart';


/// Utility class that manages loading and showing app open ads.
class ResumeAdManager {
  /// Maximum duration allowed between loading and showing the ad.
  final Duration maxCacheDuration = const Duration(hours: 4);

  /// Keep track of load time so we don't show an expired ad.
  DateTime? _appOpenLoadTime;

  AppOpenAd? _appOpenAd;
  bool _isShowingAd = false;

  String adUnitId = 'ca-app-pub-9819920607806935/5688066679';
  static int cntAds=0;
  // Switch app:
  // ID1: ca-app-pub-9819920607806935/5688066679
  // ID2: ca-app-pub-9819920607806935/2857927195
  // ID3: ca-app-pub-9819920607806935/1544845526

  /// Load an [AppOpenAd].
  void loadAd() {
    AppOpenAd.load(
      adUnitId: adUnitId,
      orientation: AppOpenAd.orientationPortrait,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          log('---OPEN APP AD---: $ad loaded');
          _appOpenLoadTime = DateTime.now();
          _appOpenAd = ad;

          cntAds=0;
          AppLog.info("Key ads Resume $adUnitId");
          adUnitId = 'ca-app-pub-9819920607806935/5688066679';
        },
        onAdFailedToLoad: (error) {
          log('---OPEN APP AD---: AppOpenAd failed to load: $error');
          cntAds++;
          AppLog.error("Key ads Resume $adUnitId");
          if(cntAds==1){
            adUnitId="ca-app-pub-9819920607806935/2857927195";
          }
          else {
            adUnitId="ca-app-pub-9819920607806935/1544845526";
          }
          if(cntAds<3){
            loadAd();
          }
          else {
            cntAds=0;
            adUnitId = 'ca-app-pub-9819920607806935/5688066679';
          }
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
      log('---OPEN APP AD---: Tried to show ad before available.');
      loadAd();
      return;
    }
    if (_isShowingAd) {
      log('---OPEN APP AD---: Tried to show ad while already showing an ad.');
      return;
    }
    if (DateTime.now().subtract(maxCacheDuration).isAfter(_appOpenLoadTime!)) {
      log('---OPEN APP AD---: Maximum cache duration exceeded. Loading another ad.');
      _appOpenAd!.dispose();
      _appOpenAd = null;
      loadAd();
      return;
    }
    // Set the fullScreenContentCallback and show the ad.
    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        _isShowingAd = true;
        log('---OPEN APP AD---: $ad onAdShowedFullScreenContent');
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        log('---OPEN APP AD---: $ad onAdFailedToShowFullScreenContent: $error');
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
      },
      onAdDismissedFullScreenContent: (ad) {
        log('---OPEN APP AD---: $ad onAdDismissedFullScreenContent');
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
        loadAd();
      },
    );
    _appOpenAd!.show();
  }
}
