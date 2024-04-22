import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel/app/ads/interstitial_ad_manager.dart';

import '../route/app_route.dart';
import '../storage/database_service.dart';
import '../ui/screen/sub_screen.dart';
import '../util/app_util.dart';
import 'app_controller.dart';

class FavoriteController extends GetxController {
  late BuildContext context;

  RxList list = [].obs;
  late Position currentPosition;
  RxBool isLoadingList = false.obs;
  int cntAds=0;
  @override
  onReady() async {
    isLoadingList.value = true;

    list.value = await DatabaseService().getAllFavorite();
    currentPosition = await getCurrentPosition(context);

    isLoadingList.value = false;

    super.onReady();
  }

  onPressItem(int index) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int cntWeatherForTrip = prefs.getInt("cnt_press_weather_your_trip") ?? 1;

    if(cntWeatherForTrip >= 2 && !Get.find<AppController>().isPremium.value) {
      Get.to(const SubScreen());
      return;
    }

    if (Get.find<AppController>().isPremium.value) {
      Get.toNamed(
        AppRoute.mapTripScreen,
        arguments: {
          'currentPosition': currentPosition,
          'data': list[index],
        },
      );
    } else {
      showInterstitialAds(() {
        Get.toNamed(
          AppRoute.mapTripScreen,
          arguments: {
            'currentPosition': currentPosition,
            'data': list[index],
          },
        );
      });
    }
  }
}
