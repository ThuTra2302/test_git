import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:travel/app/controller/app_controller.dart';

import '../../../build_constants.dart';

class SmallNativeAdsWidgetXML extends StatefulWidget {
  const SmallNativeAdsWidgetXML({Key? key}) : super(key: key);

  @override
  State<SmallNativeAdsWidgetXML> createState() => _SmallNativeAdsWidgetState();
}

class _SmallNativeAdsWidgetState extends State<SmallNativeAdsWidgetXML> {
  final double _adAspectRatioSmall = (91 / 355);

  NativeAd? _nativeAd;
  bool _nativeAdIsLoaded = false;
  String? _versionString;

  final String _adUnitId = BuildConstants.idNativeAppAd;

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
      factoryId: 'smallAdFactory',
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
    if(Get.find<AppController>().isPremium.value){
      return const SizedBox.shrink();
    }
    if (_nativeAdIsLoaded && _nativeAd != null) {
      print('check smaill true');
      return SizedBox(
        height: MediaQuery.of(context).size.width * _adAspectRatioSmall,
        width: MediaQuery.of(context).size.width,
        child: AdWidget(ad: _nativeAd!),
      );
    } else {
      print('check smaill false');
      return const SizedBox.shrink();
    }
  }
}
