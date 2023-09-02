import 'dart:convert';

import 'package:weather_app/features/main_weather_page/data/models/weekly_forecast_model.dart';

class JsonSerializer {
  static String turnAListToJsonString({
    required List listToBeStored,
  }) {
    final Map mapToBeStored = {"list": listToBeStored};
    return jsonEncode(mapToBeStored).toString();
  }

  static List<WeeklyForeCastModel> turnJsonStringListToList({
    required String jsonStringList,
  }) {
    final listToBeReturned = List.from(jsonDecode(jsonStringList)['list'])
        .map((e) => WeeklyForeCastModel.fromJson(e))
        .toList();
    return listToBeReturned;
  }
}
