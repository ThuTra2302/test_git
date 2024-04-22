import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel/app/ads/interstitial_open_ad_manager.dart';
import 'package:travel/app/ads/resume_ad_manager.dart';

import '../ads/native_ad_manager.dart';
import '../ui/widget/rate/rating_widget.dart';
import '../util/app_constant.dart';
import '../util/app_log.dart';
import '../util/app_util.dart';
import 'app_flyer_controller.dart';

onSelectNotification(s1) async {}

enum UnitTypeTemp { c, f, k }

class AppController extends SuperController {
  Locale currentLocale = AppConstant.availableLocales[1];
  List<UnitTypeTemp> listUnitTypeTemp = [
    UnitTypeTemp.c,
    UnitTypeTemp.k,
    UnitTypeTemp.f,
  ];
  Rx<UnitTypeTemp> currentUnitTypeTemp = UnitTypeTemp.c.obs;

  bool avoidShowOpenApp = false;
  bool isFirstRate = false;
  int countRate = 0;
  RxBool isPremium = true.obs;
  RxString currentLanguageCode = ''.obs;

  RxString country = "".obs;
  List<String> listCountry = ['United States', 'Australia', 'Canada'];

  StreamSubscription<dynamic>? _subscriptionIAP;
  RxList<ProductDetails> listProductDetailsSub = RxList();
  final List<ProductDetails> _listProductDetails = [];
  Rx<PurchaseStatus> rxPurchaseStatus = PurchaseStatus.canceled.obs;

  Position? currentPosition;

  // late
  late ResumeAdManager resumeAdManager;

  RxMap nativeAdsMapPermission = RxMap();
  RxMap nativeAdsMapIntro = RxMap();

  @override
  void onInit() {
    // initVideo();
    // _initNativeAds();
    AddInterstitialOpenAdManager.loadInterstitialOpenAd();
    super.onInit();
  }

  initNativeAds() {
    if (Get.find<AppController>().isPremium.value) return;

    NativeAd? nativeAd;

    nativeAd = createMediumNativeAd(() {
      nativeAdsMapPermission.value = {
        'ad': nativeAd,
        'widget': Container(
          width: Get.width,
          constraints: BoxConstraints(
            minHeight: 340.sp,
            maxHeight: 420.sp,
          ),
          child: AdWidget(
            ad: nativeAd!,
          ),
        ),
      };
    });

    nativeAd.load();

    NativeAd? nativeAd1;

    nativeAd1 = createIntroNativeAd(() {
      nativeAdsMapIntro.value = {
        'ad': nativeAd1,
        'widget': Container(
          width: Get.width,
          height: Get.height / 2.2,
          child: AdWidget(
            ad: nativeAd1!,
          ),
        ),
      };
    });

    nativeAd1.load();
  }

  @override
  void onReady() async {
    super.onReady();

    _onInitIAPListener();

    // if (Platform.isIOS) {
    //   int? firstTimeOpenApp = _localRepository.getFirstTimeOpenApp();
    //   if (isNullEmptyFalseOrZero(firstTimeOpenApp)) {
    //     _localRepository.setFirstTimeOpenApp(DateTime.now().millisecondsSinceEpoch);
    //   } else {
    //     var now = DateTime.now().millisecondsSinceEpoch;
    //     if (now - firstTimeOpenApp! > 86400000) {
    //       appresumeAdManager = AppresumeAdManager()..loadAd();
    //     }
    //   }
    // } else {
    //   appresumeAdManager = AppresumeAdManager()..loadAd();
    // }

    currentLanguageCode.value =
        currentLocale.toLanguageTag() == 'vi-VN' ? 'Viet' : 'Eng';

    resumeAdManager = ResumeAdManager()..loadAd();
    AppStateEventNotifier.startListening();
    AppStateEventNotifier.appStateStream.forEach((state) {
      if (state == AppState.foreground) {
        if (!isPremium.value &&
            !avoidShowOpenApp &&
            !isNullEmpty(resumeAdManager)) {
          resumeAdManager.showAdIfAvailable();
        }
      }
    });

    _initNotificationSelectHandle();
  }

  @override
  void onDetached() {}

  @override
  void onInactive() {}

  @override
  void onPaused() {}

  @override
  void onResumed() {
    if (Platform.isAndroid) {
      InAppPurchase.instance.restorePurchases();
    }
  }

  @override
  void onClose() {
    super.onClose();
    _subscriptionIAP?.cancel();
  }

  updateLocale(Locale locale) {
    Get.updateLocale(locale);
    currentLocale = locale;
  }

  updateUnitTypeTemp(UnitTypeTemp unitTypeTemp,
      {bool needUpdatePrefs = true}) async {
    currentUnitTypeTemp.value = unitTypeTemp;
    if (needUpdatePrefs) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('unitTypeTemp', currentUnitTypeTemp.value.name);
    }
  }

  Future<void> openRatingApp(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return const RatingWidget();
      },
    );
  }

  bool isNullEmpty(Object? o) => o == null || "" == o || o == "null";

  bool isNullEmptyFalseOrZero(Object? o) =>
      o == null || false == o || 0 == o || "" == o || "0" == o;

  /// Init Notification
  _initNotificationSelectHandle() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('noti_default_mini');
    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveBackgroundNotificationResponse: onSelectNotification);
  }

  onDidReceiveLocalNotification(i1, s1, s2, s3) {}

  // In app purchase
  Future<void> restorePurchases() async {
    await InAppPurchase.instance.restorePurchases();
  }

  Future<void> onPressPremiumByProduct(String productId) async {
    ProductDetails? productDetails = _listProductDetails
        .firstWhereOrNull((element) => element.id == productId);
    productDetails ??= listProductDetailsSub.value
        .firstWhereOrNull((element) => element.id == productId);
    if (productDetails == null || productDetails.id.isEmpty) {
      showToast('Not available');
    } else {
      log('---IAP---: response.productDetails ${productDetails.title}');
      final PurchaseParam purchaseParam =
          PurchaseParam(productDetails: productDetails);
      InAppPurchase.instance.buyNonConsumable(purchaseParam: purchaseParam);
    }
  }

  void appsFlyerPurchaseEvent(ProductDetails productDetails) {
    Map<String, String> eventValue = <String, String>{};
    eventValue["af_revenue"] = productDetails.price;
    eventValue["af_content_id"] = productDetails.id;
    eventValue["af_currency"] = productDetails.currencyCode;
    Get.find<AppFlyerController>().logAfPurchase(eventValue);
  }

  _onInitIAPListener() {
    final Stream purchaseUpdated = InAppPurchase.instance.purchaseStream;

    _subscriptionIAP = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      log('---IAP--- done IAP stream');
      _subscriptionIAP?.cancel();
    }, onError: (error) {
      log('---IAP--- error IAP stream: $error');
    });
  }

  _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      log('---IAP---: purchaseDetails.productID: ${purchaseDetails.productID}');
      log('---IAP---: purchaseDetails.status: ${purchaseDetails.status}');

      ProductDetails? productDetails = _listProductDetails.firstWhereOrNull(
          (element) => element.id == purchaseDetails.productID);
      productDetails ??= listProductDetailsSub.firstWhereOrNull(
          (element) => element.id == purchaseDetails.productID);

      if (purchaseDetails.status == PurchaseStatus.pending) {
        isPremium.value = false;
        rxPurchaseStatus.value = purchaseDetails.status;
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          // isPremium.value = false;
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          if (purchaseDetails.status == PurchaseStatus.purchased) {
            appsFlyerPurchaseEvent(productDetails!);
          }
          rxPurchaseStatus.value = purchaseDetails.status;
          isPremium.value = true;
          switch (purchaseDetails.productID) {
            case 'com.roadtrippers.weather.activity.notes.year':
              isPremium.value = true;
              break;

            case 'com.roadtrippers.weather.activity.notes.month':
              isPremium.value = true;
              break;

            case 'com.roadtrippers.weather.activity.notes.week':
              isPremium.value = true;
              break;
          }
        }

        if (purchaseDetails.pendingCompletePurchase) {
          await InAppPurchase.instance.completePurchase(purchaseDetails);
        }
      }
    });
  }

  getIAPProductDetails() async {
    final bool available = await InAppPurchase.instance.isAvailable();
    if (!available) {
      showToast('Can not connect store');
    } else {
      const Set<String> kIds = <String>{
        'com.roadtrippers.weather.activity.week',
        'com.roadtrippers.weather.activity.month',
        'com.roadtrippers.weather.activity.year',
      };

      final ProductDetailsResponse response =
          await InAppPurchase.instance.queryProductDetails(kIds);
      listProductDetailsSub.value = response.productDetails;
      log('///////////// _listProductDetails: ${response.productDetails} ${response.productDetails.isNotEmpty ? response.productDetails.first.id : ''}');
    }

    if (Platform.isAndroid) {
      InAppPurchase.instance.restorePurchases();
    }
  }

  void getPlace() async {
    try {
      currentPosition = await Geolocator.getCurrentPosition();

      List<Placemark> listAddress = await placemarkFromCoordinates(
        currentPosition!.latitude,
        currentPosition!.longitude,
      );

      Placemark placeMark = listAddress[0];

      String? country = placeMark.country;

      this.country.value = country ?? "United States";
    } catch (e) {
      AppLog.error("Exception: $e");
      country.value = "United States";
    }
  }

  // void initVideo() {
  //   videoPlayerController = VideoPlayerController.asset(AppVideo.snow1)
  //     ..initialize().then((value) {
  //       videoPlayerController.setLooping(true);
  //       videoPlayerController.play();
  //
  //       chewieController = ChewieController(
  //         videoPlayerController: videoPlayerController,
  //         aspectRatio: videoPlayerController.value.aspectRatio,
  //         autoPlay: true,
  //         looping: true,
  //         showControls: false,
  //         showOptions: false,
  //         autoInitialize: true,
  //         showControlsOnInitialize: false,
  //       );
  //     });
  // }
}
