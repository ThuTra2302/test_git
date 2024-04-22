import 'package:get/get.dart';

import 'en_strings.dart';
import 'vi_strings.dart';

class AppStrings extends Translations {
  static const String localeCodeVi = 'vi_VN';
  static const String localeCodeEn = 'en_US';

  @override
  Map<String, Map<String, String>> get keys => {
        localeCodeVi: viStrings,
        localeCodeEn: enStrings,
      };

  static String getString(String key) {
    Map<String, String> selectedLanguage = Get.locale.toString() == localeCodeEn ? enStrings : viStrings;
    String text = key;
    if (selectedLanguage.containsKey(key) && selectedLanguage[key] != null) {
      text = selectedLanguage[key] ?? key;
    }
    return text;
  }
}

class StringConstants {
  static String unknownError = 'unknownError';
  static String notice = 'notice';
  static String close = 'close';
  static String continues = 'continues';
  static String setting = 'setting';
  static String cancel = 'cancel';
  static String noNetTitle = 'noNetTitle';
  static String noNetContent = 'noNetContent';
  static String retry = 'retry';
  static String allow = 'allow';
  static String weatherForYourTrip = 'Weather for Your Trip';
  static String weatherForPlace = 'Weather For Place';
  static String weatherForFamousPlace = 'Weather for Famous Place';
  static String yourPlanedTrip = 'Your Planed Trip';
  static String exploreNearbyPlaces = 'Explore Nearby Places';
  static String yourStartLocation = 'yourStartLocation';
  static String yourSearchLocation = 'yourSearchLocation';
  static String yourDestination = 'yourDestination';
  static String departureTime = 'departureTime';
  static String date = 'date';
  static String time = 'time';
  static String averageSpeed = 'averageSpeed';
  static String checkWeather = 'checkWeather';
  static String checkPlace = 'checkPlace';
  static String yourTrip = 'yourTrip';
  static String weatherTimeline = 'Timeline';
  static String weatherForecast = 'weatherForecast';
  static String wind = 'wind';
  static String windGust = "windGust";
  static String humidity = "humidity";
  static String dewPoint = "dewPoint";
  static String skyCover = "skyCover";
  static String barometer = "barometer";
  static String visibility = "visibility";
  static String precipitation = 'precipitation';
  static String errorLocation00 = 'errorLocation00';
  static String errorLocation01 = 'errorLocation01';
  static String errorLocation02 = 'errorLocation02';
  static String errorLocation03 = 'errorLocation03';
  static String errorLocation04 = 'errorLocation04';
  static String errorEmptyAdd = 'errorEmptyAdd';
  static String errorEmptyAdd2 = 'errorEmptyAdd2';
  static String errorEmptyRoute = 'errorEmptyRoute';
  static String errorEmptyWeather = 'errorEmptyWeather';
  static String locationWarn = 'locationWarn';
  static String errorLoadAds = 'errorLoadAds';
  static String rateUs = "rateUs";
  static String privacy = "privacy";
  static String termOfCondition = "termOfCondition";
  static String contactUs = "contactUs";
  static String shareApp = "shareApp";
  static String language = "language";
  static String moreApp = "moreApp";
  static String shareMessage = 'shareMessage';
  static String hintRate = 'hintRate';
  static String rate = "rate";
  static String joinNow = "joinNow";
  static String settingPremiumTitle = "settingPremiumTitle";
  static String subTitle = "subTitle";
  static String restoreSuccessful = "restoreSuccessful";
  static String restore = "restore";
  static String descriptionSub = "descriptionSub";
  static String free3Days = 'free3Days';
  static String subHint1 = "subHint1";
  static String subHint2 = "subHint2";
  static String subHint3 = "subHint3";
  static String subHint4 = "subHint4";
  static String perYear = "perYear";
  static String perWeek = "perWeek";
  static String bestOffer = "bestOffer";
  static String chooseKindPlace = "chooseKindPlace";
  static String kindOfPlace = "kindOfPlace";
  static String evCharger = "evCharger";
  static String gasStation = "gasStation";
  static String hotel = "hotel";
  static String restaurantAndBar = "restaurantAndBar";
  static String campSite = "campSite";
  static String touristAttraction = "touristAttraction";
  static String hospital = "hospital";
  static String pharmacy = "pharmacy";
  static String fellLike = "fellLike";
  static String history = "history";
  static String search = "search";
  static String favorite = "favorite";
}
