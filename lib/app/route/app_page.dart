import 'package:get/get.dart';
import 'package:travel/app/ui/screen/loading_ads_screen.dart';

import '../binding/chat_binding.dart';
import '../binding/favorite_binding.dart';
import '../binding/intro_binding.dart';
import '../binding/loading_ads_binding.dart';
import '../binding/main_binding.dart';
import '../binding/map_famous_binding.dart';
import '../binding/map_location_binding.dart';
import '../binding/map_trip_binding.dart';
import '../binding/planed_trip_binding.dart';
import '../binding/setting_binding.dart';
import '../binding/splash_binding.dart';
import '../binding/trip_detail_binding.dart';
import '../binding/weather_detail_binding.dart';
import '../ui/screen/chat_screen.dart';
import '../ui/screen/famous_map_screen.dart';
import '../ui/screen/favorite_screen.dart';
import '../ui/screen/intro_screen.dart';
import '../ui/screen/main_screen.dart';
import '../ui/screen/map_famous_screen.dart';
import '../ui/screen/map_location_screen.dart';
import '../ui/screen/map_trip_screen.dart';
import '../ui/screen/planed_trip_screen.dart';
import '../ui/screen/setting_screen.dart';
import '../ui/screen/splash_screen.dart';
import '../ui/screen/trip_detail_screen.dart';
import '../ui/screen/weather_detail_screen.dart';
import 'app_route.dart';

class AppPage {
  static final pages = [
    GetPage(
      name: AppRoute.splashScreen,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoute.mainScreen,
      page: () => const MainScreen(),
      binding: MainBinding(),
    ),
    GetPage(
      name: AppRoute.introScreen,
      page: () => const IntroScreen(),
      binding: IntroBinding(),
    ),
    GetPage(
      name: AppRoute.chatScreen,
      page: () => const ChatScreen(),
      binding: ChatBinding(),
    ),
    GetPage(
      name: AppRoute.mapLocationScreen,
      page: () => const MapLocationScreen(),
      binding: MapLocationBinding(),
    ),
    GetPage(
      name: AppRoute.mapTripScreen,
      page: () => const MapTripScreen(),
      binding: MapTripBinding(),
    ),
    GetPage(
      name: AppRoute.tripDetailScreen,
      page: () => const TripDetailScreen(),
      binding: TripDetailBinding(),
    ),
    GetPage(
      name: AppRoute.weatherDetailScreen,
      page: () => const WeatherDetailScreen(),
      binding: WeatherDetailBinding(),
    ),
    GetPage(
      name: AppRoute.planedTripScreen,
      page: () => const PlanedTripScreen(),
      binding: PlanedTripBinding(),
    ),
    GetPage(
      name: AppRoute.settingScreen,
      page: () => const SettingScreen(),
      binding: SettingBinding(),
    ),
    GetPage(
      name: AppRoute.mapFamousScreen,
      page: () => const MapFamousScreen(),
      binding: MapFamousBinding(),
    ),
    GetPage(
      name: AppRoute.famousMapScreen,
      page: () => const FamousMapScreen(),
      binding: MapFamousBinding(),
    ),
    GetPage(
      name: AppRoute.favoriteScreen,
      page: () => const FavoriteScreen(),
      binding: FavoriteBinding(),
    ),
    GetPage(
      name: AppRoute.loadingAdsScreen,
      page: () => const LoadingAdsScreen(),
      binding: LoadingAdsBinding(),
    ),
  ];
}
