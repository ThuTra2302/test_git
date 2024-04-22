import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:get/get.dart';

class AppFlyerController extends GetxController {
  static AppsFlyerOptions appsFlyerOptions =
      AppsFlyerOptions(afDevKey: "G3MBmMRHTuEpXbqyqSWGeK", showDebug: true);
  static AppsflyerSdk appsflyerSdk = AppsflyerSdk(appsFlyerOptions);

  static AppsFlyerInviteLinkParams appsFlyerInviteLinkParams =
      AppsFlyerInviteLinkParams();
  static String nameApp = 'RoadTripper';
  static String COUNTRY = 'COUNTRY';
  static String AD_UNIT = 'AD_UNIT';
  static String AD_TYPE = 'AD_TYPE';
  static String PLACEMENT = 'PLACE';
  static String ECPM_PAYLOAD = 'ECPM_PAYLOAD';

  @override
  void onInit() {
    // TODO: implement onInit
    appsflyerSdk.initSdk(
        registerConversionDataCallback: true,
        registerOnAppOpenAttributionCallback: true,
        registerOnDeepLinkingCallback: true);
    super.onInit();
  }

  void loadAds(String tag, String content) {
    appsflyerSdk.logEvent('af_${tag}_successfullyloaded', {
      'load': content,
      'Name app': nameApp,
    });
  }

  void showAds(String tag, String content) {
    appsflyerSdk.logEvent('af_${tag}_displayed', {
      'show': content,
      'Name app': nameApp,
    });
  }
  void logAfPurchase(Map content){
    appsflyerSdk.logEvent("af_purchase", content);
  }

  void onClickAds(
    String tag,
  ) {
    appsflyerSdk.logEvent('af_${tag}_logic', {
      'onclick': 'success',
      'Name app': nameApp,
    });
  }
//   void customParams() {
//     Map<String, String> customParams = {
//       COUNTRY: 'US',
//       AD_UNIT: '@string/ads_id',
//       AD_TYPE: 'Inter_Ads',
//       PLACEMENT: 'null',
//       ECPM_PAYLOAD: '',
//     };
//     appsFlyerInviteLinkParams.customParams=customParams;
//     appsflyerSdk.generateInviteLink(appsFlyerInviteLinkParams., success, error)
//
// // Record a single impression
//   }
}
