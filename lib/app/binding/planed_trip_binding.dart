import 'package:get/get.dart';
import 'package:travel/app/controller/favorite_controller.dart';
import 'package:travel/app/controller/history_controller.dart';
import 'package:travel/app/controller/map_trip_controller.dart';

import '../controller/planed_trip_controller.dart';

class PlanedTripBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<PlanedTripController>(PlanedTripController());
    Get.lazyPut(() => FavoriteController());
    Get.lazyPut(() => MapTripController());
    Get.lazyPut<HistoryController>(()=>HistoryController());



  }
}
