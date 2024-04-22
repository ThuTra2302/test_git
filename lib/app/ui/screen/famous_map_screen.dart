import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travel/app/controller/map_famous_controller.dart';

import '../../res/image/app_image.dart';
import '../../util/custom_info_window.dart';
import '../theme/app_color.dart';
import '../widget/app_container.dart';
import '../widget/app_image_widget.dart';

class FamousMapScreen extends GetView<MapFamousController> {
  const FamousMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    controller.context = context;

    return AppContainer(
      resizeToAvoidBottomInset: true,
      showBanner: true,
      child: Stack(
        children: [
          Positioned.fill(
            child: AppImageWidget.asset(
              path: AppImage.bg_main1,
              fit: BoxFit.cover,
            ),
          ),
          Obx(
            () => controller.isInitialStateScreen.value
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
                      controller.googleMapController
                          .complete(googleMapController);
                      controller.customInfoWindowController
                          .googleMapController = googleMapController;
                    },
                    onCameraMove: (position) {
                      controller.clusterManager?.onCameraMove(position);
                      if (controller.customInfoWindowController.onCameraMove !=
                          null) {
                        controller.customInfoWindowController.onCameraMove!();
                      }
                    },
                    onCameraIdle: () {
                      controller.clusterManager?.updateMap();
                    },
                  ),
          ),
          CustomInfoWindow(
            controller: controller.customInfoWindowController,
            width: 160.0.sp,
            height: 68.0.sp,
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
          Container(
            height: 130.sp,
            padding: EdgeInsets.all(10.sp),
            margin: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 12.0.sp,
                left: 65.sp,
            right: 20.sp),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.sp)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 25.0.sp,
                      height: 25.0.sp,
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColor.gray6,
                      ),
                      child: AppImageWidget.asset(path: AppImage.icFrom),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        controller.fromAdd.value,
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                        style: const TextStyle(
                          color: Color(0xFF5E5E5E),
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.sp,),
                Row(
                  children: [
                    Container(
                      width: 25.0.sp,
                      height: 25.0.sp,
                      padding: const EdgeInsets.all(3),
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColor.gray6,
                      ),
                      child: AppImageWidget.asset(path: AppImage.icTo),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        controller.toAdd.value,
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                        style: const TextStyle(
                          color: Color(0xFF5E5E5E),
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.sp,),
                Row(
                  children: [
                    AppImageWidget.asset(
                      path: AppImage.icType,
                      height: 25.sp,
                    ),
                    SizedBox(
                      width: 16.sp,
                    ),
                    AppImageWidget.asset(
                      path: controller.selectedFamousModel.value.asset,
                      height: 20.sp,
                    ),
                    SizedBox(
                      width: 10.sp,
                    ),
                    Text(
                      controller.selectedFamousModel.value.name,
                      style: const TextStyle(
                        color: Color(0xFF5E5E5E),
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Obx(
            () => controller.isLoadingDataPlaces.value
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColor.primaryColor,
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
