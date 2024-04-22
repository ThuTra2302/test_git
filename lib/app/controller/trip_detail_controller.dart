import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/geocoding.dart';

import '../storage/database_service.dart';
import '../storage/history_trip.dart';
import '../ui/screen/sub_screen.dart';
import '../util/app_constant.dart';
import 'favorite_controller.dart';

class TripDetailController extends GetxController {
  late BuildContext context;

  RxList<Map> listLatLngNode = RxList();

  List<String> listWeatherType = [
    "snow",
    "sleet",
    "rain",
    "partly-cloudy-night",
    "partly-cloudy-day",
    "hail",
    "fog",
    "cloudy",
    "clear-night",
    "clear-day",
    'thunder-showers-day',
    'thunder-rain',
    'showers-day',
    'showers-night'
  ];



  late String from,to;

  @override
  void onInit() {

    listLatLngNode.value = Get.arguments['listLatLngNode'] ?? [];

    super.onInit();
  }

  _getAddress() async {
    for (Map data in listLatLngNode) {
      LatLng latLng = data['latLng'];
      GeocodingResponse geocodingResponse =
          await GoogleMapsGeocoding(apiKey: AppConstant.keyGoogleMap)
              .searchByLocation(
                  Location(lat: latLng.latitude, lng: latLng.longitude));
      if (geocodingResponse.results.isNotEmpty) {
        data['address'] = geocodingResponse.results.first.formattedAddress;
      }
    }
    listLatLngNode.refresh();
  }

  // onPressFavorite() async {
  //   isLoadingFavorite.value = true;
  //
  //   if (data == null) {
  //     HistoryTrip historyTrip = await DatabaseService().getItem(
  //        from ,
  //        to );
  //     isFavorite.value = historyTrip.isFavorite == 1;
  //
  //     if (!isFavorite.value) {
  //       await DatabaseService().updateFavorite(historyTrip);
  //       isFavorite.value = !isFavorite.value;
  //     } else {
  //       await DatabaseService().updateNotFavorite(historyTrip);
  //       isFavorite.value = !isFavorite.value;
  //     }
  //   } else {
  //     isFavorite.value = data!.isFavorite! == 1;
  //
  //     if (!isFavorite.value) {
  //       await DatabaseService().updateFavorite(data!);
  //       isFavorite.value = !isFavorite.value;
  //     } else {
  //       await DatabaseService().updateNotFavorite(data!);
  //       isFavorite.value = !isFavorite.value;
  //     }
  //   }
  //
  //   if (!Get.isRegistered<FavoriteController>()) {
  //     Get.put(FavoriteController());
  //   }
  //
  //   Get.find<FavoriteController>().list.value =
  //       await DatabaseService().getAllFavorite();
  //
  //   isLoadingFavorite.value = false;
  // }

  @override
  Future<void> onReady() async {
    super.onReady();
    _getAddress();
  }

  onPressVip() {
    Get.to(() => const SubScreen());
  }
}
