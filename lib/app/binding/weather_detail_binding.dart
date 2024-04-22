import 'package:get/get.dart';
import 'package:travel/app/controller/weather_detail_controller.dart';

class WeatherDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(WeatherDetailController());
  }
}
