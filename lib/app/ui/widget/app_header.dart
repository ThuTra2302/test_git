import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../res/image/app_image.dart';
import '../theme/app_color.dart';
import 'app_image_widget.dart';
import 'app_touchable.dart';

class AppHeader extends StatelessWidget {
  final String? title;
  final String? hintContent;
  final String? hintTitle;
  final Widget? leftWidget;
  final Widget? rightWidget;
  final Widget? middleWidget;
  final Widget? extendWidget;
  final CrossAxisAlignment? crossAxisAlignmentMainRow;
  final String? backgroundAsset;

  const AppHeader({
    Key? key,
    this.title,
    this.leftWidget,
    this.rightWidget,
    this.middleWidget,
    this.extendWidget,
    this.crossAxisAlignmentMainRow,
    this.hintContent,
    this.hintTitle,
    this.backgroundAsset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        0.0,
        MediaQuery.of(context).padding.top + 16.0.sp,
        0.0,
        16.0.sp,
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16.0.sp,
            ),
            child: Row(
              crossAxisAlignment:
                  crossAxisAlignmentMainRow ?? CrossAxisAlignment.center,
              children: [
                leftWidget ??
                    AppTouchable(
                      width: 40.0.sp,
                      height: 40.0.sp,
                      padding: EdgeInsets.all(2.0.sp),
                      onPressed: Get.back,
                      borderRadius: BorderRadius.circular(22.0.sp),
                      child: Container(
                        width: 45.sp,
                        height: 45.sp,
                        padding: EdgeInsets.all(6.sp),
                        decoration: const ShapeDecoration(
                          color: Color(0xFF70ACF6),
                          shape: OvalBorder(),
                        ),
                        child: AppImageWidget.asset(
                          path: AppImage.ic_back,
                          height: 24.sp,
                          color: AppColor.white,
                        ),
                      ),
                    ),
                Expanded(
                  child: middleWidget ??
                      Text(
                        title ?? '',
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20.0.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColor.black333,
                        ),
                      ),
                ),
                rightWidget ?? SizedBox(width: 40.0.sp),
              ],
            ),
          ),
          extendWidget ?? const SizedBox.shrink(),
        ],
      ),
    );
  }
}
