import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../build_constants.dart';
import '../common/logger/src/logger.dart';
import '../common/logger/src/printers/pretty_printer.dart';
import '../controller/app_controller.dart';
import '../data/model/weather_meteo_response.dart';
import '../data/model/weather_response.dart';
import '../res/string/app_strings.dart';
import '../ui/theme/app_color.dart';
import '../ui/widget/app_touchable.dart';
import 'app_constant.dart';

log(String text, {Level level = Level.info}) {
  if (BuildConstants.currentEnvironment != Environment.prod) {
    Logger(printer: PrettyPrinter(colors: !Platform.isIOS)).log(level, text);
  }
}

String chooseContentByLanguage(String enContent, String viContent) {
  if (Get.find<AppController>().currentLocale.toLanguageTag() == 'vi-VN' && viContent.isNotEmpty) {
    return viContent;
  }
  return enContent.isNotEmpty ? enContent : viContent;
}

String capitalizeOnlyFirstLater(String originalText) {
  if (originalText.trim().isEmpty) return "";
  return "${originalText[0].toUpperCase()}${originalText.substring(1)}";
}

showToast(String text) {
  Fluttertoast.showToast(
    msg: text,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 3,
    backgroundColor: AppColor.black.withOpacity(0.9),
    textColor: AppColor.white,
    fontSize: 18.0.sp,
  );
}

hideKeyboard() {
  FocusManager.instance.primaryFocus?.unfocus();
}

Future<Position> getCurrentPosition(BuildContext context) async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    showErrorDialog(context, StringConstants.errorLocation01.tr);
    return Future.error({'code': 1, 'message': StringConstants.errorLocation00.tr});
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      showErrorDialog(context, StringConstants.errorLocation02.tr);
      return Future.error({'code': 2, 'message': StringConstants.errorLocation02.tr});
    }
  }

  if (permission == LocationPermission.deniedForever) {
    showErrorDialog(context, StringConstants.errorLocation04.tr);
    return Future.error({'code': 2, 'message': StringConstants.errorLocation04.tr});
  }
  return await Geolocator.getCurrentPosition();
}

showErrorDialog(BuildContext context, String message, {Function()? onDismiss}) async {
  await showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(StringConstants.notice.tr),
            content: Text(message),
            actions: [
              AppTouchable(
                width: 80.0.sp,
                height: 40.0.sp,
                onPressed: () {
                  Get.back();
                },
                child: Text(
                  StringConstants.close.tr,
                  style: TextStyle(
                    color: AppColor.black.withOpacity(0.6),
                    fontSize: 16.0.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ));
  if (onDismiss != null) onDismiss();
}

LatLngBounds boundsFromLatLngList(List<LatLng> list) {
  assert(list.isNotEmpty);
  double? x0, x1, y0, y1;
  for (LatLng latLng in list) {
    if (x0 == null) {
      x0 = x1 = latLng.latitude;
      y0 = y1 = latLng.longitude;
    } else {
      if (latLng.latitude > x1!) x1 = latLng.latitude;
      if (latLng.latitude < x0) x0 = latLng.latitude;
      if (latLng.longitude > y1!) y1 = latLng.longitude;
      if (latLng.longitude < y0!) y0 = latLng.longitude;
    }
  }
  return LatLngBounds(northeast: LatLng(x1!, y1!), southwest: LatLng(x0!, y0!));
}

Future<WeatherResponse?> getDataWeather(List<Map> listLatLngNode) async {
  try {
    var dio = Dio();
    String param = '';
    for (final data in listLatLngNode) {
      param += 'point=${data['latLng'].latitude},${data['latLng'].longitude}&';
    }
    var response = await dio.get(
      'https://api.weatherroute.io/v1/weather/forecast-matrix?units=metric&$param',
      options: Options(
        headers: {'x-api-key': AppConstant.keyWeather},
      ),
    );
    WeatherResponse weatherResponse = WeatherResponse.fromJson(response.data);
    return weatherResponse;
  } catch (e) {
    return null;
  }
}

Future<MeteoWeatherResponse?> getDataMeteoWeather(LatLng latLng) async {
  String param = '';
  String hourlyString = "";
  String dailyString = "";

  try {
    var dio = Dio();

    List<String> hourly = [
      'weathercode',
      'temperature_2m',
      'relativehumidity_2m',
      'dewpoint_2m',
      'apparent_temperature',
      'winddirection_10m',
      'cloudcover_low',
      'precipitation',
      'surface_pressure',
      'visibility',
      'windspeed_10m',
      'windgusts_10m'
    ];

    List<String> daily = [
      'weathercode',
      'sunrise',
      'sunset'
    ];

    for (String item in hourly) {
      hourlyString += "$item,";
    }
    hourlyString = hourlyString.substring(0, hourlyString.length - 1);

    for(String item in daily) {
      dailyString += "$item,";
    }
    dailyString = dailyString.substring(0, dailyString.length - 1);

    param += 'latitude=${latLng.latitude}';
    param += '&longitude=${latLng.longitude}';
    param += "&hourly=$hourlyString";
    param += "&daily=$dailyString";
    param += '&forecast_days=1&timezone=auto';

    var response = await dio.get('https://api.open-meteo.com/v1/forecast?$param');

    MeteoWeatherResponse weatherResponse = MeteoWeatherResponse.fromJson(response.data);

    if(kDebugMode) {
      print("Meteo weather success");
      print("Hourly string: $hourlyString");
      print("Daily string: $dailyString");
      print("Meteo weather param: $param");
      print("Wind direction: ${weatherResponse.hourly!.windDirection_10m}");
      print("Temperature: ${weatherResponse.hourly!.temperature_2m}");
    }

    return weatherResponse;
  } catch (e) {
    if(kDebugMode) {
      print("Meteo weather error");
      print("Error: $e");
      print("Hourly string: $hourlyString");
      print("Daily string: $dailyString");
      print("Meteo weather param: $param");
    }

    return null;
  }
}
