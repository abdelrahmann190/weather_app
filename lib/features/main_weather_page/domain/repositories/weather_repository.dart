import 'package:dartz/dartz.dart';
import 'package:weather_app/features/core/error/failures.dart';
import 'package:weather_app/features/main_weather_page/domain/entities/current_weather.dart';
import 'package:weather_app/features/main_weather_page/domain/entities/weekly_forecast.dart';

abstract class WeatherRepository {
  Future<Either<Failure, CurrentWeatherEntity>> getCurrentWeather(
      int currentCityIndex);
  Future<Either<Failure, List<WeeklyForecastEntity>>> getWeeklyWeatherForecast(
      int currentCityIndex);
  Future<Either<Failure, String>> addCurrentCityToSavedCitiesList();
  Future<void> addCityNameFromCitySelectionListToSavedCitiesList(
      String cityToBeAddedToTheList);
  Future<bool> checkIfTheAppIsBeingOpenedForFirstTime();
  Future<List<String>> getSavedCitiesList();
  removeCityFromSavedCitiesList(String cityToBeRemoved);
  Future<bool> setWeatherDataType(bool isDataInCelsious);
  Future<bool> checkIfDataInCelsious();
}
