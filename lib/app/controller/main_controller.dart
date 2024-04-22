import 'dart:convert';
import 'dart:ui' as ui;

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel/app/extension/int_temp.dart';

import '../ads/interstitial_ad_manager.dart';
import '../data/model/weather_response.dart';
import '../route/app_route.dart';
import '../ui/screen/sub_screen.dart';
import '../util/app_constant.dart';
import '../util/app_log.dart';
import '../util/app_util.dart';
import 'app_controller.dart';

class MainController extends GetxController {
  late BuildContext context;
  RxBool isLoadingCurrentLocation01 = false.obs;
  RxBool isLoadingCurrentLocation02 = false.obs;
  RxBool isLoadingCurrentLocation03 = false.obs;
  RxBool isLoadingWeather = true.obs;
  RxBool showWarn = false.obs;
  Position? _currentPosition;
  Hourly? dataWeather;
  String? dataLocation;

  RxInt feelLikeTemp = 0.obs;

  RxInt cntWeatherForTrip = (-1).obs;

  RxBool chooseC = true.obs;

  Map<String, BitmapDescriptor> mapBitmapDescriptorMarker = {};

  final AppController appController = Get.find<AppController>();

  RxInt valueInC = 0.obs;
  RxBool sendApi = false.obs;

  @override
  void onReady() async {
    super.onReady();

    if (!Get.find<AppController>().isPremium.value) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SubScreen()),
      );
    }

    _initMapBitmapDescriptorMarker();
    await initWeather();

    Get.find<AppController>().getPlace();
    if (appController.currentPosition != null) {
      _currentPosition = appController.currentPosition;
    } else {
      _currentPosition = await getCurrentPosition(context);
    }

    Future.delayed(
      Duration.zero,
      () async {
        sendApi.value = true;

        // const String messenger1 =
        //     "Play as a tour guide to answer the questions. If the content of the conversation is not related to travel, location, vacation, road trip, or thing to do and eat during travel, refuse to answer. Note reply in user language.";
        // const String messenger2 =
        //     "Certainly, I'll do my best to answer questions related to travel, location, vacation, road trip, or thing to do and eat during travel. Please feel free to ask any questions you have in those domains, and I'll provide you with accurate information. If a question is unrelated to these topics, I'll let you know that I cannot provide an answer.";
        // String messenger3 = "This is my current location New york.";
        //
        // List listMessageSendApi = <MessengerModel>[];
        //
        // listMessageSendApi.add(MessengerModel(
        //   content: messenger1,
        //   isSender: true,
        // ));
        //
        // listMessageSendApi.add(MessengerModel(
        //   content: messenger2,
        //   isSender: false,
        // ));
        //
        // listMessageSendApi.add(MessengerModel(
        //   content: messenger3,
        //   isSender: true,
        // ));
        //
        // List<Map<String, String>> listPrompt = [];
        // for (int i = 0; i < listMessageSendApi.length; i++) {
        //   MessengerModel messengerModel = listMessageSendApi[i];
        //
        //   listPrompt.add({
        //     "role": messengerModel.isSender ? "user" : "assistant",
        //     "content": messengerModel.content,
        //   });
        // }
        //
        // AppLog.debug(listPrompt);
        //
        // String data = jsonEncode({"prompt": listPrompt, "level": 3});
        //
        // await ApiService.sendMessenger(data);

        sendApi.value = false;
      },
    );

    final
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cntWeatherForTrip.value = prefs.getInt("cnt_press_weather_your_trip") ?? 1;

    valueInC.value = (dataWeather?.temperature ?? 0).round();
    feelLikeTemp.value =
        ((dataWeather?.apparentTemperature ?? 0).round() as int)
            .toUnit(Get.find<AppController>().currentUnitTypeTemp.value);
  }

  onPressWeatherForYourTrip() async {
    AppLog.info("cnt press weather your trip: ${cntWeatherForTrip.value}");

    if (isLoadingWeather.value) {
      showToast("Please wait a moment");
      return;
    }
    // Get.toNamed(
    //   AppRoute.mapTripScreen,
    //   arguments: {'currentPosition': _currentPosition, 'data': null},
    // );
    if (cntWeatherForTrip > 2 && !Get.find<AppController>().isPremium.value) {
      Get.to(() => const SubScreen());
      return;
    }

    if (cntWeatherForTrip.value <= 2) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt("cnt_press_weather_your_trip", ++cntWeatherForTrip.value);
    }

    FirebaseAnalytics.instance.logEvent(name: 'home_trip');

    if (isLoadingCurrentLocation01.value ||
        isLoadingCurrentLocation02.value ||
        isLoadingCurrentLocation03.value) {
      return;
    }

    try {
      isLoadingCurrentLocation01.value = true;
      _currentPosition ??= await getCurrentPosition(context);
      isLoadingCurrentLocation01.value = false;

      if (appController.isPremium.value) {
        Get.toNamed(
          AppRoute.mapTripScreen,
          arguments: {'currentPosition': _currentPosition, 'data': null},
        );
      } else {
        showInterstitialAds(() {
          Get.toNamed(
            AppRoute.mapTripScreen,
            arguments: {'currentPosition': _currentPosition, 'data': null},
          );
        });
      }
    } catch (e) {
      isLoadingCurrentLocation01.value = false;
      log('${(e as Map)['message']}');
    }
  }

  onPressWeatherForPlace() async {
    if (isLoadingWeather.value) {
      showToast("Please wait a moment");
      return;
    }

    FirebaseAnalytics.instance.logEvent(name: 'home_place');

    if (isLoadingCurrentLocation01.value ||
        isLoadingCurrentLocation02.value ||
        isLoadingCurrentLocation03.value) {
      return;
    }

    try {
      isLoadingCurrentLocation02.value = true;
      _currentPosition ??= await getCurrentPosition(context);
      isLoadingCurrentLocation02.value = false;

      if (appController.isPremium.value) {
        Get.toNamed(AppRoute.mapLocationScreen, arguments: {
          'currentPosition': _currentPosition,
        });
      } else {
        showInterstitialAds(
          () => Get.toNamed(
            AppRoute.mapLocationScreen,
            arguments: {
              'currentPosition': _currentPosition,
            },
          ),
        );
      }
    } catch (e) {
      isLoadingCurrentLocation02.value = false;
      log('${(e as Map)['message']}');
    }
  }

  onPressWeatherForFamousPlace() async {
    if (isLoadingWeather.value) {
      showToast("Please wait a moment");
      return;
    }

    FirebaseAnalytics.instance.logEvent(name: 'home_famous');

    if (isLoadingCurrentLocation01.value ||
        isLoadingCurrentLocation02.value ||
        isLoadingCurrentLocation03.value) {
      return;
    }

    try {
      isLoadingCurrentLocation03.value = true;
      _currentPosition ??= await getCurrentPosition(context);
      isLoadingCurrentLocation03.value = false;

      if (appController.isPremium.value) {
        Get.toNamed(AppRoute.mapFamousScreen,
            arguments: {'currentPosition': _currentPosition});
      } else {
        showInterstitialAds(() => Get.toNamed(AppRoute.mapFamousScreen,
            arguments: {'currentPosition': _currentPosition}));
      }
    } catch (e) {
      isLoadingCurrentLocation03.value = false;
      log('${(e as Map)['message']}');
    }
  }

  onPressPlanedTrip() {
    if (isLoadingWeather.value) {
      showToast("Please wait a moment");
      return;
    }

    FirebaseAnalytics.instance.logEvent(name: 'home_planed_trip');

    Get.toNamed(AppRoute.planedTripScreen);
  }

  onPressUnitTemp(UnitTypeTemp unitTypeTemp) async {
    final AppController appController = Get.find<AppController>();

    appController.currentUnitTypeTemp.value = unitTypeTemp;
  }

  initWeather() async {
    isLoadingWeather.value = true;

    _currentPosition ??= await getCurrentPosition(context);

    try {
      if (_currentPosition != null) {
        GeocodingResponse geocodingResponse =
            await GoogleMapsGeocoding(apiKey: AppConstant.keyGoogleMap)
                .searchByLocation(
          Location(
            lat: _currentPosition!.latitude,
            lng: _currentPosition!.longitude,
          ),
        );

        WeatherResponse? weatherResponse = await getDataWeather([
          {
            'latLng': LatLng(
              _currentPosition!.latitude,
              _currentPosition!.longitude,
            )
          }
        ]);

        if (geocodingResponse.results.isNotEmpty) {
          dataLocation = geocodingResponse.results.first.formattedAddress;
        }

        if ((weatherResponse?.body.data ?? []).isNotEmpty &&
            (weatherResponse?.body.data.first.hourly ?? []).isNotEmpty) {
          dataWeather = weatherResponse!.body.data.first.hourly.first;
        }
        showWarn.value = false;
      } else {
        showWarn.value = true;
      }
    } catch (e) {
      debugPrint("$e");
      showWarn.value = true;
    }

    isLoadingWeather.value = false;
  }

  onPressSetting() {
    if (appController.isPremium.value) {
      Get.toNamed(AppRoute.settingScreen);
    } else {
      showInterstitialAds(() => Get.toNamed(AppRoute.settingScreen));
    }
  }

  // Khởi tạo ảnh dùng cho marker của map
  _initMapBitmapDescriptorMarker() async {
    final manifestJson =
        await DefaultAssetBundle.of(context).loadString('AssetManifest.json');
    final images = json
        .decode(manifestJson)
        .keys
        .where((String key) => key.startsWith('lib/app/res/image/marker/'))
        .toList();
    for (String itemImage in images) {
      final Uint8List markerIcon = await _getBytesFromAsset(
          itemImage, (40 * ui.window.devicePixelRatio).toInt());
      BitmapDescriptor bitmapDescriptor =
          BitmapDescriptor.fromBytes(markerIcon);
      mapBitmapDescriptorMarker[itemImage.split('/').last.split('.').first] =
          bitmapDescriptor;
    }
  }

  Future<Uint8List> _getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  void onPressChat() {
    FirebaseAnalytics.instance.logEvent(name: 'AI_ClickStart');

    if (appController.isPremium.value) {
      Get.toNamed(AppRoute.chatScreen);
    } else {
      showInterstitialAds(() => Get.toNamed(AppRoute.chatScreen));
    }
  }
}
