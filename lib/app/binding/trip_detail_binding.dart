import 'package:get/get.dart';
import 'package:travel/app/controller/trip_detail_controller.dart';

class TripDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(TripDetailController());
  }
}
