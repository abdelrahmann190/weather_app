import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/features/core/error/exceptions.dart';
import 'package:weather_app/features/core/utils/app_strings.dart';
import 'package:weather_app/features/core/utils/json_serializer.dart';
import 'package:weather_app/features/main_weather_page/data/models/current_weather_model.dart';
import 'package:weather_app/features/main_weather_page/data/models/weekly_forecast_model.dart';

abstract class WeatherLocalDataSource {
  Future<CurrentWeatherModel> getCachedCurrentWeather(int currentCityIndex);
  Future<List<WeeklyForeCastModel>> getCachedWeeklyForecastWeather(
      int currentCityIndex);
  Future<List<String>> getSavedCitiesList();

  Future<void> cacheCurrentWeatherData(
    CurrentWeatherModel currentWeatherDataToCache,
    int currentCityIndex,
  );
  Future<void> cacheWeeklyForecastWeatherData(
    List<WeeklyForeCastModel> weeklyForeCastToBeCached,
    int currentCityIndex,
  );
  Future<void> cacheCurrentCitiesList(String cityToBeAddedToTheList);
  Future<bool> removeCityFromSavedCitiesList(String cityToBeRemoved);
  Future<bool> setWeatherDataType(bool isDataInCelsious);
  Future<bool> checkIfDataInCelsious();
}

class WeatherLocalDataSourceImpl implements WeatherLocalDataSource {
  final SharedPreferences sharedPreferences;

  WeatherLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheCurrentWeatherData(
    CurrentWeatherModel currentWeatherDataToCache,
    int currentCityIndex,
  ) {
    String currentCity = sharedPreferences
        .getStringList(AppStrings.savedCitiesList)![currentCityIndex];
    return sharedPreferences.setString(
      "${AppStrings.cacheCurrentWeather}$currentCity",
      jsonEncode(
        currentWeatherDataToCache.toJson(),
      ),
    );
  }

  @override
  Future<CurrentWeatherModel> getCachedCurrentWeather(int currentCityIndex) {
    String currentCity = sharedPreferences
        .getStringList(AppStrings.savedCitiesList)![currentCityIndex];
    final jsonString = sharedPreferences
        .getString("${AppStrings.cacheCurrentWeather}$currentCity");
    if (jsonString != null) {
      return Future.value(
        CurrentWeatherModel.fromJson(
          jsonDecode(jsonString),
        ),
      );
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheWeeklyForecastWeatherData(
    List<WeeklyForeCastModel> weeklyForeCastToBeCached,
    int currentCityIndex,
  ) {
    final List listToBeStored = weeklyForeCastToBeCached
        .map(
          (weeklyForecastModel) => weeklyForecastModel.toJson(),
        )
        .toList();
    String currentCity = sharedPreferences
        .getStringList(AppStrings.savedCitiesList)![currentCityIndex];
    return sharedPreferences.setString(
      "${AppStrings.cacheWeeklyForecast}$currentCity",
      JsonSerializer.turnAListToJsonString(listToBeStored: listToBeStored),
    );
  }

  @override
  Future<List<WeeklyForeCastModel>> getCachedWeeklyForecastWeather(
      int currentCityIndex) async {
    String currentCity = sharedPreferences
        .getStringList(AppStrings.savedCitiesList)![currentCityIndex];
    final jsonString = sharedPreferences
        .getString("${AppStrings.cacheWeeklyForecast}$currentCity");
    if (jsonString != null) {
      return JsonSerializer.turnJsonStringListToList(
          jsonStringList: jsonString);
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheCurrentCitiesList(String cityToBeAddedToTheList) {
    List<String> savedCitiesList =
        sharedPreferences.getStringList(AppStrings.savedCitiesList) ?? [];
    if (savedCitiesList.contains(cityToBeAddedToTheList)) {
    } else {
      savedCitiesList.add(cityToBeAddedToTheList);
    }
    return sharedPreferences.setStringList(
      AppStrings.savedCitiesList,
      savedCitiesList,
    );
  }

  @override
  Future<List<String>> getSavedCitiesList() async {
    List<String> savedCitiesList =
        sharedPreferences.getStringList(AppStrings.savedCitiesList) ?? [];
    return savedCitiesList;
  }

  @override
  Future<bool> removeCityFromSavedCitiesList(String cityToBeRemoved) async {
    List<String> savedCitiesList =
        sharedPreferences.getStringList(AppStrings.savedCitiesList) ?? [];
    savedCitiesList.remove(cityToBeRemoved);
    await sharedPreferences
        .remove("${AppStrings.cacheWeeklyForecast}$cityToBeRemoved");
    await sharedPreferences
        .remove("${AppStrings.cacheCurrentWeather}$cityToBeRemoved");

    return sharedPreferences.setStringList(
      AppStrings.savedCitiesList,
      savedCitiesList,
    );
  }

  @override
  Future<bool> setWeatherDataType(bool isDataInCelsious) async {
    return sharedPreferences.setBool(AppStrings.isDataInC, isDataInCelsious);
  }

  @override
  Future<bool> checkIfDataInCelsious() async {
    bool? isDataInC = sharedPreferences.getBool(AppStrings.isDataInC);
    if (isDataInC == null) {
      return true;
    } else {
      return isDataInC;
    }
  }
}
