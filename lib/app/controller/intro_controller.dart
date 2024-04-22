import 'package:carousel_slider/carousel_controller.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../res/image/app_image.dart';
import '../ui/screen/handle_permission_screen.dart';

class IntroController extends GetxController {
  RxInt currentIndex = 0.obs;
  CarouselController carouselController = CarouselController();

  @override
  void onInit() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('is_first_open_app', false);

    super.onInit();
  }

  final List<Map> listImageAsset = [
    {
      "image": AppImage.bgIntro1,
      "title": "Weather your Trip",
      "subTitle":
          "Set Start - Finish point on the MAP\nRoadtrip weather check the forecast for whole route"
    },
    {
      "image": AppImage.bgIntro2,
      "title": "Weather your Place",
      "subTitle": "Global weather forecasts, for any regions of the global"
    },
    {
      "image": AppImage.bgIntro3,
      "title": "Explore Nearby Places",
      "subTitle":
          "Check all the stops you want Gas Station, ATM, Hospital, Restaurant, Tourist Attraction, ..."
    },
    {
      "image": AppImage.bgIntro4,
      "title": "Buddies' Adventure Planner",
      "subTitle":
      "Get ready and enjoy a trip with your friend"
    },
  ];

  void onPressNext() async {
    if (currentIndex.value <= 2) {
      carouselController.nextPage();
      currentIndex.value += 1;
    } else if (currentIndex.value == 3) {
      await Get.off(() => const HandlePermissionScreen());
    }
  }

  void onPageChanged(int index) {
    currentIndex.value = index;
    print('currentIndex: ${currentIndex.value}');
  }

  void onPressSkip() async {
    await Get.off(() => const HandlePermissionScreen());
  }
}
