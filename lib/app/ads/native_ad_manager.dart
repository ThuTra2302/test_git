import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../build_constants.dart';
import '../util/app_log.dart';

NativeAd createNativeAd(Function() onAdLoaded) {
  return NativeAd(
    adUnitId: BuildConstants.idNativeAppAd,
    factoryId: NativeFactoryId.appNativeAdFactorySmall,
    request: const AdRequest(),
    listener: NativeAdListener(
      onAdLoaded: (Ad ad) {
        AppLog.debug('---NATIVE ADS---: $NativeAd loaded.');
        onAdLoaded();
      },
      onAdFailedToLoad: (Ad ad, LoadAdError error) {
        AppLog.debug('---NATIVE ADS---: $NativeAd failedToLoad: $error');
        ad.dispose();
      },
      onAdOpened: (Ad ad) =>
          AppLog.debug('---NATIVE ADS---: $NativeAd onAdOpened.'),
      onAdClosed: (Ad ad) =>
          AppLog.debug('---NATIVE ADS---: $NativeAd onAdClosed.'),
    ),
    nativeTemplateStyle: NativeTemplateStyle(
      // Required: Choose a template.
      templateType: TemplateType.small,
      // Optional: Customize the ad's style.
      mainBackgroundColor: Colors.white,
      cornerRadius: 16.sp,
      callToActionTextStyle: NativeTemplateTextStyle(
        textColor: Colors.white,
        backgroundColor: const Color(0xFF7D73C3),
        style: NativeTemplateFontStyle.monospace,
        size: 16.0,
      ),
      primaryTextStyle: NativeTemplateTextStyle(
        textColor: Colors.black,
        backgroundColor: Colors.white,
        style: NativeTemplateFontStyle.italic,
        size: 16.0,
      ),
      secondaryTextStyle: NativeTemplateTextStyle(
        textColor: Colors.black,
        backgroundColor: Colors.white,
        style: NativeTemplateFontStyle.bold,
        size: 16.0,
      ),
      tertiaryTextStyle: NativeTemplateTextStyle(
        textColor: Colors.black,
        backgroundColor: Colors.white,
        style: NativeTemplateFontStyle.normal,
        size: 16.0,
      ),
    ),
  );
}

NativeAd createMediumNativeAd(Function() onAdLoaded) {
  return NativeAd(
    adUnitId: BuildConstants.idNativeAppAd,
    factoryId: NativeFactoryId.appNativeAdFactorySmall,
    request: const AdRequest(),
    listener: NativeAdListener(
      onAdLoaded: (Ad ad) {
        AppLog.debug('---NATIVE ADS---: $NativeAd loaded.');
        onAdLoaded();
      },
      onAdFailedToLoad: (Ad ad, LoadAdError error) {
        AppLog.debug('---NATIVE ADS---: $NativeAd failedToLoad: $error');
        ad.dispose();
      },
      onAdOpened: (Ad ad) =>
          AppLog.debug('---NATIVE ADS---: $NativeAd onAdOpened.'),
      onAdClosed: (Ad ad) =>
          AppLog.debug('---NATIVE ADS---: $NativeAd onAdClosed.'),
    ),
    nativeTemplateStyle: NativeTemplateStyle(
      // Required: Choose a template.
      templateType: TemplateType.medium,
      // Optional: Customize the ad's style.
      mainBackgroundColor: Colors.white,
      cornerRadius: 16.sp,
      callToActionTextStyle: NativeTemplateTextStyle(
        textColor: Colors.white,
        backgroundColor: const Color(0xFF7D73C3),
        style: NativeTemplateFontStyle.monospace,
        size: 16.0,
      ),
      primaryTextStyle: NativeTemplateTextStyle(
        textColor: Colors.black,
        backgroundColor: Colors.white,
        style: NativeTemplateFontStyle.italic,
        size: 16.0,
      ),
      secondaryTextStyle: NativeTemplateTextStyle(
        textColor: Colors.black,
        backgroundColor: Colors.white,
        style: NativeTemplateFontStyle.bold,
        size: 16.0,
      ),
      tertiaryTextStyle: NativeTemplateTextStyle(
        textColor: Colors.black,
        backgroundColor: Colors.white,
        style: NativeTemplateFontStyle.normal,
        size: 16.0,
      ),
    ),
  );
}

NativeAd createExitNativeAd(Function() onAdLoaded) {
  return NativeAd(
    adUnitId: BuildConstants.idExitNativeAppAd,
    factoryId: 'appNativeAdFactoryMedium',
    request: const AdRequest(),
    listener: NativeAdListener(
      onAdLoaded: (Ad ad) {
        AppLog.debug('---NATIVE ADS---: $NativeAd loaded.');
        onAdLoaded();
      },
      onAdFailedToLoad: (Ad ad, LoadAdError error) {
        AppLog.debug('---NATIVE ADS---: $NativeAd failedToLoad: $error');
        ad.dispose();
      },
      onAdOpened: (Ad ad) =>
          AppLog.debug('---NATIVE ADS---: $NativeAd onAdOpened.'),
      onAdClosed: (Ad ad) =>
          AppLog.debug('---NATIVE ADS---: $NativeAd onAdClosed.'),
    ),
    nativeTemplateStyle: NativeTemplateStyle(
      // Required: Choose a template.
      templateType: TemplateType.medium,
      // Optional: Customize the ad's style.
      mainBackgroundColor: Colors.white,
      cornerRadius: 16.sp,
      callToActionTextStyle: NativeTemplateTextStyle(
        textColor: Colors.white,
        backgroundColor: const Color(0xFF7D73C3),
        style: NativeTemplateFontStyle.monospace,
        size: 16.0,
      ),
      primaryTextStyle: NativeTemplateTextStyle(
        textColor: Colors.black,
        backgroundColor: Colors.white,
        style: NativeTemplateFontStyle.italic,
        size: 16.0,
      ),
      secondaryTextStyle: NativeTemplateTextStyle(
        textColor: Colors.black,
        backgroundColor: Colors.white,
        style: NativeTemplateFontStyle.bold,
        size: 16.0,
      ),
      tertiaryTextStyle: NativeTemplateTextStyle(
        textColor: Colors.black,
        backgroundColor: Colors.white,
        style: NativeTemplateFontStyle.normal,
        size: 16.0,
      ),
    ),
  );
}

NativeAd createIntroNativeAd(Function() onAdLoaded) {
  return NativeAd(
    adUnitId: BuildConstants.idIntroNativeAppAd,
    factoryId: NativeFactoryId.appNativeAdFactoryMedium,
    request: const AdRequest(),
    listener: NativeAdListener(
      onAdLoaded: (Ad ad) {
        AppLog.debug('---NATIVE ADS---: $NativeAd loaded.');
        onAdLoaded();
      },
      onAdFailedToLoad: (Ad ad, LoadAdError error) {
        AppLog.debug('---NATIVE ADS---: $NativeAd failedToLoad: $error');
        ad.dispose();
      },
      onAdOpened: (Ad ad) =>
          AppLog.debug('---NATIVE ADS---: $NativeAd onAdOpened.'),
      onAdClosed: (Ad ad) =>
          AppLog.debug('---NATIVE ADS---: $NativeAd onAdClosed.'),
    ),
    nativeTemplateStyle: NativeTemplateStyle(
      // Required: Choose a template.
      templateType: TemplateType.medium,
      // Optional: Customize the ad's style.
      mainBackgroundColor: Colors.white,
      cornerRadius: 16.sp,
      callToActionTextStyle: NativeTemplateTextStyle(
        textColor: Colors.white,
        backgroundColor: const Color(0xFF7D73C3),
        style: NativeTemplateFontStyle.monospace,
        size: 16.0,
      ),
      primaryTextStyle: NativeTemplateTextStyle(
        textColor: Colors.black,
        backgroundColor: Colors.white,
        style: NativeTemplateFontStyle.italic,
        size: 16.0,
      ),
      secondaryTextStyle: NativeTemplateTextStyle(
        textColor: Colors.black,
        backgroundColor: Colors.white,
        style: NativeTemplateFontStyle.bold,
        size: 16.0,
      ),
      tertiaryTextStyle: NativeTemplateTextStyle(
        textColor: Colors.black,
        backgroundColor: Colors.white,
        style: NativeTemplateFontStyle.normal,
        size: 16.0,
      ),
    ),
  );
}

class NativeFactoryId {
  static const String appNativeAdFactorySmall = 'appNativeAdFactorySmall';
  static const String appNativeAdFactoryMedium = 'appNativeAdFactoryMedium';
}
