import 'package:get/get.dart';
import 'package:travel/app/controller/map_trip_controller.dart';

class MapTripBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MapTripController());
  }
}
