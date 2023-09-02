import 'package:weather_app/features/main_weather_page/domain/entities/weekly_forecast.dart';

class WeeklyForeCastModel extends WeeklyForecast {
  const WeeklyForeCastModel({
    required int maxTempC,
    required int maxTempF,
    required int minTempC,
    required int minTempF,
    required int avgTempC,
    required int avgTempF,
    required int maxWindMPH,
    required int maxWindKPH,
    required int avgHumidity,
    required String condition,
    required String icon,
    required String date,
  }) : super(
          maxTempC: maxTempC,
          maxTempF: maxTempF,
          minTempC: minTempC,
          minTempF: minTempF,
          avgTempC: avgTempC,
          avgTempF: avgTempF,
          maxWindMPH: maxWindMPH,
          maxWindKPH: maxWindKPH,
          avgHumidity: avgHumidity,
          condition: condition,
          icon: icon,
          date: date,
        );
  factory WeeklyForeCastModel.fromJson(Map json) {
    return WeeklyForeCastModel(
      maxTempC: (json['day']['maxtemp_c'] as num).toInt(),
      maxTempF: (json['day']['maxtemp_f'] as num).toInt(),
      minTempC: (json['day']['mintemp_c'] as num).toInt(),
      minTempF: (json['day']['mintemp_f'] as num).toInt(),
      avgTempC: (json['day']['avgtemp_c'] as num).toInt(),
      avgTempF: (json['day']['avgtemp_f'] as num).toInt(),
      maxWindMPH: (json['day']['maxwind_mph'] as num).toInt(),
      maxWindKPH: (json['day']['maxwind_kph'] as num).toInt(),
      avgHumidity: (json['day']['avghumidity'] as num).toInt(),
      condition: json['day']['condition']['text'].toString(),
      icon: json['day']['condition']['icon'],
      date: json["date"].toString(),
    );
  }

  Map toJson() {
    return {
      'date': date,
      'day': {
        'maxtemp_c': maxTempC,
        'maxtemp_f': maxTempF,
        'mintemp_c': minTempC,
        'mintemp_f': minTempF,
        'avgtemp_c': avgTempC,
        'avgtemp_f': avgTempF,
        'maxwind_mph': maxWindMPH,
        'maxwind_kph': maxWindKPH,
        'avghumidity': avgHumidity,
        'condition': {
          'text': condition,
          'icon': icon,
        },
      },
    };
  }
}
