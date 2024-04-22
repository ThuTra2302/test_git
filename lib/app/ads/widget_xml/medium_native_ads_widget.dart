import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../build_constants.dart';

class MediumNativeAdsWidgetXML extends StatefulWidget {
  const MediumNativeAdsWidgetXML({Key? key}) : super(key: key);

  @override
  State<MediumNativeAdsWidgetXML> createState() =>
      _MediumNativeAdsWidgetState();
}

class _MediumNativeAdsWidgetState extends State<MediumNativeAdsWidgetXML> {
  final double _adAspectRatioMedium = (320 / 355);

  NativeAd? _nativeAd;
  bool _nativeAdIsLoaded = false;

  final String _adUnitId = BuildConstants.idNativeAppAd;

  @override
  void initState() {
    _loadAd();

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
            setState(() {
              _nativeAdIsLoaded = true;
            });
          },
          onAdFailedToLoad: (ad, error) {
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
        nativeAdOptions: NativeAdOptions(
          adChoicesPlacement: AdChoicesPlacement.topLeftCorner,
          mediaAspectRatio: MediaAspectRatio.any,
          videoOptions: VideoOptions(
            clickToExpandRequested: true,
            customControlsRequested: true,
            startMuted: true,
          ),
        ))
      ..load();
  }

  @override
  void dispose() {
    super.dispose();
    _nativeAd?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_nativeAdIsLoaded && _nativeAd != null) {
      return SizedBox(
        height: MediaQuery.of(context).size.width * _adAspectRatioMedium,
        width: MediaQuery.of(context).size.width,
        child: AdWidget(ad: _nativeAd!),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
