// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:weather_app/features/core/error/exceptions.dart';
import 'package:weather_app/features/core/error/failures.dart';
import 'package:weather_app/features/core/network/network_info.dart';
import 'package:weather_app/features/core/services/get_current_city.dart';
import 'package:weather_app/features/core/utils/date_formatter.dart';
import 'package:weather_app/features/main_weather_page/data/data_source/weather_local_data_source.dart';
import 'package:weather_app/features/main_weather_page/data/data_source/weather_remote_data_source.dart';
import 'package:weather_app/features/main_weather_page/data/models/weekly_forecast_model.dart';
import 'package:weather_app/features/main_weather_page/domain/entities/current_weather.dart';
import 'package:weather_app/features/main_weather_page/domain/entities/weekly_forecast.dart';
import 'package:weather_app/features/main_weather_page/domain/repositories/weather_repository.dart';

class WeatherRepositoryImpl extends WeatherRepository {
  final WeatherRemoteDataSource weatherRemoteDataSource;
  final WeatherLocalDataSource weatherLocalDataSource;
  final NetworkInfo networkInfo;
  final LocationHelper currentCityName;
  WeatherRepositoryImpl({
    required this.weatherRemoteDataSource,
    required this.weatherLocalDataSource,
    required this.networkInfo,
    required this.currentCityName,
  });
  @override
  Future<Either<Failure, CurrentWeatherEntity>> getCurrentWeather(
      int currentCityIndex) async {
    if (await networkInfo.isConnected) {
      return await _checkCachedCurrentWeatherDataAgainstCurrentDate(
          currentCityIndex);
    } else {
      return await _getLocalCurrentWeather(
        currentCityIndex,
      );
    }
  }

  @override
  Future<Either<Failure, List<WeeklyForecastEntity>>> getWeeklyWeatherForecast(
      int currentCityIndex) async {
    if (await networkInfo.isConnected) {
      return await _checkIfCachedWeeklyForecastIsEqualToCurrentDate(
          currentCityIndex);
    } else {
      try {
        return Right(
          await weatherLocalDataSource
              .getCachedWeeklyForecastWeather(currentCityIndex),
        );
      } on CacheException catch (e) {
        return Left(
          CacheFailure(
            e.toString(),
          ),
        );
      }
    }
  }

  Future<Either<Failure, CurrentWeatherEntity>> _getLiveCurrentWeatherData(
      int currentCityIndex) async {
    try {
      final currentWeatherData =
          await weatherRemoteDataSource.getCurrentWeather(currentCityIndex);
      weatherLocalDataSource.cacheCurrentWeatherData(
        currentWeatherData,
        currentCityIndex,
      );
      return Right(
        currentWeatherData,
      );
    } on Exception catch (e) {
      return Left(
        ServerFailure(
          e.toString(),
        ),
      );
    }
  }

  Future<Either<Failure, CurrentWeatherEntity>> _getLocalCurrentWeather(
      int currentCityIndex) async {
    try {
      final CurrentWeatherEntity localCurrentWeather =
          await weatherLocalDataSource
              .getCachedCurrentWeather(currentCityIndex);
      return Right(localCurrentWeather);
    } on Exception catch (error) {
      return Left(
        CacheFailure(
          error.toString(),
        ),
      );
    }
  }

  Future<Either<Failure, CurrentWeatherEntity>>
      _checkCachedCurrentWeatherDataAgainstCurrentDate(
          int currentCityIndex) async {
    try {
      final String cachedDate = await weatherLocalDataSource
          .getCachedCurrentWeather(0)
          .then((value) => value.lastUpdated);
      final CurrentWeatherEntity localCurrentWeather =
          await weatherLocalDataSource
              .getCachedCurrentWeather(currentCityIndex);

      if (DateFormatter.checkIfCachedHourIsTheSameAsCurrentHour(cachedDate)) {
        return Right(localCurrentWeather);
      } else {
        return await _getLiveCurrentWeatherData(currentCityIndex);
      }
    } on Exception catch (e) {
      return await _getLiveCurrentWeatherData(currentCityIndex);
    }
  }

  Future<Either<Failure, List<WeeklyForeCastModel>>>
      _checkIfCachedWeeklyForecastIsEqualToCurrentDate(
          int currentCityIndex) async {
    try {
      final cachedData =
          await weatherLocalDataSource.getCachedWeeklyForecastWeather(
        currentCityIndex,
      );
      final cachedDate = cachedData[0].date;
      if (DateFormatter.checkIfCachedDayIsTheSameAsCurrentDay(cachedDate)) {
        return Right(cachedData);
      } else {
        final currentWeeklyForecast = await weatherRemoteDataSource
            .getWeeklyForecastWeather(currentCityIndex);
        weatherLocalDataSource.cacheWeeklyForecastWeatherData(
          currentWeeklyForecast,
          currentCityIndex,
        );
        return Right(currentWeeklyForecast);
      }
    } catch (e) {
      final currentWeeklyForecast = await weatherRemoteDataSource
          .getWeeklyForecastWeather(currentCityIndex);
      weatherLocalDataSource.cacheWeeklyForecastWeatherData(
        currentWeeklyForecast,
        currentCityIndex,
      );
      return Right(currentWeeklyForecast);
    }
  }

  @override
  Future<Either<Failure, String>> addCurrentCityToSavedCitiesList() async {
    try {
      final cityName = await currentCityName.getCurrentCityNameByLocation();
      weatherLocalDataSource.cacheCurrentCitiesList(cityName);
      return Right(
        cityName,
      );
    } on Exception catch (e) {
      return Left(
        LocationFailure(
          e.toString(),
        ),
      );
    }
  }

  @override
  Future<void> addCityNameFromCitySelectionListToSavedCitiesList(
      String cityToBeAddedToTheList) async {
    return weatherLocalDataSource
        .cacheCurrentCitiesList(cityToBeAddedToTheList);
  }

  @override
  Future<bool> checkIfTheAppIsBeingOpenedForFirstTime() async {
    final List savedCitiesList =
        await weatherLocalDataSource.getSavedCitiesList();
    if (savedCitiesList.isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<List<String>> getSavedCitiesList() async {
    return weatherLocalDataSource.getSavedCitiesList();
  }

  @override
  removeCityFromSavedCitiesList(String cityToBeRemoved) async {
    await weatherLocalDataSource.removeCityFromSavedCitiesList(cityToBeRemoved);
  }

  @override
  Future<bool> setWeatherDataType(bool isDataInCelsious) async {
    return weatherLocalDataSource.setWeatherDataType(isDataInCelsious);
  }

  @override
  Future<bool> checkIfDataInCelsious() async {
    return weatherLocalDataSource.checkIfDataInCelsious();
  }
}
