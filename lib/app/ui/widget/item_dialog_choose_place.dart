import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:travel/app/res/image/app_image.dart';

import 'app_image_widget.dart';

class ItemDialogChooseOfPlace extends StatelessWidget {
  final String pathIcon;
  final String title;
  final Function()? onTap;
  final bool? isLock;

  const ItemDialogChooseOfPlace({Key? key, required this.pathIcon, required this.title, this.onTap, this.isLock = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  AppImageWidget.asset(path: pathIcon, height: 24.0.sp, width: 24.0.sp),
                  const SizedBox(width: 6),
                  Expanded(
                      child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: const Color(0xFF5D5D5D),
                      fontSize: 14.0.sp,
                      fontWeight: FontWeight.w300,
                    ),
                  )),
                  isLock == true
                      ? AppImageWidget.asset(path: AppImage.icLock, height: 24.0.sp, width: 24.0.sp)
                      : SizedBox(height: 24.0.sp, width: 24.0.sp)
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Divider(height: 1, thickness: 2, color: Color(0xFFD9D9D9))
          ],
        ),
      ),
    );
  }
}
