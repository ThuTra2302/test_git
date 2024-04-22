import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:travel/app/controller/main_controller.dart';
import 'package:travel/app/ui/theme/app_color.dart';
import 'package:travel/app/util/app_log.dart';

import '../extension/int_temp.dart';
import '../res/image/app_image.dart';
import '../res/string/app_strings.dart';
import '../ui/screen/sub_screen.dart';
import '../util/app_constant.dart';
import 'app_controller.dart';

class WeatherDetailController extends GetxController {
  late BuildContext context;
  RxMap data = RxMap();
  String? assetHeader;
  String d = '';

  RxInt currentTemp = 0.obs;
  RxInt feelLikeTemp = 0.obs;

  late RxBool chooseC;



  String title = StringConstants.weatherForYourTrip.tr;
  String imageUrl = '';
  String imageAsset = '';
  String background = AppImage.imgDem;
  Color backColor = AppColor.white;

  num windSpeed = 0.0;
  num windGust = 0.0;
  num humidity = 0.0;
  num dewPoint = 0;
  num skyCover = 0;
  num visibility = 0;
  num precipitation = 0.0;
  num barometer = 0.0;

  List<String> listWeatherType = [
    "snow",
    "sleet",
    "rain",
    "partly-cloudy-night",
    "partly-cloudy-day",
    "hail",
    "fog",
    "cloudy",
    "clear-night",
    "clear-day",
    'thunder-showers-day',
    'thunder-rain',
    'showers-day',
    'showers-night'
  ];

  @override
  void onInit() {
    data.value = Get.arguments['data'] ?? {};
    assetHeader = Get.arguments['assetHeader'];
    title = Get.arguments['title'] ?? StringConstants.weatherForYourTrip.tr;
    imageUrl = Get.arguments['imageUrl'] ?? '';
    imageAsset = Get.arguments['imageAsset'] ?? '';
    chooseC=Get.find<MainController>().chooseC;
    int a = data['weather']?.windBearing ?? 0;
    if (a <= 22 || a >= 338) {
      d = 'N';
    } else if (a >= 23 && a <= 67) {
      d = 'NE';
    } else if (a >= 68 && a <= 111) {
      d = 'E';
    } else if (a >= 112 && a <= 157) {
      d = 'SE';
    } else if (a >= 158 && a <= 202) {
      d = 'S';
    } else if (a >= 203 && a <= 247) {
      d = 'SW';
    } else if (a >= 248 && a <= 292) {
      d = 'W';
    } else if (a >= 293 && a <= 337) {
      d = 'NW';
    }
    print(data['weather']);
    currentTemp.value = (data['weather']?.temperature.round() as int)
        .toUnit(Get.find<AppController>().currentUnitTypeTemp.value);

    feelLikeTemp.value = (data['weather']?.apparentTemperature.round() as int)
        .toUnit(Get.find<AppController>().currentUnitTypeTemp.value);


    windSpeed = data['weather']?.windSpeed ?? 0;
    windGust = data['weather']?.windGust ?? 0;

    if (data['weather']?.humidity == null) {
      humidity = 0.0;
    } else {
      humidity = data['weather']?.humidity > 1
          ? data['weather']?.humidity
          : data['weather']?.humidity * 100;
    }

    dewPoint = data['weather']?.dewPoint ?? 0;

    if (data['weather']?.skyCover == null) {
      skyCover = 0;
    } else {
      skyCover = data['weather']!.skyCover > 1
          ? data['weather']!.skyCover
          : data['weather']!.skyCover * 100;
    }

    if (data['weather']?.visibility == null) {
      visibility = 0;
    } else {
      visibility = data['weather']?.humidity > 1
          ? data['weather']?.visibility / 1000
          : data['weather']?.visibility;
    }

    precipitation = data['weather']?.precipdynamicensity ?? 0;
    barometer = data['weather']?.pressure ?? 0;

    AppLog.verbose(data);
    AppLog.verbose(data['weather'].toJson());

    if (data['type'] == "Meteo") {
      if (data['weather']?.summary == "Clear sky" ||
          data['weather']?.summary == "Mainly clear") {
        background = AppImage.imgNgayNang;
        backColor = AppColor.black;
      } else if (data['weather']?.summary == 'Freezing Rain light' ||
          data['weather']?.summary == 'Freezing Rain: heavy intensity') {
        background = AppImage.imgNgayBangGia;
        backColor = AppColor.black;
      } else if (data['weather']?.summary == 'Snow fall slight' ||
          data['weather']?.summary == 'Snow fall moderate') {
        background = AppImage.imgNgayTuyetRoi;
        backColor = AppColor.black;
      } else {
        background = AppImage.imgDem;
        backColor = AppColor.white;
      }
    } else {
      if (data['weather']?.icon == 'partly-cloudy-night' ||
          data['weather']?.icon == "cloudy" ||
          data['weather']?.icon == "clear-night") {
        background = AppImage.imgDem;
      } else if (data['weather']?.icon == 'showers-day' ||
          data['weather']?.icon == 'thunder-showers-day') {
        background = AppImage.imgNgayMua;
      } else if (data['weather']?.icon == 'showers-night') {
        background = AppImage.imgDemMua;
      } else if (data['weather']?.icon == 'clear-day') {
        background = AppImage.imgNgayNang;
      } else if (data['weather']?.icon == 'snow') {
        background = AppImage.imgNgayTuyetRoi;
      }
    }

    debugPrint("weather detail controller::background: $background");
    debugPrint("weather detail controller::icon: ${data['weather']?.icon}");
    debugPrint("weather detail controller::date: ${data.value.toString()}");

    super.onInit();
  }

  _getAddress() async {
    LatLng latLng = data['latLng'];
    GeocodingResponse geocodingResponse =
        await GoogleMapsGeocoding(apiKey: AppConstant.keyGoogleMap)
            .searchByLocation(
                Location(lat: latLng.latitude, lng: latLng.longitude));
    if (geocodingResponse.results.isNotEmpty) {
      data['address'] = geocodingResponse.results.first.formattedAddress;
    }
    data.refresh();
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    feelLikeTemp.value = (data['weather']?.apparentTemperature.round() as int)
        .toUnit(Get.find<AppController>().currentUnitTypeTemp.value);
    _getAddress();
  }

  onPressVip() {
    Get.to(() => const SubScreen());
  }

  onChangeUnitTemp() {
    final AppController appController = Get.find<AppController>();

    if (appController.currentUnitTypeTemp.value == UnitTypeTemp.c) {
      appController.updateUnitTypeTemp(UnitTypeTemp.k);
    } else if (appController.currentUnitTypeTemp.value == UnitTypeTemp.k) {
      appController.updateUnitTypeTemp(UnitTypeTemp.f);
    } else {
      appController.updateUnitTypeTemp(UnitTypeTemp.c);
    }

  }
}
