// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class WeeklyForecast extends Equatable {
  final int maxTempC;
  final int maxTempF;
  final int minTempC;
  final int minTempF;
  final int avgTempC;
  final int avgTempF;
  final int maxWindMPH;
  final int maxWindKPH;
  final int avgHumidity;
  final String condition;
  final String icon;
  final String date;

  const WeeklyForecast({
    required this.maxTempC,
    required this.maxTempF,
    required this.minTempC,
    required this.minTempF,
    required this.avgTempC,
    required this.avgTempF,
    required this.maxWindMPH,
    required this.maxWindKPH,
    required this.avgHumidity,
    required this.condition,
    required this.icon,
    required this.date,
  });

  @override
  List<Object?> get props => [
        maxTempC,
        maxTempF,
        minTempC,
        minTempF,
        avgTempC,
        avgTempF,
        maxWindMPH,
        maxWindKPH,
        avgHumidity,
        condition,
      ];
}
