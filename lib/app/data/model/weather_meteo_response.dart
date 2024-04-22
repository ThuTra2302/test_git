class MeteoWeatherResponse {
  final double? latitude;
  final double? longitude;
  final double? generationtimeMs;
  final int? utcOffsetSeconds;
  final String? timezone;
  final String? timezoneAbbreviation;
  final double? elevation;
  final MeteoHourlyUnits? hourlyUnits;
  final MeteoHourly? hourly;
  final MeteoDailyUnits? dailyUnits;
  final MeteoDaily? daily;

  MeteoWeatherResponse({
    this.latitude,
    this.longitude,
    this.generationtimeMs,
    this.utcOffsetSeconds,
    this.timezone,
    this.timezoneAbbreviation,
    this.elevation,
    this.hourlyUnits,
    this.hourly,
    this.dailyUnits,
    this.daily,
  });

  MeteoWeatherResponse.fromJson(Map<String, dynamic> json)
      : latitude = json['latitude'] as double?,
        longitude = json['longitude'] as double?,
        generationtimeMs = json['generationtime_ms'] as double?,
        utcOffsetSeconds = json['utc_offset_seconds'] as int?,
        timezone = json['timezone'] as String?,
        timezoneAbbreviation = json['timezone_abbreviation'] as String?,
        elevation = json['elevation'] as double?,
        hourlyUnits = (json['hourly_units'] as Map<String, dynamic>?) != null
            ? MeteoHourlyUnits.fromJson(json['hourly_units'] as Map<String, dynamic>)
            : null,
        hourly = (json['hourly'] as Map<String, dynamic>?) != null
            ? MeteoHourly.fromJson(json['hourly'] as Map<String, dynamic>)
            : null,
        dailyUnits = (json['daily_units'] as Map<String, dynamic>?) != null
            ? MeteoDailyUnits.fromJson(json['daily_units'] as Map<String, dynamic>)
            : null,
        daily = (json['daily'] as Map<String, dynamic>?) != null
            ? MeteoDaily.fromJson(json['daily'] as Map<String, dynamic>)
            : null;

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
        'generationtime_ms': generationtimeMs,
        'utc_offset_seconds': utcOffsetSeconds,
        'timezone': timezone,
        'timezone_abbreviation': timezoneAbbreviation,
        'elevation': elevation,
        'hourly_units': hourlyUnits?.toJson(),
        'hourly': hourly?.toJson(),
        'daily_units': dailyUnits?.toJson(),
        'daily': daily?.toJson()
      };
}

class MeteoHourlyUnits {
  final String? time;
  final String? temperature_2m;
  final String? relativeHumidity_2m;
  final String? dewPoint_2m;
  final String? precipitation;
  final String? surfacePressure;
  final String? visibility;
  final String? windSpeed_10m;
  final String? windGusts_10m;

  MeteoHourlyUnits(
      this.time,
      this.temperature_2m,
      this.relativeHumidity_2m,
      this.dewPoint_2m,
      this.precipitation,
      this.surfacePressure,
      this.visibility,
      this.windSpeed_10m,
      this.windGusts_10m);

  MeteoHourlyUnits.fromJson(Map<String, dynamic> json)
      : time = json['time'] as String?,
        temperature_2m = json['temperature_2m'] as String?,
        relativeHumidity_2m = json['relativehumidity_2m'] as String?,
        dewPoint_2m = json['dewpoint_2m'] as String?,
        precipitation = json['precipitation'] as String?,
        surfacePressure = json['surface_pressure'] as String?,
        visibility = json['visibility'] as String?,
        windSpeed_10m = json['windspeed_10m'] as String?,
        windGusts_10m = json['windgusts_10m'] as String?;

  Map<String, dynamic> toJson() => {
        "time": time,
        "temperature_2m": temperature_2m,
        "relativehumidity_2m": relativeHumidity_2m,
        "dewpoint_2m": dewPoint_2m,
        "precipitation": precipitation,
        "surface_pressure": surfacePressure,
        "visibility": visibility,
        "windspeed_10m": windSpeed_10m,
        "windgusts_10m": windGusts_10m,
      };
}

class MeteoHourly {
  final List<String>? time;
  final List<int>? weatherCode;
  final List<double>? temperature_2m;
  final List<double>? apparentTemperature;
  final List<int>? relativeHumidity_2m;
  final List<double>? dewPoint_2m;
  final List<double>? precipitation;
  final List<int>? cloudCoverLow;
  final List<int>? windDirection_10m;
  final List<double>? surfacePressure;
  final List<double>? visibility;
  final List<double>? windSpeed_10m;
  final List<double>? windGusts_10m;

  MeteoHourly(
      this.time,
      this.weatherCode,
      this.temperature_2m,
      this.relativeHumidity_2m,
      this.apparentTemperature,
      this.dewPoint_2m,
      this.cloudCoverLow,
      this.precipitation,
      this.windDirection_10m,
      this.surfacePressure,
      this.visibility,
      this.windSpeed_10m,
      this.windGusts_10m);

  MeteoHourly.fromJson(Map<String, dynamic> json)
      : time = (json['time'] as List?)?.map((dynamic e) => e as String).toList(),
        weatherCode = (json['weathercode'] as List?)?.map((dynamic e) => e as int).toList(),
        temperature_2m =
            (json['temperature_2m'] as List?)?.map((dynamic e) => e as double).toList(),
        relativeHumidity_2m =
            (json['relativehumidity_2m'] as List?)?.map((dynamic e) => e as int).toList(),
        windDirection_10m =
            (json['winddirection_10m'] as List?)?.map((dynamic e) => e as int).toList(),
        cloudCoverLow = (json['cloudcover_low'] as List?)?.map((dynamic e) => e as int).toList(),
        dewPoint_2m = (json['dewpoint_2m'] as List?)?.map((dynamic e) => e as double).toList(),
        apparentTemperature =
            (json['apparent_temperature'] as List?)?.map((dynamic e) => e as double).toList(),
        precipitation = (json['precipitation'] as List?)?.map((dynamic e) => e as double).toList(),
        surfacePressure =
            (json['surface_pressure'] as List?)?.map((dynamic e) => e as double).toList(),
        visibility = (json['visibility'] as List?)?.map((dynamic e) => e as double).toList(),
        windSpeed_10m = (json['windspeed_10m'] as List?)?.map((dynamic e) => e as double).toList(),
        windGusts_10m = (json['windgusts_10m'] as List?)?.map((dynamic e) => e as double).toList();

  Map<String, dynamic> toJson() => {
        "time": time,
        'weathercode': weatherCode,
        "temperature_2m": temperature_2m,
        "apparent_temperature": apparentTemperature,
        "relativehumidity_2m": relativeHumidity_2m,
        "dewpoint_2m": dewPoint_2m,
        "precipitation": precipitation,
        "surface_pressure": surfacePressure,
        "winddirection_10m": windDirection_10m,
        "visibility": visibility,
        "cloudcover_low": cloudCoverLow,
        "windspeed_10m": windSpeed_10m,
        "windgusts_10m": windGusts_10m,
      };
}

class MeteoDailyUnits {
  final String? time;
  final String? weatherCode;
  final String? sunrise;
  final String? sunset;

  MeteoDailyUnits({
    this.time,
    this.weatherCode,
    this.sunrise,
    this.sunset,
  });

  MeteoDailyUnits.fromJson(Map<String, dynamic> json)
      : time = json['time'] as String?,
        weatherCode = json['weathercode'] as String?,
        sunrise = json['sunrise'] as String?,
        sunset = json['sunset'] as String?;

  Map<String, dynamic> toJson() =>
      {'time': time, 'weathercode': weatherCode, 'sunrise': sunrise, 'sunset': sunset};
}

class MeteoDaily {
  final List<String>? time;
  final List<int>? weatherCode;
  final List<String>? sunrise;
  final List<String>? sunset;

  MeteoDaily({
    this.time,
    this.weatherCode,
    this.sunrise,
    this.sunset,
  });

  MeteoDaily.fromJson(Map<String, dynamic> json)
      : time = (json['time'] as List?)?.map((dynamic e) => e as String).toList(),
        weatherCode = (json['weathercode'] as List?)?.map((dynamic e) => e as int).toList(),
        sunrise = (json['sunrise'] as List?)?.map((dynamic e) => e as String).toList(),
        sunset = (json['sunset'] as List?)?.map((dynamic e) => e as String).toList();

  Map<String, dynamic> toJson() =>
      {'time': time, 'weathercode': weatherCode, 'sunrise': sunrise, 'sunset': sunset};
}
