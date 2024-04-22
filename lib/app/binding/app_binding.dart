import 'package:get/get.dart';
import 'package:travel/app/controller/app_flyer_controller.dart';

import '../controller/app_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AppController());
    Get.put(AppFlyerController());
  }
}
