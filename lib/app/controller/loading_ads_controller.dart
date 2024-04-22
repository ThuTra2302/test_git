import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:travel/app/mixins/connection_mixin.dart';

import '../ads/interstitial_open_ad_manager.dart';
import '../route/app_route.dart';
import '../ui/screen/handle_permission_screen.dart';
import 'app_controller.dart';

class LoadingAdsController extends GetxController with ConnectionMixin {
  late bool _isFirstTimeOpenApp;
  int cntAds = 1;

  @override
  void onInit() {
    // TODO: implement onInit;
    _isFirstTimeOpenApp = Get.arguments['first'];

    super.onInit();
  }

  @override
  void onReady() async {
    super.onReady();
    // TODO: implement onReady
    if (AddInterstitialOpenAdManager.interstitialAd != null) {
      _nextScreen();
    } else {
      loadInterstitialOpenAd();
      Future.delayed(const Duration(milliseconds: 2500))
          .then((value) => loadAds());
    }
  }

  void loadAds() async {
    print("check cnt $cntAds");

    if (AddInterstitialOpenAdManager.interstitialAd == null) {
      cntAds++;
      AddInterstitialOpenAdManager.loadInterstitialOpenAd();
      if (cntAds > 3) {
        _nextScreen();
        return;
      }
      loadAds();
    } else {
      _nextScreen();
    }
  }

  Future<void> _nextScreen() async {
    if (_isFirstTimeOpenApp) {
      showInterstitialOpenAds(() => Get.offNamed(AppRoute.introScreen));
      return;
    } else {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission != LocationPermission.always &&
          permission != LocationPermission.whileInUse) {
        showInterstitialOpenAds(
          () => Get.off(
            () => const HandlePermissionScreen(),
          ),
        );
        return;
      } else {
        if (Get.find<AppController>().isPremium.value) {
          Get.offNamed(AppRoute.mainScreen);
          return;
        } else {
          showInterstitialOpenAds(
            () => Get.offNamed(AppRoute.mainScreen),
          );
          return;
        }
      }
    }
  }
}
