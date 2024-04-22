import 'dart:io' as io;

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'app/ads/banner_ad_manager.dart';
import 'app/binding/app_binding.dart';
import 'app/common/remote_config.dart';
import 'app/res/string/app_strings.dart';
import 'app/route/app_page.dart';
import 'app/route/app_route.dart';
import 'app/ui/theme/app_color.dart';
import 'app/util/app_constant.dart';
import 'app/util/app_util.dart';

late AndroidNotificationChannel channel;
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

io.SecurityContext appSecurityContext =
    io.SecurityContext(withTrustedRoots: true);

void mainDelegate() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // avoid crash when pop screen with maps
    final GoogleMapsFlutterPlatform mapsImplementation =
        GoogleMapsFlutterPlatform.instance;
    if (mapsImplementation is GoogleMapsFlutterAndroid) {
      mapsImplementation.useAndroidViewSurface = false;
    }
  } catch (e) {
    log(e.toString());
  }

  await Firebase.initializeApp();
  await RemoteConfig.init();
  await BannerAdManager.init();

  ByteData clientCertificate =
      await rootBundle.load("lib/app/res/raw/cert.pfx");
  var dataByte = clientCertificate.buffer.asUint8List();
  String password = await rootBundle.loadString("lib/app/res/raw/pwd.txt");

  appSecurityContext.usePrivateKeyBytes(
    dataByte,
    password: password,
  );
  appSecurityContext.useCertificateChainBytes(
    dataByte,
    password: password,
  );

  MobileAds.instance.initialize();
  MobileAds.instance.updateRequestConfiguration(
    RequestConfiguration(
      testDeviceIds: [
        '74D6469B3712F261997506C48A969B99',
        '9249D30A745C469EA2B4E1709CBB0707',
      ],
    ),
  );

  // notification start
  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    importance: Importance.high,
  );
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// Get data from notification click (app terminated)
  final NotificationAppLaunchDetails? notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  String? payload = notificationAppLaunchDetails?.notificationResponse?.payload;
  if (payload != null) {
    // SessionData.isOpenFromNotification = true;
  }
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  // notification end

  runApp(
    ScreenUtilInit(
      designSize: const Size(428, 939),
      builder: (context, widget) => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        initialBinding: AppBinding(),
        initialRoute: AppRoute.splashScreen,
        defaultTransition: Transition.fade,
        getPages: AppPage.pages,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        translations: AppStrings(),
        supportedLocales: AppConstant.availableLocales,
        locale: AppConstant.availableLocales[0],
        fallbackLocale: AppConstant.availableLocales[0],
        theme: ThemeData(
          primaryColor: AppColor.primaryColor,
          fontFamily: 'BeVietnamPro',
          textSelectionTheme: const TextSelectionThemeData(
            selectionHandleColor: Colors.transparent,
          ),
        ),
      ),
    ),
  );
}
