import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:travel/app/controller/trip_detail_controller.dart';
import 'package:travel/app/extension/int_temp.dart';

import 'package:travel/app/ui/screen/sub_screen.dart';
import 'package:travel/app/ui/widget/app_container.dart';
import 'package:travel/app/ui/widget/app_header.dart';

import '../../controller/app_controller.dart';
import '../../res/image/app_image.dart';
import '../../res/string/app_strings.dart';
import '../theme/app_color.dart';
import '../widget/show_more_popup.dart';
import '../widget/app_image_widget.dart';
import '../widget/app_touchable3.dart';

class TripDetailScreen extends GetView<TripDetailController> {
  const TripDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.context = context;

    return AppContainer(
      backgroundColor: AppColor.grayFF9,
      child: Column(
        children: [
          AppHeader(
            title: StringConstants.weatherTimeline.tr,
            rightWidget:SizedBox(width: 40.sp,),
          ),
          SizedBox(height: 12.0.sp),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                right: 12.0.sp,
                left: 12.0.sp,
                bottom: 24.0.sp,
                top: 10.0.sp,
              ),
              child: Obx(
                () => Container(
                  padding: EdgeInsets.all(30.sp),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.sp),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          AppImageWidget.asset(path: AppImage.icLocation2),
                          Expanded(
                            child: Text(
                              controller.listLatLngNode[0]['address'] ?? '',
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20.sp, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                      Stack(
                        children: [
                          /// blue line
                          Positioned(
                            left: 72.0.sp,
                            child: Container(
                              height:
                                  controller.listLatLngNode.length * (90.0.sp) -
                                      90.0.sp,
                              width: 4.0.sp,
                              color: AppColor.blue0C7,
                              margin: EdgeInsets.only(top: 40.0.sp),
                            ),
                          ),
                          Column(
                            children: controller.listLatLngNode.map(
                              (e) {
                                var index =
                                    controller.listLatLngNode.indexOf(e);
                                final GlobalKey key = GlobalKey();
                                return Container(
                                  height: 60.sp,
                                  margin: EdgeInsets.all(15.sp),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 44.0.sp,
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Row(
                                            children: [
                                              Text(
                                                DateFormat('HH : mm').format(
                                                    DateTime
                                                        .fromMillisecondsSinceEpoch(
                                                            e['dateTime'])),
                                                style: TextStyle(
                                                  color: AppColor.gray,
                                                  fontSize: 16.0.sp,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 7.0.sp),

                                      /// dot
                                      InkWell(
                                        key: key,
                                        onTap: () {
                                          if (Get.find<AppController>()
                                              .isPremium
                                              .value) {
                                            showMorePopup(context, key, e);
                                          } else if (index == 0 ||
                                              index >=
                                                  controller.listLatLngNode
                                                          .length -
                                                      2) {
                                            showMorePopup(context, key, e);
                                          } else {
                                            Get.to(const SubScreen());
                                          }
                                        },
                                        child: Column(
                                          children: [
                                            if (index == 0) ...[
                                              Container(
                                                width: 16.0.sp,
                                                height: 32.0.sp,
                                                margin:
                                                    EdgeInsets.only(top: 7.sp),
                                                decoration: const BoxDecoration(
                                                  image: DecorationImage(
                                                    image: AssetImage(
                                                      AppImage.markerFrom,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ] else if (index ==
                                                controller
                                                        .listLatLngNode.length -
                                                    1) ...[
                                              Container(
                                                width: 16.0.sp,
                                                height: 32.0.sp,
                                                margin:
                                                    EdgeInsets.only(top: 10.sp),
                                                decoration: const BoxDecoration(
                                                  image: DecorationImage(
                                                    image: AssetImage(
                                                        AppImage.markerTo),
                                                  ),
                                                ),
                                              ),
                                            ] else ...[
                                              Container(
                                                width: 16.0.sp,
                                                height: 16.0.sp,
                                                margin:
                                                    EdgeInsets.only(top: 20.sp),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: AppColor.black,
                                                      width: 2.sp),
                                                  color: AppColor.white
                                                      .withOpacity(0.5),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0.sp),
                                                ),
                                              ),
                                            ]
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 5.0.sp),
                                      SizedBox(
                                        width: 80.sp,
                                        child: Text(
                                          '${(e['distance'] / 1000).round()} Km',
                                          style: TextStyle(
                                            color: AppColor.gray,
                                            fontSize: 16.0.sp,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 5.0.sp),
                                      Text(
                                        '${(e['weather']?.temperature.round() as int).toUnit(Get.find<AppController>().currentUnitTypeTemp.value)}°${Get.find<AppController>().currentUnitTypeTemp.value.name.toLowerCase()}',
                                        style: TextStyle(
                                          color: AppColor.gray,
                                          fontSize: 24.0.sp,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20.sp,
                                      ),
                                      AppImageWidget.asset(
                                        width: 75.0.sp,
                                        path: e['type'] == "Route"
                                            ? 'lib/app/res/image/png/${e['weather']?.icon != null ? controller.listWeatherType.contains(e['weather']?.icon) ? e['weather']!.icon : "cloudy" : ''}.png'
                                            : e['weather']!.icon,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ).toList(),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30.sp,
                      ),
                      Row(
                        children: [
                          AppImageWidget.asset(path: AppImage.icLocation2),
                          Expanded(
                            child: Text(
                              controller.listLatLngNode[
                                          controller.listLatLngNode.length - 1]
                                      ['address'] ??
                                  '',
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20.sp, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30.sp,
                      ),
                      Row(
                        children: [
                          Text(
                            '*${StringConstants.averageSpeed.tr}',
                            style: TextStyle(
                              color: const Color(0xFFAEAEB2),
                              fontSize: 12.0.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showMorePopup(BuildContext context, GlobalKey key, Map e) {
    ShowMorePopup popup = ShowMorePopup(context,
        body: Container(
          height: 100.sp,
          padding: EdgeInsets.symmetric(horizontal: 8.sp),
          decoration: BoxDecoration(
            color: AppColor.grayFF9,
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text(
                    DateFormat('HH : mm').format(
                        DateTime.fromMillisecondsSinceEpoch(e['dateTime'])),
                    style: TextStyle(
                      color: AppColor.gray,
                      fontSize: 16.0.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(width: 12.0.sp),
                  Expanded(
                    child: (e['address'] ?? '').isEmpty
                        ? Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              height: 20.0.sp,
                              width: Get.width / 2,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0.sp),
                                color: AppColor.primaryColor,
                              ),
                            ),
                          )
                        : Text(
                            e['address'] ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppColor.gray42,
                              fontSize: 14.0.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                  ),
                ],
              ),
              Row(
                children: [
                  AppImageWidget.asset(
                    width: 30.0.sp,
                    path: e['type'] == "Route"
                        ? 'lib/app/res/image/png/${e['weather']?.icon != null ? controller.listWeatherType.contains(e['weather']?.icon) ? e['weather']!.icon : "cloudy" : ''}.png'
                        : e['weather']!.icon,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          '${(e['weather']?.temperature.round() as int).toUnit(Get.find<AppController>().currentUnitTypeTemp.value)}°${Get.find<AppController>().currentUnitTypeTemp.value.name.toLowerCase()}',
                          style: TextStyle(
                            color: AppColor.gray42,
                            fontSize: 16.0.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 2.0.sp),
                        Text(
                          '${e['weather']?.summary}',
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColor.gray42,
                            fontSize: 12.0.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 40.0.sp,
                    margin: EdgeInsets.symmetric(horizontal: 4.0.sp),
                    color: const Color(0xFFD3D3D3),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          StringConstants.wind.tr,
                          style: TextStyle(
                            color: AppColor.gray42,
                            fontSize: 10.0.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 3.0.sp),
                        RotationTransition(
                            turns: AlwaysStoppedAnimation(
                                (e['weather']?.windBearing ?? 0) / 360),
                            child: AppImageWidget.asset(
                              path: AppImage.ic_direction,
                              width: 12.0.sp,
                            )),
                        SizedBox(height: 3.0.sp),
                        Text(
                          '${e['weather']?.windSpeed.round()} km/h',
                          style: TextStyle(
                            color: AppColor.gray42,
                            fontSize: 10.0.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 40.0.sp,
                    margin: EdgeInsets.symmetric(horizontal: 4.0.sp),
                    color: const Color(0xFFD3D3D3),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          StringConstants.precipitation.tr,
                          style: TextStyle(
                            color: AppColor.gray42,
                            fontSize: 10.0.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 3.0.sp),
                        Text(
                          '${(e['weather']?.precipProbability * 100).round()}%',
                          style: TextStyle(
                            color: AppColor.gray42,
                            fontSize: 10.0.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 3.0.sp),
                        Text(
                          '${e['weather']?.precipType}',
                          style: TextStyle(
                            color: AppColor.gray42,
                            fontSize: 10.0.sp,
                            fontWeight: FontWeight.w400,
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
        width: Get.width / 1.05,
        height: 100.sp,
        backgroundColor: AppColor.grayFF9,
        padding: EdgeInsets.zero,
        borderRadius: BorderRadius.circular(16.sp),
        onDismiss: () {});

    /// show the popup for specific widget
    popup.show(
      widgetKey: key,
    );
  }
}
