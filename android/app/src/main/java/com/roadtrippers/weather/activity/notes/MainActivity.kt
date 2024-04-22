package com.roadtrippers.weather.activity.notes


import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin

class MainActivity : FlutterActivity() {
    @Override
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        flutterEngine.getPlugins().add(GoogleMobileAdsPlugin())
        super.configureFlutterEngine(flutterEngine)

        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterEngine, "smallAdFactory", SmallNativeAdFactory(getLayoutInflater())
        )
        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterEngine, "mediumAdFactory", MediumNativeAdFactory(getLayoutInflater())
        )

    }

    override fun cleanUpFlutterEngine(flutterEngine: io.flutter.embedding.engine.FlutterEngine) {
        super.cleanUpFlutterEngine(flutterEngine)
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "smallAdFactory")
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "mediumAdFactory")
    }

}