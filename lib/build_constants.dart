import 'dart:io';

enum Environment { dev, prod }

class BuildConstants {
  static Map<String, dynamic> _config = _Config.devConstants;
  static var currentEnvironment = Environment.dev;

  static void setEnvironment(Environment env) {
    switch (env) {
      case Environment.prod:
        _config = _Config.prodConstants;
        currentEnvironment = Environment.prod;
        break;
      case Environment.dev:
        _config = _Config.devConstants;
        currentEnvironment = Environment.dev;
        break;
    }
  }

  static get serverTYPE {
    return _config[_Config.serverTYPE];
  }

  static get idInterstitialAd {
    return Platform.isAndroid
        ? _config[_Config.idInterstitialAdAndroidKey]
        : _config[_Config.idInterstitialAdIosKey];
  }

  static get idBannerAd {
    return Platform.isAndroid
        ? _config[_Config.idBannerAdAndroidKey]
        : _config[_Config.idBannerAdIosKey];
  }

  static get idOpenAppAd {
    return Platform.isAndroid
        ? _config[_Config.idOpenAppAdAndroidKey]
        : _config[_Config.idOpenAppAdIosKey];
  }

  static get idNativeAppAd {
    return Platform.isAndroid
        ? _config[_Config.idNativeAppAdAndroidKey]
        : _config[_Config.idNativeAppAdIosKey];
  }

  static get idRewardAd {
    return Platform.isAndroid
        ? _config[_Config.idRewardAdAndroidKey]
        : _config[_Config.idRewardAdIosKey];
  }

  static get idExitNativeAppAd {
    return _config[_Config.idExitNativeAppAdAndroidKey];
  }

  static get idIntroNativeAppAd {
    return _config[_Config.idIntroNativeAppAdAndroidKey];
  }

  static get idResumeAppAdKey {
    return _config[_Config.idResumeAppAdAndroidKey];
  }
}

class _Config {
  static const serverTYPE = "SERVER_TYPE";
  static const idInterstitialAdAndroidKey = "idInterstitialAdAndroid";
  static const idBannerAdAndroidKey = "idBannerAdAndroid";
  static const idOpenAppAdAndroidKey = "idOpenAppAdAndroid";
  static const idResumeAppAdAndroidKey = "idResumeAppAdAndroid";
  static const idInterstitialAdIosKey = "idInterstitialAdIos";
  static const idBannerAdIosKey = "idBannerAdIos";
  static const idOpenAppAdIosKey = "idOpenAppAdIos";
  static const idNativeAppAdAndroidKey = "idNativeAppAdAndroidKey";
  static const idExitNativeAppAdAndroidKey = "idExitNativeAppAdAndroidKey";
  static const idIntroNativeAppAdAndroidKey = "idIntroNativeAppAdAndroidKey";
  static const idNativeAppAdIosKey = "idNativeAppAdIosKey";
  static const idRewardAdAndroidKey = "idRewardAdAndroidKey";
  static const idRewardAdIosKey = "idRewardAdIosKey";

  static Map<String, dynamic> prodConstants = {
    serverTYPE: "Prod",
    idInterstitialAdAndroidKey: "ca-app-pub-9819920607806935/7416574217",
    idBannerAdAndroidKey: "ca-app-pub-9819920607806935/9447841186",
    idOpenAppAdAndroidKey: "ca-app-pub-9819920607806935/5372084555",
    idResumeAppAdAndroidKey: "ca-app-pub-9819920607806935/4261047399",

    /// doi key
    idNativeAppAdAndroidKey: "ca-app-pub-9819920607806935/9437403757",

    ///
    idExitNativeAppAdAndroidKey: "ca-app-pub-9819920607806935/1229656969",

    /// key thieu
    idIntroNativeAppAdAndroidKey: "ca-app-pub-9819920607806935/2197493393", //
    idNativeAppAdIosKey: "",
    idOpenAppAdIosKey: "",
    idBannerAdIosKey: "",
    idInterstitialAdIosKey: "",
    idRewardAdAndroidKey: "ca-app-pub-9819920607806935/8961991496",
    idRewardAdIosKey: "ca-app-pub-3940256099942544/1712485313",
  };

  // static Map<String, dynamic> prodConstants = {
  //   idInterstitialAdAndroidKey: "ca-app-pub-3940256099942544/1033173712",///
  //   idInterstitialAdIosKey: "9aff2af77cc978f7",
  //   idBannerAdAndroidKey: "ca-app-pub-3940256099942544/6300978111",///
  //   idBannerAdIosKey: "5038094d210c3124",
  //   idOpenAppAdAndroidKey: "ca-app-pub-3940256099942544/3419835294",///
  //   idResumeAppAdAndroidKey: "ca-app-pub-9819920607806935/8240321863", /// doi key
  //   idOpenAppAdIosKey: "ca-app-pub-5294836995166944/5470534748",
  //   idNativeAppAdAndroidKey: "ca-app-pub-3940256099942544/2247696110", ///
  //   idExitNativeAppAdAndroidKey: "ca-app-pub-3940256099942544/2247696110", /// key thieu
  //   idIntroNativeAppAdAndroidKey: "ca-app-pub-3940256099942544/2247696110",
  //   idNativeAppAdIosKey: "ca-app-pub-5294836995166944/7834927914",
  // };

  static Map<String, dynamic> devConstants = {
    serverTYPE: "Dev",
    idInterstitialAdAndroidKey: "11d70e4c8f332c08",
    idInterstitialAdIosKey: "ca-app-pub-5294836995166944/1745155185",
    idBannerAdAndroidKey: "275ce0aa351f14a3",
    idBannerAdIosKey: "ca-app-pub-5294836995166944/7018766815",
    idOpenAppAdAndroidKey: "ca-app-pub-3940256099942544/3419835294",
    idOpenAppAdIosKey: "ca-app-pub-3940256099942544/5662855259",
    idNativeAppAdAndroidKey: "ca-app-pub-3940256099942544/2247696110",
    idNativeAppAdIosKey: "ca-app-pub-3940256099942544/3986624511",
    idIntroNativeAppAdAndroidKey: "ca-app-pub-3940256099942544/2247696110",
    idRewardAdAndroidKey: "ca-app-pub-3940256099942544/5224354917",
    idRewardAdIosKey: "ca-app-pub-3940256099942544/1712485313",
  };
}
