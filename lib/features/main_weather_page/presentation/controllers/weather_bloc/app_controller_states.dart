// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'app_controller_bloc.dart';

abstract class AppControllerState extends Equatable {
  const AppControllerState();

  @override
  List<Object> get props => [];
}

class WeatherInitial extends AppControllerState {}

abstract class CurrentWeatherState extends AppControllerState {
  final List savedCitiesList;
  final bool isDataInC;
  const CurrentWeatherState(
    this.savedCitiesList,
    this.isDataInC,
  );

  @override
  List<Object> get props => [];
}

class CurrentWeatherLoading extends CurrentWeatherState {
  const CurrentWeatherLoading({
    required savedCitiesList,
    required isDataInC,
  }) : super(
          savedCitiesList,
          isDataInC,
        );
  @override
  List<Object> get props => [
        savedCitiesList,
        isDataInC,
      ];
}

class CurrentWeatherLoaded extends CurrentWeatherState {
  final CurrentWeather currentWeather;

  const CurrentWeatherLoaded({
    required this.currentWeather,
    required savedCitiesList,
    required isDataInC,
  }) : super(
          savedCitiesList,
          isDataInC,
        );

  @override
  List<Object> get props => [
        currentWeather,
        savedCitiesList,
        isDataInC,
      ];
}

class CurrentWeatherLoadingError extends CurrentWeatherState {
  final String errormessage;

  const CurrentWeatherLoadingError({
    required this.errormessage,
    required savedCitiesList,
    required isDataInC,
  }) : super(
          savedCitiesList,
          isDataInC,
        );
  @override
  List<Object> get props => [
        savedCitiesList,
        isDataInC,
      ];
}

abstract class WeeklyWeatherForecastState extends AppControllerState {}

class WeeklyWeatherForecastLoading extends WeeklyWeatherForecastState {}

class WeeklyWeatherForecastLoaded extends WeeklyWeatherForecastState {
  final List<WeeklyForecast> weeklyForecastList;
  final List savedCitiesList;
  final bool isDataInC;

  WeeklyWeatherForecastLoaded({
    required this.weeklyForecastList,
    required this.savedCitiesList,
    required this.isDataInC,
  });

  @override
  List<Object> get props => [
        weeklyForecastList,
        savedCitiesList,
      ];
}

class WeeklyWeatherForecastLoadingError extends WeeklyWeatherForecastState {
  final String message;

  WeeklyWeatherForecastLoadingError({
    required this.message,
  });
}

class CityNameLoaded extends AppControllerState {
  final List savedCitiesList;

  const CityNameLoaded({required this.savedCitiesList});
}

class CityNameError extends AppControllerState {}
