import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:easy_debounce/easy_debounce.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmf;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/directions.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:travel/app/controller/main_controller.dart';

import '../ads/interstitial_ad_manager.dart';
import '../data/model/weather_response.dart';
import '../res/image/app_image.dart';
import '../res/string/app_strings.dart';
import '../route/app_route.dart';
import '../ui/screen/search_famous_screen.dart';
import '../ui/screen/sub_screen.dart';
import '../ui/theme/app_color.dart';
import '../ui/widget/app_image_widget.dart';
import '../ui/widget/app_touchable2.dart';
import '../util/app_constant.dart';
import '../util/app_util.dart';
import '../util/custom_info_window.dart';
import 'app_controller.dart';

enum KindOfPlace {
  evCharge,
  gasStation,
  hotel,
  restaurantAndBar,
  campSite,
  touristAttraction,
  hospital,
  pharmacy,
  atm
}

enum WeatherType { temp, wind, pre }

class MapFamousController extends GetxController {
  late BuildContext context;

  TextEditingController textEditingControllerFrom = TextEditingController();
  TextEditingController textEditingControllerTo = TextEditingController();
  Position? currentPosition;
  late StreamSubscription<bool> keyboardSubscription;
  RxBool keyboardVisible = false.obs;

  Completer<gmf.GoogleMapController> googleMapController =
      Completer<gmf.GoogleMapController>();
  List<FamousModel> listFamousModel = [];

  RxList<Prediction> listPredictionSuggestFrom = RxList();
  RxList<Prediction> listPredictionSuggestTo = RxList();
  RxBool isLoadingPlaceFrom = false.obs;
  RxBool isLoadingPlaceTo = false.obs;

  RxBool isLoadingPlace = false.obs;
  RxString fromAdd = 'Your start location'.obs;
  RxString toAdd = 'Your destination'.obs;

  Rx<FamousModel> selectedFamousModel = FamousModel(
          name: 'What are you looking for?',
          asset: AppImage.icWhatAreYouLookingFor)
      .obs;

  RxBool isInitialStateScreen = true.obs;
  RxBool delayLoadMap = false.obs;
  RxBool isMapLoaded = false.obs;

  RxSet<gmf.Polyline> polylineResult = RxSet();
  RxSet<gmf.Marker> markerResult = RxSet();
  List<Map> listLatLngNode = [];

  gmf.BitmapDescriptor? _markerBitmapFrom;
  gmf.BitmapDescriptor? _markerBitmapTo;

  RxBool isLoadingMyLocation = false.obs;

  RxBool isLoadingDataPlaces = false.obs;
  final CustomInfoWindowController customInfoWindowController =
      CustomInfoWindowController();

  final int numberOfSegment = 19;
  ClusterManager? clusterManager;
  ClusterPlace? selectedCluster;

  RxList<bool> isSelected = List.generate(9, (index) => false).obs;

  RxBool showClearButton = false.obs;

  final AppController appController = Get.find<AppController>();

  @override
  onInit() {
    currentPosition = Get.arguments['currentPosition'];

    Map mapBitmapDescriptorMarker =
        Get.find<MainController>().mapBitmapDescriptorMarker;
    listFamousModel = [
      FamousModel(
          id: '00',
          kindOfPlace: KindOfPlace.gasStation,
          type: 'gas_station',
          name: StringConstants.gasStation.tr,
          asset: AppImage.ic_gas_station,
          bitmapDescriptor: mapBitmapDescriptorMarker['ic_gas']),
      FamousModel(
          id: '01',
          kindOfPlace: KindOfPlace.evCharge,
          type: '',
          name: StringConstants.evCharger.tr,
          asset: AppImage.ic_ev_charge,
          bitmapDescriptor: mapBitmapDescriptorMarker['ic_charge']),
      FamousModel(
          id: '02',
          kindOfPlace: KindOfPlace.hotel,
          type: 'lodging',
          name: StringConstants.hotel.tr,
          asset: AppImage.ic_hotel,
          bitmapDescriptor: mapBitmapDescriptorMarker['ic_hotel']),
      FamousModel(
          id: '03',
          kindOfPlace: KindOfPlace.atm,
          type: 'atm',
          name: "ATM",
          asset: AppImage.ic_atm,
          bitmapDescriptor: mapBitmapDescriptorMarker['ic_atm']),
      FamousModel(
          id: '04',
          kindOfPlace: KindOfPlace.restaurantAndBar,
          type: 'restaurant|bar',
          name: StringConstants.restaurantAndBar.tr,
          asset: AppImage.ic_restaurant,
          bitmapDescriptor: mapBitmapDescriptorMarker['ic_restaurant']),
      FamousModel(
          id: '05',
          kindOfPlace: KindOfPlace.campSite,
          type: 'campground',
          name: StringConstants.campSite.tr,
          asset: AppImage.ic_camp_site,
          bitmapDescriptor: mapBitmapDescriptorMarker['ic_camp']),
      FamousModel(
          id: '06',
          kindOfPlace: KindOfPlace.touristAttraction,
          type: 'tourist_attraction',
          name: StringConstants.touristAttraction.tr,
          asset: AppImage.ic_tourist_attraction,
          bitmapDescriptor: mapBitmapDescriptorMarker['ic_tourist']),
      FamousModel(
          id: '07',
          kindOfPlace: KindOfPlace.hospital,
          type: 'hospital',
          name: StringConstants.hospital.tr,
          asset: AppImage.ic_hospital,
          bitmapDescriptor: mapBitmapDescriptorMarker['ic_hospital']),
      FamousModel(
          id: '08',
          kindOfPlace: KindOfPlace.pharmacy,
          type: 'pharmacy',
          name: StringConstants.pharmacy.tr,
          asset: AppImage.ic_pharmacy,
          bitmapDescriptor: mapBitmapDescriptorMarker['ic_pharmacy']),
    ];

    super.onInit();

    var keyboardVisibilityController = KeyboardVisibilityController();
    keyboardSubscription =
        keyboardVisibilityController.onChange.listen(_keyboardHandle);
  }

  void onPress(int currentIndex) {
    FirebaseAnalytics.instance.logEvent(name: 'home_famous_Choose_Kind of place');
    if (currentIndex == 0 || Get.find<AppController>().isPremium.value) {
      isSelected.value = List.generate(listFamousModel.length,
          (index) => index == currentIndex ? true : false).obs;
      selectedFamousModel.value = listFamousModel[currentIndex];
    } else {
      Get.to(const SubScreen());
    }
  }

  @override
  Future<void> onReady() async {
    super.onReady();

    if (appController.currentPosition != null) {
      currentPosition = appController.currentPosition;
    } else {
      currentPosition = await getCurrentPosition(context);
    }

    Future.delayed(
        const Duration(milliseconds: 400), () => delayLoadMap.value = true);
    _initBitmapMarker();
  }

  @override
  void onClose() {
    EasyDebounce.cancelAll();
    customInfoWindowController.dispose();
    super.onClose();
  }

  _initBitmapMarker() async {
    final Uint8List markerIconFrom = await _getBytesFromAsset(
        AppImage.markerFrom, (24 * ui.window.devicePixelRatio).toInt());
    final Uint8List markerIconTo = await _getBytesFromAsset(
        AppImage.markerTo, (24 * ui.window.devicePixelRatio).toInt());
    _markerBitmapFrom = gmf.BitmapDescriptor.fromBytes(markerIconFrom);
    _markerBitmapTo = gmf.BitmapDescriptor.fromBytes(markerIconTo);
  }

  Future<Uint8List> _getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  _keyboardHandle(bool visible) async {
    if (visible) {
      keyboardVisible.value = visible;
    } else {
      listPredictionSuggestFrom.value = [];
      listPredictionSuggestTo.value = [];
      Future.delayed(const Duration(milliseconds: 200),
          () => keyboardVisible.value = visible);
    }
  }

  bool textColorFrom() {
    return fromAdd.value.compareTo('Your start location') == 0;
  }

  bool textColorTo() {
    return toAdd.value.compareTo('Your destination') == 0;
  }

  bool colorCheckWeather() {
    if (selectedFamousModel.value.asset != AppImage.icWhatAreYouLookingFor &&
        !textColorTo() &&
        !textColorFrom()) {
      return true;
    }
    return false;
  }
  onPressFrom(){
    FirebaseAnalytics.instance.logEvent(name: 'home_famous_onPressFrom');
    Get.to(
          () => const SearchFamousScreen(
        type: 1,
      ),
    );
  }
  onPressTo(){
    FirebaseAnalytics.instance.logEvent(name: 'home_famous_onPressTo');
    Get.to(
          () => const SearchFamousScreen(
        type: 2,
      ),
    );
  }
  onChangedFrom(String text) {
    listPredictionSuggestFrom.value = [];
    if (text.isEmpty) {
      return;
    }
    if (textEditingControllerFrom.value.text.isEmpty) {
      showClearButton.value = false;
    } else {
      showClearButton.value = true;
    }

    EasyDebounce.debounce(
      'debouncer-autocomplete-from',
      const Duration(milliseconds: 800),
      () async {
        isLoadingPlaceFrom.value = true;
        PlacesAutocompleteResponse response =
            await GoogleMapsPlaces(apiKey: AppConstant.keyGoogleMap)
                .autocomplete(text);
        isLoadingPlaceFrom.value = false;
        listPredictionSuggestFrom.value = response.predictions;
      },
    );
  }

  onChangedTo(String text) {
    listPredictionSuggestTo.value = [];
    if (text.isEmpty) {
      return;
    }
    if (textEditingControllerTo.value.text.isEmpty) {
      showClearButton.value = false;
    } else {
      showClearButton.value = true;
    }
    EasyDebounce.debounce(
      'debouncer-autocomplete-to',
      const Duration(milliseconds: 800),
      () async {
        isLoadingPlaceTo.value = true;
        PlacesAutocompleteResponse response =
            await GoogleMapsPlaces(apiKey: AppConstant.keyGoogleMap)
                .autocomplete(text);
        isLoadingPlaceTo.value = false;
        listPredictionSuggestTo.value = response.predictions;
      },
    );
  }

  onPressVip() {
    Get.to(() => const SubScreen());
  }

  clearTextField() {
    textEditingControllerFrom.clear();
    textEditingControllerTo.clear();

    listPredictionSuggestFrom.value = [];
    listPredictionSuggestTo.value = [];

    showClearButton.value = false;
  }

  Future<bool> onPressCheckPlace() async {
    FirebaseAnalytics.instance.logEvent(name: 'check_famous_place');

    hideKeyboard();
    if (isLoadingPlace.value) return false;
    if (fromAdd.value.compareTo('Your start location') == 0 ||
        toAdd.value.compareTo('Your destination') == 0 ||
        (selectedFamousModel.value.id ?? '').isEmpty) {
      showToast(StringConstants.errorEmptyAdd2.tr);
      return false;
    }

    if (Get.find<AppController>().isPremium.value) {
      _onPressCheckPlace();
    } else {
      if (selectedFamousModel.value.id != "00") {
        Get.to(() => const SubScreen());
      } else {
        showInterstitialAds(() => _onPressCheckPlace());
      }
    }
    return true;
  }

  _onPressCheckPlace() async {
    markerResult.clear();
    polylineResult.clear();
    listLatLngNode = [];
    clusterManager = null;
    selectedCluster = null;
    if (customInfoWindowController.hideInfoWindow != null) {
      customInfoWindowController.hideInfoWindow!();
    }

    isLoadingPlace.value = true;

    DirectionsResponse directionsResponse =
        await GoogleMapsDirections(apiKey: AppConstant.keyGoogleMap)
            .directionsWithAddress(fromAdd.value, toAdd.value,
                travelMode: TravelMode.driving, units: Unit.metric);

    isLoadingPlace.value = false;

    if (directionsResponse.status == 'OK') {
      if (directionsResponse.routes.isNotEmpty &&
          directionsResponse.routes.first.legs.isNotEmpty) {
        isInitialStateScreen.value = false;
        List<gmf.LatLng> listLatLng = _decodePolylineOverView(
            directionsResponse.routes.first.overviewPolyline.points);
        polylineResult.add(
          gmf.Polyline(
            polylineId: gmf.PolylineId(
                DateTime.now().millisecondsSinceEpoch.toString()),
            visible: true,
            points: listLatLng,
            color: AppColor.primaryColor,
            width: 6,
          ),
        );
        polylineResult.refresh();
        _handleNodes(
            listLatLng,
            directionsResponse.routes.first.legs.first.steps,
            directionsResponse.routes.first.legs.first.distance.value.toInt());
        final gmf.GoogleMapController gmc = await googleMapController.future;
        gmc.animateCamera(gmf.CameraUpdate.newLatLngBounds(
            boundsFromLatLngList(listLatLng), 70.0));
      } else {
        showToast(StringConstants.errorEmptyRoute.tr);
      }
    } else {
      showToast(
          directionsResponse.errorMessage ?? StringConstants.unknownError.tr);
    }
  }

  List<gmf.LatLng> _decodePolylineOverView(String input) {
    var list = input.codeUnits;
    List lList = [];
    int index = 0;
    int len = input.length;
    int c = 0;
    List<gmf.LatLng> positions = [];
    do {
      var shift = 0;
      int result = 0;
      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);
      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);

    for (int i = 2; i < lList.length; i++) {
      lList[i] += lList[i - 2];
    }

    for (int i = 0; i < lList.length; i += 2) {
      positions.add(gmf.LatLng(lList[i], lList[i + 1]));
    }

    return positions;
  }

  _handleNodes(List<gmf.LatLng> listLatLng, List<Step> listStep,
      int totalDistance) async {
    DateTime dateTrip = DateTime.now();
    if (listLatLng.length > 1) {
      _addMarker(listLatLng.first, _markerBitmapFrom);
      listLatLngNode.add({
        'latLng': listLatLng.first,
        'distance': 0,
        'dateTime': dateTrip
            .add(Duration(
                milliseconds:
                    (((0 / 1000) / AppConstant.averageV) * 60 * 60 * 1000)
                        .round()))
            .millisecondsSinceEpoch
      });

      int totalDistanceCurrent = 0;
      int averageRange = totalDistance ~/ numberOfSegment;
      int count = 1;
      for (final step in listStep) {
        totalDistanceCurrent += step.distance.value.toInt();
        if (totalDistanceCurrent > count * averageRange &&
            count < numberOfSegment) {
          listLatLngNode.add({
            'latLng': gmf.LatLng(step.endLocation.lat, step.endLocation.lng),
            'distance': totalDistanceCurrent,
            'dateTime': dateTrip
                .add(Duration(
                    milliseconds: (((totalDistanceCurrent / 1000) /
                                AppConstant.averageV) *
                            60 *
                            60 *
                            1000)
                        .round()))
                .millisecondsSinceEpoch
          });
          count++;
        }
      }

      _addMarker(listLatLng.last, _markerBitmapTo);
      listLatLngNode.add({
        'latLng': listLatLng.last,
        'distance': totalDistance,
        'dateTime': dateTrip
            .add(Duration(
                milliseconds: (((totalDistance / 1000) / AppConstant.averageV) *
                        60 *
                        60 *
                        1000)
                    .round()))
            .millisecondsSinceEpoch
      });

      markerResult.refresh();

      for (int i = 0; i < listLatLngNode.length; i++) {
        if (i + 1 >= listLatLngNode.length) {
          listLatLngNode[i]['distanceNext'] = 0;
          listLatLngNode[i]['distancePrev'] = _calculateDistance(
              listLatLngNode[i]['latLng'], listLatLngNode[i - 1]['latLng']);
        } else if (i == 0) {
          listLatLngNode[i]['distanceNext'] = _calculateDistance(
              listLatLngNode[i]['latLng'], listLatLngNode[i + 1]['latLng']);
          listLatLngNode[i]['distancePrev'] = 0;
        } else {
          listLatLngNode[i]['distanceNext'] = _calculateDistance(
              listLatLngNode[i]['latLng'], listLatLngNode[i + 1]['latLng']);
          listLatLngNode[i]['distancePrev'] = _calculateDistance(
              listLatLngNode[i]['latLng'], listLatLngNode[i - 1]['latLng']);
        }
      }

      isLoadingDataPlaces.value = true;
      await _getDataFamous();
      isLoadingDataPlaces.value = false;
    }
  }

  // calculate distance between 2 points (km)
  double _calculateDistance(gmf.LatLng latLng1, gmf.LatLng latLng2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((latLng2.latitude - latLng1.latitude) * p) / 2 +
        c(latLng1.latitude * p) *
            c(latLng2.latitude * p) *
            (1 - c((latLng2.longitude - latLng1.longitude) * p)) /
            2;
    return 12742 * asin(sqrt(a));
  }

  _getDataFamous() async {
    if (listLatLngNode.isNotEmpty) {
      List<PlacesSearchResponse> listPlacesSearchResponse = await Future.wait(
          listLatLngNode.map((element) =>
              GoogleMapsPlaces(apiKey: AppConstant.keyGoogleMap)
                  .searchNearbyWithRadius(
                      Location(
                          lat: (element['latLng'] as gmf.LatLng).latitude,
                          lng: (element['latLng'] as gmf.LatLng).longitude),
                      (element['distanceNext'] == 0
                              ? element['distancePrev']
                              : element['distanceNext']) *
                          1000,
                      type: element['type'],
                      keyword: selectedFamousModel.value.name)));
      List<PlacesSearchResult> listPlacesSearchResult = [];
      for (final response in listPlacesSearchResponse) {
        listPlacesSearchResult.addAll(response.results);
      }
      List<ClusterPlace> listClusterPlace = [];
      for (final placeItem in listPlacesSearchResult.unique((x) => x.placeId)) {
        listClusterPlace.add(
          ClusterPlace(
              name: placeItem.name,
              latLng: gmf.LatLng(placeItem.geometry?.location.lat ?? 0,
                  placeItem.geometry?.location.lng ?? 0),
              placesSearchResult: placeItem),
        );
      }
      clusterManager = ClusterManager<ClusterPlace>(
        listClusterPlace,
        (markers) {
          markerResult.clear();
          _addMarker(listLatLngNode.first['latLng'], _markerBitmapFrom);
          _addMarker(listLatLngNode.last['latLng'], _markerBitmapTo);
          markerResult.addAll(markers);
          markerResult.refresh();
        },
        markerBuilder: _markerBuilder,
        levels: [1, 4.25, 6.75, 8.25, 11.5, 14.5, 16.0, 16.5, 20.0],
        extraPercent: 0.5,
        stopClusteringZoom: 15.0,
      );
      final gmf.GoogleMapController gmc = await googleMapController.future;
      clusterManager?.setMapId(gmc.mapId);
    }
  }

  Future<Marker> Function(Cluster<ClusterPlace>) get _markerBuilder =>
      (cluster) async {
        return Marker(
          markerId: MarkerId(cluster.getId()),
          position: cluster.location,
          onTap: () {
            if (customInfoWindowController.hideInfoWindow != null) {
              customInfoWindowController.hideInfoWindow!();
            }
            if (cluster.items.length == 1) {
              selectedCluster = cluster.items.first;
              _updateItemInfoWindow();
            }
          },
          icon: await _getMarkerBitmap(cluster.isMultiple ? 125 : 75,
              text: cluster.isMultiple ? cluster.count.toString() : null),
        );
      };

  Future<BitmapDescriptor> _getMarkerBitmap(int size, {String? text}) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint1 = Paint()..color = const Color(0xFF5D5D5D);
    final Paint paint2 = Paint()..color = AppColor.white;

    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.0, paint1);
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.2, paint2);
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.8, paint1);

    if (text != null) {
      TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
      painter.text = TextSpan(
        text: text,
        style: TextStyle(
            fontSize: size / 3,
            color: AppColor.white,
            fontWeight: FontWeight.normal),
      );
      painter.layout();
      painter.paint(
        canvas,
        Offset(size / 2 - painter.width / 2, size / 2 - painter.height / 2),
      );
    }

    final img = await pictureRecorder.endRecording().toImage(size, size);
    final data =
        await img.toByteData(format: ui.ImageByteFormat.png) as ByteData;

    return text != null
        ? BitmapDescriptor.fromBytes(data.buffer.asUint8List())
        : selectedFamousModel.value.bitmapDescriptor ??
            BitmapDescriptor.fromBytes(data.buffer.asUint8List());
  }

  _addMarker(gmf.LatLng latLng, gmf.BitmapDescriptor? bitmapDescriptor) {
    markerResult.add(
      gmf.Marker(
        markerId:
            gmf.MarkerId(DateTime.now().microsecondsSinceEpoch.toString()),
        position: latLng,
        icon: bitmapDescriptor ?? gmf.BitmapDescriptor.defaultMarker,
      ),
    );
  }

  onPressMyLocation() async {
    if (isLoadingMyLocation.value) return;
    try {
      isLoadingMyLocation.value = true;
      Position? currentPosition = await Geolocator.getLastKnownPosition();
      if (currentPosition != null) {
        final gmf.GoogleMapController gmc = await googleMapController.future;
        gmc.animateCamera(gmf.CameraUpdate.newLatLng(
            gmf.LatLng(currentPosition.latitude, currentPosition.longitude)));
      }
      isLoadingMyLocation.value = false;
    } catch (e) {
      isLoadingMyLocation.value = false;
      log('$e');
    }
  }

  changeKindOfPlace(FamousModel famousModel) {
    selectedFamousModel.value = famousModel;
    Get.back();
  }

  _updateItemInfoWindow() {
    if (customInfoWindowController.addInfoWindow != null &&
        selectedCluster != null) {
      String imageUrl = (selectedCluster?.placesSearchResult?.photos ?? [])
              .isNotEmpty
          ? 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=200&photo_reference=${selectedCluster!.placesSearchResult!.photos.first.photoReference}&key=${AppConstant.keyGoogleMap}'
          : '';
      customInfoWindowController.addInfoWindow!(
        AppTouchable2(
          height: 68.0.sp,
          width: 160.0.sp,
          onPressed: () async {
            isLoadingDataPlaces.value = true;
            WeatherResponse? weatherResponse = await getDataWeather([
              {'latLng': selectedCluster!.latLng}
            ]);

            isLoadingDataPlaces.value = false;
            if ((weatherResponse?.body.data ?? []).isNotEmpty) {
              Data dataWeather = weatherResponse!.body.data.first;
              DateTime dateTime = DateTime.now();
              Hourly? hourlyDataWeather;
              if (dataWeather.hourly.isNotEmpty) {
                for (Hourly hourly in dataWeather.hourly) {
                  if (hourly.time * 1000 > dateTime.millisecondsSinceEpoch) {
                    hourlyDataWeather = hourly;
                    break;
                  }
                }
              }

              Get.toNamed(AppRoute.weatherDetailScreen, arguments: {
                'data': {
                  'data': dataWeather,
                  'weather': hourlyDataWeather,
                  'latLng': selectedCluster!.latLng,
                  'dateTime': dateTime.millisecondsSinceEpoch
                },
                'title': StringConstants.exploreNearbyPlaces.tr,
                'imageUrl': imageUrl,
                'imageAsset': selectedFamousModel.value.asset,
              });
            }
          },
          padding: EdgeInsets.all(8.0.sp),
          borderRadius: BorderRadius.circular(12.0.sp),
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(12.0.sp),
            boxShadow: [
              BoxShadow(
                color: AppColor.black,
                offset: const Offset(0, 0),
                blurRadius: 10.0.sp,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Row(
            children: [
              imageUrl.isNotEmpty
                  ? SizedBox(
                      width: 58.0.sp,
                      height: 48.0.sp,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(7.0.sp),
                        child: AppImageWidget.network(
                          path: imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  : SizedBox(
                      width: 58.0.sp,
                      height: 48.0.sp,
                      child: AppImageWidget.asset(
                          path: selectedFamousModel.value.asset),
                    ),
              SizedBox(width: 8.0.sp),
              Expanded(
                child: Text(
                  selectedCluster!.name,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColor.gray,
                    fontSize: 12.0.sp,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'SVN-Gilroy',
                  ),
                ),
              ),
            ],
          ),
        ),
        selectedCluster!.latLng,
      );
    }
  }
}

class FamousModel {
  String? id;
  KindOfPlace? kindOfPlace;
  String? type;
  String name;
  String asset;
  BitmapDescriptor? bitmapDescriptor;

  FamousModel(
      {this.id,
      this.kindOfPlace,
      this.type,
      required this.name,
      required this.asset,
      this.bitmapDescriptor});
}

extension Unique<E, Id> on List<E> {
  List<E> unique([Id Function(E element)? id, bool inplace = true]) {
    final ids = <dynamic>{};
    var list = inplace ? this : List<E>.from(this);
    list.retainWhere((x) => ids.add(id != null ? id(x) : x as Id));
    return list;
  }
}

class ClusterPlace with ClusterItem {
  final String name;
  final LatLng latLng;
  PlacesSearchResult? placesSearchResult;

  ClusterPlace(
      {required this.name, required this.latLng, this.placesSearchResult});

  @override
  LatLng get location => latLng;
}
