import 'package:weather_app/features/main_weather_page/domain/entities/current_weather.dart';

class CurrentWeatherModel extends CurrentWeather {
  const CurrentWeatherModel({
    required final String cityName,
    required final int tempC,
    required final int tempF,
    required final String condition,
    required final int windMPH,
    required final int windKPH,
    required final int humidity,
    required final int visibilityKm,
    required final int visibilityMh,
    required final String lastUpdated,
    required final int feelsLikeC,
    required final int feelsLikeF,
    required final int maxTempC,
    required final int maxTempF,
    required final int minTempC,
    required final int minTempF,
  }) : super(
          cityName: cityName,
          tempC: tempC,
          tempF: tempF,
          condition: condition,
          windMPH: windMPH,
          windKPH: windKPH,
          humidity: humidity,
          visibilityKm: visibilityKm,
          visibilityMh: visibilityMh,
          lastUpdated: lastUpdated,
          feelsLikeC: feelsLikeC,
          feelsLikeF: feelsLikeF,
          maxTempC: maxTempC,
          maxTempF: maxTempF,
          minTempC: minTempC,
          minTempF: minTempF,
        );

  factory CurrentWeatherModel.fromJson(Map json) {
    return CurrentWeatherModel(
      cityName: json['location']['name'],
      tempC: (json['current']['temp_c'] as num).toInt(),
      tempF: (json['current']['temp_f'] as num).toInt(),
      condition: json['current']['condition']['text'],
      windMPH: (json['current']['wind_mph'] as num).toInt(),
      windKPH: (json['current']['wind_kph'] as num).toInt(),
      humidity: (json['current']['humidity'] as num).toInt(),
      visibilityKm: (json['current']['vis_km'] as num).toInt(),
      visibilityMh: (json['current']['vis_miles'] as num).toInt(),
      lastUpdated: json['current']['last_updated'].toString(),
      feelsLikeC: (json['current']["feelslike_c"] as num).toInt(),
      feelsLikeF: (json['current']["feelslike_f"] as num).toInt(),
      maxTempC: (json['forecast']['forecastday'][0]['day']['maxtemp_c'] as num)
          .toInt(),
      maxTempF: (json['forecast']['forecastday'][0]['day']['maxtemp_f'] as num)
          .toInt(),
      minTempC: (json['forecast']['forecastday'][0]['day']['mintemp_c'] as num)
          .toInt(),
      minTempF: (json['forecast']['forecastday'][0]['day']['mintemp_f'] as num)
          .toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'location': {
        'name': cityName,
      },
      'current': {
        'temp_c': tempC,
        'temp_f': tempF,
        'condition': {
          'text': condition,
        },
        'wind_mph': windMPH,
        'wind_kph': windKPH,
        'humidity': humidity,
        'vis_km': visibilityKm,
        'vis_miles': visibilityMh,
        'last_updated': lastUpdated,
        'feelslike_c': feelsLikeC,
        'feelslike_f': feelsLikeF,
      },
      'forecast': {
        'forecastday': [
          {
            'day': {
              'maxtemp_c': maxTempC,
              'maxtemp_f': maxTempF,
              'mintemp_c': minTempC,
              'mintemp_f': minTempF,
            }
          }
        ]
      }
    };
  }
}
