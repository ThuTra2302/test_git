import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:travel/app/ads/interstitial_ad_manager.dart';
import 'package:travel/app/ads/native_ads_widget.dart';
import 'package:travel/app/controller/app_controller.dart';
import 'package:travel/app/controller/main_controller.dart';
import 'package:travel/app/extension/int_temp.dart';
import 'package:travel/app/res/image/app_image.dart';
import 'package:travel/app/ui/theme/app_color.dart';
import 'package:travel/app/ui/widget/app_image_widget.dart';

import '../../ads/widget_xml/small_native_ads_widget.dart';
import '../../common/remote_config.dart';
import '../../route/app_route.dart';
import '../../util/disable_glow_behavior.dart';
import '../widget/app_container.dart';
import '../widget/app_dialog.dart';
import '../widget/app_touchable3.dart';
import 'sub_screen.dart';

class MainScreen extends GetView<MainController> {
  const MainScreen({Key? key}) : super(key: key);

  Widget _buildWeatherInfoLoading() {
    return Column(
      key: const ValueKey(0),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16.0.sp),
        SizedBox(width: 16.0.sp),
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 50.0.sp,
            width: Get.height / 30 * 7,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0.sp),
              color: AppColor.primaryColor,
            ),
          ),
        ),
        SizedBox(height: 100.0.sp),
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: Get.height / 30 * 7,
            height: 50.0.sp,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0.sp),
              color: AppColor.primaryColor,
            ),
          ),
        ),
        SizedBox(height: 16.0.sp),
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 70.0.sp,
            width: Get.width * 7 / 8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0.sp),
              color: AppColor.primaryColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeInfo(BuildContext context) {
    return Column(
      key: const ValueKey(1),
      children: [
        SizedBox(
          height: MediaQuery.of(context).padding.top + 12.0.sp,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(width: 16.0.sp),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat(
                            'EEEE, dd MMMM yyyy',
                            Get.find<AppController>()
                                .currentLocale
                                .languageCode)
                        .format(DateTime.now()),
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: AppColor.white,
                      fontSize: 18.0.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Get.find<AppController>().isPremium.value
                      ? const SizedBox.shrink()
                      : SizedBox(
                          height: 40.sp,
                        ),
                ],
              ),
            ),
            Column(
              children: [
                Obx(
                  () => Get.find<AppController>().isPremium.value
                      ? const SizedBox.shrink()
                      : Column(
                          children: [
                            AppTouchable3(
                              onPressed: () {
                                Get.to(() => const SubScreen());
                              },
                              width: 40.0.sp,
                              height: 40.0.sp,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(6.0),
                              child: AppImageWidget.asset(
                                path: AppImage.lottiePremium,
                              ),
                            ),
                            SizedBox(
                              height: 8.sp,
                            ),
                          ],
                        ),
                ),
                AppTouchable3(
                  onPressed: () {
                    if (!Get.find<AppController>().isPremium.value) {
                      showInterstitialAds(
                          () => Get.toNamed(AppRoute.settingScreen));
                    } else {
                      Get.toNamed(AppRoute.settingScreen);
                    }
                  },
                  child: Container(
                    width: 40.0.sp,
                    height: 40.0.sp,
                    padding: EdgeInsets.all(8.0.sp),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: AppImageWidget.asset(
                      path: AppImage.ic_setting,
                      width: 24.0.sp,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: 16.0.sp),
          ],
        ),
        SizedBox(height: 12.0.sp),
      ],
    );
  }

  Widget _buildWeatherInfo() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
              width: 12.sp,
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 2.sp,
                    ),
                    AppImageWidget.asset(
                      path: AppImage.ic_location,
                      width: 20.0.sp,
                    ),
                    SizedBox(width: 8.0.sp),
                    SizedBox(
                      width: Get.width * 0.35,
                      child: Text(
                        controller.dataLocation ?? '---',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColor.white,
                          fontSize: 16.0.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 70.sp,
                ),
                Obx(
                  () => SizedBox(
                    width: Get.width / 2.3,
                    child: Row(
                      children: [
                        AppTouchable3(
                          onPressed: () {
                            controller.chooseC.value = true;
                            Get.find<MainController>()
                                .onPressUnitTemp(UnitTypeTemp.c);

                            controller.feelLikeTemp.value = (controller
                                    .dataWeather?.apparentTemperature
                                    .round() as int)
                                .toUnit(Get.find<AppController>()
                                    .currentUnitTypeTemp
                                    .value);
                          },
                          child: Container(
                            height: 42.sp,
                            width: 42.sp,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14.sp),
                                color: controller.chooseC.value
                                    ? Colors.white.withOpacity(0.3)
                                    : null),
                            child: Text(
                              'C°',
                              style: TextStyle(
                                color: controller.chooseC.value
                                    ? Colors.white
                                    : const Color(0xFFFCFBF6).withOpacity(0.6),
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10.sp,
                        ),
                        AppTouchable3(
                          onPressed: () {
                            controller.chooseC.value = false;
                            Get.find<MainController>()
                                .onPressUnitTemp(UnitTypeTemp.f);

                            controller.feelLikeTemp.value = (controller
                                    .dataWeather?.apparentTemperature
                                    .round() as int)
                                .toUnit(Get.find<AppController>()
                                    .currentUnitTypeTemp
                                    .value);
                          },
                          child: Container(
                            height: 42.sp,
                            width: 42.sp,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14.sp),
                                color: !controller.chooseC.value
                                    ? Colors.white.withOpacity(0.3)
                                    : null),
                            child: Text(
                              'F°',
                              style: TextStyle(
                                color: !controller.chooseC.value
                                    ? Colors.white
                                    : const Color(0xFFFCFBF6).withOpacity(0.6),
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            Expanded(
              child: AppImageWidget.asset(
                path: (controller.dataWeather?.icon ?? '').isEmpty
                    ? 'lib/app/res/image/png/partly-cloudy-day.png'
                    : 'lib/app/res/image/png/${controller.dataWeather?.icon ?? ''}.png',
                width: Get.width / 2,
                height: Get.width / 2.5,
              ),
            ),
          ],
        ),
        Row(
          children: [
            SizedBox(
              width: 20.sp,
            ),
            Container(
              constraints: BoxConstraints(
                maxWidth: Get.width / 2,
                minWidth: 1,
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(() {
                      UnitTypeTemp u =
                          Get.find<AppController>().currentUnitTypeTemp.value;
                      return RichText(
                        text: TextSpan(
                          text: controller.dataWeather?.temperature == null
                              ? '--'
                              : '${controller.valueInC.value.toUnit(u)}',
                          style: TextStyle(
                            color: AppColor.white,
                            fontSize: 80.0.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: '°',
                              style: TextStyle(
                                fontSize: 70.0.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            TextSpan(
                              text: u.name.toUpperCase(),
                              style: TextStyle(fontSize: 72.0.sp),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 60.sp,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: 12.sp,
                ),
                Text(
                  "Feel like",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 18.0.sp,
                  ),
                ),
                SizedBox(
                  height: 6.0.sp,
                ),
                Obx(
                  () => FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "${controller.feelLikeTemp} °${Get.find<AppController>().currentUnitTypeTemp.value.name.toUpperCase()}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildButton(
    String title,
    String pathImage,
    Color color,
    Function() onPress,
  ) {
    return AppTouchable3(
      onPressed: onPress,
      height: Get.width / 2.3,
      width: Get.width / 2.3,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(40.sp),
        boxShadow: const [
          BoxShadow(
            color: Color(0x4C000000),
            blurRadius: 20,
            offset: Offset(0, 4),
            spreadRadius: 0,
          )
        ],
      ),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          AppImageWidget.asset(
            path: AppImage.bgButton,
            height: Get.width,
            width: Get.width,
          ),
          Positioned(
            bottom: 10.sp,
            right: 15.sp,
            child: AppImageWidget.asset(
              path: pathImage,
              width: 85.sp,
            ),
          ),
          Positioned(
            left: 20.sp,
            top: 24.sp,
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 16.0.sp),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(width: 10.0.sp),
            Obx(
              () => controller.cntWeatherForTrip.value <= 2
                  ? _buildButton(
                      'Weather for\nYour Trip',
                      AppImage.icWeatherTrip,
                      const Color(0xFFCEA9FF),
                      () => controller.onPressWeatherForYourTrip())
                  : Stack(
                      children: [
                        _buildButton(
                            'Weather for\nYour Trip',
                            AppImage.icWeatherTrip,
                            const Color(0xFFCEA9FF),
                            () => controller.onPressWeatherForYourTrip()),
                        Positioned(
                          top: 18.0.sp,
                          right: 18.0.sp,
                          child: !Get.find<AppController>().isPremium.value
                              ? AppImageWidget.asset(
                                  path: AppImage.icPremium,
                                  width: 30.0.sp,
                                  height: 30.0.sp,
                                )
                              : SizedBox(
                                  height: 0.sp,
                                ),
                        ),
                      ],
                    ),
            ),
            _buildButton(
                'Weather For\nPlace',
                AppImage.icWeatherPlace,
                const Color(0xFF57C792),
                () => controller.onPressWeatherForPlace()),
            SizedBox(width: 10.0.sp),
          ],
        ),
        SizedBox(
          height: 10.sp,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(width: 10.0.sp),
            _buildButton(
                'Explore Nearby\nPlaces',
                AppImage.icExploreNearby,
                const Color(0xFFF39A9A),
                () => controller.onPressWeatherForFamousPlace()),
            _buildButton('Your Planed\nTrip', AppImage.icPlannedTrip,
                const Color(0xFFECC359), () => controller.onPressPlanedTrip()),
            SizedBox(width: 10.0.sp),
          ],
        ),
      ],
    );
  }

  Widget _buildButtonBig(
    String title,
    String pathImage,
    Color color,
    Function() onPress,
  ) {
    return AppTouchable3(
      onPressed: onPress,
      height: Get.width / 2.3,
      margin: EdgeInsets.symmetric(horizontal: 12.0.sp),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(40.sp),
        boxShadow: const [
          BoxShadow(
            color: Color(0x4C000000),
            blurRadius: 20,
            offset: Offset(0, 4),
            spreadRadius: 0,
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 24.0.sp),
          Padding(
            padding: EdgeInsets.only(
              top: 16.0.sp,
            ),
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 28.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(width: 24.0.sp),
          Expanded(
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                AppImageWidget.asset(
                  path: AppImage.bgButton,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    right: 12.0.sp,
                    bottom: 8.0.sp,
                  ),
                  child: AppImageWidget.asset(
                    path: pathImage,
                    width: 85.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonSmall(
    String title,
    String pathImage,
    Color color,
    Function() onPress,
  ) {
    return AppTouchable3(
      onPressed: onPress,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(26.sp),
        boxShadow: const [
          BoxShadow(
            color: Color(0x4C000000),
            blurRadius: 20,
            offset: Offset(0, 4),
            spreadRadius: 0,
          )
        ],
      ),
      child: Stack(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              AppImageWidget.asset(
                path: AppImage.bgButton,
              ),
              Padding(
                padding: EdgeInsets.only(
                  right: 12.0.sp,
                  bottom: 8.0.sp,
                ),
                child: AppImageWidget.asset(
                  path: pathImage,
                  width: 60.sp,
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 12.0.sp,
              top: 8.0.sp,
            ),
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupNewUIButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 16.0.sp),
        Obx(
          () => controller.cntWeatherForTrip.value <= 2
              ? _buildButtonBig(
                  'Weather for\nYour Trip',
                  AppImage.icWeatherTrip,
                  const Color(0xFF57C792),
                  () => controller.onPressWeatherForYourTrip())
              : Stack(
                  children: [
                    _buildButton(
                        'Weather for\nYour Trip',
                        AppImage.icWeatherTrip,
                        const Color(0xFFCEA9FF),
                        () => controller.onPressWeatherForYourTrip()),
                    Positioned(
                      top: 18.0.sp,
                      right: 18.0.sp,
                      child: !Get.find<AppController>().isPremium.value
                          ? AppImageWidget.asset(
                              path: AppImage.icPremium,
                              width: 30.0.sp,
                              height: 30.0.sp,
                            )
                          : SizedBox(
                              height: 0.sp,
                            ),
                    ),
                  ],
                ),
        ),
        SizedBox(
          height: 10.sp,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(width: 10.0.sp),
            Expanded(
              child: _buildButtonSmall(
                'Weather For\nPlace',
                AppImage.icWeatherPlace,
                const Color(0xFFBF98F2),
                () => controller.onPressWeatherForPlace(),
              ),
            ),
            SizedBox(width: 10.0.sp),
            Expanded(
                child: _buildButtonSmall(
              'Your Planed\nTrip',
              AppImage.icPlannedTrip,
              const Color(0xFF90A9D9),
              () => controller.onPressPlanedTrip(),
            )),
            SizedBox(width: 10.0.sp),
            Expanded(
              child: _buildButtonSmall(
                'Explore Nearby\nPlaces',
                AppImage.icExploreNearby,
                const Color(0xFFECC359),
                () => controller.onPressWeatherForFamousPlace(),
              ),
            ),
            SizedBox(width: 10.0.sp),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    controller.context = context;
    return AppContainer(
      showBanner: true,
      isCollapsibleBanner: false,
      onWillPop: () async {
        showAppDialog(context, '', '',
            hideGroupButton: true,
            widthDialog: Get.width / 1.15,
            widgetBody: Container(
              margin: EdgeInsets.only(
                top: 15.sp,
                right: 10.sp,
                bottom: 10.sp,
              ),
              decoration: BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.circular(12.sp),
              ),
              child: Column(
                children: [
                  Text(
                    'Are you sure you want to exit?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF12203A),
                    ),
                  ),
                  SizedBox(height: 30.sp),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 46.sp,
                        width: Get.width / 3.5,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(16.sp),
                          color: const Color(0xFFE2E1E1),
                        ),
                        child: TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: Text(
                            'Close',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 48.sp,
                        width: Get.width / 3.5,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(16.sp),
                          color: const Color(0xFF3388F2),
                        ),
                        child: TextButton(
                          onPressed: () {
                            SystemNavigator.pop();
                          },
                          child: Text(
                            'Exit',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // NativeAdsWidget(factoryId: NativeFactoryId.appNativeAdFactoryMedium, isPremium: false)
                  Get.find<AppController>().isPremium.value
                      ? const SizedBox.shrink()
                      : const ExitNativeAdsWidget(),
                ],
              ),
            ));
        return false;
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: AppImageWidget.asset(
              path: AppImage.bgMain,
              fit: BoxFit.fill,
            ),
          ),
          Positioned.fill(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).padding.top + 60.sp,
                ),
                Expanded(
                  child: ScrollConfiguration(
                    behavior: DisableGlowBehavior(),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Obx(
                            () => AnimatedSwitcher(
                              duration: const Duration(milliseconds: 100),
                              child: controller.isLoadingWeather.value
                                  ? _buildWeatherInfoLoading()
                                  : _buildWeatherInfo(),
                            ),
                          ),
                          SizedBox(height: 16.sp),
                          AppTouchable3(
                            onPressed: () {
                              controller.onPressChat();
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SizedBox(width: 16.0.sp),
                                Container(
                                  width: 60.0.sp,
                                  height: 60.0.sp,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  padding: EdgeInsets.all(4.0.sp),
                                  child: AppImageWidget.asset(
                                    path: AppImage.animationBotAvatar,
                                  ),
                                ),
                                SizedBox(width: 6.0.sp),
                                Expanded(
                                  child: Container(
                                    height: 60.0.sp,
                                    padding: EdgeInsets.symmetric(
                                      vertical: 12.0.sp,
                                      horizontal: 16.0.sp,
                                    ),
                                    margin: EdgeInsets.only(
                                      right: 12.0.sp,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(60.0.sp),
                                        topLeft: Radius.circular(60.0.sp),
                                        bottomLeft: Radius.circular(2.0.sp),
                                        bottomRight: Radius.circular(60.0.sp),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Plan your journey with me now!",
                                          style: TextStyle(
                                            color: AppColor.grayText,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 13.0.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 16.0.sp),
                              ],
                            ),
                          ),
                          RemoteConfig.getNewUI()
                              ? _buildGroupNewUIButton()
                              : _buildGroupButton(),
                          SizedBox(
                            height: 90.sp,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          _buildTimeInfo(context),
        ],
      ),
    );
  }
}
