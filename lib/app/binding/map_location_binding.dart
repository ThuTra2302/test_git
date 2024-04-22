import 'package:get/get.dart';

import '../controller/map_location_controller.dart';

class MapLocationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MapLocationController());
  }
}
