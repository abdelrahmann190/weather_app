// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class CurrentWeather extends Equatable {
  final String cityName;
  final int tempC;
  final int tempF;
  final String condition;
  final int windMPH;
  final int windKPH;
  final int humidity;
  final int visibilityKm;
  final int visibilityMh;
  final String lastUpdated;
  final int feelsLikeC;
  final int feelsLikeF;
  final int maxTempC;
  final int maxTempF;
  final int minTempC;
  final int minTempF;

  const CurrentWeather({
    required this.cityName,
    required this.tempC,
    required this.tempF,
    required this.condition,
    required this.windMPH,
    required this.windKPH,
    required this.humidity,
    required this.visibilityKm,
    required this.visibilityMh,
    required this.lastUpdated,
    required this.feelsLikeC,
    required this.feelsLikeF,
    required this.maxTempC,
    required this.maxTempF,
    required this.minTempC,
    required this.minTempF,
  });

  @override
  List<Object?> get props => [
        cityName,
        tempC,
        tempF,
        condition,
        windMPH,
        windKPH,
        humidity,
        visibilityKm,
        visibilityMh,
      ];
}
