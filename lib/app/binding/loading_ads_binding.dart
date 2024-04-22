import 'package:get/get.dart';
import 'package:travel/app/controller/loading_ads_controller.dart';

class LoadingAdsBinding extends Bindings{

  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(LoadingAdsController());
  }
}