import 'dart:async';
import 'dart:ui' as ui;

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:intl/intl.dart';
import 'package:travel/app/ads/interstitial_ad_manager.dart';

import '../data/model/weather_meteo_response.dart';
import '../data/model/weather_response.dart';
import '../res/image/app_image.dart';
import '../res/string/app_strings.dart';
import '../ui/screen/location_search_screen.dart';
import '../ui/screen/sub_screen.dart';
import '../ui/widget/item_weather_widget.dart';
import '../util/app_constant.dart';
import '../util/app_util.dart';
import '../util/custom_info_window.dart';
import 'app_controller.dart';
import 'map_trip_controller.dart';

class MapLocationController extends GetxController {
  late BuildContext context;

  late Position currentPosition;
  RxBool isMapLoaded = false.obs;
  Completer<GoogleMapController> googleMapController =
      Completer<GoogleMapController>();
  RxBool haveWeatherData = false.obs;
  RxBool showWeatherTypeList = false.obs;
  RxBool isLoadingWeather = false.obs;
  Rx<WeatherType> currentWeatherType = WeatherType.temp.obs;
  RxSet<Marker> markerResult = RxSet();
  BitmapDescriptor? _markerBitmapFrom;
  MarkerId markerId = const MarkerId('Marker_id_location_pick');
  final CustomInfoWindowController customInfoWindowController =
      CustomInfoWindowController();
  LatLng? currentLatLng;
  int? currentDateTime;
  Hourly? currentHourlyDataWeather;
  RxMap selectedData = RxMap();
  RxBool delayLoadMap = false.obs;
  RxBool isLoadingMyLocation = false.obs;

  late StreamSubscription<bool> keyboardSubscription;
  TextEditingController textEditingControllerSearch = TextEditingController();
  RxList<Prediction> listPredictionSuggestSearch = RxList();
  RxString strSearch = "".obs;
  RxBool isLoadingSearch = false.obs;
  RxBool isLoadingPlaceSearch = false.obs;
  RxBool keyboardVisible = false.obs;
  RxBool isSearch = false.obs;
  RxString currentAddress = "".obs;

  RxBool showClearButton = false.obs;
  RxBool showPanel = true.obs;

  @override
  void onInit() {
    currentPosition = Get.arguments['currentPosition'];

    onPressMap(LatLng(currentPosition.latitude, currentPosition.longitude));

    showPanel.value = true;

    super.onInit();

    getLocation();

    var keyboardVisibilityController = KeyboardVisibilityController();
    keyboardSubscription =
        keyboardVisibilityController.onChange.listen(_keyboardHandle);
  }

  onPressWeatherTypeToggle() {
    showWeatherTypeList.value = !showWeatherTypeList.value;
  }

  getLocation() async {
    GeocodingResponse geocodingResponse =
        await GoogleMapsGeocoding(apiKey: AppConstant.keyGoogleMap)
            .searchByLocation(
      Location(
        lat: currentPosition.latitude,
        lng: currentPosition.longitude,
      ),
    );

    if (geocodingResponse.results.isNotEmpty) {
      currentAddress.value =
          geocodingResponse.results.first.formattedAddress ?? "";
    }
  }

  onPressWeatherType(WeatherType weatherType) {
    onPressWeatherTypeToggle();
    currentWeatherType.value = weatherType;
    customInfoWindowController.addInfoWindow!(
      ItemWeatherWidget(
        hourlyDataWeather: currentHourlyDataWeather,
        timeStamp: currentDateTime ?? 0,
        weatherType: currentWeatherType.value,
        data: {
          'dateTime': currentDateTime ?? 0,
          'weather': currentHourlyDataWeather,
          'latLng': currentLatLng
        },
        onPressed: (data) async {
          if (data['latLng'] != null) {
            final GoogleMapController gmc = await googleMapController.future;
            gmc.animateCamera(CameraUpdate.newLatLng(data['latLng']));
          }
        },
      ),
      currentLatLng ?? const LatLng(0, 0),
    );
  }

  onPressMap(LatLng latLng) async {
    if (isLoadingWeather.value) return;

    showPanel.value = false;

    int dateTime = DateTime.now().millisecondsSinceEpoch;
    isLoadingWeather.value = true;

    if (customInfoWindowController.addInfoWindow != null) {
      customInfoWindowController.addInfoWindow!(
        const SizedBox.shrink(),
        latLng,
      );
    }

    markerResult.clear();
    markerResult.add(
      Marker(
        markerId: markerId,
        position: latLng,
        icon: _markerBitmapFrom ?? BitmapDescriptor.defaultMarker,
      ),
    );

    WeatherResponse? weatherResponse = await getDataWeather([
      {'latLng': latLng}
    ]);

    isLoadingWeather.value = false;

    if (weatherResponse != null && weatherResponse.body.data.isNotEmpty) {
      Data data = weatherResponse.body.data.first;
      Hourly? hourlyDataWeather;
      if (data.hourly.isNotEmpty) {
        for (Hourly hourly in data.hourly) {
          if (hourly.time * 1000 > dateTime) {
            hourlyDataWeather = hourly;
            break;
          }
        }
      }

      if (kDebugMode) {
        print("Weather icon: ${hourlyDataWeather?.icon}");
        print("Visibility: ${hourlyDataWeather?.visibility}");
        print("Sky cover: ${hourlyDataWeather?.skyCover}");
        print("Dew point: ${hourlyDataWeather?.dewPoint}");
        print("Humidity: ${hourlyDataWeather?.humidity}");
        print("Wind gust: ${hourlyDataWeather?.windGust}");
        print("Wind speed: ${hourlyDataWeather?.windSpeed}");
      }

      currentHourlyDataWeather = hourlyDataWeather;
      currentDateTime = dateTime;
      currentLatLng = latLng;
      if (customInfoWindowController.addInfoWindow != null) {
        customInfoWindowController.addInfoWindow!(
          ItemWeatherWidget(
            hourlyDataWeather: hourlyDataWeather,
            timeStamp: dateTime,
            weatherType: currentWeatherType.value,
            data: {
              'dateTime': dateTime,
              'weather': hourlyDataWeather,
              'latLng': latLng,
              'type': "Route"
            },
            onPressed: (data) async {
              if (data['latLng'] != null) {
                final GoogleMapController gmc =
                    await googleMapController.future;
                gmc.animateCamera(CameraUpdate.newLatLng(data['latLng']));
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
          latLng,
        );
      }
      haveWeatherData.value = true;
    } else {
      isLoadingWeather.value = true;

      MeteoWeatherResponse? meteoWeatherResponse =
          await getDataMeteoWeather(latLng);

      isLoadingWeather.value = false;

      if (meteoWeatherResponse == null) {
        showToast(StringConstants.errorEmptyWeather.tr);
      } else {
        int hour = DateTime.now().hour;

        Map currentStatusWeather = AppConstant.listWMOCode.firstWhereOrNull(
            (element) =>
                element['code'] ==
                (meteoWeatherResponse.hourly!.weatherCode![hour]));

        DateTime _dateTime = DateFormat("yyyy-MM-dd'T'HH:mm").parse(
            meteoWeatherResponse.hourly?.time?[hour] ?? "1970-01-01T00:00");

        String? sunrise = (meteoWeatherResponse.daily?.sunrise ?? [])
            .firstWhereOrNull((element) {
          DateTime dateTimeSunriseTemp =
              DateFormat("yyyy-MM-dd'T'HH:mm").parse(element);
          if (dateTimeSunriseTemp.year == _dateTime.year &&
              dateTimeSunriseTemp.month == _dateTime.month &&
              dateTimeSunriseTemp.day == _dateTime.day) {
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
          if (dateTimeSunsetTemp.year == _dateTime.year &&
              dateTimeSunsetTemp.month == _dateTime.month &&
              dateTimeSunsetTemp.day == _dateTime.day) {
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
            (_dateTime.isBefore(dateTimeSunrise) ||
                _dateTime.isAfter(dateTimeSunset))) {
          useNight = true;
        }

        if (kDebugMode) {
          print("Summary: ${currentStatusWeather['desEN']}");
          print("Image: ${currentStatusWeather['image']}");
          print("Image 2: ${currentStatusWeather['image2']}");
          print(
              "Weather code: ${meteoWeatherResponse.hourly?.weatherCode?[hour]}");
        }

        String pathIcon = useNight == true
            ? currentStatusWeather['image2']
            : currentStatusWeather['image'];

        Hourly hourly = Hourly(
            time: dateTime,
            summary: currentStatusWeather['desEN'],
            icon: pathIcon,
            temperature: meteoWeatherResponse.hourly!.temperature_2m![hour],
            apparentTemperature:
                meteoWeatherResponse.hourly!.apparentTemperature![hour],
            precipType: meteoWeatherResponse.hourlyUnits!.precipitation!,
            precipProbability:
                meteoWeatherResponse.hourly!.precipitation![hour],
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

        currentHourlyDataWeather = hourly;
        currentDateTime = dateTime;
        currentLatLng = latLng;
        if (customInfoWindowController.addInfoWindow != null) {
          customInfoWindowController.addInfoWindow!(
            ItemWeatherWidget(
              hourlyDataWeather: hourly,
              timeStamp: dateTime,
              weatherType: currentWeatherType.value,
              data: {
                'dateTime': dateTime,
                'weather': hourly,
                'latLng': latLng,
                'type': "Meteo"
              },
              onPressed: (data) async {
                if (data['latLng'] != null) {
                  final GoogleMapController gmc =
                      await googleMapController.future;
                  gmc.animateCamera(CameraUpdate.newLatLng(data['latLng']));
                }
              },
              type: "Meteo",
              showWaring:
                  !(meteoWeatherResponse.hourly?.weatherCode?[hour] == 0 ||
                      meteoWeatherResponse.hourly?.weatherCode?[hour] == 1 ||
                      meteoWeatherResponse.hourly?.weatherCode?[hour] == 2 ||
                      meteoWeatherResponse.hourly?.weatherCode?[hour] == 3),
            ),
            latLng,
          );
        }
        haveWeatherData.value = true;
      }
    }
  }

  onPressMap1(LatLng latLng) {
    if(Get.find<AppController>().isPremium.value) {
      onPressMap(latLng);
    } else {
      Get.to(const SubScreen());
    }
  }

  @override
  void onReady() async {
    super.onReady();
    Future.delayed(
        const Duration(milliseconds: 400), () => delayLoadMap.value = true);

    final Uint8List markerIconFrom = await _getBytesFromAsset(
        AppImage.ic_pick, (24 * ui.window.devicePixelRatio).toInt());
    _markerBitmapFrom = BitmapDescriptor.fromBytes(markerIconFrom);
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

  @override
  void onClose() {
    customInfoWindowController.dispose();
    super.onClose();
  }

  onPressMyLocation() async {
    if (isLoadingMyLocation.value) return;

    try {
      isLoadingMyLocation.value = true;
      Position? currentPosition = await Geolocator.getLastKnownPosition();
      if (currentPosition != null) {
        final GoogleMapController gmc = await googleMapController.future;
        gmc.animateCamera(CameraUpdate.newLatLng(
            LatLng(currentPosition.latitude, currentPosition.longitude)));
        onPressMap(LatLng(currentPosition.latitude, currentPosition.longitude));
      }
      isLoadingMyLocation.value = false;
    } catch (e) {
      isLoadingMyLocation.value = false;
      log('$e');
    }

    showPanel.value = true;
  }

  _keyboardHandle(bool visible) async {
    if (visible) {
      keyboardVisible.value = visible;
    } else {
      // listPredictionSuggestSearch.value = [];
      Future.delayed(const Duration(milliseconds: 200),
          () => keyboardVisible.value = visible);
    }
  }

  onChangedSearch(String text) {
    listPredictionSuggestSearch.value = [];

    if (text.isEmpty) {
      return;
    }

    if (textEditingControllerSearch.value.text.isEmpty) {
      showClearButton.value = false;
    } else {
      showClearButton.value = true;
    }

    EasyDebounce.debounce(
      'debouncer-autocomplete-to',
      const Duration(milliseconds: 800),
      () async {
        isLoadingPlaceSearch.value = true;
        PlacesAutocompleteResponse response =
            await GoogleMapsPlaces(apiKey: AppConstant.keyGoogleMap)
                .autocomplete(text);
        isLoadingPlaceSearch.value = false;
        listPredictionSuggestSearch.value = response.predictions;
      },
    );
  }

  onPressSearchDialog() async {
    hideKeyboard();

    strSearch.value = textEditingControllerSearch.text;
    if (strSearch.value.isEmpty) {
      showToast(StringConstants.errorEmptyAdd.tr);
      return;
    }

    isSearch.value = true;
    isLoadingSearch.value = true;
    PlacesSearchResponse response =
        await GoogleMapsPlaces(apiKey: AppConstant.keyGoogleMap)
            .searchByText(strSearch.value);
    isLoadingSearch.value = false;

    Get.back();

    onPressMap(LatLng(
        response.results[0].geometry?.location.lat ?? currentPosition.latitude,
        response.results[0].geometry?.location.lng ??
            currentPosition.longitude));

    final GoogleMapController gmc = await googleMapController.future;
    gmc.animateCamera(CameraUpdate.newLatLng(LatLng(
        response.results[0].geometry?.location.lat ?? currentPosition.latitude,
        response.results[0].geometry?.location.lng ??
            currentPosition.longitude)));
  }

  onPressSearch() {
    if (Get.find<AppController>().isPremium.value) {
      Get.to(() => const LocationSearchScreen());
    } else {
      showInterstitialAds(() => Get.to(() => const LocationSearchScreen()));
    }
  }

  clearTextField() {
    textEditingControllerSearch.clear();

    listPredictionSuggestSearch.value = [];

    showClearButton.value = false;
  }
}
