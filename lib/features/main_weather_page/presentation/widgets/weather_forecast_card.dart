// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:weather_app/features/core/utils/date_formatter.dart';

class WeatherForecastCard extends StatelessWidget {
  final String expectedWeatherDegree;
  final String weatherIcon;
  final String date;
  final Function()? onTap;
  const WeatherForecastCard({
    Key? key,
    required this.expectedWeatherDegree,
    required this.weatherIcon,
    required this.date,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(
          bottom: 25,
          left: 15,
          right: 15,
        ),
        width: 100,
        height: 80,
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "$expectedWeatherDegree°",
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            Image.network(
              "https:$weatherIcon",
              color: Colors.black,
              scale: 1.3,
            ),
            Text(
              DateFormatter.formatWeeklyForecastDate(date),
            ),
          ],
        ),
      ),
    );
  }
}
