package com.roadtrippers.weather.activity.notes

import android.view.LayoutInflater
import android.view.View
import android.widget.Button
import android.widget.ImageView
import android.widget.RatingBar
import android.widget.TextView
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView
import com.roadtrippers.weather.activity.notes.R
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin

class SmallNativeAdFactory(
    private var layoutInflater: LayoutInflater
) : GoogleMobileAdsPlugin.NativeAdFactory {
    override fun createNativeAd(
        nativeAd: NativeAd?,
        customOptions: MutableMap<String, Any>?
    ): NativeAdView {
        val adView = layoutInflater.inflate(R.layout.small_template_view, null) as NativeAdView

        adView.headlineView = adView.findViewById(R.id.primary)
        (adView.headlineView as TextView).text = nativeAd?.headline

        adView.iconView = adView.findViewById(R.id.small_ads_view_icon)
        if (nativeAd?.icon == null) {
            adView.iconView?.visibility = View.GONE
        } else {
            (adView.iconView as ImageView).setImageDrawable(nativeAd.icon!!.drawable)
            adView.iconView?.visibility = View.VISIBLE
        }

        adView.starRatingView = adView.findViewById(R.id.small_ads_view_rating_bar)
        if (nativeAd?.starRating == null) {
            adView.starRatingView?.visibility = View.INVISIBLE
        } else {
            (adView.starRatingView as RatingBar).rating = nativeAd.starRating!!.toFloat()
            adView.starRatingView?.visibility = View.VISIBLE
        }

        adView.callToActionView = adView.findViewById(R.id.small_ads_view_cta)
        if (nativeAd?.callToAction == null) {
            adView.callToActionView?.visibility = View.INVISIBLE
        } else {
            adView.callToActionView?.visibility = View.VISIBLE
            (adView.callToActionView as Button).text = nativeAd.callToAction
        }

        if (nativeAd != null) {
            adView.setNativeAd(nativeAd)
        }
        return adView
    }
}