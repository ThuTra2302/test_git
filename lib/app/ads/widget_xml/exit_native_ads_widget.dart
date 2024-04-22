import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../build_constants.dart';
import '../../controller/app_controller.dart';

class ExitNativeAdsWidgetXML extends StatefulWidget {
  const ExitNativeAdsWidgetXML({Key? key}) : super(key: key);

  @override
  State<ExitNativeAdsWidgetXML> createState() => _MediumNativeAdsWidgetState();
}

class _MediumNativeAdsWidgetState extends State<ExitNativeAdsWidgetXML> {
  final double _adAspectRatioMedium = (340 / 355);

  NativeAd? _nativeAd;
  bool _nativeAdIsLoaded = false;
  String? _versionString;

  final String _adUnitId = BuildConstants.idExitNativeAppAd;

  @override
  void initState() {
    _loadAd();
    _loadVersionString();

    super.initState();
  }

  void _loadAd() {
    setState(() {
      _nativeAdIsLoaded = false;
    });

    _nativeAd = NativeAd(
      adUnitId: _adUnitId,
      factoryId: 'mediumAdFactory',
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          // ignore: avoid_print
          print('$NativeAd loaded.');
          setState(() {
            _nativeAdIsLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          // ignore: avoid_print
          print('$NativeAd failedToLoad: $error');
          ad.dispose();
        },
        onAdClicked: (ad) {},
        onAdImpression: (ad) {},
        onAdClosed: (ad) {},
        onAdOpened: (ad) {},
        onAdWillDismissScreen: (ad) {},
        onPaidEvent: (ad, valueMicros, precision, currencyCode) {},
      ),
      request: const AdRequest(),
    )..load();
  }

  void _loadVersionString() {
    MobileAds.instance.getVersionString().then((value) {
      setState(() {
        _versionString = value;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _nativeAd?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (Get.find<AppController>().isPremium.value) {
      return const SizedBox.shrink();
    }
    if (_nativeAdIsLoaded && _nativeAd != null) {
      print('check true');
      return SizedBox(
        height: MediaQuery.of(context).size.width * _adAspectRatioMedium,
        width: MediaQuery.of(context).size.width,
        child: AdWidget(ad: _nativeAd!),
      );
    } else {
      print('check false');
      // _loadAd();
      return const SizedBox.shrink();
    }
  }
}
