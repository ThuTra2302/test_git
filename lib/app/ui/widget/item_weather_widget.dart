import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:travel/app/controller/app_controller.dart';
import 'package:travel/app/controller/map_location_controller.dart';
import 'package:travel/app/controller/map_trip_controller.dart';
import 'package:travel/app/data/model/weather_response.dart';
import 'package:travel/app/extension/int_temp.dart';
import 'package:travel/app/res/image/app_image.dart';
import 'package:travel/app/route/app_route.dart';
import 'package:travel/app/ui/widget/app_touchable.dart';

import '../../ads/interstitial_ad_manager.dart';
import '../theme/app_color.dart';
import 'app_image_widget.dart';

class ItemWeatherWidget extends StatelessWidget {
  final Hourly? hourlyDataWeather;
  final int? timeStamp;
  final Color? shadowColor;
  final WeatherType? weatherType;
  final Map? data;
  final String? assetHeader;
  final Function(Map)? onPressed;
  final bool? showWaring;
  final String? type;

  const ItemWeatherWidget({
    Key? key,
    required this.hourlyDataWeather,
    required this.timeStamp,
    this.shadowColor,
    this.weatherType,
    this.data,
    this.assetHeader,
    this.showWaring = false,
    this.type = "Route",
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MapTripController? mapTripController = Get.isRegistered<MapTripController>()
        ? Get.find<MapTripController>()
        : null;
    MapLocationController? mapLocationController =
        Get.isRegistered<MapLocationController>()
            ? Get.find<MapLocationController>()
            : null;

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

    return Obx(
      () => Stack(
        children: [
          AppTouchable(
            onPressed: () async {
              FirebaseAnalytics.instance.logEvent(name: 'weather_detail_trip');

              if (mapTripController != null) {
                mapTripController.selectedData.value = data ?? {};
              }

              if (mapLocationController != null) {
                mapLocationController.selectedData.value = data ?? {};
              }
              // Get.toNamed(AppRoute.weatherDetailScreen, arguments: {'data': data, 'assetHeader': assetHeader});

              if (Get.find<AppController>().isPremium.value) {
                Get.toNamed(AppRoute.weatherDetailScreen, arguments: {
                  'data': data,
                  'assetHeader': assetHeader,
                });
              } else {
                showInterstitialAds(() {
                  Get.toNamed(AppRoute.weatherDetailScreen, arguments: {
                    'data': data,
                    'assetHeader': assetHeader,
                  });
                });
              }

              if (onPressed != null) onPressed!(data ?? {});
            },
            width: showWaring == true ? 80.0.sp : 75.0.sp,
            height: showWaring == true ? 90.0.sp : 85.0.sp,
            padding: EdgeInsets.symmetric(vertical: 6.0.sp),
            margin: showWaring == true
                ? EdgeInsets.only(top: 6.0.sp, right: 6.0.sp)
                : EdgeInsets.zero,
            borderRadius: BorderRadius.circular(12.0.sp),
            decoration: BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.circular(12.0.sp),
              border: mapTripController?.selectedData['dateTime'] ==
                          timeStamp ||
                      mapLocationController?.selectedData['dateTime'] ==
                          timeStamp
                  ? Border.all(color: const Color(0xFF61C200), width: 2.0.sp)
                  : null,
              boxShadow: [
                BoxShadow(
                  color: mapTripController?.selectedData['dateTime'] ==
                              timeStamp ||
                          mapLocationController?.selectedData['dateTime'] ==
                              timeStamp
                      ? const Color(0xFF61C200)
                      : (shadowColor ?? AppColor.black),
                  offset: const Offset(0, 0),
                  blurRadius: 10.0.sp,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  DateFormat('HH : mm')
                      .format(DateTime.fromMillisecondsSinceEpoch(timeStamp!)),
                  style: TextStyle(
                    color: AppColor.gray,
                    fontSize: 14.0.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 3.0.sp),
                Expanded(
                  child: weatherType == WeatherType.wind
                      ? RotationTransition(
                          turns: AlwaysStoppedAnimation(
                              (hourlyDataWeather?.windBearing ?? 0) / 360),
                          child: AppImageWidget.asset(
                            path: AppImage.ic_direction,
                            height: 21.sp,
                          ))
                      : weatherType == WeatherType.pre
                          ? Center(
                              child: Text(
                                '${(hourlyDataWeather?.precipProbability * 100).round()}%',
                                style: TextStyle(
                                  color: AppColor.gray,
                                  fontSize: 14.0.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            )
                          : (hourlyDataWeather?.icon ?? '').isEmpty
                              ? const SizedBox.shrink()
                              : AppImageWidget.asset(
                                  path: type == "Route"
                                      ? 'lib/app/res/image/png/${hourlyDataWeather?.icon != null ? listWeatherType.contains(hourlyDataWeather!.icon) ? hourlyDataWeather!.icon : "cloudy" : ''}.png'
                                      : hourlyDataWeather!.icon,
                                ),
                ),
                SizedBox(height: 3.0.sp),
                Text(
                  weatherType == WeatherType.wind
                      ? '${hourlyDataWeather?.windSpeed.round()} km/h'
                      : weatherType == WeatherType.pre
                          ? '${hourlyDataWeather?.precipType}'
                          : '${((hourlyDataWeather?.temperature ?? 0).round() as int).toUnit(Get.find<AppController>().currentUnitTypeTemp.value)}°${Get.find<AppController>().currentUnitTypeTemp.value.name.toLowerCase()}',
                  style: TextStyle(
                    color: AppColor.gray,
                    fontSize: 14.0.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          showWaring == true
              ? Align(
                  alignment: Alignment.topRight,
                  child: AppImageWidget.asset(
                    path: AppImage.icWarning,
                    height: 20.0.sp,
                    width: 20.0.sp,
                  ),
                )
              : const SizedBox.shrink()
        ],
      ),
    );
  }
}
