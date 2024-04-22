import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfig {
  static final RemoteConfig _instance = RemoteConfig._internal();

  factory RemoteConfig() => _instance;

  RemoteConfig._internal();

  static late final FirebaseRemoteConfig remoteConfig;

  static Future<void> init() async {
    remoteConfig = FirebaseRemoteConfig.instance;

    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(hours: 1),
      ),
    );

    await remoteConfig.setDefaults(<String, dynamic>{
      'inters_capping': 20,
      'new_ui': true,
    });

    RemoteConfigValue(null, ValueSource.valueStatic);
  }

  static int getBannerRefresh() {
    return remoteConfig.getInt("banner_refresh");
  }

  static int getIntersCapping() {
    return remoteConfig.getInt("inters_capping");
  }

  static bool getNewUI() {
    return remoteConfig.getBool("new_ui");
  }
}
