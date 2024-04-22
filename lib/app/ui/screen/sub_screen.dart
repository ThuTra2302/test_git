import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:travel/app/ui/widget/app_image_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controller/app_controller.dart';
import '../../res/image/app_image.dart';
import '../../res/string/app_strings.dart';
import '../../util/app_util.dart';
import '../../util/disable_glow_behavior.dart';
import '../theme/app_color.dart';
import '../widget/app_container.dart';
import '../widget/app_touchable3.dart';
import '../widget/gradient_border.dart';
import '../widget/shake_widget.dart';

class SubScreen extends StatefulWidget {
  const SubScreen({Key? key}) : super(key: key);

  @override
  State<SubScreen> createState() => _SubScreenState();
}

class _SubScreenState extends State<SubScreen> {
  bool isWeekly = false;
  bool isMonth = false;
  bool isYearly = true;

  bool isWait = true;
  bool isLoading = false;

  ProductDetails productDetailsWeek = ProductDetails(
      title: '',
      id: '',
      currencyCode: '',
      description: '',
      price: '',
      rawPrice: 0.0);

  ProductDetails productDetailsMonth = ProductDetails(
      title: '',
      id: '',
      currencyCode: '',
      description: '',
      price: '',
      rawPrice: 0.0);

  ProductDetails productDetailsYear = ProductDetails(
      title: '',
      id: '',
      currencyCode: '',
      description: '',
      price: '',
      rawPrice: 0.0);

  String priceWeekDisplay = "";
  String priceMonthDisplay = "";
  String priceYearDisplay = "";

  double onlyWeek = 0.0;

  int saveVale = 0;

  Widget _groupButtonWidget() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6.0.sp),
      margin: EdgeInsets.symmetric(horizontal: 24.0.sp),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SubscribeButton(
                onPressed: () => onPressWeek(),
                width: Get.width / 2.5,
                isSelect: isWeekly,
                padding: EdgeInsets.zero,
                margin: EdgeInsets.zero,
                height: 140.sp,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 10.0.sp, vertical: 30.sp),
                  child: Column(
                    children: [
                      Text(
                        chooseContentByLanguage("Weekly", "Tuần"),
                        style: TextStyle(
                          color: const Color(0xFF12203A).withOpacity(0.5),
                          fontWeight: FontWeight.w600,
                          fontSize: 24.0.sp,
                        ),
                      ),
                      SizedBox(
                        height: 10.sp,
                      ),
                      Expanded(
                        child: Text(
                          priceWeekDisplay,
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            color: AppColor.black333,
                            fontWeight: FontWeight.w500,
                            fontSize: 28.0.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: Get.width * 0.02),
              Stack(
                alignment: Alignment.topRight,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 16.0.sp),
                    child: SubscribeButton(
                      onPressed: () => onPressYear(),
                      padding: EdgeInsets.zero,
                      margin: EdgeInsets.zero,
                      width: Get.width / 2.5,
                      height: 152.sp,
                      isSelect: isYearly,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.0.sp),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 20.sp,
                            ),
                            Text(
                              chooseContentByLanguage("Yearly", "Năm"),
                              style: TextStyle(
                                color: const Color(0xFF424242),
                                fontWeight: FontWeight.w700,
                                fontSize: 24.0.sp,
                              ),
                            ),
                            SizedBox(
                              height: 10.sp,
                            ),
                            Expanded(
                              child: Text(
                                textAlign: TextAlign.center,
                                chooseContentByLanguage(
                                  priceYearDisplay,
                                  "Chỉ / Tuần",
                                ),
                                style: TextStyle(
                                  color: const Color(0xFFFF8552),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 31.0.sp,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                textAlign: TextAlign.center,
                                chooseContentByLanguage(
                                  "Just ${onlyWeek.toStringAsFixed(2)}/week",
                                  "Chỉ / Tuần",
                                ),
                                style: TextStyle(
                                  color:
                                      const Color(0xFF12203A).withOpacity(0.5),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.0.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF8552),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(18.0.sp),
                          bottomRight: Radius.circular(18.0.sp),
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.0.sp,
                        vertical: 4.0.sp,
                      ),
                      child: Text(
                        "Save $saveVale%",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
          SizedBox(height: Get.height * 0.02),
          ShakeWidget(
            shakeOffset: 10,
            child: AppTouchable3(
              onPressed: onSubscribed,
              rippleColor: Colors.transparent,
              child: Container(
                width: Get.width,
                padding: EdgeInsets.zero,
                margin: EdgeInsets.zero,
                decoration: const BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Color(0xFF3388F2),
                ),
                child: isLoading
                    ? SizedBox(
                        height: 60.sp,
                        width: 32.sp,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColor.white,
                            strokeWidth: 2.sp,
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Continue",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 24.0.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      showBanner: false,
      backgroundColor: AppColor.gray2F7,
      child: Container(
        margin: EdgeInsets.only(
          bottom: 10.0.h,
        ),
        child: Stack(
          children: [
            SizedBox(
              height: Get.height,
              child: ScrollConfiguration(
                behavior: DisableGlowBehavior(),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).padding.top + 4.0.sp),
                      AppImageWidget.asset(
                        path: AppImage.imgSub,
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 80.0.sp),
                            child: AppImageWidget.asset(
                              path: AppImage.titleSub,
                            ),
                          ),
                          SizedBox(height: Get.height * 0.015),
                          SubtitleLine(content: StringConstants.subHint1.tr),
                          SubtitleLine(content: StringConstants.subHint2.tr),
                          SubtitleLine(content: StringConstants.subHint3.tr),
                          SubtitleLine(content: StringConstants.subHint4.tr),
                          SizedBox(height: Get.height * 0.02),
                          _groupButtonWidget(),
                          SizedBox(height: Get.height * 0.02),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.0.sp),
                            child: Text(
                              StringConstants.descriptionSub.trParams({
                                "priceOfMonth": productDetailsWeek.price == ''
                                    ? '\$7.99'
                                    : productDetailsWeek.price,
                                "priceOfYear": productDetailsYear.price == ''
                                    ? '\$39.99'
                                    : productDetailsYear.price,
                              }),
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontSize: 11.0.sp,
                                color: AppColor.grayE93,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          SizedBox(height: Get.height * 0.03),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: onPressPrivacy,
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 4.0.sp,
                                    horizontal: 8.0.sp,
                                  ),
                                  child: Text(
                                    StringConstants.privacy.tr,
                                    style: TextStyle(
                                      fontSize: 14.0.sp,
                                      color: AppColor.grayE93,
                                      fontWeight: FontWeight.w400,
                                      height: 14 / 18,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: 1.0.sp,
                                height: 20.0.sp,
                                decoration: const BoxDecoration(
                                  color: AppColor.grayE93,
                                  shape: BoxShape.rectangle,
                                ),
                              ),
                              InkWell(
                                onTap: onPressTerm,
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 4.0.sp,
                                    horizontal: 8.0.sp,
                                  ),
                                  child: Text(
                                    StringConstants.termOfCondition.tr,
                                    style: TextStyle(
                                      fontSize: 14.0.sp,
                                      color: AppColor.grayE93,
                                      fontWeight: FontWeight.w400,
                                      height: 14 / 18,
                                    ),
                                  ),
                                ),
                              ),
                              // InkWell(
                              //   onTap: onPressRestore,
                              //   child: Padding(
                              //     padding:
                              //         EdgeInsets.symmetric(vertical: 4.0.sp, horizontal: 8.0.sp),
                              //     child: Text(
                              //       StringConstants.restore.tr,
                              //       style: TextStyle(
                              //         fontSize: 14.0.sp,
                              //         color: AppColor.black,
                              //         fontWeight: FontWeight.w400,
                              //         height: 14 / 18,
                              //         decoration: TextDecoration.underline,
                              //       ),
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                          SizedBox(height: Get.height * 0.02),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Row(
              children: [
                InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: Get.back,
                  child: isWait
                      ? const SizedBox(
                          height: 20,
                        )
                      : Container(
                          margin: EdgeInsets.only(
                            left: 12.0.sp,
                            top: MediaQuery.of(context).padding.top + 8.0.h,
                          ),
                          padding: EdgeInsets.all(8.sp),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColor.blueCF6,
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    productDetailsWeek =
        Get.find<AppController>().listProductDetailsSub.firstWhere(
              (element) =>
                  element.id == 'com.roadtrippers.weather.activity.week',
              orElse: () => ProductDetails(
                title: '',
                id: '',
                currencyCode: '',
                description: '',
                price: '',
                rawPrice: 0.0,
              ),
            );
    priceWeekDisplay =
        productDetailsWeek.price == '' ? "\$7.99" : productDetailsWeek.price;

    productDetailsMonth =
        Get.find<AppController>().listProductDetailsSub.firstWhere(
              (element) =>
                  element.id == 'com.roadtrippers.weather.activity.month',
              orElse: () => ProductDetails(
                title: '',
                id: '',
                currencyCode: '',
                description: '',
                price: '',
                rawPrice: 0.0,
              ),
            );

    productDetailsYear =
        Get.find<AppController>().listProductDetailsSub.firstWhere(
              (element) =>
                  element.id == 'com.roadtrippers.weather.activity.year',
              orElse: () => ProductDetails(
                title: '',
                id: '',
                currencyCode: '',
                description: '',
                price: '',
                rawPrice: 0.0,
              ),
            );

    priceYearDisplay =
        productDetailsYear.price == '' ? "\$39.99" : productDetailsYear.price;

    double rawPriceWeek =
        productDetailsWeek.rawPrice == 0.0 ? 7.99 : productDetailsWeek.rawPrice;
    double rawPriceYear = productDetailsYear.rawPrice == 0.0
        ? 39.99
        : productDetailsYear.rawPrice;

    saveVale =
        (((rawPriceWeek - (rawPriceYear / 48)) / rawPriceWeek) * 100).round();
    onlyWeek = rawPriceYear / 48;

    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        isWait = false;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onPressPrivacy() {
    _openLink('https://appvillage.com.vn/privacy.txt');
  }

  void onPressTerm() {
    _openLink('https://appvillage.com.vn/privacy.txt');
  }

  void _openLink(String url) async {
    Uri uri = Uri.parse(url);
    await canLaunchUrl(uri)
        ? await launchUrl(uri)
        : throw 'Could not launch $url';
  }

  void onPressRestore() async {
    setState(() {
      isLoading = true;
    });
    await InAppPurchase.instance.restorePurchases();
    setState(() {
      isLoading = false;
    });

    showToast(StringConstants.restoreSuccessful.tr);
  }

  Future<void> onSubscribed() async {
    if (isLoading) {
      return;
    }

    if (Get.find<AppController>().rxPurchaseStatus.value ==
        PurchaseStatus.pending) {
      FirebaseAnalytics.instance.logEvent(name: 'on Subscription');
      setState(() {
        isLoading = true;
      });
    }

    String str = isWeekly
        ? "com.roadtrippers.weather.activity.week"
        : isMonth
            ? "com.roadtrippers.weather.activity.month"
            : "com.roadtrippers.weather.activity.year";
    await Get.find<AppController>().onPressPremiumByProduct(str);

    if (Get.find<AppController>().rxPurchaseStatus.value !=
        PurchaseStatus.pending) {
      if (Get.find<AppController>().rxPurchaseStatus.value ==
          PurchaseStatus.canceled) {
        FirebaseAnalytics.instance.logEvent(name: 'on Canceled Subscription');
      } else if (Get.find<AppController>().rxPurchaseStatus.value ==
          PurchaseStatus.purchased) {
        FirebaseAnalytics.instance.logEvent(name: 'on Completed Subscription');
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  bool isNullEmpty(Object? o) => o == null || "" == o || o == "null";

  void onPressWeek() {
    FirebaseAnalytics.instance.logEvent(name: 'btn_sub_weekly');
    setState(() {
      isWeekly = true;
      isMonth = false;
      isYearly = false;
    });
  }

  void onPressMonth() {
    FirebaseAnalytics.instance.logEvent(name: 'btn_sub_monthly');
    setState(() {
      isWeekly = false;
      isMonth = true;
      isYearly = false;
    });
  }

  void onPressYear() {
    FirebaseAnalytics.instance.logEvent(name: 'btn_sub_yearly');
    setState(() {
      isWeekly = false;
      isMonth = false;
      isYearly = true;
    });
  }
}

class SubscribeButton extends StatelessWidget {
  final Function()? onPressed;
  final Widget child;
  final double? width, height;
  final bool isSelect;
  final EdgeInsets? padding, margin;

  const SubscribeButton({
    super.key,
    this.onPressed,
    required this.child,
    this.height,
    required this.isSelect,
    this.width,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return !isSelect
        ? InkWell(
            onTap: onPressed,
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            child: Container(
              width: width ?? Get.width / 2.5,
              height: height ?? 60.sp,
              padding: padding ??
                  EdgeInsets.symmetric(
                    horizontal: 8.sp,
                    vertical: 4.sp,
                  ),
              margin: margin ??
                  EdgeInsets.symmetric(
                    horizontal: 40.0.sp,
                  ),
              decoration: BoxDecoration(
                borderRadius: BorderRadiusDirectional.all(
                  Radius.circular(14.0.sp),
                ),
                color: AppColor.white,
              ),
              child: child,
            ),
          )
        : GradientBorderButton(
            onPressed: onPressed,
            strokeWidth: 2.0.sp,
            width: width ?? Get.width,
            height: height ?? 60.sp,
            padding: padding ??
                EdgeInsets.symmetric(
                  horizontal: 8.sp,
                  vertical: 4.sp,
                ),
            margin: margin ??
                EdgeInsets.symmetric(
                  horizontal: 40.0.sp,
                ),
            gradient: const LinearGradient(
              colors: [
                Color(0xFFFF8552),
                Color(0xFFFFBC9F),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            radius: 14.0.sp,
            child: Container(
              margin: EdgeInsets.all(2.0.sp),
              decoration: BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.circular(14.0.sp),
              ),
              child: child,
            ),
          );
  }
}

class SubtitleLine extends StatelessWidget {
  final String content;
  final EdgeInsets? padding;

  const SubtitleLine({Key? key, required this.content, this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ??
          EdgeInsets.only(
            left: 60.0.sp,
            top: 6.0.sp,
          ),
      child: Row(
        children: [
          AppImageWidget.asset(
            path: AppImage.ic_check,
          ),
          SizedBox(width: 8.0.sp),
          Expanded(
            child: Text(
              content,
              style: TextStyle(
                fontSize: 16.0.sp,
                color: AppColor.black333,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
