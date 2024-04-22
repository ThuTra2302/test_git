import 'package:get/get.dart';

import '../controller/map_famous_controller.dart';

class MapFamousBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MapFamousController());
  }
}
