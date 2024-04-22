import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:travel/app/controller/loading_ads_controller.dart';
import 'package:travel/app/ui/widget/app_container.dart';

import '../theme/app_color.dart';

class LoadingAdsScreen extends GetView<LoadingAdsController>{
  const LoadingAdsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AppContainer(
      showBanner: false,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CupertinoActivityIndicator(
              color: AppColor.blueCF6,
            ),
            SizedBox(height: 10.sp,),
            Text('Loading Ads',style:TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w500,
              color: AppColor.blueCF6,
            ),)
          ],
        ),
      ),
    );
  }

}