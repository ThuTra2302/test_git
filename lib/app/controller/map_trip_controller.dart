import 'dart:async';
import 'dart:ui' as ui;

import 'package:easy_debounce/easy_debounce.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmf;
import 'package:google_maps_webservice/directions.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:intl/intl.dart';
import 'package:travel/app/controller/favorite_controller.dart';

import '../ads/interstitial_ad_manager.dart';
import '../data/model/weather_meteo_response.dart';
import '../data/model/weather_response.dart';
import '../res/image/app_image.dart';
import '../res/string/app_strings.dart';
import '../route/app_route.dart';
import '../storage/database_service.dart';
import '../storage/history_trip.dart';
import '../ui/screen/search_screen.dart';
import '../ui/screen/sub_screen.dart';
import '../ui/screen/weather_map_screen.dart';
import '../ui/theme/app_color.dart';
import '../ui/widget/item_weather_widget.dart';
import '../util/app_constant.dart';
import '../util/app_util.dart';
import '../util/custom_info_window.dart';
import '../util/datetime_picker/flutter_datetime_picker.dart';
import 'app_controller.dart';

enum WeatherType { temp, wind, pre }

class MapTripController extends GetxController {
  late BuildContext context;
  TextEditingController textEditingControllerFrom = TextEditingController();
  TextEditingController textEditingControllerTo = TextEditingController();
  Position? currentPosition;
  RxList<Prediction> listPredictionSuggestFrom = RxList();
  RxList<Prediction> listPredictionSuggestTo = RxList();
  Rx<DateTime> dateTrip = DateTime.now().obs;
  Rx<DateTime> timeTrip = DateTime.now().obs;
  RxBool isLoadingWeather = false.obs;
  RxBool isLoadingWeatherStep2 = false.obs;
  RxBool isLoadingPlaceFrom = false.obs;
  RxBool isLoadingPlaceTo = false.obs;
  RxBool isLoadingFavorite = false.obs;
  RxBool isFavorite = false.obs;
  RxBool isInitialStateScreen = true.obs;
  RxSet<gmf.Polyline> polylineResult = RxSet();
  RxSet<gmf.Marker> markerResult = RxSet();
  gmf.BitmapDescriptor? _markerBitmapFrom;
  gmf.BitmapDescriptor? _markerBitmapTo;
  gmf.BitmapDescriptor? _markerBitmapNode;
  Completer<gmf.GoogleMapController> googleMapController =
      Completer<gmf.GoogleMapController>();
  RxList<Map> listLatLngNode = RxList();
  final CustomInfoWindowController customInfoWindowController00 =
      CustomInfoWindowController();
  final CustomInfoWindowController customInfoWindowController01 =
      CustomInfoWindowController();
  final CustomInfoWindowController customInfoWindowController02 =
      CustomInfoWindowController();
  final CustomInfoWindowController customInfoWindowController03 =
      CustomInfoWindowController();
  final CustomInfoWindowController customInfoWindowController04 =
      CustomInfoWindowController();
  final CustomInfoWindowController customInfoWindowController05 =
      CustomInfoWindowController();
  late StreamSubscription<bool> keyboardSubscription;
  RxBool keyboardVisible = false.obs;
  RxBool isMapLoaded = false.obs;
  RxString fromAdd = 'Your start location'.obs;
  RxString toAdd = 'Your destination'.obs;
  Rx<WeatherType> currentWeatherType = WeatherType.temp.obs;
  RxBool showWeatherTypeList = false.obs;
  RxBool haveWeatherData = false.obs;
  RxBool delayLoadMap = false.obs;
  RxBool isLoadingMyLocation = false.obs;
  RxMap selectedData = RxMap();

  HistoryTrip? data;
  RxBool isTripHistory = false.obs;
  RxBool isLoadingTripHistory = false.obs;

  RxList listAddressFrom = [].obs;
  RxList listAddressTo = [].obs;
  RxBool isShowHistoryFrom = false.obs;
  RxBool isShowHistoryTo = false.obs;

  RxBool showClearButton = false.obs;

  gmf.GoogleMapController? gmc;

  final AppController appController = Get.find<AppController>();

  FocusNode focusNode = FocusNode();

  @override
  void onInit() async {
    focusNode.unfocus();
    currentPosition = Get.arguments['currentPosition'];
    data = Get.arguments['data'];

    if (data == null) {
      isTripHistory.value = true;
    } else {
      isTripHistory.value = false;
      fromAdd.value = data!.addressFrom!;
      toAdd.value = data!.addressTo!;

      textEditingControllerFrom.text = data!.addressFrom!;
      textEditingControllerTo.text = data!.addressTo!;
    }

    listAddressFrom.value = await DatabaseService().getAllAddressFrom();
    listAddressFrom.value = listAddressFrom.toSet().toList();

    listAddressTo.value = await DatabaseService().getAllAddressTo();
    listAddressTo.value = listAddressTo.toSet().toList();

    super.onInit();

    var keyboardVisibilityController = KeyboardVisibilityController();
    keyboardSubscription =
        keyboardVisibilityController.onChange.listen(_keyboardHandle);
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    Future.delayed(
        const Duration(milliseconds: 400), () => delayLoadMap.value = true);
    _initBitmapMarker();

    if (appController.currentPosition != null) {
      currentPosition = appController.currentPosition;
    } else {
      currentPosition = await getCurrentPosition(context);
    }

    if (data != null) checkWeatherWithHistory();
  }

  _keyboardHandle(bool visible) async {
    if (visible) {
      keyboardVisible.value = visible;
    } else {
      // listPredictionSuggestFrom.value = [];
      // listPredictionSuggestTo.value = [];
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
    if (!textColorTo() && !textColorFrom()) {
      return true;
    }
    return false;
  }

  onPressFrom() {
    FirebaseAnalytics.instance.logEvent(name: 'home_trip_onPressFrom');
    Get.to(() => const SearchScreen(
          type: 1,
        ));
  }

  onPressTo() {
    FirebaseAnalytics.instance.logEvent(name: 'home_trip_onPressTo');
    Get.to(() => const SearchScreen(
          type: 2,
        ));
  }

  onChangedFrom(String text) {
    listPredictionSuggestFrom.value = [];

    if (text.isEmpty) {
      return;
    }

    isShowHistoryFrom.value = false;

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

    isShowHistoryTo.value = false;
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

  onPressDate(BuildContext context) {
    FirebaseAnalytics.instance.logEvent(name: 'home_trip_onPressDate');
    DatePicker.showDatePicker(
      context,
      minTime: DateTime.now(),
      maxTime: DateTime.now().add(const Duration(days: 6)),
      currentTime: dateTrip.value,
      onConfirm: (date) {
        dateTrip.value = date;
      },
    );
  }

  onPressTime(BuildContext context) {
    FirebaseAnalytics.instance.logEvent(name: 'home_trip_onPressTime');
    timeTrip.value = DateTime.now();

    DatePicker.showTimePicker(
      context,
      currentTime: timeTrip.value,
      showTitleActions: true,
      onConfirm: (date) {
        timeTrip.value = date;
        dateTrip.value = DateTime(
          dateTrip.value.year,
          dateTrip.value.month,
          dateTrip.value.day,
          timeTrip.value.hour,
          timeTrip.value.minute,
          timeTrip.value.second,
        );
      },
    );
  }

  clearTextField() {
    textEditingControllerFrom.clear();
    textEditingControllerTo.clear();

    listPredictionSuggestFrom.value = [];
    listPredictionSuggestTo.value = [];

    showClearButton.value = false;
  }

  onPressCheckWeather() async {
    FirebaseAnalytics.instance.logEvent(name: 'check_weather');

    if (isLoadingWeather.value) return;

    isLoadingWeather.value = true;

    if (textEditingControllerFrom.text.isNotEmpty) {
      fromAdd.value = textEditingControllerFrom.text;
    }

    if (textEditingControllerTo.text.isNotEmpty) {
      toAdd.value = textEditingControllerTo.text;
    }

    if (textEditingControllerFrom.text.isEmpty ||
        textEditingControllerTo.text.isEmpty) {
      showToast(StringConstants.errorEmptyAdd.tr);
      isLoadingWeather.value = false;
      return;
    }

    if (Get.find<AppController>().isPremium.value) {
      _onPressCheckWeather();
    } else {
      // final prefs = await SharedPreferences.getInstance();
      // int cntTrip = prefs.getInt("cnt_map_trip") ?? 0;
      //
      // if (cntTrip >= 2) {
      //   Get.to(() => const SubScreen());
      // } else {
      //   showInterstitialAds(() {
      //     _onPressCheckWeather();
      //     prefs.setInt("cnt_map_trip", ++cntTrip);
      //   });
      // }

      showInterstitialAds(() {
        _onPressCheckWeather();
      });
    }
  }

  _onPressCheckWeather() async {
    DirectionsResponse directionsResponse =
        await GoogleMapsDirections(apiKey: AppConstant.keyGoogleMap)
            .directionsWithAddress(
      fromAdd.value,
      toAdd.value,
      travelMode: TravelMode.driving,
      units: Unit.metric,
    );

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
          directionsResponse.routes.first.legs.first.distance.value.toInt(),
        );

        var data = HistoryTrip(
          addressFrom: fromAdd.value,
          addressTo: toAdd.value,
          isFavorite: 0,
        );

        await DatabaseService().insert(data);

        isLoadingWeather.value = false;

        Get.to(() => const WeatherMapScreen());

        gmc = await googleMapController.future;
        await gmc!
            .animateCamera(gmf.CameraUpdate.newLatLngBounds(
                boundsFromLatLngList(listLatLng), 70.0))
            .then((value) => gmc!.dispose());
      } else {
        isLoadingWeather.value = false;

        showToast(StringConstants.errorEmptyRoute.tr);
      }
    } else {
      isLoadingWeather.value = false;

      debugPrint("Error message: ${directionsResponse.errorMessage}");
      showToast(
          directionsResponse.errorMessage ?? StringConstants.unknownError.tr);
    }
  }

  checkWeatherWithHistory() async {
    isFavorite.value = data!.isFavorite! == 1;

    isLoadingTripHistory.value = true;

    DirectionsResponse directionsResponse =
        await GoogleMapsDirections(apiKey: AppConstant.keyGoogleMap)
            .directionsWithAddress(data!.addressFrom!, data!.addressTo!,
                travelMode: TravelMode.driving, units: Unit.metric);

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

        isLoadingTripHistory.value = false;

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

  @override
  void onClose() {
    EasyDebounce.cancelAll();
    customInfoWindowController00.dispose();
    customInfoWindowController01.dispose();
    customInfoWindowController02.dispose();
    customInfoWindowController03.dispose();
    customInfoWindowController04.dispose();
    customInfoWindowController05.dispose();
    super.onClose();
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

  _initBitmapMarker() async {
    final Uint8List markerIconFrom = await _getBytesFromAsset(
        AppImage.markerFrom, (24 * ui.window.devicePixelRatio).toInt());
    final Uint8List markerIconTo = await _getBytesFromAsset(
        AppImage.markerTo, (24 * ui.window.devicePixelRatio).toInt());
    final Uint8List markerIconNode = await _getBytesFromAsset(
        AppImage.ic_marker_node, (24 * ui.window.devicePixelRatio).toInt());
    _markerBitmapFrom = gmf.BitmapDescriptor.fromBytes(markerIconFrom);
    _markerBitmapTo = gmf.BitmapDescriptor.fromBytes(markerIconTo);
    _markerBitmapNode = gmf.BitmapDescriptor.fromBytes(markerIconNode);
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

  _handleNodes(List<gmf.LatLng> listLatLng, List<Step> listStep,
      int totalDistance) async {
    if (listLatLng.length > 1) {
      listLatLngNode.value = [];

      _addMarker(listLatLng.first, 0, _markerBitmapFrom);

      int totalDistanceCurrent = 0;
      int totalDistanceFromPrevPoint = 0;
      int averageRange = totalDistance ~/ 5;
      int count = 1;

      for (final step in listStep) {
        totalDistanceCurrent += step.distance.value.toInt();
        totalDistanceFromPrevPoint += step.distance.value.toInt();

        if (totalDistanceFromPrevPoint > averageRange && count < 5) {
          totalDistanceFromPrevPoint = 0;
          _addMarker(gmf.LatLng(step.endLocation.lat, step.endLocation.lng),
              totalDistanceCurrent, _markerBitmapNode);

          count++;
        }
      }

      _addMarker(listLatLng.last, totalDistance, _markerBitmapTo);

      markerResult.refresh();

      _addInfoWindow();
    }
  }

  _addMarker(
      gmf.LatLng latLng, int distance, gmf.BitmapDescriptor? bitmapDescriptor) {
    markerResult.add(
      gmf.Marker(
        markerId:
            gmf.MarkerId(DateTime.now().microsecondsSinceEpoch.toString()),
        position: latLng,
        icon: bitmapDescriptor ?? gmf.BitmapDescriptor.defaultMarker,
      ),
    );
    DateTime arriveDateTime = dateTrip.value.add(Duration(
        milliseconds:
            (((distance / 1000) / AppConstant.averageV) * 60 * 60 * 1000)
                .round()));

    Map temp = {
      'latLng': latLng,
      'distance': distance,
      'dateTime': arriveDateTime.millisecondsSinceEpoch
    };

    bool check = false;
    for (var item in listLatLngNode) {
      if ((item['distance'] / 1000).toInt() ==
          (temp['distance'] / 1000).toInt()) {
        check = true;
        break;
      }
    }

    for (var item in listLatLngNode) {
      debugPrint("Distance: ${(item['distance'] / 1000).round}");
    }

    if (!check) listLatLngNode.add(temp);
  }

  _addInfoWindow() async {
    isLoadingWeatherStep2.value = true;
    WeatherResponse? weatherResponse = await getDataWeather(listLatLngNode);
    isLoadingWeatherStep2.value = false;

    if (weatherResponse != null && weatherResponse.body.data.isNotEmpty) {
      for (int i = 0; i < listLatLngNode.length; i++) {
        Data? data = weatherResponse.body.data.firstWhereOrNull((element) =>
            element.latitude.toString() ==
                (listLatLngNode[i]['latLng'] as gmf.LatLng)
                    .latitude
                    .toString() &&
            element.longitude.toString() ==
                (listLatLngNode[i]['latLng'] as gmf.LatLng)
                    .longitude
                    .toString());
        listLatLngNode[i]['data'] = data;
        listLatLngNode[i]['type'] = "Route";
      }
      haveWeatherData.value = true;

      for (int i = 0; i < listLatLngNode.length; i++) {
        Map item = listLatLngNode[i];
        _generateItemInfoWindow(
            i == 0
                ? customInfoWindowController00
                : i == 1
                    ? customInfoWindowController01
                    : i == 2
                        ? customInfoWindowController02
                        : i == 3
                            ? customInfoWindowController03
                            : i == 4
                                ? customInfoWindowController04
                                : customInfoWindowController05,
            item,
            i);
      }
      listLatLngNode.refresh();
    } else {
      // showToast(StringConstants.errorEmptyWeather.tr);
      isLoadingWeatherStep2.value = true;

      for (int i = 0; i < listLatLngNode.length; i++) {
        MeteoWeatherResponse? meteoWeatherResponse = await getDataMeteoWeather(
            listLatLngNode[i]['latLng'] as gmf.LatLng);

        listLatLngNode[i]['data'] = meteoWeatherResponse;
        listLatLngNode[i]['type'] = "Meteo";
      }

      isLoadingWeatherStep2.value = false;

      haveWeatherData.value = true;

      for (int i = 0; i < listLatLngNode.length; i++) {
        Map item = listLatLngNode[i];
        _generateItemInfoWindow(
            i == 0
                ? customInfoWindowController00
                : i == 1
                    ? customInfoWindowController01
                    : i == 2
                        ? customInfoWindowController02
                        : i == 3
                            ? customInfoWindowController03
                            : i == 4
                                ? customInfoWindowController04
                                : customInfoWindowController05,
            item,
            i);
      }
      listLatLngNode.refresh();
    }
  }

  _generateItemInfoWindow(CustomInfoWindowController customInfoWindowController,
      Map data, int index) {
    Hourly? hourlyDataWeather;

    if (kDebugMode) {
      print("Call api type: ${data['type'] as String}");
      print('Ans route = ${(data["type"] as String).compareTo("Route")}');
      print('Ans meteo = ${(data["type"] as String).compareTo("Meteo")}');
    }

    if ((data['type'] as String).compareTo("Route") == 0) {
      if ((data['data'] as Data).hourly.isNotEmpty) {
        for (Hourly hourly in (data['data'] as Data).hourly) {
          if (hourly.time * 1000 > data['dateTime']) {
            hourlyDataWeather = hourly;
            break;
          }
        }

        data['weather'] = hourlyDataWeather;

        if (kDebugMode) {
          print("Weather icon: ${hourlyDataWeather?.icon}");
          print("Visibility: ${hourlyDataWeather?.visibility}");
          print("Sky cover: ${hourlyDataWeather?.skyCover}");
          print("Dew point: ${hourlyDataWeather?.dewPoint}");
          print("Humidity: ${hourlyDataWeather?.humidity}");
          print("Wind gust: ${hourlyDataWeather?.windGust}");
          print("Wind speed: ${hourlyDataWeather?.windSpeed}");
        }

        if (customInfoWindowController.addInfoWindow != null) {
          customInfoWindowController.addInfoWindow!(
            ItemWeatherWidget(
              hourlyDataWeather: hourlyDataWeather,
              timeStamp: data['dateTime'],
              weatherType: currentWeatherType.value,
              data: data,
              onPressed: (data) async {
                if (data['latLng'] != null) {
                  final gmf.GoogleMapController gmc =
                      await googleMapController.future;
                  gmc.animateCamera(gmf.CameraUpdate.newLatLng(data['latLng']));
                }
              },
              showWaring: !([
                'clear-day',
                'clear-night',
                'cloudy',
                'partly-cloudy-day',
                'partly-cloudy-night'
              ].contains(hourlyDataWeather?.icon)),
            ),
            data['latLng'],
          );
        }
      }
    } else {
      var meteoWeatherResponse = data['data'] as MeteoWeatherResponse;

      int hour = DateTime.now().hour;

      Map currentStatusWeather = AppConstant.listWMOCode.firstWhereOrNull(
          (element) =>
              element['code'] ==
              (meteoWeatherResponse.hourly!.weatherCode![hour]));

      DateTime dateTime = DateFormat("yyyy-MM-dd'T'HH:mm").parse(
          meteoWeatherResponse.hourly?.time?[hour] ?? "1970-01-01T00:00");

      String? sunrise = (meteoWeatherResponse.daily?.sunrise ?? [])
          .firstWhereOrNull((element) {
        DateTime dateTimeSunriseTemp =
            DateFormat("yyyy-MM-dd'T'HH:mm").parse(element);
        if (dateTimeSunriseTemp.year == dateTime.year &&
            dateTimeSunriseTemp.month == dateTime.month &&
            dateTimeSunriseTemp.day == dateTime.day) {
          return true;
        }
        return false;
      });

      DateTime? dateTimeSunrise;
      if ((sunrise ?? '').isNotEmpty) {
        dateTimeSunrise = DateFormat("yyyy-MM-dd'T'HH:mm").parse(sunrise!);
      }

      String? sunset = (meteoWeatherResponse.daily?.sunset ?? [])
          .firstWhereOrNull((element) {
        DateTime dateTimeSunsetTemp =
            DateFormat("yyyy-MM-dd'T'HH:mm").parse(element);
        if (dateTimeSunsetTemp.year == dateTime.year &&
            dateTimeSunsetTemp.month == dateTime.month &&
            dateTimeSunsetTemp.day == dateTime.day) {
          return true;
        }
        return false;
      });

      DateTime? dateTimeSunset;
      if ((sunset ?? '').isNotEmpty) {
        dateTimeSunset = DateFormat("yyyy-MM-dd'T'HH:mm").parse(sunset!);
      }

      bool useNight = false;

      if ((meteoWeatherResponse.hourly?.weatherCode?[hour] == 0 ||
              meteoWeatherResponse.hourly?.weatherCode?[hour] == 1 ||
              meteoWeatherResponse.hourly?.weatherCode?[hour] == 2) &&
          dateTimeSunrise != null &&
          dateTimeSunset != null &&
          (dateTime.isBefore(dateTimeSunrise) ||
              dateTime.isAfter(dateTimeSunset))) {
        useNight = true;
      }

      if (kDebugMode) {
        print("Summary: ${currentStatusWeather['desEN']}");
        print("Image: ${currentStatusWeather['image']}");
        print("Image 2: ${currentStatusWeather['image2']}");
      }

      String pathIcon = useNight == true
          ? currentStatusWeather['image2']
          : currentStatusWeather['image'];

      Hourly hourly = Hourly(
          time: DateTime.now().millisecondsSinceEpoch,
          summary: currentStatusWeather['desEN'],
          icon: pathIcon,
          temperature: meteoWeatherResponse.hourly!.temperature_2m![hour],
          apparentTemperature:
              meteoWeatherResponse.hourly!.apparentTemperature![hour],
          precipType: meteoWeatherResponse.hourlyUnits!.precipitation!,
          precipProbability: meteoWeatherResponse.hourly!.precipitation![hour],
          dewPoint: meteoWeatherResponse.hourly!.dewPoint_2m![hour],
          humidity: meteoWeatherResponse.hourly!.relativeHumidity_2m![hour],
          pressure: meteoWeatherResponse.hourly!.surfacePressure![hour],
          windSpeed: meteoWeatherResponse.hourly!.windSpeed_10m![hour],
          windGust: meteoWeatherResponse.hourly!.windGusts_10m![hour],
          windBearing: meteoWeatherResponse.hourly!.windDirection_10m![hour],
          skyCover: meteoWeatherResponse.hourly!.cloudCoverLow![hour],
          visibility: meteoWeatherResponse.hourly!.visibility![hour],
          precipdynamicensity:
              meteoWeatherResponse.hourly!.precipitation![hour]);

      if (kDebugMode) {
        print("Summary: ${currentStatusWeather['desEN']}");
        print("Image: ${currentStatusWeather['image']}");
        print("Image 2: ${currentStatusWeather['image2']}");
        print(
            "Weather code: ${meteoWeatherResponse.hourly?.weatherCode?[hour]}");
      }

      hourlyDataWeather = hourly;
      data['weather'] = hourlyDataWeather;
      if (customInfoWindowController.addInfoWindow != null) {
        customInfoWindowController.addInfoWindow!(
          ItemWeatherWidget(
            hourlyDataWeather: hourlyDataWeather,
            timeStamp: data['dateTime'],
            weatherType: currentWeatherType.value,
            data: data,
            onPressed: (data) async {
              if (data['latLng'] != null) {
                final gmf.GoogleMapController gmc =
                    await googleMapController.future;
                gmc.animateCamera(gmf.CameraUpdate.newLatLng(data['latLng']));
              }
            },
            type: "Meteo",
            showWaring:
                !(meteoWeatherResponse.hourly?.weatherCode?[hour] == 0 ||
                    meteoWeatherResponse.hourly?.weatherCode?[hour] == 1 ||
                    meteoWeatherResponse.hourly?.weatherCode?[hour] == 2 ||
                    meteoWeatherResponse.hourly?.weatherCode?[hour] == 3),
          ),
          data['latLng'],
        );
      }
    }
  }

  onPressWeatherTimeline() {
    FirebaseAnalytics.instance.logEvent(name: 'weather_timeline');

    if (Get.find<AppController>().isPremium.value) {
      Get.toNamed(AppRoute.tripDetailScreen, arguments: {
        'listLatLngNode': listLatLngNode,
        'data': data,
        'from': textEditingControllerFrom.text.tr,
        'to': textEditingControllerTo.text.tr,
      });
    } else {
      showInterstitialAds(
          () => Get.toNamed(AppRoute.tripDetailScreen, arguments: {
                'listLatLngNode': listLatLngNode,
                'data': data,
                'from': textEditingControllerFrom.text.tr,
                'to': textEditingControllerTo.text.tr,
              }));
    }
  }

  onPressWeatherTypeToggle() {
    showWeatherTypeList.value = !showWeatherTypeList.value;
  }

  onPressWeatherType(WeatherType weatherType) {
    onPressWeatherTypeToggle();
    currentWeatherType.value = weatherType;
    for (int i = 0; i < listLatLngNode.length; i++) {
      Map item = listLatLngNode[i];
      _generateItemInfoWindow(
          i == 0
              ? customInfoWindowController00
              : i == 1
                  ? customInfoWindowController01
                  : i == 2
                      ? customInfoWindowController02
                      : i == 3
                          ? customInfoWindowController03
                          : i == 4
                              ? customInfoWindowController04
                              : customInfoWindowController05,
          item,
          i);
    }
  }

  onPressMyLocation() async {
    if (isLoadingMyLocation.value) return;
    try {
      isLoadingMyLocation.value = true;
      Position? currentPosition = await Geolocator.getLastKnownPosition();
      if (currentPosition != null) {
        final gmf.GoogleMapController gmc = await googleMapController.future;
        gmc.animateCamera(
          gmf.CameraUpdate.newLatLng(
            gmf.LatLng(
              currentPosition.latitude,
              currentPosition.longitude,
            ),
          ),
        );
      }
      isLoadingMyLocation.value = false;
    } catch (e) {
      isLoadingMyLocation.value = false;
      log('$e');
    }
  }

  onPressFavorite() async {
    isLoadingFavorite.value = true;

    if (data == null) {
      HistoryTrip historyTrip =
          await DatabaseService().getItem(fromAdd.value, toAdd.value);

      isFavorite.value = historyTrip.isFavorite == 1;

      if (!isFavorite.value) {
        await DatabaseService().updateFavorite(historyTrip);
        isFavorite.value = !isFavorite.value;
      } else {
        await DatabaseService().updateNotFavorite(historyTrip);
        isFavorite.value = !isFavorite.value;
      }
    } else {
      isFavorite.value = data!.isFavorite! == 1;

      if (!isFavorite.value) {
        await DatabaseService().updateFavorite(data!);
        isFavorite.value = !isFavorite.value;
      } else {
        await DatabaseService().updateNotFavorite(data!);
        isFavorite.value = !isFavorite.value;
      }
    }

    if (!Get.isRegistered<FavoriteController>()) {
      Get.put(FavoriteController());
    }

    Get.find<FavoriteController>().list.value =
        await DatabaseService().getAllFavorite();

    isLoadingFavorite.value = false;
  }

  onPressVip() {
    Get.to(() => const SubScreen());
  }
}
