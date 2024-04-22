import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../controller/app_controller.dart';
import '../../../res/image/app_image.dart';
import '../../../res/string/app_strings.dart';
import '../../../util/disable_glow_behavior.dart';
import '../../theme/app_color.dart';
import '../app_button.dart';
import 'rating_bar.dart';

class RatingWidget extends StatefulWidget {
  const RatingWidget({Key? key}) : super(key: key);

  @override
  State<RatingWidget> createState() => _RatingWidgetState();
}

class _RatingWidgetState extends State<RatingWidget> {
  double _rating = 5.0;

  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: AlertDialog(
            elevation: 0.0,
            insetPadding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  30.0.sp,
                ),
              ),
            ),
            contentPadding: const EdgeInsets.only(
              top: 10.0,
            ),
            content: _rating > 3.0
                ? SizedBox(
                    height: Get.height * 0.3,
                    width: Get.width * 0.85,
                    child: Column(
                      children: [
                        SizedBox(height: Get.height * 0.01),
                        Text(
                          StringConstants.rate.tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColor.black,
                            fontSize: 20.0.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: Get.height * 0.03),
                        RatingBar.builder(
                          initialRating: _rating,
                          minRating: 0,
                          direction: Axis.horizontal,
                          itemCount: 5,
                          itemSize: 50.0,
                          itemPadding: EdgeInsets.symmetric(horizontal: 1.0.sp),
                          itemBuilder: (context, _) => SvgPicture.asset(
                            AppImage.selectedStar,
                          ),
                          onRatingUpdate: (rating) {
                            setState(() {
                              _rating = rating;
                            });
                          },
                          updateOnDrag: true,
                        ),
                        SizedBox(height: Get.height * 0.06),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppButton(
                              onPressed: () => Get.back(),
                              text: "Close",
                              textColor: AppColor.red,
                              color: AppColor.whiteBG,
                              radius: 10.0.sp,
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(-6.0.sp, -6.0.sp),
                                  blurRadius: 10.0.sp,
                                  spreadRadius: 0,
                                  color: AppColor.white,
                                ),
                                BoxShadow(
                                  offset: Offset(5.0.sp, 5.0.sp),
                                  blurRadius: 10.0.sp,
                                  spreadRadius: 0,
                                  color: const Color(0xFFBFC9D7),
                                ),
                              ],
                            ),
                            SizedBox(width: Get.width * 0.06),
                            AppButton(
                              onPressed: () async {
                                final prefs = await SharedPreferences.getInstance();
                                prefs.setBool("first_rate", false);
                                Get.find<AppController>().isFirstRate = false;

                                const appId = 'com.roadtrippers.weather.activity.notes';
                                final url = Uri.parse("market://details?id=$appId");
                                launchUrl(
                                  url,
                                  mode: LaunchMode.externalApplication,
                                );

                                Get.back();
                              },
                              text: "Send",
                              textColor: AppColor.primaryColor,
                              color: AppColor.whiteBG,
                              radius: 10.0.sp,
                              fontWeight: FontWeight.w400,
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(-6.0.sp, -6.0.sp),
                                  blurRadius: 10.0.sp,
                                  spreadRadius: 0,
                                  color: AppColor.white,
                                ),
                                BoxShadow(
                                  offset: Offset(5.0.sp, 5.0.sp),
                                  blurRadius: 10.0.sp,
                                  spreadRadius: 0,
                                  color: const Color(0xFFBFC9D7),
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  )
                : ScrollConfiguration(
                    behavior: DisableGlowBehavior(),
                    child: SingleChildScrollView(
                      child: SizedBox(
                        width: Get.width * 0.9,
                        child: Column(
                          children: [
                            SizedBox(height: Get.height * 0.01),
                            Text(
                              StringConstants.rate.tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColor.black,
                                fontSize: 20.0.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: Get.height * 0.03),
                            RatingBar.builder(
                              initialRating: _rating,
                              minRating: 0,
                              direction: Axis.horizontal,
                              itemCount: 5,
                              itemSize: 50.0,
                              itemPadding: EdgeInsets.symmetric(horizontal: 1.0.sp),
                              itemBuilder: (context, _) => SvgPicture.asset(
                                AppImage.selectedStar,
                              ),
                              onRatingUpdate: (rating) {
                                setState(() {
                                  _rating = rating;
                                });
                              },
                              updateOnDrag: true,
                            ),
                            SizedBox(height: Get.height * 0.04),
                            Container(
                              width: Get.width * 0.65,
                              height: Get.height * 0.15,
                              decoration: BoxDecoration(
                                color: const Color(0xFFD9D9D9),
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.all(Radius.circular(12.0.sp)),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12.0.sp),
                                child: TextField(
                                  controller: myController,
                                  maxLines: 6,
                                  keyboardType: TextInputType.multiline,
                                  textInputAction: TextInputAction.send,
                                  decoration:
                                      InputDecoration(border: InputBorder.none, hintText: StringConstants.hintRate.tr),
                                ),
                              ),
                            ),
                            SizedBox(height: Get.height * 0.04),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AppButton(
                                  onPressed: () => Get.back(),
                                  text: "Close",
                                  textColor: AppColor.red,
                                  color: AppColor.whiteBG,
                                  radius: 10.0.sp,
                                  boxShadow: [
                                    BoxShadow(
                                      offset: Offset(-6.0.sp, -6.0.sp),
                                      blurRadius: 10.0.sp,
                                      spreadRadius: 0,
                                      color: AppColor.white,
                                    ),
                                    BoxShadow(
                                      offset: Offset(5.0.sp, 5.0.sp),
                                      blurRadius: 10.0.sp,
                                      spreadRadius: 0,
                                      color: const Color(0xFFBFC9D7),
                                    ),
                                  ],
                                ),
                                SizedBox(width: Get.width * 0.06),
                                AppButton(
                                  onPressed: () async {
                                    FirebaseAnalytics.instance.logEvent(
                                      name: "review",
                                      parameters: {
                                        "content_type": "String",
                                        "rate_comment": myController.text,
                                      },
                                    );

                                    FirebaseAnalytics.instance.logEvent(
                                      name: "rate_review",
                                      parameters: {
                                        "content_type": "String",
                                        "rate_comment": myController.text,
                                      },
                                    );

                                    FirebaseAnalytics.instance.logEvent(
                                      name: "review_rate",
                                      parameters: {
                                        "content_type": "String",
                                        "rate_comment": myController.text,
                                      },
                                    );

                                    FirebaseAnalytics.instance.logEvent(name: 'review');

                                    FirebaseAnalytics.instance.logEvent(name: 'rate_review');

                                    FirebaseAnalytics.instance.logEvent(
                                      name: 'review_rate',
                                    );

                                    final prefs = await SharedPreferences.getInstance();
                                    prefs.setBool("first_rate", false);
                                    Get.find<AppController>().isFirstRate = false;

                                    Get.back();
                                  },
                                  text: "Send",
                                  textColor: AppColor.primaryColor,
                                  color: AppColor.whiteBG,
                                  radius: 10.0.sp,
                                  fontWeight: FontWeight.w400,
                                  boxShadow: [
                                    BoxShadow(
                                      offset: Offset(-6.0.sp, -6.0.sp),
                                      blurRadius: 10.0.sp,
                                      spreadRadius: 0,
                                      color: AppColor.white,
                                    ),
                                    BoxShadow(
                                      offset: Offset(5.0.sp, 5.0.sp),
                                      blurRadius: 10.0.sp,
                                      spreadRadius: 0,
                                      color: const Color(0xFFBFC9D7),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            SizedBox(height: Get.height * 0.04),
                          ],
                        ),
                      ),
                    ))),
        onWillPop: () async => false);
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }
}
