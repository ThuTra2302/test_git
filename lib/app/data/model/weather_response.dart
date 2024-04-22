class WeatherResponse {
  WeatherResponse({
    required this.statusCode,
    required this.body,
    required this.isBase64Encoded,
  });

  late final dynamic statusCode;
  late final Body body;
  late final bool isBase64Encoded;

  WeatherResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    body = Body.fromJson(json['body']);
    isBase64Encoded = json['isBase64Encoded'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['body'] = body.toJson();
    data['isBase64Encoded'] = isBase64Encoded;
    return data;
  }
}

class Body {
  Body({
    required this.apiUsage,
    required this.data,
    required this.errors,
  });

  late final ApiUsage apiUsage;
  late final List<Data> data;
  late final List<dynamic> errors;

  Body.fromJson(Map<String, dynamic> json) {
    apiUsage = ApiUsage.fromJson(json['apiUsage']);
    data = List.from(json['data']).map((e) => Data.fromJson(e)).toList();
    errors = List.castFrom<dynamic, dynamic>(json['errors']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['apiUsage'] = apiUsage.toJson();
    _data['data'] = data.map((e) => e.toJson()).toList();
    _data['errors'] = errors;
    return _data;
  }
}

class ApiUsage {
  ApiUsage({
    required this.numTotalRequestPodynamics,
    required this.numDirectionRequestPodynamics,
    required this.numForecastRequestPodynamics,
    required this.numGeocodeRequestPodynamics,
    required this.cycleResetTime,
  });

  late final dynamic numTotalRequestPodynamics;
  late final dynamic numDirectionRequestPodynamics;
  late final dynamic numForecastRequestPodynamics;
  late final dynamic numGeocodeRequestPodynamics;
  late final dynamic cycleResetTime;

  ApiUsage.fromJson(Map<String, dynamic> json) {
    numTotalRequestPodynamics = json['numTotalRequestPodynamics'];
    numDirectionRequestPodynamics = json['numDirectionRequestPodynamics'];
    numForecastRequestPodynamics = json['numForecastRequestPodynamics'];
    numGeocodeRequestPodynamics = json['numGeocodeRequestPodynamics'];
    cycleResetTime = json['cycleResetTime'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['numTotalRequestPodynamics'] = numTotalRequestPodynamics;
    data['numDirectionRequestPodynamics'] = numDirectionRequestPodynamics;
    data['numForecastRequestPodynamics'] = numForecastRequestPodynamics;
    data['numGeocodeRequestPodynamics'] = numGeocodeRequestPodynamics;
    data['cycleResetTime'] = cycleResetTime;
    return data;
  }
}

class Data {
  Data({
    required this.latitude,
    required this.longitude,
    required this.hourly,
    required this.daily,
    required this.alerts,
  });

  late final dynamic latitude;
  late final dynamic longitude;
  late final List<Hourly> hourly;
  late final List<Daily> daily;
  late final List<dynamic> alerts;

  Data.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
    hourly = List.from(json['hourly']).map((e) => Hourly.fromJson(e)).toList();
    daily = List.from(json['daily']).map((e) => Daily.fromJson(e)).toList();
    alerts = List.castFrom<dynamic, dynamic>(json['alerts']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['hourly'] = hourly.map((e) => e.toJson()).toList();
    data['daily'] = daily.map((e) => e.toJson()).toList();
    data['alerts'] = alerts;
    return data;
  }
}

class Hourly {
  Hourly({
    required this.time,
    required this.summary,
    required this.icon,
    this.score,
    required this.temperature,
    required this.apparentTemperature,
    required this.precipType,
    required this.precipProbability,
    required this.precipdynamicensity,
    this.precipAccumulation,
    required this.dewPoint,
    required this.humidity,
    required this.pressure,
    required this.windSpeed,
    required this.windGust,
    required this.windBearing,
    required this.skyCover,
    required this.visibility,
  });

  late final dynamic time;
  late final String summary;
  late final String icon;
  late final dynamic score;
  late final dynamic temperature;
  late final dynamic apparentTemperature;
  late final String precipType;
  late final dynamic precipProbability;
  late final dynamic precipdynamicensity;
  late final dynamic precipAccumulation;
  late final dynamic dewPoint;
  late final dynamic humidity;
  late final dynamic pressure;
  late final dynamic windSpeed;
  late final dynamic windGust;
  late final dynamic windBearing;
  late final dynamic skyCover;
  late final dynamic visibility;

  Hourly.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    summary = json['summary'];
    icon = json['icon'];
    score = json['score'];
    temperature = json['temperature'];
    apparentTemperature = json['apparentTemperature'];
    precipType = json['precipType'];
    precipProbability = json['precipProbability'];
    precipdynamicensity = json['precipdynamicensity'];
    precipAccumulation = null;
    dewPoint = json['dewPoint'];
    humidity = json['humidity'];
    pressure = json['pressure'];
    windSpeed = json['windSpeed'];
    windGust = json['windGust'];
    windBearing = json['windBearing'];
    skyCover = json['skyCover'];
    visibility = json['visibility'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['time'] = time;
    data['summary'] = summary;
    data['icon'] = icon;
    data['score'] = score;
    data['temperature'] = temperature;
    data['apparentTemperature'] = apparentTemperature;
    data['precipType'] = precipType;
    data['precipProbability'] = precipProbability;
    data['precipdynamicensity'] = precipdynamicensity;
    data['precipAccumulation'] = precipAccumulation;
    data['dewPoint'] = dewPoint;
    data['humidity'] = humidity;
    data['pressure'] = pressure;
    data['windSpeed'] = windSpeed;
    data['windGust'] = windGust;
    data['windBearing'] = windBearing;
    data['skyCover'] = skyCover;
    data['visibility'] = visibility;
    return data;
  }
}

class Daily {
  Daily({
    required this.time,
    required this.summary,
    required this.icon,
    required this.temperatureMax,
    required this.temperatureMaxTime,
    required this.temperatureMin,
    required this.temperatureMdynamicime,
    required this.apparentTemperatureMax,
    required this.apparentTemperatureMaxTime,
    required this.apparentTemperatureMin,
    required this.apparentTemperatureMdynamicime,
    required this.precipType,
    required this.precipProbability,
    required this.precipdynamicensity,
    required this.precipdynamicensityMax,
    this.precipAccumulation,
    required this.dewPoint,
    required this.humidity,
    required this.pressure,
    required this.windSpeed,
    required this.windGust,
    required this.windGustTime,
    required this.windBearing,
    required this.skyCover,
    required this.visibility,
  });

  late final dynamic time;
  late final String summary;
  late final String icon;
  late final dynamic temperatureMax;
  late final dynamic temperatureMaxTime;
  late final dynamic temperatureMin;
  late final dynamic temperatureMdynamicime;
  late final dynamic apparentTemperatureMax;
  late final dynamic apparentTemperatureMaxTime;
  late final dynamic apparentTemperatureMin;
  late final dynamic apparentTemperatureMdynamicime;
  late final String precipType;
  late final dynamic precipProbability;
  late final dynamic precipdynamicensity;
  late final dynamic precipdynamicensityMax;
  late final dynamic precipAccumulation;
  late final dynamic dewPoint;
  late final dynamic humidity;
  late final dynamic pressure;
  late final dynamic windSpeed;
  late final dynamic windGust;
  late final dynamic windGustTime;
  late final dynamic windBearing;
  late final dynamic skyCover;
  late final dynamic visibility;

  Daily.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    summary = json['summary'];
    icon = json['icon'];
    temperatureMax = json['temperatureMax'];
    temperatureMaxTime = json['temperatureMaxTime'];
    temperatureMin = json['temperatureMin'];
    temperatureMdynamicime = json['temperatureMdynamicime'];
    apparentTemperatureMax = json['apparentTemperatureMax'];
    apparentTemperatureMaxTime = json['apparentTemperatureMaxTime'];
    apparentTemperatureMin = json['apparentTemperatureMin'];
    apparentTemperatureMdynamicime = json['apparentTemperatureMdynamicime'];
    precipType = json['precipType'];
    precipProbability = json['precipProbability'];
    precipdynamicensity = json['precipdynamicensity'];
    precipdynamicensityMax = json['precipdynamicensityMax'];
    precipAccumulation = null;
    dewPoint = json['dewPoint'];
    humidity = json['humidity'];
    pressure = json['pressure'];
    windSpeed = json['windSpeed'];
    windGust = json['windGust'];
    windGustTime = json['windGustTime'];
    windBearing = json['windBearing'];
    skyCover = json['skyCover'];
    visibility = json['visibility'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['time'] = time;
    data['summary'] = summary;
    data['icon'] = icon;
    data['temperatureMax'] = temperatureMax;
    data['temperatureMaxTime'] = temperatureMaxTime;
    data['temperatureMin'] = temperatureMin;
    data['temperatureMdynamicime'] = temperatureMdynamicime;
    data['apparentTemperatureMax'] = apparentTemperatureMax;
    data['apparentTemperatureMaxTime'] = apparentTemperatureMaxTime;
    data['apparentTemperatureMin'] = apparentTemperatureMin;
    data['apparentTemperatureMdynamicime'] = apparentTemperatureMdynamicime;
    data['precipType'] = precipType;
    data['precipProbability'] = precipProbability;
    data['precipdynamicensity'] = precipdynamicensity;
    data['precipdynamicensityMax'] = precipdynamicensityMax;
    data['precipAccumulation'] = precipAccumulation;
    data['dewPoint'] = dewPoint;
    data['humidity'] = humidity;
    data['pressure'] = pressure;
    data['windSpeed'] = windSpeed;
    data['windGust'] = windGust;
    data['windGustTime'] = windGustTime;
    data['windBearing'] = windBearing;
    data['skyCover'] = skyCover;
    data['visibility'] = visibility;
    return data;
  }
}
