import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:travel/app/ads/native_ads_widget.dart';
import 'package:travel/app/ui/screen/famous_map_screen.dart';
import 'package:travel/app/ui/screen/sub_screen.dart';

import '../../controller/app_controller.dart';
import '../../controller/map_famous_controller.dart';
import '../../res/image/app_image.dart';
import '../../res/string/app_strings.dart';
import '../../util/disable_glow_behavior.dart';
import '../theme/app_color.dart';
import '../widget/app_container.dart';
import '../widget/app_header.dart';
import '../widget/app_image_widget.dart';
import '../widget/app_touchable3.dart';

class MapFamousScreen extends GetView<MapFamousController> {
  const MapFamousScreen({super.key});

  @override
  Widget build(BuildContext context) {
    showBottomSheet() {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(

            color: AppColor.gray2F7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppBar(
                  automaticallyImplyLeading: false, // Ẩn nút "Back"
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Choose kind of place',
                        style: TextStyle(
                          color: AppColor.black333,
                          fontSize: 14.0.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Done',
                            style: TextStyle(
                              color: AppColor.primaryColor,
                              fontSize: 14.0.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          )),
                    ],
                  ),
                  backgroundColor: AppColor.white,
                ),
                SizedBox(
                  height: 19.sp,
                ),
                Expanded(
                  child: Obx(
                    () => GridView.count(
                      //shrinkWrap: true,
                      crossAxisCount: 2,
                      childAspectRatio: 2.2.sp,
                      crossAxisSpacing: 0.sp,
                      children: List.generate(controller.listFamousModel.length,
                          (index) {
                        // if(!Get.find<AppController>().isPremium.value){
                        //
                        // }
                        return InkWell(
                          onTap: () {
                            controller.onPress(index);
                          },
                          child: Container(
                            color: AppColor.gray2F7,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                /// khung trang phia sau
                                Positioned(
                                  top: 25.sp,
                                  child: Container(
                                    height: 60.sp,
                                    width: 150.sp,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(10.sp),
                                      color: Get.find<AppController>()
                                              .isPremium
                                              .value
                                          ? AppColor.white
                                          : index == 0
                                              ? AppColor.white
                                              : AppColor.gray5,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 30.sp,
                                  right: 40.sp,
                                  child:
                                      Get.find<AppController>().isPremium.value
                                          ? const SizedBox(
                                              height: 0,
                                            )
                                          : index == 0
                                              ? const SizedBox(
                                                  height: 0,
                                                )
                                              : AppImageWidget.asset(
                                                  path: AppImage.icPremium,
                                                ),
                                ),
                                Column(
                                  children: [
                                    SizedBox(
                                      height: 15.sp,
                                    ),
                                    Obx(
                                      () => AppImageWidget.asset(
                                        path: controller
                                            .listFamousModel[index].asset,
                                        width: 35.sp,
                                        color: controller.isSelected[index]
                                            ? AppColor.blue
                                            : AppColor.gray,
                                      ),
                                    ),
                                    SizedBox(height: 10.sp),
                                    Text(
                                      controller.listFamousModel[index].name,
                                      style: TextStyle(
                                        color: AppColor.black333,
                                        fontSize: 14.0.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }

    return AppContainer(
      resizeToAvoidBottomInset: true,
      showBanner: true,
      backgroundColor: AppColor.grayFF9,
      child: Column(
        children: [
          AppHeader(
            title: StringConstants.exploreNearbyPlaces.tr,
          ),
          Expanded(
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                ScrollConfiguration(
                  behavior: DisableGlowBehavior(),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 20.0.sp,
                          ),
                          padding: EdgeInsets.all(20.sp),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.sp),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(
                                  horizontal: 12.0.sp,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        AppImageWidget.asset(
                                          path: AppImage.weatherTripFrom,
                                          height: 24.0.sp,
                                          width: 24.0.sp,
                                        ),
                                        Expanded(
                                          child: AppTouchable3(
                                            onPressed: () {
                                              controller.onPressFrom();
                                            },
                                            child: Container(
                                              height: 48.0.sp,
                                              margin: EdgeInsets.symmetric(
                                                horizontal: 8.0.sp,
                                              ),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFF8F8F8),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        12.0.sp),
                                                shape: BoxShape.rectangle,
                                                border: Border.all(
                                                  color: AppColor.gray2F7,
                                                  width: 1.0.sp,
                                                ),
                                              ),
                                              child: Obx(
                                                () => Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width: 14.0.sp,
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        controller
                                                            .fromAdd.value,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          color: controller
                                                                  .textColorFrom()
                                                              ? AppColor.grayE93
                                                              : AppColor
                                                                  .black333,
                                                          fontSize: 16.0.sp,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
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
                                        Expanded(
                                          child: AppTouchable3(
                                            onPressed: () {
                                              controller.onPressTo();
                                            },
                                            child: Container(
                                              height: 48.0.sp,
                                              margin: EdgeInsets.symmetric(
                                                horizontal: 8.0.sp,
                                              ),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFF8F8F8),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        12.0.sp),
                                                shape: BoxShape.rectangle,
                                                border: Border.all(
                                                  color: AppColor.gray2F7,
                                                  width: 1.0.sp,
                                                ),
                                              ),
                                              child: Obx(
                                                () => Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width: 14.0.sp,
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        controller.toAdd.value,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          color: controller
                                                                  .textColorTo()
                                                              ? AppColor.grayE93
                                                              : AppColor
                                                                  .black333,
                                                          fontSize: 16.0.sp,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 8.sp,
                        ),
                        Container(
                          width: Get.width,
                          margin: EdgeInsets.symmetric(horizontal: 20.sp),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.0.sp),
                          ),
                          child: AppTouchable3(
                            onPressed: () {
                              showBottomSheet();
                            },
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 12.0.sp,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 12.0.sp,
                                    ),
                                    Text(
                                      'Kind of place',
                                      style: TextStyle(
                                        color: AppColor.black333,
                                        fontSize: 18.0.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 12.0.sp,
                                ),
                                Stack(
                                  children: [
                                    Positioned(
                                        left: 40.sp,
                                        bottom: 0.sp,
                                        child: Container(
                                          height: 60.sp,
                                          width: 300.sp,
                                          margin: EdgeInsets.all(1.5.sp),
                                          decoration: BoxDecoration(
                                            color: AppColor.gray7,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.1),
                                                blurRadius: 8,
                                                offset: const Offset(0, 4),
                                              ),
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.1),
                                                blurRadius: 1,
                                                offset: const Offset(0, 0),
                                              ),
                                            ],
                                          ),
                                        )),
                                    Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              height: 50.0.sp,
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 4.0.sp,
                                              ),
                                              child: Center(
                                                child: Obx(
                                                  () => AppImageWidget.asset(
                                                    path: controller
                                                        .selectedFamousModel
                                                        .value
                                                        .asset,
                                                    width: 40.sp,
                                                    color: (controller
                                                                .selectedFamousModel
                                                                .value
                                                                .asset) !=
                                                            AppImage
                                                                .icWhatAreYouLookingFor
                                                        ? AppColor.blue
                                                        : null,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 4.0.sp,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 3.0.sp,
                                        ),
                                        Center(
                                          child: Obx(
                                            () => Text(
                                              controller.selectedFamousModel
                                                  .value.name,
                                              style: TextStyle(
                                                color: controller
                                                            .selectedFamousModel
                                                            .value
                                                            .asset ==
                                                        AppImage
                                                            .icWhatAreYouLookingFor
                                                    ? AppColor.grayE93
                                                    : AppColor.black333,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 18.0.sp,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10.sp,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 20.0.sp,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 60.sp,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Obx(
            () => SizedBox(
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppTouchable3(
                        child: Container(
                          width: Get.find<AppController>().isPremium.value
                              ? Get.width * 4 / 5
                              : Get.width * 2.3 / 3,
                          height: 44.0.sp,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(12.0.sp),
                            color: controller.colorCheckWeather()
                                ? const Color(0xFF3388F2)
                                : const Color(0xFFD8D8D8),
                          ),
                          child: Center(
                            child: Text(
                              "Check Explore",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        onPressed: () async {
                          if (await controller.onPressCheckPlace()) {
                            Get.to(() => const FamousMapScreen());
                          }
                        },
                      ),
                      SizedBox(
                        width: 10.0.sp,
                      ),
                      Obx(
                        () => Get.find<AppController>().isPremium.value
                            ? const SizedBox.shrink()
                            : AppTouchable3(
                                onPressed: () =>
                                    Get.to(() => const SubScreen()),
                                width: 40.0.sp,
                                height: 40.0.sp,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      offset: const Offset(0, 0),
                                      blurRadius: 10.0.sp,
                                      spreadRadius: 2.0.sp,
                                      color: Colors.black.withOpacity(0.5),
                                    )
                                  ],
                                ),
                                padding: const EdgeInsets.all(6.0),
                                margin: EdgeInsets.only(
                                  right: 12.0.sp,
                                ),
                                child: AppImageWidget.asset(
                                  path: AppImage.lottiePremium,
                                ),
                              ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.sp),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
