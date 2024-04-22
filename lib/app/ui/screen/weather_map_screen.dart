import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:travel/app/ui/widget/app_touchable3.dart';

import '../../controller/app_controller.dart';
import '../../controller/map_trip_controller.dart';
import '../../res/image/app_image.dart';
import '../../res/string/app_strings.dart';
import '../../util/custom_info_window.dart';
import '../theme/app_color.dart';
import '../widget/app_container.dart';
import '../widget/app_image_widget.dart';
import '../widget/app_touchable.dart';
import '../widget/item_weather_widget.dart';

class WeatherMapScreen extends GetView<MapTripController> {
  const WeatherMapScreen({super.key});

  Widget buildHeader(BuildContext context) {
    return Container(
      width: Get.width,
      margin: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 12.0.sp,
          left: 65.sp,
          right: 20.sp),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(20.sp),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 0),
            blurRadius: 1,
            color: Colors.black.withOpacity(0.04),
          ),
          BoxShadow(
            offset: const Offset(0, 4),
            blurRadius: 8,
            color: Colors.black.withOpacity(0.04),
          )
        ],
      ),
      padding: EdgeInsets.all(8.sp),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 8.0.sp),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 4.0.sp),
                Row(
                  children: [
                    AppImageWidget.asset(
                      path: AppImage.weatherTripFrom,
                      height: 24.0.sp,
                      width: 24.0.sp,
                    ),
                    SizedBox(
                      width: 14.0.sp,
                    ),
                    Expanded(
                      child: Obx(
                        () => Text(
                          controller.fromAdd.value,
                          style: TextStyle(
                            color: AppColor.black333,
                            fontSize: 16.0.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 3.0.sp,
                  height: 3.0.sp,
                  margin: EdgeInsets.only(
                    left: 12.0.sp - 1.5.sp,
                    top: 2.0.sp,
                    bottom: 2.0.sp,
                  ),
                  decoration: const BoxDecoration(
                    color: AppColor.grayE93,
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  width: 3.0.sp,
                  height: 3.0.sp,
                  margin: EdgeInsets.only(
                    left: 12.0.sp - 1.5.sp,
                    top: 2.0.sp,
                    bottom: 2.0.sp,
                  ),
                  decoration: const BoxDecoration(
                    color: AppColor.grayE93,
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  width: 3.0.sp,
                  height: 3.0.sp,
                  margin: EdgeInsets.only(
                    left: 12.0.sp - 1.5.sp,
                    top: 2.0.sp,
                    bottom: 2.0.sp,
                  ),
                  decoration: const BoxDecoration(
                    color: AppColor.grayE93,
                    shape: BoxShape.circle,
                  ),
                ),
                Row(
                  children: [
                    AppImageWidget.asset(
                      path: AppImage.weatherTripTo,
                      height: 24.0.sp,
                      width: 24.0.sp,
                    ),
                    SizedBox(
                      width: 14.0.sp,
                    ),
                    Expanded(
                      child: Obx(
                        () => Text(
                          controller.toAdd.value,
                          style: TextStyle(
                            color: AppColor.black333,
                            fontSize: 16.0.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 14.0.sp,
                ),
                Row(
                  children: [
                    AppImageWidget.asset(
                      path: AppImage.weatherTripTime,
                      height: 24.0.sp,
                      width: 24.0.sp,
                    ),
                    SizedBox(
                      width: 14.0.sp,
                    ),
                    Expanded(
                      child: Obx(
                        () => Text(
                          "${DateFormat('MMMM dd').format(controller.dateTrip.value)} at ${controller.timeTrip.value.hour.toString().padLeft(2, '0')}:${controller.timeTrip.value.minute.toString().padLeft(2, '0')}",
                          style: TextStyle(
                            color: AppColor.black333,
                            fontSize: 16.0.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 14.0.sp,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildGroupButton(BuildContext context) {
    return Obx(
      () => controller.haveWeatherData.value
          ? SizedBox(
              width: Get.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Obx(
                    () => controller.showWeatherTypeList.value
                        ? Container(
                            key: const ValueKey(0),
                            width: 187.0.sp,
                            height: 114.0.sp,
                            margin: EdgeInsets.only(
                                bottom: 12.0.sp +
                                    (MediaQuery.of(context).padding.bottom > 0
                                        ? 20.0.sp
                                        : 0),
                                right: 12.0.sp),
                            decoration: BoxDecoration(
                              color: AppColor.white,
                              borderRadius: BorderRadius.circular(16.0.sp),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColor.black.withOpacity(0.25),
                                  offset: const Offset(0, 0),
                                  blurRadius: 10.0.sp,
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: Obx(
                              () => Column(
                                children: [
                                  {
                                    'type': WeatherType.temp,
                                    'text': StringConstants.weatherForecast.tr,
                                    'asset': AppImage.ic_weather
                                  },
                                  {
                                    'type': WeatherType.wind,
                                    'text': StringConstants.wind.tr,
                                    'asset': AppImage.ic_wind
                                  },
                                  {
                                    'type': WeatherType.pre,
                                    'text': StringConstants.precipitation.tr,
                                    'asset': AppImage.ic_pre
                                  },
                                ].map((e) {
                                  bool isSelected = e['type'] ==
                                      controller.currentWeatherType.value;
                                  return AppTouchable(
                                    width: 160.0.sp,
                                    height: 36.0.sp,
                                    onPressed: () =>
                                        controller.onPressWeatherType(
                                            e['type'] as WeatherType),
                                    child: Row(
                                      children: [
                                        AppImageWidget.asset(
                                          width: 16.0.sp,
                                          path: '${e['asset']}',
                                        ),
                                        SizedBox(width: 10.0.sp),
                                        Expanded(
                                          child: Text(
                                            '${e['text']}',
                                            style: TextStyle(
                                              color: AppColor.gray,
                                              fontSize: 12.0.sp,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                        isSelected
                                            ? AppImageWidget.asset(
                                                width: 14.0.sp,
                                                path: AppImage.ic_checked,
                                              )
                                            : const SizedBox.shrink(),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          )
                        : AppTouchable(
                            key: const ValueKey(1),
                            onPressed: controller.onPressWeatherTypeToggle,
                            width: 50.0.sp,
                            height: 50.0.sp,
                            margin: EdgeInsets.only(
                                bottom: 12.0.sp +
                                    (MediaQuery.of(context).padding.bottom > 0
                                        ? 20.0.sp
                                        : 0),
                                right: 12.0.sp),
                            padding: EdgeInsets.all(4.0.sp),
                            borderRadius: BorderRadius.circular(30.0.sp),
                            decoration: BoxDecoration(
                              color: AppColor.white,
                              borderRadius: BorderRadius.circular(30.0.sp),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColor.black.withOpacity(0.25),
                                  offset: const Offset(0, 0),
                                  blurRadius: 10.0.sp,
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: Obx(
                              () {
                                String asset = AppImage.ic_weather;
                                switch (controller.currentWeatherType.value) {
                                  case WeatherType.temp:
                                    asset = AppImage.ic_weather;
                                    break;
                                  case WeatherType.wind:
                                    asset = AppImage.ic_wind;
                                    break;
                                  case WeatherType.pre:
                                    asset = AppImage.ic_pre;
                                    break;
                                }
                                return AppImageWidget.asset(path: asset);
                              },
                            ),
                          ),
                  ),
                  AppTouchable(
                    onPressed: controller.onPressMyLocation,
                    width: 50.0.sp,
                    height: 50.0.sp,
                    margin: EdgeInsets.only(
                        bottom: 12.0.sp + 66.0.sp, right: 12.0.sp),
                    padding: EdgeInsets.all(4.0.sp),
                    borderRadius: BorderRadius.circular(30.0.sp),
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      borderRadius: BorderRadius.circular(30.0.sp),
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.black.withOpacity(0.25),
                          offset: const Offset(0, 0),
                          blurRadius: 10.0.sp,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Obx(
                      () => controller.isLoadingMyLocation.value
                          ? const CupertinoActivityIndicator()
                          : AppImageWidget.asset(
                              path: AppImage.ic_my_location,
                            ),
                    ),
                  ),
                ],
              ),
            )
          : const SizedBox.shrink(),
    );
  }

  Widget _buildSlidingUpPanel(BuildContext context) {
    return Column(
      children: [
        Container(
          width: Get.width * 0.5,
          height: 6.0.sp,
          margin: EdgeInsets.only(
            top: 12.0.sp,
            bottom: 8.0.sp,
          ),
          decoration: BoxDecoration(
            color: AppColor.lightGray,
            borderRadius: BorderRadius.circular(10.0.sp),
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 16.sp, right: 16.sp),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //SizedBox(width: 16.0.sp),
              Text(
                "Timeline",
                style: TextStyle(
                  color: AppColor.black333,
                  fontSize: 15.0.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              AppTouchable3(
                onPressed: () {
                  controller.onPressFavorite();
                },
                child: Obx(
                      () => !controller.isFavorite.value
                      ? AppImageWidget.asset(
                    path: AppImage.icNoteFavorite,
                    height: 26.sp,
                  )
                      : AppImageWidget.asset(
                    path: AppImage.icFavorite,
                    height: 26.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10.0.sp +
              (MediaQuery.of(context).padding.bottom > 0 ? 20.0.sp : 0),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.0.sp),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(10.0.sp),
                  decoration: BoxDecoration(
                    color: AppColor.lightBlue,
                    borderRadius: BorderRadius.circular(13.0.sp),
                  ),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          AppImageWidget.asset(
                            path: AppImage.weatherTripFrom,
                            width: 24.0.sp,
                            height: 24.0.sp,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 4.0.sp),
                            child: Text(
                              '•\n•\n•',
                              style: TextStyle(
                                color: AppColor.gray2,
                                fontSize: 10.0.sp,
                                fontWeight: FontWeight.w700,
                                height: 0.6,
                              ),
                            ),
                          ),
                          AppImageWidget.asset(
                            path: AppImage.weatherTripTo,
                            width: 24.0.sp,
                            height: 24.0.sp,
                          ),
                        ],
                      ),
                      SizedBox(width: 14.0.sp),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(
                              () => Text(
                                controller.fromAdd.value,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: AppColor.black333,
                                  fontSize: 14.0.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            SizedBox(height: 30.0.sp),
                            Obx(
                              () => Text(
                                controller.toAdd.value,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: AppColor.black333,
                                  fontSize: 14.0.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 14.0.sp),
              Column(
                children: [
                  Text(
                    StringConstants.departureTime.tr,
                    style: TextStyle(
                      color: AppColor.black333,
                      fontSize: 14.0.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 4.0.sp),
                  Container(
                    width: 117.0.sp,
                    padding: EdgeInsets.all(10.0.sp),
                    decoration: BoxDecoration(
                      color: AppColor.lightBlue,
                      borderRadius: BorderRadius.circular(13.0.sp),
                    ),
                    child: Column(
                      children: [
                        Obx(
                          () => Text(
                            DateFormat(
                                    'MMM dd',
                                    Get.find<AppController>()
                                        .currentLocale
                                        .languageCode)
                                .format(controller.dateTrip.value),
                            style: TextStyle(
                              color: AppColor.black333,
                              fontSize: 16.0.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        SizedBox(height: 8.sp),
                        Obx(
                          () => Text(
                            DateFormat(
                                    'HH : mm',
                                    Get.find<AppController>()
                                        .currentLocale
                                        .languageCode)
                                .format(controller.timeTrip.value),
                            style: TextStyle(
                              color: AppColor.black333,
                              fontSize: 16.0.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 10.0.sp),
        Text(
          StringConstants.averageSpeed.tr,
          style: TextStyle(
            color: AppColor.black333,
            fontSize: 12.0.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 10.0.sp),
        Obx(
          () => SingleChildScrollView(
            padding: EdgeInsets.only(
              top: 10.0.sp,
              bottom: 10.0.sp,
              left: 10.0.sp,
            ),
            scrollDirection: Axis.horizontal,
            child: Row(
              children: controller.listLatLngNode.value
                  .map(
                    (e) => Padding(
                      padding: EdgeInsets.only(right: 12.0.sp),
                      child: ItemWeatherWidget(
                        hourlyDataWeather: e['weather'],
                        timeStamp: e['dateTime'],
                        shadowColor: AppColor.black.withOpacity(0.2),
                        weatherType: controller.currentWeatherType.value,
                        data: e,
                        onPressed: (data) async {
                          if (data['latLng'] != null) {
                            final GoogleMapController gmc =
                                await controller.googleMapController.future;
                            gmc.animateCamera(
                              CameraUpdate.newLatLng(data['latLng']),
                            );
                          }
                        },
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
        const Spacer(),
        AppTouchable(
          width: Get.width - 80.0.sp,
          height: 48.0.sp,
          onPressed: controller.onPressWeatherTimeline,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(12.0.sp),
            gradient: const LinearGradient(
              colors: [
                Color(0xFF437AFF),
                Color(0xFF67A4FE),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: Text(
            StringConstants.weatherTimeline.tr,
            style: TextStyle(
              color: AppColor.white,
              fontSize: 18.0.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).padding.bottom + 12.0.sp,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      backgroundColor: Colors.white,
      showBanner: false,
      child: Stack(
        children: [
          Obx(
            () => !controller.delayLoadMap.value
                ? const SizedBox.shrink()
                : GoogleMap(
                    mapType: MapType.normal,
                    padding: controller.isMapLoaded.value
                        ? EdgeInsets.only(top: 200.0.sp)
                        : EdgeInsets.zero,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        controller.currentPosition!.latitude,
                        controller.currentPosition!.longitude,
                      ),
                      zoom: 14.4746,
                    ),
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: false,
                    polylines: controller.polylineResult.value,
                    markers: controller.markerResult.value,
                    onMapCreated: (GoogleMapController googleMapController) {
                      controller.isMapLoaded.value = true;
                      if (!controller.googleMapController.isCompleted) {
                        controller.googleMapController
                            .complete(googleMapController);
                      }

                      controller.customInfoWindowController00
                          .googleMapController = googleMapController;
                      controller.customInfoWindowController01
                          .googleMapController = googleMapController;
                      controller.customInfoWindowController02
                          .googleMapController = googleMapController;
                      controller.customInfoWindowController03
                          .googleMapController = googleMapController;
                      controller.customInfoWindowController04
                          .googleMapController = googleMapController;
                      controller.customInfoWindowController05
                          .googleMapController = googleMapController;
                    },
                    onCameraMove: (position) {
                      if (controller
                              .customInfoWindowController00.onCameraMove !=
                          null) {
                        controller.customInfoWindowController00.onCameraMove!();
                      }
                      if (controller
                              .customInfoWindowController01.onCameraMove !=
                          null) {
                        controller.customInfoWindowController01.onCameraMove!();
                      }
                      if (controller
                              .customInfoWindowController02.onCameraMove !=
                          null) {
                        controller.customInfoWindowController02.onCameraMove!();
                      }
                      if (controller
                              .customInfoWindowController03.onCameraMove !=
                          null) {
                        controller.customInfoWindowController03.onCameraMove!();
                      }
                      if (controller
                              .customInfoWindowController04.onCameraMove !=
                          null) {
                        controller.customInfoWindowController04.onCameraMove!();
                      }
                      if (controller
                              .customInfoWindowController05.onCameraMove !=
                          null) {
                        controller.customInfoWindowController05.onCameraMove!();
                      }
                    },
                  ),
          ),
          CustomInfoWindow(
            controller: controller.customInfoWindowController00,
            width: 75.0.sp,
            height: 85.0.sp,
            offset: 30.0.sp,
          ),
          CustomInfoWindow(
            controller: controller.customInfoWindowController01,
            width: 75.0.sp,
            height: 85.0.sp,
            offset: 30.0.sp,
          ),
          CustomInfoWindow(
            controller: controller.customInfoWindowController02,
            width: 75.0.sp,
            height: 85.0.sp,
            offset: 30.0.sp,
          ),
          CustomInfoWindow(
            controller: controller.customInfoWindowController03,
            width: 75.0.sp,
            height: 85.0.sp,
            offset: 30.0.sp,
          ),
          CustomInfoWindow(
            controller: controller.customInfoWindowController04,
            width: 75.0.sp,
            height: 85.0.sp,
            offset: 30.0.sp,
          ),
          CustomInfoWindow(
            controller: controller.customInfoWindowController05,
            width: 75.0.sp,
            height: 85.0.sp,
            offset: 30.0.sp,
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 12.0.sp,
            left: 20.sp,
            child: Container(
              height: 40.sp,
              width: 40.sp,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.blueCF6,
              ),
              child: IconButton(
                onPressed: () {
                  Get.back();
                  Get.back();
                },
                icon: AppImageWidget.asset(
                  path: AppImage.ic_back,
                  height: 20.sp,
                  width: 20.sp,
                  color: AppColor.white,
                ),
              ),
            ),
          ),
          buildHeader(context),
          buildGroupButton(context),
          Obx(
            () => SlidingUpPanel(
              minHeight: !controller.haveWeatherData.value
                  ? 0
                  : (60.0.sp +
                      (MediaQuery.of(context).padding.bottom > 0
                          ? 20.0.sp
                          : 0)),
              maxHeight: 360.0.sp + MediaQuery.of(context).padding.bottom,
              // maxHeight: Get.height,
              backdropColor: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.0.sp),
                topRight: Radius.circular(12.0.sp),
              ),
              color: AppColor.white,
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 0),
                  blurRadius: 1,
                  color: Colors.black.withOpacity(0.04),
                ),
                BoxShadow(
                  offset: const Offset(0, 4),
                  blurRadius: 8,
                  color: Colors.black.withOpacity(0.04),
                )
              ],
              panel: _buildSlidingUpPanel(context),
            ),
          ),
        ],
      ),
    );
  }
}
