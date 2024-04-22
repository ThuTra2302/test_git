import 'dart:async';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:travel/app/ads/interstitial_open_ad_manager.dart';

import '../ads/reward_ads_manager.dart';
import '../mixins/connection_mixin.dart';
import '../route/app_route.dart';
import '../ui/screen/handle_permission_screen.dart';
import '../util/app_constant.dart';
import 'app_controller.dart';

class SplashController extends GetxController with ConnectionMixin {
  late BuildContext context;
  RxString version = ''.obs;
  bool _isFirstTimeOpenApp = true;

  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void onReady() async {
    super.onReady();
    Get.find<AppController>().initNativeAds();
    FlutterNativeSplash.remove();
    // get version app
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version.value = packageInfo.version;

    final prefs = await SharedPreferences.getInstance();
    String? language = prefs.getString('language');
    _isFirstTimeOpenApp = prefs.getBool('is_first_open_app') ?? true;
    // _isFirstTimeOpenApp =  true;

    Get.find<AppController>().updateLocale(
        AppConstant.availableLocales[int.tryParse(language ?? '') ?? 1]);
    String stringUnitTypeTemp = prefs.getString('unitTypeTemp') ?? '';
    UnitTypeTemp unitTypeTemp = Get.find<AppController>()
        .listUnitTypeTemp
        .firstWhere((element) => element.name == stringUnitTypeTemp,
            orElse: () => Get.find<AppController>().listUnitTypeTemp.first);
    Get.find<AppController>()
        .updateUnitTypeTemp(unitTypeTemp, needUpdatePrefs: false);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );

    await Get.find<AppController>().getIAPProductDetails();

    if (!Get.find<AppController>().isPremium.value) {
      loadInterstitialOpenAd();
      loadRewardAd();
    }

    _initNotificationAlarm8();
    _initNotificationAlarm12();
    _initNotificationAlarm18();

    await initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((_updateConnectionStatus));
  }

  @override
  void onClose() {
    super.onClose();
    _connectivitySubscription.cancel();
  }

  Future<void> nextScreen() async {
    if (_isFirstTimeOpenApp) {
      Get.offAndToNamed(AppRoute.loadingAdsScreen, arguments: {
        'first': _isFirstTimeOpenApp,
      });
      return;
    } else {
      LocationPermission permission = await Geolocator.checkPermission();
      if (Get.find<AppController>().isPremium.value) {
        if (permission != LocationPermission.always &&
            permission != LocationPermission.whileInUse) {
          Get.off(() => const HandlePermissionScreen());
          return;
        }
        Get.offNamed(AppRoute.mainScreen);
        return;
      } else {
        Get.toNamed(AppRoute.loadingAdsScreen, arguments: {
          'first': _isFirstTimeOpenApp,
        });
        return;
      }
    }
  }

  tz.TZDateTime _nextInstanceOfHourInDay(int day, int hour) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, day, hour);
    return scheduledDate
        .subtract(const Duration(hours: 7)); // chuyển về múi giờ Việt Nam
  }

  _initNotificationAlarm8() {
    tz.initializeTimeZones();
    for (int i = 1; i < 32; i++) {
      final random = Random();
      var content = AppConstant.listNotificationContent[
          random.nextInt(AppConstant.listNotificationContent.length)];

      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();

      flutterLocalNotificationsPlugin.zonedSchedule(
          256 + i,
          'Travel Weather',
          content,
          _nextInstanceOfHourInDay(i, 8),
          NotificationDetails(
            android: AndroidNotificationDetails(
              'travel_weather_num_$i',
              'Daily Travel Weather Notifications',
              channelDescription: 'Daily Travel Weather Notifications Des',
              icon: 'noti_default_mini',
            ),
          ),
          androidAllowWhileIdle: true,
          matchDateTimeComponents: DateTimeComponents.dayOfMonthAndTime,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime);
    }
  }

  _initNotificationAlarm12() {
    tz.initializeTimeZones();
    for (int i = 1; i < 32; i++) {
      final random = Random();
      var content = AppConstant.listNotificationContent[
          random.nextInt(AppConstant.listNotificationContent.length)];
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();
      flutterLocalNotificationsPlugin.zonedSchedule(
          356 + i,
          'Travel Weather',
          content,
          _nextInstanceOfHourInDay(i, 12),
          NotificationDetails(
            android: AndroidNotificationDetails(
              'travel_weather_num_$i',
              'Daily Travel Weather Notifications',
              channelDescription: 'Daily Travel Weather Notifications Des',
              icon: 'noti_default_mini',
            ),
          ),
          androidAllowWhileIdle: true,
          matchDateTimeComponents: DateTimeComponents.dayOfMonthAndTime,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime);
    }
  }

  _initNotificationAlarm18() {
    tz.initializeTimeZones();
    for (int i = 1; i < 32; i++) {
      final random = Random();
      var content = AppConstant.listNotificationContent[
          random.nextInt(AppConstant.listNotificationContent.length)];
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();
      flutterLocalNotificationsPlugin.zonedSchedule(
          456 + i,
          'Travel Weather',
          content,
          _nextInstanceOfHourInDay(i, 18),
          NotificationDetails(
            android: AndroidNotificationDetails(
              'travel_weather_num_$i',
              'Daily Travel Weather Notifications',
              channelDescription: 'Daily Travel Weather Notifications Des',
              icon: 'noti_default_mini',
            ),
          ),
          androidAllowWhileIdle: true,
          matchDateTimeComponents: DateTimeComponents.dayOfMonthAndTime,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime);
    }
  }

// Connection
  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
      debugPrint('Connectivity status: $result');
    } on PlatformException catch (e) {
      debugPrint('Could n\'t check connectivity status: $e');
      showConnectError(
        context: context,
        exception: e,
      );
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    debugPrint("Connection status: $result");

    if (result == ConnectivityResult.none) {
      showNotConnectDialog(context);
    }

    if (result == ConnectivityResult.wifi ||
        result == ConnectivityResult.mobile) {
      await nextScreen();
    }
  }
}
