import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../controller/map_location_controller.dart';
import '../../controller/map_trip_controller.dart';
import '../../res/image/app_image.dart';
import '../../res/string/app_strings.dart';
import '../../util/custom_info_window.dart';
import '../theme/app_color.dart';
import '../widget/app_container.dart';
import '../widget/app_image_widget.dart';
import '../widget/app_touchable.dart';
import '../widget/app_touchable3.dart';

class MapLocationScreen extends GetView<MapLocationController> {
  const MapLocationScreen({Key? key}) : super(key: key);

  Widget buildGroupButton(BuildContext context) {
    return Obx(
      () => controller.showWeatherTypeList.value
          ? Container(
              key: const ValueKey(0),
              width: 187.0.sp,
              height: 114.0.sp,
              margin: EdgeInsets.only(
                bottom: 66.0.sp +
                    (MediaQuery.of(context).padding.bottom > 0 ? 20.0.sp : 0),
                right: 12.0.sp,
              ),
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
                    bool isSelected =
                        e['type'] == controller.currentWeatherType.value;
                    return AppTouchable(
                      width: 160.0.sp,
                      height: 36.0.sp,
                      onPressed: () => controller
                          .onPressWeatherType(e['type'] as WeatherType),
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
                bottom: MediaQuery.of(context).padding.bottom + 12.0.sp,
                right: 12.0.sp,
              ),
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
        Row(
          children: [
            SizedBox(width: 16.0.sp),
            Text(
              "Your Location",
              style: TextStyle(
                color: AppColor.black333,
                fontSize: 15.0.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: 7.0.sp),
        Obx(
          () => Padding(
            padding: EdgeInsets.only(
              left: 16.0.sp,
              right: 8.0.sp,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    controller.currentAddress.value,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    style: TextStyle(
                      color: const Color(0xFF3C3C43).withOpacity(0.6),
                      fontWeight: FontWeight.w500,
                      fontSize: 15.0.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 10.0.sp +
              (MediaQuery.of(context).padding.bottom > 0 ? 20.0.sp : 0),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    controller.context = context;

    return AppContainer(
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
                target: LatLng(controller.currentPosition.latitude,
                    controller.currentPosition.longitude),
                zoom: 14.4746,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              markers: controller.markerResult.value,
              onTap: controller.onPressMap1,
              onMapCreated: (GoogleMapController googleMapController) {
                controller.isMapLoaded.value = true;
                controller.googleMapController
                    .complete(googleMapController);
                controller.customInfoWindowController
                    .googleMapController = googleMapController;
              },
              onCameraMove: (position) {
                if (controller.customInfoWindowController.onCameraMove !=
                    null) {
                  controller.customInfoWindowController.onCameraMove!();
                }
              },
            ),
          ),
          CustomInfoWindow(
            controller: controller.customInfoWindowController,
            width: 75.0.sp,
            height: 85.0.sp,
            offset: 50.0.sp,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 12.0.sp,
                  bottom: 26.sp,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30.sp),bottomRight:  Radius.circular(30.sp)
                  )
                ),
                child: Row(
                  children: [
                    AppTouchable(
                      width: 40.0.sp,
                      height: 40.0.sp,
                      backgroundColor: AppColor.blueCF6,
                      padding: EdgeInsets.all(2.0.sp),
                      onPressed: Get.back,
                      margin: EdgeInsets.only(left: 15.sp),
                      borderRadius: BorderRadius.circular(22.0.sp),
                      child: AppImageWidget.asset(
                        path: AppImage.ic_back,
                        color: Colors.white ,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "Weather for Place",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20.0.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColor.black333,
                        ),
                      ),
                    ),
                    AppTouchable3(
                      backgroundColor: AppColor.blueCF6,
                      outlinedBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0.sp),
                      ),
                      padding: EdgeInsets.all(8.sp),
                      margin: EdgeInsets.only(right: 14.sp),
                      onPressed: controller.onPressSearch,
                      child: AppImageWidget.asset(
                        path: AppImage.icSearch,
                        width: 24.0.sp,
                        height: 24.0.sp,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Obx(
                  () => controller.haveWeatherData.value &&
                          !controller.isLoadingWeather.value
                      ? Stack(
                          children: [
                            SizedBox(
                              width: Get.width,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  buildGroupButton(context),
                                  AppTouchable(
                                    onPressed: controller.onPressMyLocation,
                                    width: 50.0.sp,
                                    height: 50.0.sp,
                                    margin: EdgeInsets.only(
                                        bottom: 12.0.sp, right: 12.0.sp),
                                    padding: EdgeInsets.all(4.0.sp),
                                    borderRadius:
                                        BorderRadius.circular(30.0.sp),
                                    decoration: BoxDecoration(
                                      color: AppColor.white,
                                      borderRadius:
                                          BorderRadius.circular(30.0.sp),
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              AppColor.black.withOpacity(0.25),
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
                                  Obx(
                                    () => controller.isSearch.value ||
                                            !controller.showPanel.value
                                        ? const SizedBox()
                                        : SlidingUpPanel(
                                            minHeight: !controller
                                                    .haveWeatherData.value
                                                ? 0
                                                : (120.0.sp +
                                                    (MediaQuery.of(context)
                                                                .padding
                                                                .bottom >
                                                            0
                                                        ? 20.0.sp
                                                        : 0)),
                                            maxHeight: 120.0.sp,
                                            // maxHeight: Get.height,
                                            backdropColor: Colors.white,
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(12.0.sp),
                                              topRight:
                                                  Radius.circular(12.0.sp),
                                            ),
                                            color: AppColor.white,
                                            boxShadow: [
                                              BoxShadow(
                                                offset: const Offset(0, 0),
                                                blurRadius: 1,
                                                color: Colors.black
                                                    .withOpacity(0.04),
                                              ),
                                              BoxShadow(
                                                offset: const Offset(0, 4),
                                                blurRadius: 8,
                                                color: Colors.black
                                                    .withOpacity(0.04),
                                              )
                                            ],
                                            panel:
                                                _buildSlidingUpPanel(context),
                                          ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
                ),
              ),
            ],
          ),
          Obx(
            () => controller.isLoadingWeather.value
                ? const Center(
                    child: CircularProgressIndicator(
                    color: AppColor.primaryColor,
                  ))
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
