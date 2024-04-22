import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:travel/app/ads/interstitial_ad_manager.dart';
import 'package:travel/app/ui/widget/app_image_widget.dart';

import '../../controller/app_controller.dart';
import '../../controller/planed_trip_controller.dart';
import '../../res/string/app_strings.dart';
import '../theme/app_color.dart';
import '../widget/app_container.dart';
import '../widget/app_header.dart';
import 'favorite_screen.dart';
import 'history_screen.dart';

class PlanedTripScreen extends GetView<PlanedTripController> {
  const PlanedTripScreen({super.key});

  @override
  Widget build(BuildContext context) {
    controller.context = context;
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: AppContainer(
          backgroundColor: AppColor.grayFF9,
          child: Column(
            children: [
              AppHeader(
                title: StringConstants.yourPlanedTrip.tr,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.sp),
                height: 72.sp,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.sp),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    AnimatedBuilder(
                      animation: controller.animation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(controller.animation.value * 96.sp, 0),
                          // Thay đổi vị trí theo giá trị animation
                          child: AnimatedBuilder(
                            animation: controller.animation,
                            builder: (context, child) {
                              return Transform.translate(
                                offset:
                                    Offset(controller.animation.value* 90.sp, 0),
                                // Thay đổi vị trí theo giá trị animation
                                child: Container(
                                  width: Get.width / 2.12,
                                  height: 72.sp,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.sp),
                                    color: AppColor.blueCF6,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                    Obx(
                      () => SizedBox(
                        height: 72.sp,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children:
                              controller.tabs.asMap().entries.map((entry) {
                            final index = entry.key;
                            final tab = entry.value;
                            final isSelected =
                                index == controller.selectedIndex.value;
                            return GestureDetector(
                              onTap: () {
                                controller.isRightToLeft.value = true;
                                if(Get.find<AppController>().isPremium.value){
                                  controller.setTab(index);
                                }
                                else {
                                  showInterstitialAds(() => controller.setTab(index));
                                }

                              },
                              child: Padding(
                                padding: EdgeInsets.all(16.sp),
                                child: Row(
                                  children: [
                                    AppImageWidget.asset(
                                      path: tab.icon,
                                      color: isSelected ? Colors.white : null,
                                    ),
                                    SizedBox(
                                      width: 5.sp,
                                    ),
                                    Text(
                                      tab.label,
                                      style: TextStyle(
                                          color: isSelected
                                              ? Colors.white
                                              : AppColor.grayE93,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18.sp),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: PageView(
                  controller: controller.pageController,
                  onPageChanged: (index) {
                    if (controller.isRightToLeft.value) {
                      controller.isRightToLeft.value = false;
                      return;
                    }
                    if(Get.find<AppController>().isPremium.value){
                      controller.setTab(index);
                    }
                    else {
                      showInterstitialAds(() => controller.setTab(index));
                    }
                  },
                  children: const [
                    FavoriteScreen(),
                    HistoryScreen(),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
