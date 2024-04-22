import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../ads/interstitial_ad_manager.dart';
import '../res/image/app_image.dart';
import '../res/string/app_strings.dart';
import '../route/app_route.dart';
import '../storage/database_service.dart';
import '../storage/history_trip.dart';
import '../ui/screen/sub_screen.dart';
import '../ui/widget/app_image_widget.dart';
import 'app_controller.dart';

class PlanedTripController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late BuildContext context;


  List<CustomTab> tabs = [
    CustomTab("Favorite", AppImage.icHeart),
    CustomTab("History", AppImage.icHistory),
  ];


  RxBool isLoadingHistory = false.obs;
  RxBool isLoadingFavorite = false.obs;

  List<HistoryTrip> listHistory = [];
  List<HistoryTrip> listFavorite = [];

  RxInt selectedIndex=0.obs;

  RxBool isRightToLeft = false.obs;

  late AnimationController controller;
  late Animation<double> animation;

  late PageController pageController;
  int cnt=1;
  void toggleAnimation() {
    if (controller.isCompleted) {
      controller.reverse();
    } else {
      controller.forward();
    }
  }

  void setTab(int index) {
    selectedIndex.value = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 100),
      curve: Curves.fastOutSlowIn,
    );
    toggleAnimation();

  }

  onPressVip() {
    Get.to(const SubScreen());
  }

  onPressHistory() async {
    isLoadingHistory.value = true;

    listHistory = await DatabaseService().getAll();

    isLoadingHistory.value = false;

    if (Get.find<AppController>().isPremium.value) {
      Get.toNamed(AppRoute.historyScreen,
          arguments: {"listHistory": listHistory});
    } else {
      showInterstitialAds(() => Get.toNamed(AppRoute.historyScreen,
          arguments: {"listHistory": listHistory}));
    }
  }

  onPressFavorite() async {
    isLoadingFavorite.value = true;

    listFavorite = await DatabaseService().getAllFavorite();

    isLoadingFavorite.value = false;

    if (Get.find<AppController>().isPremium.value) {
      Get.toNamed(AppRoute.favoriteScreen,
          arguments: {"listFavorite": listFavorite});
    } else {
      showInterstitialAds(() => Get.toNamed(AppRoute.favoriteScreen,
          arguments: {"listFavorite": listFavorite}));
    }
  }

  @override
  void onInit() {
    super.onInit();
    controller = AnimationController(
      duration: const Duration(milliseconds: 300), // Thời gian của animation
      vsync: this,
    );

    animation = Tween<double>(
      begin: 0, // Giá trị ban đầu
      end: 1,   // Giá trị cuối cùng
    ).animate(controller);
    pageController = PageController(initialPage: selectedIndex.value);
  }
}

class CustomTab {
  final String label;
  final String icon;

  CustomTab(this.label, this.icon);
}
