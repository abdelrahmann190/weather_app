// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dio/dio.dart';

import 'package:weather_app/features/core/error/exceptions.dart';
import 'package:weather_app/features/core/utils/app_strings.dart';
import 'package:weather_app/features/main_weather_page/data/data_source/weather_local_data_source.dart';
import 'package:weather_app/features/main_weather_page/data/models/current_weather_model.dart';
import 'package:weather_app/features/main_weather_page/data/models/weekly_forecast_model.dart';

abstract class WeatherRemoteDataSource {
  Future<CurrentWeatherModel> getCurrentWeather(int currentCityIndex);
  Future<List<WeeklyForeCastModel>> getWeeklyForecastWeather(
      int currentCityIndex);
}

class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  final WeatherLocalDataSource weatherLocalDataSource;
  late Dio dio;
  WeatherRemoteDataSourceImpl({
    required this.weatherLocalDataSource,
  }) {
    final BaseOptions baseOptions = BaseOptions(
      baseUrl: AppStrings.baseUrl,
    );
    dio = Dio(baseOptions);
  }
  @override
  Future<CurrentWeatherModel> getCurrentWeather(int currentCityIndex) async {
    final String city = await weatherLocalDataSource.getSavedCitiesList().then(
          (value) => value[currentCityIndex],
        );
    final Response response = await _getWeatherResponse(
      '/forecast.json?key=00b83591c9834f0c8f1190241233007&q=$city&days=1&aqi=no&alerts=no',
    );
    if (response.statusCode == 200) {
      print("current weatehr request performed");
      return CurrentWeatherModel.fromJson(response.data);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<WeeklyForeCastModel>> getWeeklyForecastWeather(
      int currentCityIndex) async {
    final String city = await weatherLocalDataSource.getSavedCitiesList().then(
          (value) => value[currentCityIndex],
        );
    final Response response = await _getWeatherResponse(
      '/forecast.json?key=00b83591c9834f0c8f1190241233007&q=$city&days=7&aqi=no&alerts=no',
    );
    if (response.statusCode == 200) {
      print("forecast weatehr request performed");

      List<WeeklyForeCastModel> forecastList =
          List.from(response.data['forecast']['forecastday'] as List)
              .map((e) => WeeklyForeCastModel.fromJson(e))
              .toList();
      return forecastList;
    } else {
      throw ServerException();
    }
  }

  Future _getWeatherResponse(String url) async {
    return await dio.get(url);
  }
}
