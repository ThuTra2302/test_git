import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_webservice/places.dart';

import '../../controller/map_location_controller.dart';
import '../../res/image/app_image.dart';
import '../../util/app_util.dart';
import '../theme/app_color.dart';
import '../widget/app_container.dart';
import '../widget/app_image_widget.dart';
import '../widget/app_touchable3.dart';

class LocationSearchScreen extends GetView<MapLocationController> {
  const LocationSearchScreen({super.key});

  Widget buildTextField(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12.0.sp,
        right: 20.sp,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(40.sp),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            offset: const Offset(0, 0),
            blurRadius: 1,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            offset: const Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Obx(
        () => TextField(
          controller: controller.textEditingControllerSearch,
          keyboardType: TextInputType.text,
          autofocus: true,
          showCursor: true,
          cursorColor: AppColor.black333,
          cursorWidth: 1.5.sp,
          cursorRadius: Radius.circular(24.0.sp),
          onChanged: (value) {
            controller.onChangedSearch(value);
          },
          maxLines: 1,
          style: TextStyle(
            color: AppColor.black,
            fontWeight: FontWeight.w500,
            fontSize: 16.0.sp,
          ),
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(left: 25.sp),
            filled: true,
            suffixIcon: !controller.showClearButton.value
                ? null
                : controller.isLoadingPlaceSearch.value
                    ? const CupertinoActivityIndicator()
                    : IconButton(
                        icon: const Icon(
                          Icons.cancel_outlined,
                          size: 24,
                          color: AppColor.grayE93,
                        ),
                        onPressed: controller.clearTextField,
                      ),
            hintStyle: TextStyle(
              color: AppColor.grayC43.withOpacity(0.6),
              fontWeight: FontWeight.w500,
              fontSize: 16.0.sp,
            ),
            hintText: "Your search location",
            fillColor: Colors.white,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColor.gray2F7,
                width: 1.0.sp,
              ),
              borderRadius: BorderRadius.circular(40.0.sp),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColor.gray2F7,
                width: 1.0.sp,
              ),
              borderRadius: BorderRadius.circular(40.0.sp),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSuggestList() {
    return Expanded(
      child: Obx(
            () => ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: controller.listPredictionSuggestSearch.length,
          itemBuilder: (context, index) {
            Prediction? option = controller.listPredictionSuggestSearch.elementAt(index);

            return Container(
              width: Get.width,
              margin: EdgeInsets.only(
                left: 12.0.sp,
                right: 12.0.sp,
                top: 8.0.sp,
                bottom: 8.0.sp,
              ),
              child: AppTouchable3(
                onPressed: () {
                  log('$option');

                  controller.textEditingControllerSearch.text =
                      option.description ?? '';
                  controller.listPredictionSuggestSearch.value = [];

                  controller.onPressSearchDialog();
                },
                child: Column(
                  children: [
                    Row(
                      children: [
                        AppImageWidget.asset(
                          path: AppImage.ic_location1,
                          width: 24.0.sp,
                          height: 24.0.sp,
                        ),
                        SizedBox(
                          width: 8.0.sp,
                        ),
                        Expanded(
                          child: Text(
                            option.description ?? '',
                            style: TextStyle(
                              color: AppColor.black333,
                              fontSize: 15.0.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 8.0.sp,
                        ),
                        AppImageWidget.asset(
                          path: AppImage.icSend,
                          width: 24.0.sp,
                          height: 24.0.sp,
                        ),
                        SizedBox(
                          width: 8.0.sp,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 12.0.sp,
                    ),
                    Container(
                      width: Get.width,
                      height: 1.0.sp,
                      decoration: const BoxDecoration(
                        color: AppColor.gray2F7,
                        shape: BoxShape.rectangle,
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      backgroundColor: AppColor.grayFF9,
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(width: 20.sp,),
              Container(
                padding: EdgeInsets.all(8.sp),
                margin: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 12.0.sp,
                ),
                decoration: const BoxDecoration(
                  color: AppColor.blueCF6,
                  shape: BoxShape.circle,
                ),
                child: AppTouchable3(
                  onPressed: Get.back,
                  child: AppImageWidget.asset(
                    path: AppImage.ic_back,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: 10.sp,),
              Expanded(child: buildTextField(context)),
            ],
          ),
          SizedBox(
            height: 16.0.sp,
          ),
          buildSuggestList(),
        ],
      ),
    );
  }
}
