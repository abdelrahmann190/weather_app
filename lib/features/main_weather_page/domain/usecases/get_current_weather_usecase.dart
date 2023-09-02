import 'package:dartz/dartz.dart';
import 'package:weather_app/features/core/domain/usecases/usecase.dart';
import 'package:weather_app/features/core/error/failures.dart';
import 'package:weather_app/features/main_weather_page/domain/entities/current_weather.dart';
import 'package:weather_app/features/main_weather_page/domain/repositories/weather_repository.dart';

class GetCurrentWeather implements UseCase<CurrentWeatherEntity, int> {
  final WeatherRepository weatherRepository;

  GetCurrentWeather({
    required this.weatherRepository,
  });
  @override
  Future<Either<Failure, CurrentWeatherEntity>> call(int currentCityIndex) {
    return weatherRepository.getCurrentWeather(currentCityIndex);
  }
}
