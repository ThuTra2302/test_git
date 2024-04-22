import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:travel/app/ui/theme/app_color.dart';

import '../../res/image/app_image.dart';
import 'app_image_widget.dart';
import 'dot.dart';

class ItemList extends StatelessWidget {
  final String addressTo, addressFrom;
  final Function()? onPressed;

  const ItemList(
      {Key? key,
      required this.addressTo,
      required this.addressFrom,
      this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        margin: EdgeInsets.symmetric(vertical: 10.0.sp, horizontal: 24.0.sp),
        decoration: BoxDecoration(
          color: AppColor.white,
          shape: BoxShape.rectangle,
          borderRadius: const BorderRadius.all(Radius.circular(20)),

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
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColor.gray6,
                  ),
                  child: AppImageWidget.asset(path: AppImage.icFrom),
                ),
                const SizedBox(width: 16),
                Flexible(
                  child: Text(
                    addressFrom,
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                    style: const TextStyle(
                        color: Color(0xFF5E5E5E),
                        fontWeight: FontWeight.w400,
                        fontSize: 16),
                  ),
                ),
              ],
            ),
           Row(
             children: [
               SizedBox(width: 30.sp,),
               Column(
                 children: [
                   Dot(
                       size: 3,
                       margin: EdgeInsets.symmetric(
                           vertical: 1.5, horizontal: 12.5.sp - 2)),
                   Dot(
                       size: 3,
                       margin: EdgeInsets.symmetric(
                           vertical: 1.5, horizontal: 12.5.sp - 2)),
                   Dot(
                       size: 3,
                       margin: EdgeInsets.symmetric(
                           vertical: 1.5, horizontal: 12.5.sp - 2)),
                 ],
               )
             ],
           ),
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
                Flexible(
                  child: Text(
                    addressTo,
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                    style: const TextStyle(
                        color: Color(0xFF5E5E5E),
                        fontWeight: FontWeight.w400,
                        fontSize: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
