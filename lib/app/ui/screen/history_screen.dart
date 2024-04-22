import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:travel/app/ads/widget_xml/small_native_ads_widget.dart';
import 'package:travel/app/ui/theme/app_color.dart';

import '../../controller/history_controller.dart';
import '../../res/image/app_image.dart';
import '../../util/disable_glow_behavior.dart';
import '../widget/app_container.dart';
import '../widget/app_image_widget.dart';
import '../widget/item_list.dart';

class HistoryScreen extends GetView<HistoryController> {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    controller.context = context;

    return AppContainer(
      showBanner: false,
      backgroundColor: AppColor.grayFF9,
      bottomNavigationBar: Obx(() => controller.list.length < 4
          ? AppImageWidget.asset(
              path: AppImage.icLessThan4,
              width: Get.width,
            )
          : SizedBox(
              height: 0.sp,
            )),
      child: Column(
        children: [
          Expanded(
            child: controller.isLoadingList.value
                ? const Center(
                    child: CupertinoActivityIndicator(),
                  )
                : Obx(
                    () => controller.list.isEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AppImageWidget.asset(
                                path: AppImage.icNoDataHistory,
                              ),
                              SizedBox(height: 8.0.sp),
                              const Text(
                                'You don\'t have any trip yet?',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF8E8E93),
                                ),
                              )
                            ],
                          )
                        : ScrollConfiguration(
                            behavior: DisableGlowBehavior(),
                            child: SingleChildScrollView(
                              child: Obx(
                                () => SizedBox(
                                  height: controller.list.length < 4
                                      ? 440.sp
                                      : 587.sp,
                                  child: ListView.builder(
                                    padding: EdgeInsets.only(
                                      top: 12.0.sp,
                                    ),
                                    itemCount: controller.list.length,
                                    itemBuilder: (context, index) {
                                      controller.cntAds++;
                                      if (index == 2 ||
                                          index == 5 ||
                                          index == 8) {
                                        return Column(
                                          children: [
                                            Padding(
                                              padding:EdgeInsets.symmetric(horizontal: 20.sp),
                                              child: const SmallNativeAdsWidgetXML(),
                                            ),
                                            ItemList(
                                              onPressed: () =>
                                                  controller.onPressItem(index),
                                              addressFrom: controller
                                                  .list[index]
                                                  .addressFrom ??
                                                  "",
                                              addressTo: controller
                                                  .list[index].addressTo ??
                                                  "",
                                            )
                                          ],
                                        );
                                      }
                                      return ItemList(
                                        onPressed: () =>
                                            controller.onPressItem(index),
                                        addressFrom: controller
                                                .list[index].addressFrom ??
                                            "",
                                        addressTo:
                                            controller.list[index].addressTo ??
                                                "",
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                  ),
          ),

          // Obx(
          //   () => Get.find<AppController>().isPremium.value
          //       ? const SizedBox.shrink()
          //       : NativeAdsWidget(
          //           factoryId: NativeFactoryId.appNativeAdFactorySmall,
          //           isPremium: Get.find<AppController>().isPremium.value,
          //           height: 120.0.sp,
          //         ),
          // ),
        ],
      ),
    );
  }
}
